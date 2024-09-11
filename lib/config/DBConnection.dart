// lib/config/DBConnection.dart
import 'package:mysql1/mysql1.dart';

class DBConnection {
  static final DBConnection _instance = DBConnection._internal();

  factory DBConnection() {
    return _instance;
  }

  DBConnection._internal();

  Future<MySqlConnection> getConnection() async {
    final settings = ConnectionSettings(
      host: '192.168.43.165', // Asegúrate de que no haya espacios aquí
      port: 3306,
      user: 'root',
      password: 'Aldair', // Asegúrate de que la contraseña esté correcta
      db: 'viaje',
    );
    return await MySqlConnection.connect(settings);
  }
}
