import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class CheckoutWebView extends StatefulWidget {
  final String initPointUrl;

  const CheckoutWebView({super.key, required this.initPointUrl});

  @override
  State<CheckoutWebView> createState() => _CheckoutWebViewState();
}

class _CheckoutWebViewState extends State<CheckoutWebView> {
  late final WebViewController _controller;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (String url) {
            if (!mounted) return;
            setState(() {
              _isLoading = true;
            });
          },
          onPageFinished: (String url) {
            if (!mounted) return;
            setState(() {
              _isLoading = false;
            });
          },
          onNavigationRequest: (NavigationRequest request) {
            final url = request.url;
            if (!mounted) return NavigationDecision.prevent;

            if (url.contains('/payments/success') || url.contains('status=approved')) {
              Navigator.of(context).pop('success');
              return NavigationDecision.prevent;
            } else if (url.contains('/payments/failure') || url.contains('status=rejected')) {
              Navigator.of(context).pop('failure');
              return NavigationDecision.prevent;
            } else if (url.contains('/payments/pending') || url.contains('status=in_process')) {
              Navigator.of(context).pop('pending');
              return NavigationDecision.prevent;
            }
            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadRequest(Uri.parse(widget.initPointUrl));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Pago Seguro - Mercado Pago',
          style: TextStyle(color: Color(0xFF1D1B4B), fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        elevation: 0.5,
        leading: IconButton(
          icon: const Icon(Icons.close_rounded, color: Color(0xFF1D1B4B)),
          onPressed: () => Navigator.of(context).pop('cancelled'),
        ),
      ),
      body: Stack(
        children: [
          WebViewWidget(controller: _controller),
          if (_isLoading)
            const Center(
              child: CircularProgressIndicator(
                color: Color(0xFF311B92),
              ),
            ),
        ],
      ),
    );
  }
}
