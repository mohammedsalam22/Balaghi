import 'package:flutter/material.dart';
import '../../l10n/app_localizations.dart';
import 'models/shell_destination.dart';
import 'models/shell_action.dart';
import 'models/phone_nav.dart';

/// Adaptive navigation shell that switches between different layouts
/// based on screen width:
/// - Phone (< 600dp): Bottom navigation bar
/// - Tablet (600-839dp): Navigation rail
/// - Desktop (≥ 840dp): Navigation drawer
class AdaptiveShell extends StatefulWidget {
  final String title;
  final List<ShellDestination> destinations;
  final List<ShellDestination> quickActions;
  final List<ShellAction> actions;
  final PhoneNav phoneNav;
  final Widget Function(BuildContext, int, ValueChanged<int>)? toolbarBuilder;

  const AdaptiveShell({
    super.key,
    required this.title,
    required this.destinations,
    this.quickActions = const [],
    this.actions = const [],
    this.phoneNav = PhoneNav.bottomBar,
    this.toolbarBuilder,
  }) : assert(
         phoneNav == PhoneNav.bottomBar || toolbarBuilder != null,
         'toolbarBuilder is required when phoneNav is PhoneNav.toolbar',
       );

  @override
  State<AdaptiveShell> createState() => _AdaptiveShellState();
}

class _AdaptiveShellState extends State<AdaptiveShell> with RestorationMixin {
  final RestorableInt _tab = RestorableInt(0);
  final Map<int, Widget> _cachedScreens = {};

  @override
  String get restorationId => 'adaptive_shell_tab';

  @override
  void restoreState(RestorationBucket? oldBucket, bool initialRestore) {
    registerForRestoration(_tab, 'tab');
  }

  @override
  void initState() {
    super.initState();
    // Cache first screen
    if (widget.destinations.isNotEmpty) {
      _cachedScreens[0] = widget.destinations[0].screen;
    }
  }

  @override
  void didUpdateWidget(AdaptiveShell oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Reset tab if destinations changed and current index is invalid
    if (_tab.value >= widget.destinations.length) {
      _tab.value = 0;
    }
  }

  int get safeIndex => _tab.value.clamp(0, widget.destinations.length - 1);

