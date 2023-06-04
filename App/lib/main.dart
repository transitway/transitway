import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:transitway/providers/account_provider.dart';
import 'package:transitway/Pages/splashscreen.dart';
import 'package:transitway/providers/balance_provider.dart';
import 'package:transitway/providers/route_provider.dart';
import 'package:transitway/providers/tickets_provider.dart';

void main() async {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
        value: const SystemUiOverlayStyle(
          statusBarColor: Colors.white,
          statusBarIconBrightness: Brightness.dark,
          systemNavigationBarColor: Colors.white,
        ),
        child: MultiProvider(
            providers: [
              ChangeNotifierProvider(create: (_) => AccountProvider()),
              ChangeNotifierProvider(create: (_) => RouteProvider()),
              ChangeNotifierProvider(create: (_) => BalanceProvider()),
              ChangeNotifierProvider(create: (_) => TicketsProvider()),
            ],
            child: MaterialApp(
                theme: ThemeData(scaffoldBackgroundColor: Colors.white),
                debugShowCheckedModeBanner: false,
                home: const SplashScreen())));
  }
}
