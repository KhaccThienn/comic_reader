import 'package:flutter/material.dart';

class WebViewContainer extends StatefulWidget {
  final String url;

  const WebViewContainer(this.url, {super.key});

  @override
  _WebViewContainerState createState() => _WebViewContainerState();
}

class _WebViewContainerState extends State<WebViewContainer> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.white,
        ),
        backgroundColor: Colors.orange,
      ),
      body: WebViewContainer(widget.url),
    );
  }
}
