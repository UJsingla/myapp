import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final controller = WebViewController();

  @override
  void initState() {
    super.initState();
    controller.setJavaScriptMode(JavaScriptMode.unrestricted);
    controller.setNavigationDelegate(NavigationDelegate(
      onNavigationRequest: (request) {
        if (request.url.startsWith("https://www.google.com")) {
          return NavigationDecision.navigate;
        } else {
          print("prevent user navigate out of google website!");
          return NavigationDecision.prevent;
        }
      },
      onPageStarted: (url) {
        print("onPageStarted: $url");
      },
      onPageFinished: (url) => print("onPageFinished: $url"),
      onWebResourceError: (error) =>
          print("onWebResourceError: ${error.description}"),
    ));
    controller.addJavaScriptChannel("RenderChannel", onMessageReceived: (message) {
      print("js -> dart : ${message.message}");
    });
    controller.loadRequest(Uri.parse("https://www.google.com/"));
  }

  void testJavascript() {
    controller.runJavaScript("RenderChannel.postMessage('中文')");
  }

  @override
  Widget build(BuildContext context) {
    Widget body = WebViewWidget(controller: controller);
    return MaterialApp(home: Scaffold(appBar: AppBar(
          title: const Text('Webview Example'),
          actions: [
            IconButton(
              icon: const Icon(Icons.code),  // Icon to trigger JavaScript test
              onPressed: testJavascript,  // Link the JavaScript test function
            ),
          ],
        ), body: body));
  }
}


