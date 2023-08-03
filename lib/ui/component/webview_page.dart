
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebviewPage extends StatefulWidget {
  final String link;
  final VoidCallback? onClose;

  const WebviewPage({Key? key, required this.link, this.onClose})
      : super(key: key);

  @override
  _WebviewPageState createState() => _WebviewPageState();
}

class _WebviewPageState extends State<WebviewPage> {
  String title = 'KlikNSS';

  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  @override
  Widget build(BuildContext context) {
    title = "KlikNSS";
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        elevation: 0.1,
        title: Text(title),
      ),
      body: WebView(
        initialUrl:
            // "${widget.link}?webview-mode",
            widget.link.contains("?")
                ? "${widget.link}&webview-mode"
                : "${widget.link}?webview-mode",
        javascriptMode: JavascriptMode.unrestricted,
        javascriptChannels: {
          JavascriptChannel(
              name: 'KlikNSS',
              onMessageReceived: (JavascriptMessage js) {
                if (js.message.startsWith('title=')) {
                  if (js.message.contains("undefined")) {
                    setState(() {
                      title = "";
                    });
                  } else {
                    // setState(() {
                    //   // title = (js.message).substring(6);
                    //   title = "Diskusi ${(js.message).substring(6)}".substring(
                    //       0, min("${(js.message).substring(6)}".length, 16));
                    // });
                  }
                }

                print("mau masuk onclose");

                if (widget.onClose != null) {
                  print("udah masuk onclose");
                  widget.onClose!();
                }
              })
        },
      ),
    );
  }
}
