import 'package:flutter/material.dart';
import '../admin/CalculatorBView.dart';
import '../admin/FuelCalculatorView.dart';

class CalculatorView extends StatefulWidget {
  final int userId;

  CalculatorView({required this.userId});

  @override
  _CalculatorViewState createState() => _CalculatorViewState();
}

class _CalculatorViewState extends State<CalculatorView> {
  TextEditingController fuelController = TextEditingController();
  TextEditingController distanceController = TextEditingController();
  TextEditingController priceController = TextEditingController();

  double fuelConsumed = 0;
  double fuelPrice = 0;
  bool showResults = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFFEF4136),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      FuelCalculatorView(userId: widget.userId)),
            );
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 10),
            Container(
              color: Colors.grey[200],
              width: MediaQuery.of(context).size.width * 0.9,
              margin: EdgeInsets.symmetric(
                  horizontal: MediaQuery.of(context).size.width * 0.05),
              height: 80,
              child: Row(
                children: [
                  Transform.translate(
                    offset: Offset(45, 0),
                    child: GestureDetector(
                      onTap: () {
                        // Navigator.push(
                        //   context,
                        //   MaterialPageRoute(builder: (context) => MessengerUsersView(userId: widget.userId)),
                        // );
                      },
                      child: Text(
                        'Volumen.',
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ),
                  Transform.translate(
                    offset: Offset(-45, 15),
                    child: Container(
                      color: Color(0xFFEF4136),
                      width: 100,
                      height: 5,
                    ),
                  ),
                  Spacer(),
                  Transform.translate(
                    offset: Offset(-45, 0),
                    child: InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  CalculatorBView(userId: widget.userId)),
                        );
                      },
                      child: Text(
                        'Eficiencia.',
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 30),
            Transform.translate(
              offset: Offset(-60, 0),
              child: Text(
                'Consumo de combustible.',
                style: TextStyle(
                  fontSize: 15,
                ),
              ),
            ),
            SizedBox(height: 10),
            Transform.translate(
              offset: Offset(-20, 0),
              child: Container(
                width: MediaQuery.of(context).size.width * 0.8,
                padding: EdgeInsets.symmetric(horizontal: 20),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.grey[200],
                ),
                child: TextField(
                  controller: fuelController,
                  keyboardType: TextInputType.phone,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: 'litros x 100km',
                  ),
                ),
              ),
            ),
            Transform.translate(
              offset: Offset(150, -35),
              child: Icon(
                Icons.settings,
                color: Color(0xFFEF4136),
                size: 25,
              ),
            ),
            Transform.translate(
              offset: Offset(-120, 0),
              child: Text(
                'Distancia',
                style: TextStyle(
                  fontSize: 15,
                ),
              ),
            ),
            SizedBox(height: 10),
            Transform.translate(
              offset: Offset(-20, 0),
              child: Container(
                width: MediaQuery.of(context).size.width * 0.8,
                padding: EdgeInsets.symmetric(horizontal: 20),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.grey[200],
                ),
                child: TextField(
                  controller: distanceController,
                  keyboardType: TextInputType.phone,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: 'Kilometros',
                  ),
                ),
              ),
            ),
            Transform.translate(
              offset: Offset(150, -35),
              child: Icon(
                Icons.settings,
                color: Color(0xFFEF4136),
                size: 25,
              ),
            ),
            Transform.translate(
              offset: Offset(-75, 0),
              child: Text(
                'Precio de combustible',
                style: TextStyle(
                  fontSize: 15,
                ),
              ),
            ),
            SizedBox(height: 10),
            Transform.translate(
              offset: Offset(-20, 0),
              child: Container(
                width: MediaQuery.of(context).size.width * 0.8,
                padding: EdgeInsets.symmetric(horizontal: 20),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.grey[200],
                ),
                child: TextField(
                  controller: priceController,
                  keyboardType: TextInputType.phone,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: 'Por litro',
                  ),
                ),
              ),
            ),
            Transform.translate(
              offset: Offset(150, -35),
              child: Icon(
                Icons.settings,
                color: Color(0xFFEF4136),
                size: 25,
              ),
            ),
            if (showResults)
              Transform.translate(
                offset: Offset(0, -20),
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.9,
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Transform.translate(
                        offset: Offset(0, 10),
                        child: Text('Combustible consumido ='),
                      ),
                      Transform.translate(
                        offset: Offset(170, -10),
                        child: Text(
                          '$fuelConsumed Litros',
                          style: TextStyle(
                            color: Color(0xFFEF4136),
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        ),
                      ),
                      Transform.translate(
                        offset: Offset(0, 10),
                        child: Text('Costo de combustible ='),
                      ),
                      Transform.translate(
                        offset: Offset(155, -10),
                        child: Text(
                          '$fuelPrice',
                          style: TextStyle(
                            color: Color(0xFFEF4136),
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ElevatedButton(
              onPressed: () {
                calculateValues();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFFEF4136),
                minimumSize: Size(MediaQuery.of(context).size.width * 0.8, 25),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              child: SizedBox(
                width: MediaQuery.of(context).size.width * 0.75,
                height: 45,
                child: Center(
                  child: Text(
                    'Calcular',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void calculateValues() {
    if (fuelController.text.isEmpty ||
        distanceController.text.isEmpty ||
        priceController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Todos los campos son obligatorios.')),
      );
      return;
    }

    double fuel = double.parse(fuelController.text);
    double distance = double.parse(distanceController.text);
    double price = double.parse(priceController.text);

    setState(() {
      fuelConsumed = fuel * distance / 100;
      fuelPrice = fuelConsumed * price;
      showResults = true;
    });
  }
}

void main() {
  runApp(MaterialApp(
    home: CalculatorView(userId: 1),
  ));
}
