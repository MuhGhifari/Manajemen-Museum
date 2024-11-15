import 'dart:io';

import 'package:csv/csv.dart';
import 'package:csv/csv_settings_autodetection.dart';

final String eolCsv  = '\n';

class Galeri {
  String nama, lokasi;

  Galeri(
    this.nama,
    this.lokasi,
  );

  static Map<String, Galeri> list = {};
  static String lokasiCsv = 'data/galeri.csv';

  static void inisialisasiData() {
    final fileInput = File(lokasiCsv).readAsStringSync();

    if (fileInput.isEmpty) {
      print('File "$lokasiCsv" tidak terdeteksi!');
      return;
    }

    var csvFormat = FirstOccurrenceSettingsDetector(eols: ['\r', '\n', '\r\n'], fieldDelimiters: [',', ';']);
    final dataInput = CsvToListConverter(csvSettingsDetector: csvFormat, shouldParseNumbers: false).convert(fileInput);

    for (var baris in dataInput) {
      Galeri galeri = Galeri(
        baris[0], // nama
        baris[1], // lokasi
      );
      galeri.simpan();
    }
  }

  static void sinkronData() {
    List<List<String>> data = [];

    for (var galeri in list.values) {
      List<String> dataBaris = [];
      dataBaris.addAll([
        galeri.nama,
        galeri.lokasi,
      ]);
      data.add(dataBaris);
    }

    String csv = ListToCsvConverter(eol: eolCsv).convert(data);
    File output = File(lokasiCsv);

    try {
      output.writeAsString(csv);
    } catch (e) {
      print('Error : $e');
    }
  }

  void simpan() {
    list[nama] = this;
  }

  void hapus(String nama) {
    list.remove(nama);
  }
}