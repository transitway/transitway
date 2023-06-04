import 'package:shared_preferences/shared_preferences.dart';
import 'package:transitway/state/state.dart';

import 'package:transitway/datamodels/account.dart';

Future<String> getToken() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String loadedtoken = prefs.getString('token').toString();
  token = loadedtoken;
  return loadedtoken;
}

Future<Account> getAccount() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return Account(
      id: prefs.getString('account.id'),
      phone: prefs.getString('account.phone'),
      firstName: prefs.getString('account.firstName'),
      lastName: prefs.getString('account.lastName'),
      stripeCustomerID: prefs.getString('account.stripeCustomerID'),
      homeAddress:
          AccountAddress(street: prefs.getString('account.homeAddress.street')),
      workAddress: AccountAddress(
          street: prefs.getString('account.workAddress.street')));
}

void setToken(String token) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setString('token', token);
}

void setAccount(Account account) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setString('account.id', account.id.toString());
  prefs.setString('account.phone', account.phone.toString());
  prefs.setString('account.firstName', account.firstName.toString());
  prefs.setString('account.lastName', account.lastName.toString());
  prefs.setString(
      'account.stripeCustomerID', account.stripeCustomerID.toString());
  prefs.setString(
      'account.homeAddress.street', account.homeAddress?.street ?? '');
  prefs.setString(
      'account.workAddress.street', account.workAddress?.street ?? '');
}

void removeToken() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.remove('token');
}

void removeAccount() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.remove('account.id');
  prefs.remove('account.phone');
  prefs.remove('account.firstName');
  prefs.remove('account.lastName');
  prefs.remove('account.stripeCustomerID');
}

void removePrefs() async {
  removeToken();
  removeAccount();
}
