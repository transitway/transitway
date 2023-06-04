import 'package:flutter/material.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:transitway/state/state.dart';

import '../url.dart';

class Topup extends StatefulWidget {
  const Topup({super.key});

  @override
  State<Topup> createState() => _TopupState();
}

class _TopupState extends State<Topup> {
  final flutterWebviewPlugin = FlutterWebviewPlugin();

  @override
  Widget build(BuildContext context) {
    flutterWebviewPlugin.show();
    flutterWebviewPlugin
        .launch('${AppURL.paymentsURL}/topup',
            withJavascript: true, withLocalStorage: true)
        .whenComplete(() {
      flutterWebviewPlugin
          .evalJavascript("window.localStorage.setItem('token', '$token')");
    });

    return WebviewScaffold(
      url: '${AppURL.paymentsURL}//topup',
      withJavascript: true,
      withLocalStorage: true,
      scrollBar: false,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: Container(),
        flexibleSpace: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Row(
              children: [
                GestureDetector(
                    onTap: () {
                      flutterWebviewPlugin.hide();
                      Navigator.pop(context);
                    },
                    child: const Icon(Icons.arrow_back_ios_new)),
                const Padding(
                  padding: EdgeInsets.only(left: 20),
                  child: Text(
                    'Adaugă sold',
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'UberMoveBold'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
