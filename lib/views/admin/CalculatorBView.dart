import 'package:flutter/material.dart';
import '../admin/FuelCalculatorView.dart';
import 'CalculatorView.dart';

class CalculatorBView extends StatefulWidget {
  final int userId;

  CalculatorBView({required this.userId});

  @override
  _CalculatorBViewState createState() => _CalculatorBViewState();
}

class _CalculatorBViewState extends State<CalculatorBView> {
  TextEditingController fuelController = TextEditingController();
  TextEditingController distanceController = TextEditingController();
  TextEditingController priceController = TextEditingController();

  double fuelConsumedOne = 0;
  double fuelConsumedTwo = 0;
  double fuelConsumedThree = 0;
  double fuelConsumedMilla = 0;
  double totalMilla = 0;
  double fuelPrice = 0;
  double fuelConsumed = 0;
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
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  CalculatorView(userId: widget.userId)),
                        );
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
                    offset: Offset(105, 15),
                    child: Container(
                      color: Color(0xFFEF4136),
                      width: 100,
                      height: 5,
                    ),
                  ),
                  Spacer(),
                  Transform.translate(
                    offset: Offset(-45, 0),
                    child: Text(
                      'Eficiencia.',
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
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
                'Combustible Consumido.',
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
                    hintText: 'Litros',
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
                        child: Text(
                          '$fuelConsumedOne',
                          style: TextStyle(
                            color: Color(0xFFEF4136),
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        ),
                      ),
                      Transform.translate(
                        offset: Offset(70, -8),
                        child: Text('Litros x 100 km.'),
                      ),
                      Transform.translate(
                        offset: Offset(0, 0),
                        child: Text(
                          '$fuelConsumedTwo',
                          style: TextStyle(
                            color: Color(0xFFEF4136),
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        ),
                      ),
                      Transform.translate(
                        offset: Offset(70, -18),
                        child: Text('Litros x 10 km.'),
                      ),
                      Transform.translate(
                        offset: Offset(0, -10),
                        child: Text(
                          '$fuelConsumedThree',
                          style: TextStyle(
                            color: Color(0xFFEF4136),
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        ),
                      ),
                      Transform.translate(
                        offset: Offset(70, -28),
                        child: Text('Litros x km.'),
                      ),
                      Transform.translate(
                        offset: Offset(0, -20),
                        child: Text(
                          '${totalMilla.toStringAsFixed(2)}',
                          style: TextStyle(
                            color: Color(0xFFEF4136),
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        ),
                      ),
                      Transform.translate(
                        offset: Offset(70, -38),
                        child: Text('Litros x milla.'),
                      ),
                      Transform.translate(
                        offset: Offset(0, -25),
                        child: Text('Costo de combustible ='),
                      ),
                      Transform.translate(
                        offset: Offset(155, -45),
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
      fuelConsumedOne = 100 / distance * fuel;
      fuelConsumedTwo = 10 / distance * fuel;
      fuelConsumedThree = 1 / distance * fuel;
      fuelConsumedMilla = distance * 0.621371;
      totalMilla = fuel / fuelConsumedMilla;
      fuelConsumed = fuelConsumedOne * distance / 100;
      fuelPrice = fuelConsumed * price;
      showResults = true;
    });
  }
}

void main() {
  runApp(MaterialApp(
    home: CalculatorBView(userId: 1),
  ));
}
