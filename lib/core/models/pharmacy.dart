class Pharmacy {
  String _date;
  String _locy;
  String _locx;
  String _name;
  String _phone;
  String _address;
  int _areaid;
  String _area;
  int _id;
  int _ilceid;

  Pharmacy(this._date, this._locy, this._locx, this._name, this._phone,
      this._address, this._areaid, this._area, this._id, this._ilceid);

  factory Pharmacy.fromJSON(Map<String, dynamic> json) {
    if (json == null) {
      return null;
    } else {
      return Pharmacy(
          json['Tarih'],
          json['LokasyonY'],
          json['LokasyonX'],
          json['Adi'],
          json['Telefon'],
          json['Adres'],
          json['BolgeId'],
          json['Bolge'],
          json['EczaneId'],
          json['IlceId']);
    }
  }

  String get date => _date;
  String get locy => _locy;
  String get locx => _locx;
  String get name => _name;
  String get phone => _phone;
  String get address => _address;
  int get areaid => _areaid;
  String get area => _area;
  int get id => _id;
  int get ilceid => _ilceid;
}
