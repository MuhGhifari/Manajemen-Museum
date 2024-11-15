import 'dart:io';

import 'package:csv/csv.dart';
import 'package:csv/csv_settings_autodetection.dart';
import 'package:manajemen_museum/helper.dart';

final String eolCsv  = '\n';

class Koleksi {
  String idKoleksi, nama, deskripsi, status;
  DateTime tanggalMasuk;

  Koleksi(
    this.idKoleksi,
    this.nama,
    this.deskripsi,
    this.status,
    this.tanggalMasuk
  );

  static Map<String, Koleksi> list = {};
  static String lokasiCsv = 'data/koleksi.csv';

  static void inisialisasiData() {
    final fileInput = File(lokasiCsv).readAsStringSync();

    if (fileInput.isEmpty) {
      print('File "$lokasiCsv" tidak terdeteksi!');
      return;
    }

    var csvFormat = FirstOccurrenceSettingsDetector(eols: ['\r', '\n', '\r\n'], fieldDelimiters: [',', ';']);
    final dataInput = CsvToListConverter(csvSettingsDetector: csvFormat, shouldParseNumbers: false).convert(fileInput);

    for (var baris in dataInput) {
      Koleksi koleksi = Koleksi(
        baris[0], // idKoleksi
        baris[1], // nama
        baris[2], // deskripsi
        baris[3], // status
        baris[4], // tanggalMasuk
      );
      koleksi.simpan();
    }
  }

  static void sinkronData() {
    List<List<String>> data = [];

    for (var koleksi in list.values) {
      List<String> dataBaris = [];
      dataBaris.addAll([
        koleksi.idKoleksi,
        koleksi.nama,
        koleksi.deskripsi,
        koleksi.status,
        Helper.tanggalToString(koleksi.tanggalMasuk)
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
    list[idKoleksi] = this;
  }

  void hapus(String idKoleksi) {
    list.remove(idKoleksi);
  }
}