  void _onDestinationSelected(int index) {
    if (index != _tab.value &&
        index >= 0 &&
        index < widget.destinations.length) {
      setState(() {
        _tab.value = index;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;

        if (width >= 840) {
          return _drawer();
        }
        if (width >= 600) {
          return _rail();
        }
        return _phone();
      },
    );
  }

  /// Phone layout (< 600dp): Bottom navigation bar
  Widget _phone() {
    if (widget.phoneNav == PhoneNav.toolbar) {
      return _phoneToolbar();
    }
    return _phoneBottomBar();
  }

  /// Phone layout with bottom navigation bar
  Widget _phoneBottomBar() {
    final l10n = AppLocalizations.of(context)!;

    // Build navigation bar items
    final navItems = widget.destinations.asMap().entries.map((entry) {
      final destination = entry.value;

      return NavigationDestination(
        icon: Icon(destination.selectedIcon ?? destination.icon),
        selectedIcon: Icon(destination.icon),
        label: destination.getLabelText(l10n),
      );
    }).toList();

    // Build body with IndexedStack for caching
    Widget body = IndexedStack(
      index: safeIndex,
      children: List<Widget>.generate(widget.destinations.length, (i) {
        if (i == safeIndex) {
          return _cachedScreens[i] ??= widget.destinations[i].screen;
        }
        return _cachedScreens[i] ?? const SizedBox.shrink();
      }),
    );

    return Scaffold(
      appBar: safeIndex == 0
          ? AppBar(
              title: Text(widget.title),
              actions: widget.actions.map((action) {
                return IconButton(
                  icon: Icon(action.icon),
                  tooltip: action.tooltip,
                  onPressed: () => action.handler(context),
                );
              }).toList(),
            )
          : null,
      body: body,
      bottomNavigationBar: NavigationBar(
        selectedIndex: safeIndex,
        onDestinationSelected: _onDestinationSelected,
        destinations: navItems,
      ),
    );
  }

  /// Phone layout with custom toolbar
  Widget _phoneToolbar() {
    Widget body = IndexedStack(
      index: safeIndex,
      children: List<Widget>.generate(widget.destinations.length, (i) {
        if (i == safeIndex) {
          return _cachedScreens[i] ??= widget.destinations[i].screen;
        }
        return _cachedScreens[i] ?? const SizedBox.shrink();
      }),
    );

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: [
          ...widget.actions.map((action) {
            return IconButton(
              icon: Icon(action.icon),
              tooltip: action.tooltip,
              onPressed: () => action.handler(context),
            );
          }),
          if (widget.toolbarBuilder != null)
            widget.toolbarBuilder!(context, safeIndex, _onDestinationSelected),
        ],
      ),
      body: body,
    );
  }

  /// Tablet layout (600-839dp): Navigation rail
  Widget _rail() {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    // Build rail destinations
    final railDestinations = widget.destinations.asMap().entries.map((entry) {
      final destination = entry.value;

      return NavigationRailDestination(
        icon: Icon(destination.icon),
        selectedIcon: Icon(destination.selectedIcon ?? destination.icon),
        label: Text(destination.getLabelText(l10n)),
      );
    }).toList();

    // Build actions for rail trailing
    final railActions = widget.actions.map((action) {
      return IconButton(
        icon: Icon(action.icon),
        tooltip: action.tooltip,
        onPressed: () => action.handler(context),
      );
    }).toList();

    // Get current screen (lazy load)
    final currentScreen = _cachedScreens[safeIndex] ??=
        widget.destinations[safeIndex].screen;

    return Scaffold(
      body: Row(
        children: [
          NavigationRail(
            selectedIndex: safeIndex,
            onDestinationSelected: _onDestinationSelected,
            labelType: NavigationRailLabelType.all,
            destinations: railDestinations,
            leading: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Image.asset(
                'assets/imgaes/mainlogo_appbar.png',
                height: 70,
                width: 70,
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) {
                  return Icon(
                    Icons.account_balance,
                    size: 48,
                    color: colorScheme.primary,
                  );
                },
              ),
            ),
            trailing: Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: railActions,
              ),
            ),
          ),
          const VerticalDivider(thickness: 1, width: 1),
          Expanded(child: currentScreen),
        ],
      ),
    );
  }

  /// Desktop layout (≥ 840dp): Navigation drawer
  Widget _drawer() {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    // Get current screen (lazy load)
    final currentScreen = _cachedScreens[safeIndex] ??=
        widget.destinations[safeIndex].screen;

    return Scaffold(
      body: Row(
        children: [
          NavigationDrawer(
            selectedIndex: safeIndex,
            onDestinationSelected: _onDestinationSelected,
            children: [
              // Header with logo and actions
              Container(
                constraints: const BoxConstraints(minHeight: 140),
                decoration: BoxDecoration(color: colorScheme.surface),
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 1,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/imgaes/mainlogo_appbar.png',
                      height: 150,
                      width: 150,
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTrace) {
                        return Icon(
                          Icons.account_balance,
                          size: 100,
                          color: colorScheme.primary,
                        );
                      },
                    ),
                    if (widget.actions.isNotEmpty) ...[
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: widget.actions.map((action) {
                          return IconButton(
                            icon: Icon(action.icon),
                            tooltip: action.tooltip,
                            onPressed: () => action.handler(context),
                          );
                        }).toList(),
                      ),
                    ],
                  ],
                ),
              ),
              const Divider(height: 1),
              SizedBox(height: 10),
              // Main destinations
              ...widget.destinations.map((destination) {
                return NavigationDrawerDestination(
                  icon: Icon(destination.icon),
                  selectedIcon: Icon(
                    destination.selectedIcon ?? destination.icon,
                  ),
                  label: Text(destination.getLabelText(l10n)),
                );
              }),
              // Divider and quick actions (handled separately, not part of selectedIndex)
              if (widget.quickActions.isNotEmpty) ...[
                const Divider(),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  child: Text(
                    'Quick Actions',
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: colorScheme.onSurface.withOpacity(0.6),
                    ),
                  ),
                ),
                // Quick actions as ListTiles (not NavigationDrawerDestinations)
                ...widget.quickActions.map((destination) {
                  return ListTile(
                    leading: Icon(destination.icon),
                    title: Text(destination.getLabelText(l10n)),
                    onTap: () {
                      // Handle quick action navigation if needed
                      // For now, quick actions are just placeholders
                    },
                  );
                }),
              ],
            ],
          ),
          const VerticalDivider(thickness: 1, width: 1),
          Expanded(child: currentScreen),
        ],
      ),
    );
  }
}
