import 'package:flutter/material.dart';
import '/views/HomeView.dart';
import '../admin/CalculatorView.dart';
import 'HomeAdminView.dart';

class FuelCalculatorView extends StatelessWidget {
  final int userId;

  FuelCalculatorView({required this.userId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              height: 230,
              decoration: BoxDecoration(
                color: Color(0xFFEF4136),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20),
                ),
              ),
              child: Stack(
                children: [
                  Positioned(
                    top: 20,
                    left: 10,
                    child: IconButton(
                      icon: Icon(Icons.arrow_back_ios, color: Colors.white),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  HomeAdminView(userId: userId)),
                        );
                      },
                    ),
                  ),
                  Positioned(
                    bottom: 10,
                    left: 20,
                    child: Text.rich(
                      TextSpan(
                        text: 'CALCULADORA DE\n',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 40,
                          fontWeight: FontWeight.bold,
                        ),
                        children: <TextSpan>[
                          TextSpan(
                            text: 'COMBUSTIBLE.',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 40,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 30),
            Container(
              width: MediaQuery.of(context).size.width * 0.8,
              height: 170,
              decoration: BoxDecoration(
                color: Colors.transparent,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Transform.translate(
                    offset: Offset(10, -20),
                    child: Container(
                      width: 130,
                      height: 130,
                      decoration: BoxDecoration(
                        color: Color(0xFFEF4136),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: InkWell(
                        onTap: () {
                          // Navigator.push(
                          //   context,
                          //   MaterialPageRoute(builder: (context) => HomeView(userId: userId)),
                          // );
                        },
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.data_thresholding_rounded,
                              color: Colors.white,
                              size: 40,
                            ),
                            Text(
                              'Consumo de combustible.',
                              style: TextStyle(fontSize: 13),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Transform.translate(
                    offset: Offset(0, -20),
                    child: Container(
                      width: 130,
                      height: 130,
                      decoration: BoxDecoration(
                        color: Color(0xFFEF4136),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    CalculatorView(userId: userId)),
                          );
                        },
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.local_gas_station,
                              color: Colors.white,
                              size: 40,
                            ),
                            Text(
                              'Gasolina.',
                              style: TextStyle(fontSize: 13),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width * 0.8,
              height: 170,
              decoration: BoxDecoration(
                color: Colors.transparent,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Transform.translate(
                    offset: Offset(10, -20),
                    child: Container(
                      width: 130,
                      height: 130,
                      decoration: BoxDecoration(
                        color: Color(0xFFEF4136),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: InkWell(
                        onTap: () {
                          // Navigator.push(
                          //   context,
                          //   MaterialPageRoute(builder: (context) => HomeView(userId: userId)),
                          // );
                        },
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.watch_later,
                              color: Colors.white,
                              size: 40,
                            ),
                            Text(
                              'Consumo promedio.',
                              style: TextStyle(fontSize: 13),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Transform.translate(
                    offset: Offset(0, -20),
                    child: Container(
                      width: 130,
                      height: 130,
                      decoration: BoxDecoration(
                        color: Color(0xFFEF4136),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: InkWell(
                        onTap: () {
                          // Navigator.push(
                          //   context,
                          //   MaterialPageRoute(builder: (context) => HomeView(userId: userId)),
                          // );
                        },
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.price_change,
                              color: Colors.white,
                              size: 40,
                            ),
                            Text(
                              'Precio de ruta.',
                              style: TextStyle(fontSize: 13),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
