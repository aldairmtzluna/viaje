import 'package:flutter/material.dart';
import '../../config/DBConnection.dart';
import 'FleetsUnitsView.dart';
import 'package:mysql1/mysql1.dart';

class AddUnitView extends StatefulWidget {
  final int idFlotilla;
  final int userId;

  AddUnitView({required this.idFlotilla, required this.userId});

  @override
  _AddUnitViewState createState() => _AddUnitViewState();
}

class _AddUnitViewState extends State<AddUnitView> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController _matriculaController = TextEditingController();
  List<Map<String, dynamic>> conductores = [];
  String? selectedConductor;

  @override
  void initState() {
    super.initState();
    fetchConductores();
  }

  void fetchConductores() async {
    try {
      final conn = await DBConnection().getConnection();
      Results results = await conn.query(
          'SELECT * FROM conductores WHERE id_usuario_conductor = ?',
          [widget.userId]);

      List<Map<String, dynamic>> fetchedConductores = [];

      for (var row in results) {
        fetchedConductores.add(Map<String, dynamic>.from(row.fields));
      }

      setState(() {
        conductores = fetchedConductores;
        if (conductores.isNotEmpty) {
          selectedConductor = conductores.first['id_conductor'].toString();
        } else {
          selectedConductor = null;
        }
      });

      await conn.close();
    } catch (e) {
      print('Error al obtener los conductores: $e');
    }
  }

  void addUnidad() async {
    if (_formKey.currentState!.validate()) {
      try {
        final creationDate = DateTime.now().toUtc();
        final conn = await DBConnection().getConnection();
        await conn.query(
          'INSERT INTO unidades (placa_unidad, id_flotilla_unidad, fecha_creacion_unidad, id_conductor_unidad) VALUES (?, ?, ?, ?)',
          [
            _matriculaController.text,
            widget.idFlotilla,
            creationDate,
            selectedConductor
          ],
        );

        // Actualizar cantidad_flotilla
        Results flotillaResults = await conn.query(
            'SELECT cantidad_flotilla FROM flotillas WHERE id_flotilla = ?',
            [widget.idFlotilla]);

        if (flotillaResults.isNotEmpty) {
          var row = flotillaResults.first;
          String cantidadFlotilla = row['cantidad_flotilla'];
          int numero = int.parse(cantidadFlotilla.split(' ')[0]);
          String palabra = cantidadFlotilla.split(' ').sublist(1).join(' ');

          numero = numero + 1;

          String nuevaCantidadFlotilla = '$numero $palabra';
          await conn.query(
              'UPDATE flotillas SET cantidad_flotilla = ? WHERE id_flotilla = ?',
              [nuevaCantidadFlotilla, widget.idFlotilla]);
        }

        await conn.close();
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => Fleetsunitsview(
                idFlotilla: widget.idFlotilla, userId: widget.userId),
          ),
        );
      } catch (e) {
        print('Error al agregar la unidad: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (conductores.isEmpty ||
        !conductores.any((conductor) =>
            conductor['id_conductor'].toString() == selectedConductor)) {
      selectedConductor = null;
    }

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
          'Agregar Unidad',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _matriculaController,
                decoration: InputDecoration(
                  labelText: 'Placa ò matrícula',
                  filled: true,
                  fillColor: Colors.grey[200],
                  border: InputBorder.none,
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, ingrese la placa ò matrìcula del vehiculo';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: selectedConductor,
                items: conductores.map((conductor) {
                  return DropdownMenuItem<String>(
                    value: conductor['id_conductor'].toString(),
                    child: Text(
                      '${conductor['matricula_conductor']} - ${conductor['nombre_conductor']} ${conductor['apellido_paterno_conductor']}',
                    ),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    selectedConductor = value;
                  });
                },
                decoration: InputDecoration(
                  labelText: 'Conductor',
                  filled: true,
                  fillColor: Colors.grey[200],
                  border: InputBorder.none,
                ),
                validator: (value) {
                  if (value == null) {
                    return 'Por favor, seleccione un conductor';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: addUnidad,
                child: Text(
                  'Agregar',
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFFEF4136),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
