import 'package:flutter/material.dart';
import '../../config/DBConnection.dart';
import 'package:mysql1/mysql1.dart';
import '/views/admin/fleetsView.dart';

class EditUnitView extends StatefulWidget {
  final int idUnidad;
  final int userId;

  EditUnitView({required this.idUnidad, required this.userId});

  @override
  _EditUnitViewState createState() => _EditUnitViewState();
}

class _EditUnitViewState extends State<EditUnitView> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController _matriculaController = TextEditingController();
  List<Map<String, dynamic>> conductores = [];
  String? selectedConductor;

  @override
  void initState() {
    super.initState();
    fetchConductores();
    fetchUnidad();
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

  void fetchUnidad() async {
    try {
      final conn = await DBConnection().getConnection();
      Results results = await conn.query(
          'SELECT * FROM unidades WHERE id_unidad = ?', [widget.idUnidad]);

      if (results.isNotEmpty) {
        setState(() {
          _matriculaController.text = results.first['placa_unidad'];
          selectedConductor = results.first['id_conductor'].toString();
        });
      }

      await conn.close();
    } catch (e) {
      print('Error al obtener la unidad: $e');
    }
  }

  void updateUnidad() async {
    if (_formKey.currentState!.validate()) {
      try {
        final creationDate = DateTime.now().toUtc();
        final conn = await DBConnection().getConnection();
        await conn.query(
          'UPDATE unidades SET placa_unidad = ?, id_conductor_unidad = ?, fecha_modificacion_unidad = ? WHERE id_unidad = ?',
          [
            _matriculaController.text,
            selectedConductor,
            creationDate,
            widget.idUnidad
          ],
        );
        await conn.close();
        Navigator.pop(context);
      } catch (e) {
        print('Error al actualizar la unidad: $e');
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
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => Fleetsview(userId: widget.userId)),
            );
          },
        ),
        title: Text(
          'Editar Unidad',
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
                onPressed: updateUnidad,
                child: Text(
                  'Actualziar',
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
