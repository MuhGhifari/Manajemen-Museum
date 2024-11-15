import 'dart:io';

import 'package:csv/csv.dart';
import 'package:csv/csv_settings_autodetection.dart';

final String eolCsv  = '\n';

class KategoriKoleksi {
  String idKategori, nama, deskripsi;

  KategoriKoleksi(
    this.idKategori,
    this.nama,
    this.deskripsi,
  );

  static Map<String, KategoriKoleksi> list = {};
  static String lokasiCsv = 'data/KategoriKoleksi.csv';

  static void inisialisasiData() {
    final fileInput = File(lokasiCsv).readAsStringSync();

    if (fileInput.isEmpty) {
      print('File "$lokasiCsv" tidak terdeteksi!');
      return;
    }

    var csvFormat = FirstOccurrenceSettingsDetector(eols: ['\r', '\n', '\r\n'], fieldDelimiters: [',', ';']);
    final dataInput = CsvToListConverter(csvSettingsDetector: csvFormat, shouldParseNumbers: false).convert(fileInput);

    for (var baris in dataInput) {
      KategoriKoleksi kategori = KategoriKoleksi(
        baris[0], // idKategori
        baris[1], // nama
        baris[2], // deskripsi
      );
      kategori.simpan();
    }
  }

  static void sinkronData() {
    List<List<String>> data = [];

    for (var kategori in list.values) {
      List<String> dataBaris = [];
      dataBaris.addAll([
        kategori.idKategori,
        kategori.nama,
        kategori.deskripsi,
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