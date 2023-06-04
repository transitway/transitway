import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:transitway/providers/account_provider.dart';
import 'package:transitway/utils/env.dart';
import 'package:transitway/helpers/places_class.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:transitway/components/customaddr.dart';
import 'package:transitway/Pages/navbar.dart';

import '../../datamodels/account.dart';

class CustomAddressPage extends StatefulWidget {
  final bool homeWork;
  const CustomAddressPage({required this.homeWork, Key? key}) : super(key: key);

  @override
  State<CustomAddressPage> createState() => _CustomAddressPageState();
}

class _CustomAddressPageState extends State<CustomAddressPage> {
  final TextEditingController _searchController = TextEditingController();
  String preFilledText = '';
  List<Place> placePredictions = [];
  String text = 'acasa';

  @override
  void initState() {
    super.initState();
    AccountProvider auth = AccountProvider();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      auth = Provider.of<AccountProvider>(context, listen: false);
    });
    if (widget.homeWork) {
      preFilledText = auth.account.workAddress?.street ?? '';
      text = 'serviciu';
    } else {
      preFilledText = auth.account.homeAddress?.street ?? '';
      text = 'acasa';
    }
    _searchController.text = preFilledText;
  }

  void onPlaceSelected(String fromLocation) {
    if (widget.homeWork) {
      workAddress = fromLocation;
    } else {
      homeAddress = fromLocation;
    }
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const NavBar(
          pageIndex: 2,
        ),
      ),
    );
  }

  Future<void> getPlacePredictions(String input) async {
    if (input.isEmpty) {
      setState(() {
        placePredictions = [];
      });
      return;
    }

    final apiKey = mapKey;
    const apiUrl =
        'https://maps.googleapis.com/maps/api/place/autocomplete/json';
    final sessionToken = DateTime.now().millisecondsSinceEpoch.toString();

    final response = await http.get(Uri.parse(
        '$apiUrl?input=$input&components=country:RO&locationbias=circle:8400@44.942965,26.018094&key=$apiKey&sessiontoken=$sessionToken'));

    if (response.statusCode == 200) {
      const maxLengthDescription = 38; // Maximum length for the description
      const maxLengthName = 28;
      final predictions = json.decode(response.body)['predictions'];
      setState(() {
        placePredictions = predictions.map<Place>((prediction) {
          String description = prediction['description'];
          String name = prediction['structured_formatting']['main_text'];
          if (description.length > maxLengthDescription) {
            description =
                '${description.substring(0, maxLengthDescription)}...';
          }
          if (name.length > maxLengthName) {
            name = '${name.substring(0, maxLengthName)}...';
          }
          return Place(
            description: description,
            placeId: prediction['place_id'],
            name: name,
          );
        }).toList();
      });
    } else {
      throw Exception('Failed to fetch place predictions');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AccountProvider>(builder: (context, auth, _) {
      return Scaffold(
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(30.0),
            child: Column(children: [
              Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const NavBar(
                            pageIndex: 3,
                          ),
                        ),
                      );
                    },
                    child: const Icon(Icons.arrow_back_ios_new),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 25.0),
                    child: Text(
                      'Editeaza adresa de $text',
                      style: const TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'UberMoveBold'),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: TextField(
                  autofocus: true,
                  controller: _searchController,
                  onChanged: (text) {
                    Timer(const Duration(milliseconds: 500), () {
                      getPlacePredictions(text);
                    });
                  },
                  cursorColor: Colors.black,
                  style: const TextStyle(
                      fontSize: 17, fontFamily: 'UberMoveMedium'),
                  decoration: InputDecoration(
                    focusedBorder: OutlineInputBorder(
                      borderSide:
                          const BorderSide(color: transitwayPurple, width: 2),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    suffixIcon: GestureDetector(
                      onTap: _searchController.clear,
                      child: const Icon(
                        Icons.clear,
                        color: Colors.black,
                      ),
                    ),
                    prefixIcon: const Icon(
                      Icons.search,
                      color: Colors.black,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: BorderSide.none,
                    ),
                    fillColor: const Color(0xFFE8E8E8),
                    filled: true,
                  ),
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: placePredictions.length,
                  itemBuilder: (context, index) {
                    final prediction = placePredictions[index];
                    return GestureDetector(
                      onTap: () async {
                        // onPlaceSelected(prediction.description);
                        final addr =
                            AccountAddress(street: prediction.description);
                        await auth.addAddressAccount(
                            addr, widget.homeWork ? 'work' : 'home', context);
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 20.0),
                        child: CustomAddr(
                          title: prediction.name,
                          address: prediction.description,
                          icon: Icons.location_on,
                          map: false,
                          color: darkGrey,
                        ),
                      ),
                    );
                  },
                ),
              ),
            ]),
          ),
        ),
      );
    });
  }
}
