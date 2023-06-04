import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:transitway/Pages/navbar.dart';
import 'package:transitway/Pages/onboarding/namepage.dart';
import 'package:transitway/Pages/onboarding/otp.dart';
import 'package:transitway/utils/prefs.dart';

import 'package:transitway/state/state.dart' as state;

import '../datamodels/account.dart';
import '../url.dart';

class AccountProvider with ChangeNotifier {
  String phoneNumber = '';
  bool newClient = false;
  String token = '';
  bool loading = false;
  String errorMessage = '';
  bool hasError = false;

  Account account = Account();

  loadAccount() async {
    token = await getToken();
    state.token = token;
    account = await getAccount();
    state.account = account;
    print(state.account.homeAddress?.street);
    notifyListeners();
  }

  setError(String message) {
    errorMessage = message;
    notifyListeners();
  }

  onboarding(String phone, BuildContext context) async {
    phoneNumber = phone;
    loading = true;
    notifyListeners();

    final response = await http.post(AppURL.onboardingPhone,
        headers: basicHeader,
        body: jsonEncode(<String, String>{
          'phone': phone,
        }));

    loading = false;
    notifyListeners();

    final body = json.decode(response.body);
    if (response.statusCode == 200) {
      newClient = body['newClient'];
      token = body['token'];

      errorMessage = '';

      Navigator.push(
          context, MaterialPageRoute(builder: (context) => const OTPPage()));

      notifyListeners();
    }
  }

  verifyCode(String code, BuildContext context) async {
    final response = await http.post(AppURL.onboardingVerifyCode,
        headers: authHeader(token),
        body: jsonEncode(<String, String>{
          'phone': phoneNumber,
          'code': code,
        }));

    final json = jsonDecode(response.body);
    if (response.statusCode == 200) {
      token = json['token'];
      state.token = token;
      setToken(token);
      notifyListeners();

      account = Account.fromJSON(json['account']);
      state.account = account;
      setAccount(account);

      if (newClient) {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => const NamePage()));
      } else {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => const NavBar(
                      pageIndex: 1,
                    )));
      }

      errorMessage = '';

      notifyListeners();
    } else {
      errorMessage = json['message'];
      notifyListeners();
    }
  }

  addName(String lastName, String firstName, BuildContext context) async {
    loading = true;
    notifyListeners();

    final response = await http.post(AppURL.onboardingName,
        headers: authHeader(token),
        body: jsonEncode(<String, String>{
          "firstName": firstName,
          "lastName": lastName,
        }));

    loading = false;
    notifyListeners();

    final json = jsonDecode(response.body);
    if (response.statusCode == 200) {
      token = json['token'];
      setToken(token);
      notifyListeners();

      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => const NavBar(
                  pageIndex: 1,
                )),
      );

      account = Account.fromJSON(json['account']);
      setAccount(account);
    } else {
      errorMessage = json['message'];
    }
  }

  addAddressAccount(
      AccountAddress address, String typeOf, BuildContext context) async {
    print(address.street);
    final response = await http.post(
        Uri.parse(AppURL.settingsAddAccountAddress + typeOf),
        headers: authHeader(token),
        body: jsonEncode(<String, String>{"street": address.street ?? ''}));

    final json = jsonDecode(response.body);
    if (response.statusCode == 200) {
      account = Account.fromJSON(json['account']);

      setAccount(account);

      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => const NavBar(
                    pageIndex: 2,
                  )));
    }
  }

  logout() async {
    account = Account();
    token = '';

    removeAccount();
    removeToken();

    notifyListeners();
  }
}
