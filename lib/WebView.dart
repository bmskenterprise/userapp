import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'widgets/Toast.dart';

class WebView extends StatelessWidget {
  const WebView({super.key, required this.url});
  final String url;

    
  @override
  Widget build(BuildContext context) {
    WebViewController controller = WebViewController()
    ..setJavaScriptMode(JavaScriptMode.unrestricted)
    ..setNavigationDelegate(
      NavigationDelegate(
        onProgress: (int progress) {
          // Update loading bar.
        },
        onPageStarted: (String url) {},
        onPageFinished: (String url) {},
        onHttpError: (HttpResponseError error) {},
        onWebResourceError: (WebResourceError error) {},
        onNavigationRequest: (NavigationRequest request) {
          final url= request.url;
          if (url.contains('payment-success')) {
            Toast({'message': ' Payment success','success': true});
            Navigator.pop(context);
            return NavigationDecision.prevent;
          }
          else if (url.contains('payment-fail')) {
            Toast({'message': ' Payment Failed','success': false});
            Navigator.pop(context);
            return NavigationDecision.prevent;
          } else if (url.contains('payment-cancel')) {
            Toast({'message': ' Payment Cancelled','success': false});
            // Navigator.pop(context);
            return NavigationDecision.prevent;
          }
          return NavigationDecision.navigate;
        },
      ),
    )
    ..loadRequest(Uri.parse(url));
    return Scaffold(
      appBar: AppBar(title: const Text('Flutter Simple Example')),
      body: WebViewWidget(controller: controller),
    );
  }
}