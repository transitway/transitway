import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:transitway/url.dart';
import 'package:http/http.dart' as http;
import 'package:transitway/state/state.dart' as state;

class BalanceProvider with ChangeNotifier {
  double value = 0.0;
  String errorMessage = '';

  bool loading = false;

  getBalance() async {
    loading = true;
    notifyListeners();

    final response =
        await http.get(AppURL.getBalance, headers: authHeader(state.token));

    loading = false;
    notifyListeners();

    dynamic json = jsonDecode(response.body);
    if (response.statusCode == 200) {
      value = json['value'].toDouble();
      notifyListeners();
    } else {
      errorMessage = 'A aparut o eroare, va rugam incercati mai tarziu';
      notifyListeners();
    }
  }
}
