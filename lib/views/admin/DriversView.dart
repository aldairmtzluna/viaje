import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../admin/TripAssignmentView.dart';
import 'AddUnitView.dart';

class Driversview extends StatefulWidget {
  final int userId;

  Driversview({required this.userId});

  @override
  _DriversviewState createState() => _DriversviewState();
}

class _DriversviewState extends State<Driversview> {
  List<Map<String, dynamic>> conductores =
      []; // Lista para almacenar los conductores del usuario

  @override
  void initState() {
    super.initState();
    fetchConductores(); // Llamada inicial para obtener los conductores del usuario
  }

  void fetchConductores() async {
    // URL de la API
    final url =
        'https://whitesmoke-magpie-578690.hostingersite.com/index.php/conductores?id_usuario_pertenece_conductor=${widget.userId}';

    try {
      // Realizar la solicitud GET a la API
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        // Parsear la respuesta JSON
        final List<dynamic> data = json.decode(response.body);

        List<Map<String, dynamic>> fetchedConductores =
            []; // Lista temporal para almacenar los conductores convertidos

        for (var item in data) {
          fetchedConductores.add({
            'id_conductor': item['id_conductor'],
            'nombre_conductor': item['nombre_conductor'],
            'apellido_paterno_conductor': item['apellido_paterno_conductor'],
            'apellido_materno_conductor': item['apellido_materno_conductor'],
            'matricula_conductor': item['matricula_conductor'],
            'placa_unidad': item['placa_unidad'] ??
                'Sin unidad', // Agregar la placa de la unidad
            'id_unidad_conductor':
                item['id_unidad_conductor'], // Agregar el id de la unidad
          });
        }

        setState(() {
          conductores = fetchedConductores;
        });
      } else {
        print('Error en la respuesta: ${response.statusCode}');
      }
    } catch (e) {
      print('Error al obtener los conductores: $e');
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
            Navigator.pop(context);
          },
        ),
        title: Text(
          'Tus Conductores',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
      ),
      body: ListView.builder(
        itemCount: conductores.length,
        itemBuilder: (context, index) {
          return ListTile(
            leading:
                Icon(Icons.supervised_user_circle), // Icono para cada conductor
            title: Text('${conductores[index]['matricula_conductor']}'),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${conductores[index]['nombre_conductor'] ?? 'Sin conductor'} ${conductores[index]['apellido_paterno_conductor'] ?? ''} ${conductores[index]['apellido_materno_conductor'] ?? ''}',
                ),
                SizedBox(height: 4),
                Text(
                  'Unidad: ${conductores[index]['placa_unidad']}',
                  style: TextStyle(fontSize: 14, color: Colors.grey),
                ),
              ],
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: Icon(Icons.alt_route_sharp),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => TripAssignmentView(
                          idConductor: conductores[index]['id_conductor'],
                          idUnidad: conductores[index]['id_unidad_conductor'],
                        ),
                      ),
                    );
                  },
                ),
                IconButton(
                  icon: Icon(Icons.edit),
                  onPressed: () {
                    // Implementar la funcionalidad de edición
                  },
                ),
                IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () {
                    // Implementar la funcionalidad de eliminación
                  },
                ),
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Color(0xFFEF4136),
        onPressed: () {
          // Implementar la navegación a la vista de registro de nuevos conductores
        },
        tooltip: 'Agregar nuevo conductor',
        child: Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
    );
  }
}
