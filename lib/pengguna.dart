import 'dart:io';

import 'package:interact_cli/interact_cli.dart';
import 'package:csv/csv_settings_autodetection.dart';
import 'package:csv/csv.dart';
import 'package:dart_console/dart_console.dart';

import 'package:manajemen_museum/helper.dart';

final Console console = Console();
final String eolCsv  = '\n';

class Pengguna {
  String email, _password;
  String? nama,noTelp, tipePengguna;
  DateTime? tanggalLahir;

  Pengguna(
    this.nama,
    this.email,
    this._password,
    this.noTelp,
    this.tipePengguna,
    this.tanggalLahir
  );

  static Map<String, Pengguna> list = {};
  static String lokasiCsv = 'data/pengguna.csv';

  static void inisialisasiData() {
    final fileInput = File(lokasiCsv).readAsStringSync();

    if (fileInput.isEmpty) {
      print('File "$lokasiCsv" tidak terdeteksi!');
      return;
    }

    var csvFormat = FirstOccurrenceSettingsDetector(eols: ['\r', '\n', '\r\n'], fieldDelimiters: [',', ';']);
    final dataInput = CsvToListConverter(csvSettingsDetector: csvFormat, shouldParseNumbers: false).convert(fileInput);

    for (var baris in dataInput) {
      Pengguna pengguna = Pengguna(
        baris[0].toString(),
        baris[1].toString(),
        baris[2].toString(),
        baris[3].toString(),
        baris[4].toString(),
        Helper.stringToTanggal(baris[5].toString()) 
      );
      pengguna.simpan();
    }
  }

