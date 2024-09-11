import 'package:flutter/material.dart';
import '../../config/DBConnection.dart';
import '../admin/AddUnitView.dart';
import '../admin/EditUnitView.dart';
import 'package:mysql1/mysql1.dart';

class Fleetsunitsview extends StatefulWidget {
  final int idFlotilla;
  final int userId;

  Fleetsunitsview({required this.idFlotilla, required this.userId});

  @override
  _FleetsunitsviewState createState() => _FleetsunitsviewState();
}

class _FleetsunitsviewState extends State<Fleetsunitsview> {
  List<Map<String, dynamic>> unidades = [];

  @override
  void initState() {
    super.initState();
    fetchUnidades();
  }

  void fetchUnidades() async {
    try {
      final conn = await DBConnection().getConnection();
      Results results = await conn.query(
          'SELECT u.id_unidad, u.placa_unidad, c.nombre_conductor, c.apellido_paterno_conductor, c.apellido_materno_conductor '
          'FROM unidades u '
          'LEFT JOIN conductores c ON u.id_conductor_unidad = c.id_conductor '
          'WHERE u.id_flotilla_unidad = ?',
          [widget.idFlotilla]);

      List<Map<String, dynamic>> fetchedUnidades = [];

      for (var row in results) {
        fetchedUnidades.add(Map<String, dynamic>.from(row.fields));
      }

      setState(() {
        unidades = fetchedUnidades;
      });

      await conn.close();
    } catch (e) {
      print('Error al obtener las unidades: $e');
    }
  }

  void deleteUnidad(int idUnidad) async {
    bool? confirmed = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirmar eliminación'),
          content: Text(
              '¿Estás seguro de que deseas eliminar esta unidad de tu flotilla?'),
          actions: [
            TextButton(
              child: Text(
                'Cancelar',
                style: TextStyle(
                  fontSize: 16,
                  color:
                      Color(0xFFEF4136), // Cambia el color del texto a blanco
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop(false);
              },
            ),
            TextButton(
              child: Text(
                'Aceptar',
                style: TextStyle(
                  fontSize: 16,
                  color:
                      Color(0xFFEF4136), // Cambia el color del texto a blanco
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop(true);
              },
            ),
          ],
        );
      },
    );

    if (confirmed == true) {
      try {
        final conn = await DBConnection().getConnection();
        await conn
            .query('DELETE FROM unidades WHERE id_unidad = ?', [idUnidad]);

        // Actualizar cantidad_flotilla
        Results flotillaResults = await conn.query(
            'SELECT cantidad_flotilla FROM flotillas WHERE id_flotilla = ?',
            [widget.idFlotilla]);

        if (flotillaResults.isNotEmpty) {
          var row = flotillaResults.first;
          String cantidadFlotilla = row['cantidad_flotilla'];
          int numero = int.parse(cantidadFlotilla.split(' ')[0]);
          String palabra = cantidadFlotilla.split(' ').sublist(1).join(' ');

          numero = numero - 1;

          String nuevaCantidadFlotilla = '$numero $palabra';
          await conn.query(
              'UPDATE flotillas SET cantidad_flotilla = ? WHERE id_flotilla = ?',
              [nuevaCantidadFlotilla, widget.idFlotilla]);
        }

        await conn.close();
        fetchUnidades();
      } catch (e) {
        print('Error al eliminar la unidad: $e');
      }
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
          'Unidades de la Flotilla',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
      ),
      body: ListView.builder(
        itemCount: unidades.length,
        itemBuilder: (context, index) {
          final unidad = unidades[index];
          return ListTile(
            leading: Icon(Icons.directions_car),
            title: Text(unidad['placa_unidad']?.isNotEmpty == true
                ? unidad['placa_unidad']
                : 'Sin matrícula'),
            subtitle: Text(
              '${unidad['nombre_conductor'] ?? 'Sin conductor'} ${unidad['apellido_paterno_conductor'] ?? ''} ${unidad['apellido_materno_conductor'] ?? ''}',
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: Icon(Icons.edit),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => EditUnitView(
                            idUnidad: unidad['id_unidad'],
                            userId: widget.userId),
                      ),
                    ).then((_) {
                      fetchUnidades();
                    });
                  },
                ),
                IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () {
                    deleteUnidad(unidad['id_unidad']);
                  },
                ),
                IconButton(
                  icon: Icon(Icons.remove_red_eye),
                  onPressed: () {
                    // Implementar la navegación a la vista de información de la unidad
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
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddUnitView(
                idFlotilla: widget.idFlotilla,
                userId: widget.userId,
              ),
            ),
          );
        },
        tooltip: 'Agregar nueva unidad',
        child: Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
    );
  }
}
