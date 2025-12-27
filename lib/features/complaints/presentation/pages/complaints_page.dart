import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../l10n/app_localizations.dart';
import '../cubit/complaints/complaint_cubit.dart';
import '../cubit/complaints/complaint_state.dart';
import '../widgets/complaint_card.dart';
import '../widgets/create_complaint_dialog.dart';
import '../widgets/filter_chip_widget.dart';
import '../widgets/complaints_loading_widget.dart';
import '../widgets/complaints_error_widget.dart';
import '../widgets/complaints_empty_state_widget.dart';
import '../utils/complaint_utils.dart';

class ComplaintsPage extends StatefulWidget {
  const ComplaintsPage({super.key});

  @override
  State<ComplaintsPage> createState() => _ComplaintsPageState();
}

class _ComplaintsPageState extends State<ComplaintsPage>
    with TickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  int? _selectedStatusFilter; // null means "All"
  late AnimationController _fabAnimationController;
  late AnimationController _filterAnimationController;
  late Animation<double> _fabScaleAnimation;
  late Animation<Offset> _filterSlideAnimation;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    
    // Initialize animations
    _fabAnimationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _filterAnimationController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _fabScaleAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _fabAnimationController,
      curve: Curves.elasticOut,
    ));

    _filterSlideAnimation = Tween<Offset>(
      begin: const Offset(0, -0.1),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _filterAnimationController,
      curve: Curves.easeOutBack,
    ));

    // Load data
    context.read<ComplaintCubit>().loadComplaints();
    
    // Start animations after first frame
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fabAnimationController.forward();
      Future.delayed(const Duration(milliseconds: 200), () {
        if (mounted) _filterAnimationController.forward();
      });
    });
  }

  @override
  void dispose() {
    _fabAnimationController.dispose();
    _filterAnimationController.dispose();
    context.read<ComplaintCubit>().clearCache();
    super.dispose();
  }

  void _showCreateComplaintDialog() async {
    await showDialog(
      context: context,
      builder: (context) => const CreateComplaintDialog(),
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      body: BlocConsumer<ComplaintCubit, ComplaintState>(
        listener: (context, state) {
          if (state is ComplaintError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
              ),
            );
          } else if (state is ComplaintCreated) {
            final l10n = AppLocalizations.of(context)!;
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  l10n.complaintCreatedSuccessfully(
                    state.response.trackingNumber,
                  ),
                ),
                backgroundColor: Colors.green,
              ),
            );
          } else if (state is ComplaintStatusUpdated) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.green,
              ),
            );
          }
        },
        builder: (context, state) {
          final l10n = AppLocalizations.of(context)!;

          if (state is ComplaintLoading && state is! ComplaintLoaded) {
            return const ComplaintsLoadingWidget();
          }

          if (state is ComplaintLoaded) {
            final allComplaints = state.complaints;
            final isFromCache = state.isFromCache;
            final statusCounts = state.statusCounts;
            
            final filteredComplaints = _selectedStatusFilter == null
                ? allComplaints
                : allComplaints
                      .where((c) => c.status == _selectedStatusFilter)
                      .toList();

            return Column(
              children: [
                // Cache indicator banner
                if (isFromCache)
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    color: Colors.orange.withValues(alpha: 0.1),
                    child: Row(
                      children: [
                        Icon(
                          Icons.cloud_off,
                          size: 16,
                          color: Colors.orange[700],
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            l10n.showingCachedData,
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.orange[700],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                // Status filter chips
                SlideTransition(
                  position: _filterSlideAnimation,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          FilterChipWidget(
                            status: null,
                            label: l10n.all,
                            icon: Icons.filter_list,
                            count: allComplaints.length,
                            isSelected: _selectedStatusFilter == null,
                            onSelected: (selected) {
                              setState(() {
                                _selectedStatusFilter = selected ? null : null;
                              });
                            },
                          ),
                          const SizedBox(width: 8),
                          FilterChipWidget(
                            status: 0,
                            label: l10n.statusNew,
                            icon: Icons.new_releases,
                            count: statusCounts[0] ?? 0,
                            color: Colors.blue,
                            isSelected: _selectedStatusFilter == 0,
                            onSelected: (selected) {
                              setState(() {
                                _selectedStatusFilter = selected ? 0 : null;
                              });
                            },
                          ),
                          const SizedBox(width: 8),
                          FilterChipWidget(
                            status: 1,
                            label: l10n.statusInProgress,
                            icon: Icons.hourglass_empty,
                            count: statusCounts[1] ?? 0,
                            color: Colors.orange,
                            isSelected: _selectedStatusFilter == 1,
                            onSelected: (selected) {
                              setState(() {
                                _selectedStatusFilter = selected ? 1 : null;
                              });
                            },
                          ),
                          const SizedBox(width: 8),
                          FilterChipWidget(
                            status: 2,
                            label: l10n.statusDone,
                            icon: Icons.check_circle,
                            count: statusCounts[2] ?? 0,
                            color: Colors.green,
                            isSelected: _selectedStatusFilter == 2,
                            onSelected: (selected) {
                              setState(() {
                                _selectedStatusFilter = selected ? 2 : null;
                              });
                            },
                          ),
                          const SizedBox(width: 8),
                          FilterChipWidget(
                            status: 3,
                            label: l10n.statusRejected,
                            icon: Icons.cancel,
                            count: statusCounts[3] ?? 0,
                            color: Colors.red,
                            isSelected: _selectedStatusFilter == 3,
                            onSelected: (selected) {
                              setState(() {
                                _selectedStatusFilter = selected ? 3 : null;
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                // Complaints list
                Expanded(
                  child: filteredComplaints.isEmpty
                      ? ComplaintsEmptyStateWidget(
                          isFiltered: _selectedStatusFilter != null,
                          selectedStatusText: _selectedStatusFilter != null
                              ? ComplaintUtils.getStatusText(l10n, _selectedStatusFilter!)
                              : null,
                          onCreateComplaint: _showCreateComplaintDialog,
                        )
                      : RefreshIndicator(
                          onRefresh: () async {
                            context.read<ComplaintCubit>().loadComplaints(
                              forceRefresh: true,
                            );
                          },
                          child: ListView.builder(
                            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                            itemCount: filteredComplaints.length,
                            // Performance optimization: add cache extent for better scrolling
                            cacheExtent: 500,
                            itemBuilder: (context, index) {
                              final complaint = filteredComplaints[index];
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 16),
                                child: ComplaintCard(
                                  key: ValueKey(complaint.id),
                                  complaint: complaint,
                                  isAdmin: false,
                                  onStatusUpdate: (complaintId, status) {
                                    context
                                        .read<ComplaintCubit>()
                                        .updateComplaintStatus(
                                          complaintId,
                                          status,
                                        );
                                  },
                                ),
                              );
                            },
                          ),
                        ),
                ),
              ],
            );
          }

          if (state is ComplaintError) {
            return ComplaintsErrorWidget(
              error: state,
              onRetry: () => context.read<ComplaintCubit>().loadComplaints(),
            );
          }

          return Center(child: Text(l10n.noComplaintsToDisplay));
        },
      ),
      floatingActionButton: ScaleTransition(
        scale: _fabScaleAnimation,
        child: Builder(
          builder: (context) {
            final l10n = AppLocalizations.of(context)!;
            return FloatingActionButton.extended(
              onPressed: _showCreateComplaintDialog,
              icon: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.add, size: 20),
              ),
              label: Text(l10n.newComplaint),
              backgroundColor: Theme.of(context).colorScheme.primary,
              foregroundColor: Theme.of(context).colorScheme.onPrimary,
              elevation: 6,
              highlightElevation: 12,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            );
          },
        ),
      ),
    );
  }
}
