import 'dart:math';
import 'package:flutter/material.dart';
import '../../config/DBConnection.dart';
import '../admin/fleetsView.dart';
import '../admin/RegisterFleetView.dart';

class Numberfleetbusesview extends StatelessWidget {
  final int userId;
  final TextEditingController _controller = TextEditingController();

  Numberfleetbusesview({required this.userId});

  String generateFleetRegistration(int nextNumber) {
    const letters = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
    final random = Random();
    final firstLetter = letters[random.nextInt(letters.length)];
    final secondLetter = letters[random.nextInt(letters.length)];
    return 'A$firstLetter$secondLetter${nextNumber.toString().padLeft(2, '0')}';
  }

  Future<int> getNextFleetNumber() async {
    final db = await DBConnection().getConnection();
    var results = await db.query(
        'SELECT MAX(SUBSTRING(matricula_flotilla, 4)) AS max_number FROM flotillas');
    var maxNumber = results.first['max_number'];
    return (maxNumber != null) ? int.parse(maxNumber) + 1 : 1;
  }

  Future<int> getLastFleetId() async {
    final db = await DBConnection().getConnection();
    var results = await db.query(
        'SELECT id_flotilla FROM flotillas ORDER BY id_flotilla DESC LIMIT 1');
    var lastId = results.first['id_flotilla'];
    return (lastId != null) ? lastId : 0;
  }

  Future<void> submitFleet(BuildContext context) async {
    if (_controller.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Ingrese una cantidad de Autobuses.')),
      );
      return;
    }

    final fleetCount = int.parse(_controller.text);
    final nextNumber = await getNextFleetNumber();
    final fleetRegistration = generateFleetRegistration(nextNumber);
    final creationDate = DateTime.now().toUtc();

    final db = await DBConnection().getConnection();
    await db.query(
      'INSERT INTO flotillas (matricula_flotilla, tipo_flotilla, cantidad_flotilla, id_usuario_flotilla, fecha_creacion_flotilla) VALUES (?, 3, ?, ?, ?)',
      [fleetRegistration, '$fleetCount Autobus(es)', userId, creationDate],
    );

    final newFleetId = await getLastFleetId();

    for (int i = 0; i < fleetCount; i++) {
      await db.query(
        'INSERT INTO unidades (placa_unidad, id_flotilla_unidad, fecha_creacion_unidad, fecha_modificacion_unidad) VALUES (?, ?, ?, ?)',
        ['', newFleetId, creationDate, null],
      );
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Flotilla registrada exitosamente.')),
    );

    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => Fleetsview(userId: userId)),
    );
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
                  builder: (context) => RegisterFleetView(userId: userId)),
            );
          },
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              '¿Cuántos autobuses pertenecen a su flotilla?',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20.0),
            Container(
              width: MediaQuery.of(context).size.width * 0.8,
              padding: EdgeInsets.symmetric(horizontal: 20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Colors.grey[200],
              ),
              child: TextField(
                controller: _controller,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: 'Ingrese una cantidad',
                ),
              ),
            ),
            SizedBox(height: 20),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.8,
              height: 45,
              child: ElevatedButton(
                onPressed: () => submitFleet(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFFEF4136),
                  minimumSize:
                      Size(MediaQuery.of(context).size.width * 0.8, 25),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                child: Text(
                  'Enviar',
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
