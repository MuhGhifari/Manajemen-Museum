
import 'package:dart_console/dart_console.dart';
import 'package:interact_cli/interact_cli.dart';
import 'package:intl/intl.dart';
import 'package:manajemen_museum/pengguna.dart';

final Console console = Console();

void main() {
  bool menu = true;

  console.clearScreen();

  while(menu) {
    console.setTextStyle(bold: true);
    console.setBackgroundColor(ConsoleColor.green);
    console.writeLine("Museum", TextAlignment.center);
    console.resetColorAttributes();

    int pilihan = Select(
      prompt: "Pilih Menu", 
      options: [
        "Masuk",
        "Daftar",
        "Tutup",
        "Test"
      ]
    ).interact();

    switch (pilihan) {
      case 0:
        console.writeLine("---- Login ----");
        String email = Input(prompt: "Masukkan Email : ").interact();
        String password = Input(prompt: "Masukkan Password : ").interact();

        Pengguna pengguna = Pengguna.kredensial(email, password);
        pengguna.login();
      break;
      case 1:
        console.writeLine('---- Daftar ----');
        String nama = Input(prompt: 'Masukkan Nama : ').interact();
        String noTelp= Input(prompt: 'Masukkan No. Telpon : ').interact();
        String tanggalLahir = Input(prompt: 'Masukkan Tanggal Lahir (dd/mm/yyyy) : ').interact();
        String email = Input(prompt: 'Masukkan Email : ').interact();
        String password = Input(prompt: 'Masukkan Password : ').interact();

        Pengunjung pengunjungBaru = Pengunjung(
          nama, 
          email, 
          password, 
          'PENGUNJUNG', 
          noTelp, 
          DateFormat('dd/MM/yyyy').parse(tanggalLahir), 
          DateTime.now()
        );

        console.clearScreen();
        pengunjungBaru.daftar(pengunjungBaru);
      break;
      case 2:
        print("Terima Kasih...");
        menu = false;
      break;
      case 3: 
        testing();
      break;
      default:
        print('input tidak valid');
    }
  }
}

void testing() {
  // for (var i = 0; i < 10; i++) {
  //   Pengguna penggunaBaru = Pengguna('nama$i', 'email$i', 'password$i', 'noTelp$i', 'PENGUNJUNG', DateTime.now());

  //   penggunaBaru.simpan();
  // }

  // // Pengguna.lokasiCsv = 'data/test.csv';
  // // Pengguna.sinkronData();

  // // Pengguna.lokasiCsv = 'data/test.csv';
  // // Pengguna.inisialisasiData();
  // Pengguna.inisialisasiData();
  // Petugas penggunaBaru = Petugas('admin', 'admin@gmail.com', 'admin', '0895397589062', 'ADMIN', DateTime.now(), 'admin01', 'manajemen');
  // penggunaBaru.simpan();
  // Petugas.showListPengguna();
  // // Pengguna.inisialisasiData();
  // // Pengguna? test = Pengguna.list['admin@gmail.com'];

  // Pengguna.sinkronData();
}