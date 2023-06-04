import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:transitway/Pages/onboarding/onboarding.dart';
import 'package:transitway/providers/account_provider.dart';
import 'package:transitway/url.dart';
import 'package:transitway/utils/env.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:transitway/Pages/navbar.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool _showImage = true;
  String localToken = '';
  FlutterWebviewPlugin flutterWebviewPlugin = FlutterWebviewPlugin();

  Future<void> requestLocationPermissions() async {
    PermissionStatus status = await Permission.location.request();

    if (status.isGranted) {
      // Location permissions granted, proceed with your logic
      // ...
    } else if (status.isDenied) {
      // Location permissions denied, show a message or take appropriate action
      // ...
    } else if (status.isPermanentlyDenied) {
      // Location permissions permanently denied, show a message or take appropriate action
      // ...
    }
  }

  @override
  void initState() {
    AccountProvider auth = AccountProvider();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      auth = Provider.of<AccountProvider>(context, listen: false);
      auth.loadAccount();
    });

    requestLocationPermissions();
    super.initState();
    Timer(const Duration(seconds: 1), () {
      setState(() {
        _showImage = false;
      });
      Timer(const Duration(seconds: 1), () {
        setState(() {
          localToken = auth.token;
        });
        if (auth.token != 'null' && auth.account.id != null) {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => const NavBar(
                      pageIndex: 1,
                    )),
            // MaterialPageRoute(
            //     builder: (context) =>
            //         const RoutePreview(toLocationName: 'Strada Tabla Butii')),
          );
        } else {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const Onboarding()));
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    AccountProvider auth = Provider.of<AccountProvider>(context);
    flutterWebviewPlugin
        .launch(AppURL.paymentsURL,
            withJavascript: true, withLocalStorage: true)
        .whenComplete(() {
      flutterWebviewPlugin.evalJavascript(
          "window.localStorage.setItem('token', '${auth.token}')");
    });
    flutterWebviewPlugin.hide();
    return Scaffold(
      body: Center(
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 250),
          child: _showImage
              ? Image.asset(
                  'assets/Images/logotransp.png',
                  height: 100,
                )
              : const CircularProgressIndicator(
                  color: transitwayPurple,
                ),
        ),
      ),
    );
  }
}
