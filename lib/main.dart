import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'core/di/injection_container.dart' as di;
import 'core/routes/app_router.dart';
import 'core/theme/app_theme.dart';
import 'core/theme/theme_service.dart';
import 'core/localization/localization_service.dart';
import 'core/navigation/main_navigation.dart';
import 'features/auth/presentation/cubit/auth/auth_cubit.dart';
import 'features/auth/presentation/cubit/auth/auth_state.dart';
import 'features/auth/presentation/pages/login_page.dart';
import 'features/complaints/presentation/cubit/complaints/complaint_cubit.dart';
import 'l10n/app_localizations.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize dependency injection
  await di.init();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        // Global Auth Cubit
        BlocProvider(create: (context) => di.sl<AuthCubit>()),
        // Global Complaint Cubit
        BlocProvider(create: (context) => di.sl<ComplaintCubit>()),
      ],
      child: ValueListenableBuilder<ThemeMode>(
        valueListenable: di.sl<ThemeService>(),
        builder: (context, themeMode, child) {
          return ValueListenableBuilder<Locale>(
            valueListenable: di.sl<LocalizationService>(),
            builder: (context, locale, child) {
              return MaterialApp(
                title: 'Balaghi App',
                debugShowCheckedModeBanner: false,
                theme: AppTheme.lightTheme,
                darkTheme: AppTheme.darkTheme,
                themeMode: themeMode,
                locale: locale,
                localizationsDelegates: [
                  AppLocalizations.delegate,
                  GlobalMaterialLocalizations.delegate,
                  GlobalWidgetsLocalizations.delegate,
                  GlobalCupertinoLocalizations.delegate,
                ],
                supportedLocales: di.sl<LocalizationService>().supportedLocales,
                onGenerateRoute: AppRouter.generateRoute,
                home: BlocBuilder<AuthCubit, AuthState>(
                  builder: (context, state) {
                    if (state is AuthLoading || state is AuthInitial) {
                      return const Scaffold(
                        body: Center(child: CircularProgressIndicator()),
                      );
                    } else if (state is AuthAuthenticated) {
                      return const MainNavigation();
                    } else {
                      return const LoginPage();
                    }
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
