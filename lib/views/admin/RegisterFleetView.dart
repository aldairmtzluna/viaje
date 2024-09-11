import 'package:flutter/material.dart';
import '/views/HomeView.dart';
import '../admin/HomeAdminView.dart';
import '../admin/NumberFleetBusesView.dart';
import '../admin/NumberFleetTrucksView.dart';
import '../admin/NumberFleetVehiclesView.dart';

class RegisterFleetView extends StatelessWidget {
  final int userId;

  RegisterFleetView({required this.userId});

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
                        text: 'REGISTRAR\n',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 40,
                          fontWeight: FontWeight.bold,
                        ),
                        children: <TextSpan>[
                          TextSpan(
                            text: 'FLOTILLA.',
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
            SizedBox(height: 20),
            Text(
              '¿Con qué tipo de vehículos cuentas?',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 30),
            Container(
              width: MediaQuery.of(context).size.width * 0.9,
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
                      width: 150,
                      height: 150,
                      color: Colors.white,
                      child: InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    Numberfleetvehiclesview(userId: userId)),
                          );
                        },
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.directions_car_filled,
                              color: Colors.black,
                              size: 80,
                            ),
                            Text(
                              'Automóviles.',
                              style: TextStyle(fontSize: 16),
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
                      width: 150,
                      height: 150,
                      color: Colors.white,
                      child: InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    Numberfleettrucksview(userId: userId)),
                          );
                        },
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.local_shipping,
                              color: Colors.black,
                              size: 80,
                            ),
                            Text(
                              'Camiones.',
                              style: TextStyle(fontSize: 16),
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
              width: MediaQuery.of(context).size.width * 0.9,
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
                      width: 150,
                      height: 150,
                      color: Colors.white,
                      child: InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    Numberfleetbusesview(userId: userId)),
                          );
                        },
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.directions_bus_filled,
                              color: Colors.black,
                              size: 80,
                            ),
                            Text(
                              'Autobuses.',
                              style: TextStyle(fontSize: 16),
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
                      width: 150,
                      height: 150,
                      color: Colors.white,
                      child: InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => HomeView(userId: userId)),
                          );
                        },
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.playlist_add_circle_rounded,
                              color: Colors.black,
                              size: 80,
                            ),
                            Text(
                              'Otro.',
                              style: TextStyle(fontSize: 16),
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
