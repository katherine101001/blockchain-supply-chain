import 'package:flutter/material.dart';
import '../../core/utils/context_extensions.dart';
import '../../features/home/presentation/pages/home_page.dart';
import '../../features/blockchain_explorer/presentation/pages/explorer_page.dart';
import '../../features/scan/presentation/pages/scan_page.dart';
import '../../features/history/presentation/pages/history_page_modern.dart';
import 'app_app_bar.dart';
import 'app_bottom_nav.dart';

class AppShell extends StatefulWidget {
  const AppShell({super.key, this.initialIndex = 0});

  final int initialIndex;

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  late int _currentIndex;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
  }

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDarkMode;

    return Scaffold(
      backgroundColor: isDark
          ? context.colors.background
          : const Color(0xFFFBFBFD),
      extendBody: true,
      appBar: const AppAppBar(),
      body: Stack(
        children: [
          // BACKGROUND TEXTURE (Light Mode Only)
          if (!isDark) ...[
            // Soft Grey/Lavender Mist Top Right
            Positioned(
              top: -100,
              right: -50,
              child: _BackgroundMist(color: const Color(0xFFE8EAF6), size: 400),
            ),
            // Very faint Slate Mist Bottom Left
            Positioned(
              bottom: 100,
              left: -100,
              child: _BackgroundMist(color: const Color(0xFFECEFF1), size: 350),
            ),
          ],

          // MAIN CONTENT
          SafeArea(
            bottom: false,
            child: IndexedStack(
              index: _currentIndex,
              children: [
                const HomePage(),
                const ExplorerPage(),
                // Build ScanPage ONLY when active to avoid double camera init
                _currentIndex == 2 ? const ScanPage() : const SizedBox.shrink(),
                const HistoryPageModern(),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: AppBottomNav(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
      ),
    );
  }
}

class _BackgroundMist extends StatelessWidget {
  final Color color;
  final double size;

  const _BackgroundMist({required this.color, this.size = 250});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: RadialGradient(colors: [color, color.withValues(alpha: 0.0)]),
      ),
    );
  }
}
