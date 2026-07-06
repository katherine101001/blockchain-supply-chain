import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '../../../../core/utils/context_extensions.dart';
import '../../../../design_system/foundations/spacing.dart';
import '../../application/bloc/explorer_bloc.dart';
import '../../application/bloc/explorer_state.dart';
import '../widgets/explorer_form.dart';

class ExplorerPage extends StatefulWidget {
  const ExplorerPage({super.key});

  @override
  State<ExplorerPage> createState() => _ExplorerPageState();
}

class _ExplorerPageState extends State<ExplorerPage> {
  late final WebViewController _controller;

  @override
  void initState() {
    super.initState();

    // Initialize the WebViewController
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted);
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ExplorerBloc, ExplorerState>(
      listener: (context, state) {
        if (state is ExplorerError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error: ${state.message}'),
              backgroundColor: context.colors.danger,
            ),
          );
        }
      },
      builder: (context, state) {
        if (state is ExplorerReady) {
          // Column with Form on top and WebView below
          return Column(
            children: [
              const Padding(
                padding: EdgeInsets.all(AppSpacing.spaceM),
                child: ExplorerForm(),
              ),
              Expanded(
                child: WebViewWidget(
                  controller: _controller
                    ..loadRequest(Uri.parse(state.explorerUrl.toString())),
                ),
              ),
            ],
          );
        }

        // Default state: just show the form
        return const SingleChildScrollView(
          padding: EdgeInsets.all(AppSpacing.spaceM),
          child: ExplorerForm(),
        );
      },
    );
  }
}
