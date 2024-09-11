import 'package:flutter/material.dart';
import '../../config/DBConnection.dart';
import '../admin/FleetsUnitsView.dart';
import '../admin/HomeAdminView.dart';
// import 'package:viaje/views/admin/fleetsusersview.dart'; // Asegúrate de importar fleetsusersview.dart aquí
import 'package:mysql1/mysql1.dart';
import '../admin/RegisterFleetView.dart';

class Fleetsview extends StatefulWidget {
  final int userId;

  Fleetsview({required this.userId});

  @override
  _FleetsviewState createState() => _FleetsviewState();
}

class _FleetsviewState extends State<Fleetsview> {
  List<Map<String, dynamic>> flotillas =
      []; // Lista para almacenar las flotillas del usuario

  @override
  void initState() {
    super.initState();
    fetchFlotillas(); // Llamada inicial para obtener las flotillas del usuario
  }

  void fetchFlotillas() async {
    // Realiza la consulta para obtener las flotillas del usuario
    try {
      final conn = await DBConnection().getConnection();
      Results results = await conn.query(
          'SELECT id_flotilla, matricula_flotilla, tipo_flotilla, cantidad_flotilla, id_usuario_flotilla FROM flotillas WHERE id_usuario_flotilla = ${widget.userId}');

      List<Map<String, dynamic>> fetchedFlotillas =
          []; // Lista temporal para almacenar las flotillas convertidas

      for (var row in results) {
        fetchedFlotillas.add(Map<String, dynamic>.from(row.fields));
      }

      setState(() {
        flotillas = fetchedFlotillas;
      });

      await conn.close();
    } catch (e) {
      print('Error al obtener las flotillas: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFFEF4136),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => HomeAdminView(userId: widget.userId)),
            );
          },
        ),
        title: Text(
          'Tus Flotillas',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
      ),
      body: ListView.builder(
        itemCount: flotillas.length,
        itemBuilder: (context, index) {
          return ListTile(
            leading: Icon(Icons.directions_bus), // Icono para cada flotilla
            title: Text('${flotillas[index]['matricula_flotilla']}'),
            subtitle: Text(_getTipoFlotilla(flotillas[index]['tipo_flotilla']) +
                ' - ${flotillas[index]['cantidad_flotilla']}'),
            trailing: IconButton(
              icon: Icon(Icons.remove_red_eye),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Fleetsunitsview(
                        idFlotilla: flotillas[index]['id_flotilla'],
                        userId: widget.userId),
                  ),
                );
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Color(0xFFEF4136),
        onPressed: () {
          // Aquí implementamos la lógica para cerrar sesión
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
                builder: (context) => RegisterFleetView(userId: widget.userId)),
            (Route<dynamic> route) =>
                false, // Eliminar todas las rutas anteriores
          );
        },
        tooltip: 'Agregar nueva flotilla',
        child: Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
    );
  }

  // Función para obtener el nombre del tipo de flotilla basado en el tipo
  String _getTipoFlotilla(int tipo) {
    switch (tipo) {
      case 1:
        return 'Vehículos';
      case 2:
        return 'Camiones';
      case 3:
        return 'Autobuses';
      default:
        return 'Desconocido';
    }
  }
}