  static void sinkronData() {
    List<List<String>> data = [];
    for (var pengguna in list.values) {
      List<String> dataBaris = [];
      dataBaris.addAll([
        pengguna.nama ?? '-',
        pengguna.email,
        pengguna._password,
        pengguna.noTelp ?? '-',
        pengguna.tipePengguna ?? '-',
        Helper.tanggalToString(pengguna.tanggalLahir)
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

  Pengguna.kredensial(this.email, this._password);

  void simpan() {
    list[email] = this;
  }

  void login() {
    Pengguna.inisialisasiData();
    if (list.containsKey(email) && _password == list[email]!._password) {
      print('setidaknya masuk');
      switch (list[email]!.tipePengguna) {
        case 'ADMIN':
          print('deket');
          Petugas? admin = Petugas.autentikasi(email);
          if (admin != null) {
            print('bingo');
            admin.beranda();
          }
        break;
        case 'PENGUNJUNG':
          Pengunjung? pengunjung = Pengunjung.autentikasi(email);
          if (pengunjung != null) {
            pengunjung.beranda();
          }
        break;
      }
    
      print('Proses Autentikasi Berhasil!');
    } else if (list.containsKey(email) && _password != list[email]!._password) {
    
      print('Password Salah! Silahkan Coba Kembali');
    } else {
    
      print('Error : Pengguna tidak ditemukan!');
    }
  }

  void editProfil(String email, Pengguna pengguna) {

  }

  void gantiPassword(String email, String passwordLama, String, passwordBaru) {

  }
}

class Petugas extends Pengguna {
  String idPetugas, jabatan;

  Petugas (
    String super.nama, 
    super.email, 
    super._password, 
    super.tipePengguna, 
    super.noTelp, 
    DateTime super.tanggalLahir,
    this.idPetugas,
    this.jabatan
  );

  static Map<String, Petugas> list = {};
  static String lokasiCsv = 'data/petugas.csv';

  static void inisialisasiData() {
    final fileInput = File(lokasiCsv).readAsStringSync();

    if (fileInput.isEmpty) {
      print('File "$lokasiCsv" tidak terdeteksi!');
      return;
    }

    var csvFormat = FirstOccurrenceSettingsDetector(eols: ['\r', '\n', '\r\n'], fieldDelimiters: [',', ';']);
    final dataInput = CsvToListConverter(csvSettingsDetector: csvFormat, shouldParseNumbers: false).convert(fileInput);

    for (var baris in dataInput) {
      Pengguna pengguna = Pengguna(
        baris[0].toString(),
        baris[1].toString(),
        baris[2].toString(),
        baris[3].toString(),
        baris[4].toString(),
        Helper.stringToTanggal(baris[5].toString()) 
      );
      pengguna.simpan();
    }
  }

  static void sinkronData() {
    List<List<String>> data = [];
    for (var pengguna in list.values) {
      List<String> dataBaris = [];
      dataBaris.addAll([
        pengguna.nama ?? '-',
        pengguna.email,
        pengguna._password,
        pengguna.noTelp ?? '-',
        pengguna.tipePengguna ?? '-',
        Helper.tanggalToString(pengguna.tanggalLahir)
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

  void beranda() {
    bool menuPetugas = true;
    
    while (menuPetugas) {
      int pilihan = Select(
        prompt: '-- Menu Petugas --', 
        options: [
          "Kelola Galeri",
          "Kelola Koleksi",
          "Kelola Pengguna",
          "Logout",
        ]
      ).interact();

      switch (pilihan) {
        case 0:
          
        break;
        case 1:
          
        break;
        case 2:
          menuPetugas = false;
        break;
        default:
          print('input tidak valid!');
      } 
    }
  }

  @override
  void simpan() {
    if (Pengguna.list.containsKey(email)) {
      print('Pengguna sudah ada!');
      if (Petugas.list.containsKey(email)) {
        Petugas.list[email] = this;
        return;
      }
      return;
    }
    
    Pengguna.list[email] = Pengguna(nama, email, _password, noTelp, tipePengguna, tanggalLahir);
    Petugas.list[email] = this;
    return;
  }

  static Petugas? autentikasi(String email) {
    if (list.containsKey(email)) {
      return list[email];
    } else {
      print('"$email" tidak terdaftar sebagai admin!');
      return null;
    }
  }


  static void showListPengguna() {
    Table tabel = Table()
      ..insertColumn(header: "Email", alignment: TextAlignment.center)
      ..insertColumn(header: "Nama", alignment: TextAlignment.center)
      ..insertColumn(header: "Tipe Pengguna", alignment: TextAlignment.center)
      ..insertColumn(header: "Tanggal Lahir", alignment: TextAlignment.center)
      ..insertColumn(header: "No Telp", alignment: TextAlignment.center)
      ..headerStyle = FontStyle.bold
      ..headerColor = ConsoleColor.green
      ..borderStyle = BorderStyle.square
      ..borderType = BorderType.grid
      ..borderColor = ConsoleColor.cyan;
    
    if (Pengguna.list.isEmpty) {
      tabel.insertRow(List.filled(5, '-')); 
    } else {
      for (var pengguna in Pengguna.list.values) {
        tabel.insertRow([
          pengguna.email,
          pengguna.nama ?? '-',
          pengguna.tipePengguna ?? '-',
          Helper.tanggalToString(pengguna.tanggalLahir),
          pengguna.noTelp ?? '-',
        ]);
      }
    }

    print(tabel);
  }  
}

class Pengunjung extends Pengguna {
  DateTime tanggalDaftar;

  Pengunjung (
    String super.nama, 
    super.email, 
    super._password, 
    String super.tipePengguna, 
    String super.noTelp, 
    DateTime super.tanggalLahir,
    this.tanggalDaftar
  );

  static Map<String, Pengunjung> list = {};

  void daftar(Pengunjung pengunjungBaru) {
    Pengguna penggunaBaru = Pengguna(
      pengunjungBaru.nama, 
      pengunjungBaru.email, 
      pengunjungBaru._password, 
      pengunjungBaru.noTelp, 
      pengunjungBaru.tipePengguna, 
      pengunjungBaru.tanggalLahir
    );
    penggunaBaru.simpan();
    print('Anda Berhasil Didaftarkan!');
    penggunaBaru.login();
  }

  void beranda() {
    bool menuPengunjung = true;
    
    while (menuPengunjung) {
      int pilihan = Select(
        prompt: '-- Menu Pengunjung --', 
        options: [
          "Pesan Tiket",
          "Cetak Tiket",
          "Logout",
        ]
      ).interact();

      switch (pilihan) {
        case 0:
          
        break;
        case 1:
          
        break;
        case 2:
          menuPengunjung = false;
        break;
        default:
          print('input tidak valid!');
      } 
    }
  }

  @override
  void simpan() {
    Pengguna.list[email] = Pengguna(nama, email, _password, noTelp, tipePengguna, tanggalLahir);
    Pengunjung.list[email] = this;
  }

  static Pengunjung? autentikasi(String email) {
    if (list.containsKey(email)) {
      return list[email];
    }

    print('"$email" tidak terdaftar sebagai admin!');
    return null;
  }

  void pesanTiket() {
    
  }

  void bayarTiket() {

  }

  void scanTiket() {

  }
}