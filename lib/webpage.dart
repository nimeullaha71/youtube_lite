import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

class WebViewScreen extends StatefulWidget {
  const WebViewScreen({super.key});

  @override
  State<WebViewScreen> createState() => _WebViewScreenState();
}

class _WebViewScreenState extends State<WebViewScreen> {
  late InAppWebViewController _inAppWebViewController;
  double progress = 0;

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (bool didPop) async {
        if (await _inAppWebViewController.canGoBack()) {
          _inAppWebViewController.goBack();
        } else {
          exit(0);
        }
      },
      child: Scaffold(
        appBar: MediaQuery.of(context).orientation == Orientation.landscape
            ? null
            : AppBar(
          backgroundColor: Colors.white,
          title: const Text("Youtube Lite"),
          actions: [
            IconButton(
              onPressed: () async {
                if (await _inAppWebViewController.canGoBack()) {
                  _inAppWebViewController.goBack();
                } else {
                  exit(0);
                }
              },
              icon: const Icon(Icons.arrow_back),
            )
          ],
        ),
        body: Stack(
          children: [
            InAppWebView(
              initialUrlRequest: URLRequest(
                url: WebUri("https://www.youtube.com/watch?v=0Xn1QhNtPkQ"),
              ),
              initialOptions: InAppWebViewGroupOptions(
                crossPlatform: InAppWebViewOptions(
                  javaScriptEnabled: true,
                  supportZoom: false,
                  useShouldOverrideUrlLoading: true,
                  mediaPlaybackRequiresUserGesture: false,
                ),
                android: AndroidInAppWebViewOptions(
                  useWideViewPort: true,
                  loadWithOverviewMode: true,
                ),
                ios: IOSInAppWebViewOptions(
                  allowsInlineMediaPlayback: true,
                ),
              ),
              onWebViewCreated: (controller) {
                _inAppWebViewController = controller;
              },
              shouldOverrideUrlLoading: (controller, navigationAction) async {
                final uri = navigationAction.request.url;
                if (uri != null && !["http", "https"].contains(uri.scheme)) {
                  return NavigationActionPolicy.CANCEL;
                }
                return NavigationActionPolicy.ALLOW;
              },
              onLoadStop: (controller, url) {
                setState(() {
                  progress = 1.0;
                });
              },
              onProgressChanged: (controller, progressValue) {
                setState(() {
                  progress = progressValue / 100;
                });
              },
            ),
            if (progress < 1.0)
              LinearProgressIndicator(
                value: progress,
                color: Colors.green,
                backgroundColor: Colors.black12,
              ),
          ],
        ),
      ),
    );
  }
}
