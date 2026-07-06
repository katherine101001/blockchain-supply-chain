import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart'; // Add this import
import '../design_system/theme/app_theme.dart';
import 'app_router.dart';
import '../design_system/theme/theme_cubit.dart'; // Import the ThemeCubit

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    // 1. Wrap with BlocBuilder to listen for state changes
    return BlocBuilder<ThemeCubit, ThemeMode>(
      builder: (context, themeMode) {
        return MaterialApp.router(
          debugShowCheckedModeBanner: false,
          title: 'TRASE',
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          // 2. Use the themeMode emitted by your Cubit
          themeMode: themeMode,
          routerConfig: AppRouter.router,
        );
      },
    );
  }
}
