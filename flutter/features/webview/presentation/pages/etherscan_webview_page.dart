import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '../../../../core/utils/context_extensions.dart';
import '../../../../design_system/components/glass/glass_container.dart';
import '../../../../design_system/foundations/spacing.dart';
import '../../../../design_system/foundations/typography.dart';
import '../../../../design_system/components/buttons/app_button.dart';

/// A reusable webview page for displaying Etherscan links in-app
class EtherscanWebViewPage extends StatefulWidget {
  const EtherscanWebViewPage({
    super.key,
    required this.url,
    this.title = 'Etherscan Transaction',
  });

  final String url;
  final String title;

  @override
  State<EtherscanWebViewPage> createState() => _EtherscanWebViewPageState();
}

class _EtherscanWebViewPageState extends State<EtherscanWebViewPage> {
  late final WebViewController _controller;
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _initializeWebView();
  }

  void _initializeWebView() {
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (String url) {
            setState(() {
              _isLoading = true;
              _errorMessage = null;
            });
          },
          onPageFinished: (String url) {
            setState(() {
              _isLoading = false;
            });
          },
          onWebResourceError: (WebResourceError error) {
            setState(() {
              _isLoading = false;
              _errorMessage = error.description;
            });
          },
        ),
      )
      ..loadRequest(Uri.parse(widget.url));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.colors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: context.colors.textPrimary),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          widget.title,
          style: AppTypography.textTheme.titleMedium?.copyWith(
            color: context.colors.textPrimary,
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh, color: context.colors.textPrimary),
            onPressed: () {
              _controller.reload();
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          // WebView
          if (_errorMessage == null)
            WebViewWidget(controller: _controller)
          else
            // Error State
            Center(
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.spaceL),
                child: GlassContainer(
                  borderRadius: AppSpacing.radiusM,
                  padding: const EdgeInsets.all(AppSpacing.spaceL),
                  margin: EdgeInsets.zero,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.error_outline,
                        size: 64,
                        color: context.colors.danger,
                      ),
                      const SizedBox(height: AppSpacing.spaceM),
                      Text(
                        'Failed to Load Page',
                        style: AppTypography.textTheme.titleLarge?.copyWith(
                          color: context.colors.textPrimary,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.spaceS),
                      Text(
                        _errorMessage ?? 'Unknown error occurred',
                        style: AppTypography.textTheme.bodyMedium?.copyWith(
                          color: context.colors.textSecondary,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: AppSpacing.spaceL),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          AppButton(
                            label: 'Retry',
                            icon: Icons.refresh,
                            onPressed: () {
                              _controller.reload();
                            },
                            variant: AppButtonVariant.filled,
                            size: AppButtonSize.medium,
                          ),
                          const SizedBox(width: AppSpacing.spaceM),
                          AppButton(
                            label: 'Go Back',
                            icon: Icons.arrow_back,
                            onPressed: () => Navigator.of(context).pop(),
                            variant: AppButtonVariant.outlined,
                            size: AppButtonSize.medium,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),

          // Loading Indicator
          if (_isLoading && _errorMessage == null)
            Container(
              color: context.colors.background.withValues(alpha: 0.8),
              child: Center(
                child: GlassContainer(
                  borderRadius: AppSpacing.radiusM,
                  padding: const EdgeInsets.all(AppSpacing.spaceL),
                  margin: EdgeInsets.zero,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(
                          context.colors.primary,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.spaceM),
                      Text(
                        'Loading Etherscan...',
                        style: AppTypography.textTheme.bodyMedium?.copyWith(
                          color: context.colors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
