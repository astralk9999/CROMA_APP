import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:croma_app/config/theme.dart';

class CheckoutWebView extends StatefulWidget {
  final String url;
  final String successUrl;
  final String cancelUrl;

  const CheckoutWebView({
    super.key,
    required this.url,
    required this.successUrl,
    required this.cancelUrl,
  });

  @override
  State<CheckoutWebView> createState() => _CheckoutWebViewState();
}

class _CheckoutWebViewState extends State<CheckoutWebView> {
  late final WebViewController controller;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (String url) {
            setState(() => _isLoading = true);
          },
          onPageFinished: (String url) {
            setState(() => _isLoading = false);
          },
          onWebResourceError: (WebResourceError error) {},
          onNavigationRequest: (NavigationRequest request) {
            if (request.url.contains('checkout/success')) {
              Navigator.of(context).pop(true); // Success
              return NavigationDecision.prevent;
            }
            if (request.url.contains('checkout/cancel')) {
              Navigator.of(context).pop(false); // Cancel
              return NavigationDecision.prevent;
            }
            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadRequest(Uri.parse(widget.url));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'SECURE CHECKOUT',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: AppTheme.white,
        leading: IconButton(
          icon: const Icon(Icons.close, color: AppTheme.black),
          onPressed: () => Navigator.of(context).pop(false),
        ),
      ),
      body: Stack(
        children: [
          WebViewWidget(controller: controller),
          if (_isLoading)
            const Center(
              child: CircularProgressIndicator(color: AppTheme.black),
            ),
        ],
      ),
    );
  }
}
