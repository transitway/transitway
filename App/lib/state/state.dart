// url and other stuff
import 'package:transitway/datamodels/account.dart';

String apiURL = 'https://api.transitway.tech';

// local storage
dynamic localprefs;

// account
String phone = '';
String token = '';
bool newClient = true;
Account account = Account();

// handling backend functions
bool loading = false;
String errorMessage = '';

bool validCode = false;

//
double balance = 0.0;

String homeAddress = 'Strada Dealu cu Piatra 2';
String workAddress = 'Strada Ion Th. Grigore 22';
