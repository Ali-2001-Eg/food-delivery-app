class AddressModel {
  //nullable because we may create id or not for address
  late int? _id;
  late String _addressType;
  late String? _contactPersonName;
  late String _address;
  late String? _contactPersonNumber;
  late String _latitude;
  late String _longitude;

//without underscore because data will be given from outside
  AddressModel({
    id,
    required addressType,
    contactPersonName,
    address,
    contactPersonNumber,
    latitude,
    longitude,
  }) {
    _id = id;
    _addressType = addressType;
    _address = address;
    _contactPersonName = _contactPersonName;
    _contactPersonNumber = _contactPersonNumber;
    _latitude = latitude;
    _longitude = longitude;
  }

  String get longitude => _longitude;

  String get latitude => _latitude;

  String? get contactPersonNumber => _contactPersonNumber;

  String get address => _address;

  String? get contactPersonName => _contactPersonName;

  String get addressType => _addressType;

//to convert data to object to view it in UI
  AddressModel.fromJson(Map<String, dynamic> json) {
    _id = json['id'];
    _addressType = json['address_type'] ?? '';
    _address = json['address'];
    _contactPersonNumber = json['contact_person_number'] ?? '';
    _contactPersonName = json['contact_person_name'] ?? '';
    _latitude = json['latitude'];
    _longitude = json['longitude'];
  }
//converting object to json to make the post method to the server
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['id'] = _id;
    data['addressType'] = _addressType;
    data['address'] = _address;
    data['contactPersonNumber'] = _contactPersonNumber;
    data['contactPersonName'] = _contactPersonName;
    data['latitude'] = _latitude;
    data['longitude'] = _longitude;
    return data;
  }
}
