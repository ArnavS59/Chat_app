import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/platform_interface.dart';
import 'package:webview_flutter/webview_flutter.dart';

class RecipeView extends StatefulWidget {
//  RecipeView({Key key}) : super(key: key);

  final String postUrl;

  RecipeView({this.postUrl});

  @override
  _RecipeViewState createState() => _RecipeViewState();
}

class _RecipeViewState extends State<RecipeView> {
  String finalurl;

  final _controller = Completer<WebViewPlatformController>();

  @override
  void initState() {
    // TODO: implement initState
    if (widget.postUrl.contains("http://")) {
      finalurl = widget.postUrl.replaceAll("http://", "https://");
    } else {
      finalurl = widget.postUrl;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Column(
          children: <Widget>[
            Container(
              padding: EdgeInsets.only(top: 50, bottom: 10),
              decoration: BoxDecoration(
                  gradient: LinearGradient(colors: [
                const Color(0xffaa4b6b),
                const Color(0xff6b6b83),
                const Color(0xff3b8d99),
              ])),
              width: MediaQuery.of(context).size.width,
              child: Row(
                mainAxisAlignment:
                    kIsWeb ? MainAxisAlignment.start : MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    "Recipe",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold),
                  ),
                  Text(
                    "App",
                    style: TextStyle(
                        color: Colors.black54,
                        fontSize: 22,
                        fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            Container(
              height: MediaQuery.of(context).size.height - 100,
              width: double.infinity,
              child: WebView(
                initialUrl: widget.postUrl,
                javascriptMode: JavascriptMode.unrestricted,
                onWebViewCreated: (controller) {
                  setState(() {
                    _controller.complete();
                  });
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
