import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

class WebViewScreen extends StatelessWidget {
  const WebViewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: StreamBuilder<String>(
          stream: FirebaseFirestore.instance
              .doc("ai/ai")
              .snapshots()
              .map((event) => event["link"]),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const CircularProgressIndicator();
            }
            return InAppWebView(
              initialUrlRequest: URLRequest(url: Uri.parse(snapshot.data!)),
              initialOptions: InAppWebViewGroupOptions(
                crossPlatform: InAppWebViewOptions(
                  useShouldOverrideUrlLoading: true,
                ),
                ios: IOSInAppWebViewOptions(
                  enableViewportScale: true,
                ),
                android: AndroidInAppWebViewOptions(
                  // useHybridComposition: true,
                  loadsImagesAutomatically: true,
                  useWideViewPort: false,
                ),
              ),
            );
          }),
    );
  }
}
