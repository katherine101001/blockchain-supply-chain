// go_router config
// import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'shell/app_shell.dart';
import '../features/product/presentation/pages/product_fast_view_page.dart';
import '../features/product/presentation/pages/product_real_notice_page.dart';
import '../features/product/presentation/pages/product_full_detail_page_refined.dart';
import '../features/webview/presentation/pages/etherscan_webview_page.dart';

class AppRouter {
  static final router = GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(
        path: '/',
        name: 'home',
        builder: (context, state) => const AppShell(),
      ),
      GoRoute(
        path: '/explore',
        name: 'explore',
        builder: (context, state) => const AppShell(initialIndex: 1),
      ),
      GoRoute(
        path: '/scan',
        name: 'scan',
        builder: (context, state) => const AppShell(initialIndex: 2),
      ),
      GoRoute(
        path: '/history',
        name: 'history',
        builder: (context, state) => const AppShell(initialIndex: 3),
      ),
      GoRoute(
        path: '/product/:sku',
        name: 'productFast',
        builder: (context, state) {
          final sku = state.pathParameters['sku']!;
          return ProductFastViewPage(sku: sku);
        },
      ),
      GoRoute(
        path: '/product/:sku/real',
        name: 'productRealNotice',
        builder: (context, state) {
          final sku = state.pathParameters['sku']!;
          return ProductRealNoticePage(sku: sku);
        },
      ),
      GoRoute(
        path: '/product/:sku/details',
        name: 'productFull',
        builder: (context, state) {
          final sku = state.pathParameters['sku']!;
          final extra = state.extra;
          final verifyOnOpen = extra is Map && extra['verifyOnOpen'] == true;
          return ProductFullDetailPageRefined(
            sku: sku,
            verifyOnOpen: verifyOnOpen,
          );
        },
      ),
      GoRoute(
        path: '/webview/etherscan',
        name: 'etherscanWebView',
        builder: (context, state) {
          final extra = state.extra;
          final url = extra is Map ? extra['url'] as String? : null;
          final title = extra is Map ? extra['title'] as String? : null;
          
          if (url == null) {
            // Fallback to home if no URL provided
            return const AppShell();
          }
          
          return EtherscanWebViewPage(
            url: url,
            title: title ?? 'Etherscan Transaction',
          );
        },
      ),
    ],
  );
}
