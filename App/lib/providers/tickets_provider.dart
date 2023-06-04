import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:transitway/Pages/navbar.dart';
import 'package:transitway/url.dart';
import 'package:transitway/state/state.dart' as state;
import 'package:http/http.dart' as http;

import '../datamodels/ticket.dart';
import '../datamodels/ticket_type.dart';

class TicketsProvider with ChangeNotifier {
  List<Ticket> list = [];
  List<TicketType> typeList = [];
  bool loading = false;
  String errorMessage = '';

  getTickets() async {
    loading = true;
    notifyListeners();
    final response =
        await http.get(AppURL.getTickets, headers: authHeader(state.token));
    loading = false;
    notifyListeners();

    dynamic json = jsonDecode(response.body);
    if (response.statusCode == 200) {
      List<Ticket> ticketsList =
          List<Ticket>.from(json.map((x) => Ticket.fromJSON(x)));
      ticketsList.sort(
          (b, a) => a.expiresAt.toString().compareTo(b.expiresAt.toString()));
      list = ticketsList;
      notifyListeners();
    } else {
      errorMessage = 'Nu s-au putut gasi biletele existente';
    }
  }

  getTicketTypes(String city) async {
    loading = true;
    notifyListeners();
    final response =
        await http.get(AppURL.getTicketTypes, headers: authHeader(state.token));
    loading = false;
    notifyListeners();

    final json = jsonDecode(response.body);
    if (response.statusCode == 200) {
      typeList = List<TicketType>.from(json.map((x) => TicketType.fromJSON(x)));
      notifyListeners();
    } else {
      errorMessage = json['message'];
    }
  }

  buyTicket(List<String> lines, String typeID, BuildContext context) async {
    final response = await http.post(Uri.parse("${AppURL.buyTicket}$typeID"),
        headers: authHeader(state.token),
        body: jsonEncode(<String, dynamic>{
          'lines': lines,
        }));

    final json = jsonDecode(response.body);

    if (response.statusCode == 200) {
      Ticket ticket = Ticket.fromJSON(json['ticket']);

      list.add(ticket);
      notifyListeners();

      Navigator.push(context,
          MaterialPageRoute(builder: (context) => const NavBar(pageIndex: 0)));
    } else {
      errorMessage = json['message'];
    }
  }
}
