class AccountAddress {
  String? street;
  String? number;
  double? longitude;
  double? latitude;

  AccountAddress({
    this.street,
    this.number,
    this.longitude,
    this.latitude,
  });

  factory AccountAddress.fromJSON(Map<String, dynamic> json) {
    return AccountAddress(
      street: json['street'] ?? '',
      number: json['number'] ?? '',
      longitude: json['longitude'] == 0 ? 0.0 : json['longitude'],
      latitude: json['latitude'] == 0 ? 0.0 : json['latitude'],
    );
  }

  Map<String, dynamic> toJSON() {
    Map<String, dynamic> accountJSON = <String, dynamic>{
      'street': street,
      'number': number,
      'longitude': longitude,
      'latitude': latitude,
    };

    return accountJSON;
  }
}

class Account {
  String? id;
  String? phone;
  String? firstName;
  String? lastName;
  String? stripeCustomerID;
  AccountAddress? homeAddress;
  AccountAddress? workAddress;

  Account({
    this.id,
    this.phone,
    this.firstName,
    this.lastName,
    this.stripeCustomerID,
    this.homeAddress,
    this.workAddress,
  });

  factory Account.fromJSON(Map<String, dynamic> json) {
    return Account(
      id: json['id'],
      phone: json['phone'],
      firstName: json['firstName'],
      lastName: json['lastName'],
      stripeCustomerID: json['stripeCustomerID'],
      homeAddress: AccountAddress.fromJSON(json['homeAddress']),
      workAddress: AccountAddress.fromJSON(json['workAddress']),
    );
  }

  Map<String, dynamic> toJSON() {
    Map<String, dynamic> accountJSON = <String, dynamic>{
      'id': id,
      'phone': phone,
      'firstName': firstName,
      'lastName': lastName,
      'stripeCustomerID': stripeCustomerID,
      'homeAddress': homeAddress?.toJSON(),
      'workAddress': workAddress?.toJSON(),
    };

    return accountJSON;
  }
}
