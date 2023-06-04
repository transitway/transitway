class AppURL {
  static const String liveBaseURL = 'https://api.transitway.online';
  static const String devBaseURL = 'http://localhost:4200';

  static const String livePaymentsURL = 'https://payments.transitway.online';
  static const String devPaymentsURL = 'http://localhost:5173';

  static const String baseURL = liveBaseURL;
  static const String paymentsURL = livePaymentsURL;

  static Uri test = Uri.parse('$baseURL/accounts/onboarding/test');

  static Uri onboardingPhone = Uri.parse('$baseURL/accounts/onboarding');
  static Uri onboardingVerifyCode =
      Uri.parse('$baseURL/accounts/onboarding/verify-code');
  static Uri onboardingName = Uri.parse('$baseURL/accounts/onboarding/name');
  static String settingsAddAccountAddress =
      '$baseURL/accounts/settings/address/';

  static Uri getBalance = Uri.parse("$baseURL/accounts/balance/");

  static Uri getTickets = Uri.parse("$baseURL/tickets");
  static Uri getTicketTypes = Uri.parse("$baseURL/tickets/types");
  static String buyTicket = "$baseURL/tickets/buy?typeID=";
}

const Map<String, String> basicHeader = <String, String>{
  'Content-Type': 'application/json',
};

Map<String, String> authHeader(String token) {
  return <String, String>{
    'Content-Type': 'application/json',
    'Authorization': 'Bearer $token',
  };
}
