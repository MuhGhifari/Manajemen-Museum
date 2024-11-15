import 'package:intl/intl.dart';

class Helper {
  static DateTime stringToTanggal(String tanggal) {
    return DateFormat('dd/MM/yyyy').parse(tanggal);
  }

  static String tanggalToString(DateTime? tanggal) {
    if (tanggal == null) {
      return '-';
    }
    
    return DateFormat('dd/MM/yyyy').format(tanggal);
  }
}