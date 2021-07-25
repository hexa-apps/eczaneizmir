import 'dart:convert';
import 'dart:io';

import 'package:eczaneizmir/core/models/pharmacy.dart';
import 'package:http/http.dart' as http;

Future<List> getPharmacies(
  bool nobetci,
) async {
  var values = [];
  String url = nobetci
      ? 'https://openapi.izmir.bel.tr/api/ibb/nobetcieczaneler'
      : 'https://openapi.izmir.bel.tr/api/ibb/eczaneler';
  final response = await http.get(Uri.parse(url));
  if (response.statusCode == HttpStatus.ok) {
    final pharmacy = jsonDecode(response.body);
    for (var i = 0; i < pharmacy.length; i++) {
      values.add(Pharmacy(
        pharmacy.elementAt(i)['Tarih'],
        pharmacy.elementAt(i)['LokasyonY'],
        pharmacy.elementAt(i)['LokasyonX'],
        pharmacy.elementAt(i)['Adi'],
        pharmacy.elementAt(i)['Telefon'],
        pharmacy.elementAt(i)['Adres'],
        int.parse(pharmacy.elementAt(i)['BolgeId'].toString()),
        pharmacy.elementAt(i)['Bolge'],
        int.parse(pharmacy.elementAt(i)['EczaneId'].toString()),
        int.parse(pharmacy.elementAt(i)['IlceId'].toString()),
      ));
    }
    await Future.delayed(Duration(seconds: 1));
  }
  return values;
}

bool isNumeric(String str) {
  if (str == null) {
    return false;
  }
  return double.tryParse(str) != null;
}
