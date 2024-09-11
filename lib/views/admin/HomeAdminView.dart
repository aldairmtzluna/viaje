import 'package:flutter/material.dart';
import '/views/DriversActivesView.dart';
import '/views/HomeView.dart';
import '/views/LoginView.dart';
import '/views/MessengerUsersView.dart';
import '../admin/DriversView.dart';
import '../admin/fleetsView.dart';
import '../ResetPasswordView.dart';
import '../superAdmin/DriverRegisterView.dart';
import '../admin/RegisterFleetView.dart';
import 'FuelCalculatorView.dart';
import '../superAdmin/HomeSuperAdminView.dart';
import 'package:url_launcher/url_launcher.dart';

class HomeAdminView extends StatelessWidget {
  final int userId;

  HomeAdminView({required this.userId});

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Cerrar Sesión"),
          content: Text("¿Está seguro que desea cerrar sesión?"),
          actions: <Widget>[
            TextButton(
              child: Text(
                "Cancelar",
                style: TextStyle(
                  fontSize: 16,
                  color:
                      Color(0xFFEF4136), // Cambia el color del texto a blanco
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop(); // Cerrar el diálogo
              },
            ),
            TextButton(
              child: Text(
                "Cerrar Sesión",
                style: TextStyle(
                  fontSize: 16,
                  color:
                      Color(0xFFEF4136), // Cambia el color del texto a blanco
                ),
              ),
              onPressed: () {
                // Aquí implementamos la lógica para cerrar sesión
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => LoginView()),
                  (Route<dynamic> route) =>
                      false, // Eliminar todas las rutas anteriores
                );
              },
            ),
          ],
        );
      },
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
            Navigator.pop(context);
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(height: 30),
            Container(
              width: MediaQuery.of(context).size.width * 0.9,
              margin: EdgeInsets.symmetric(
                  horizontal: MediaQuery.of(context).size.width * 0.05),
              child: Row(
                children: [
                  Icon(
                    Icons.settings,
                    color: Colors.grey,
                    size: 25,
                  ),
                  Spacer(),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                MessengerUsersView(userId: userId)),
                      );
                    },
                    child: Icon(
                      Icons.messenger,
                      color: Colors.grey,
                      size: 25,
                    ),
                  ),
                  Spacer(),
                  IconButton(
                    icon: Icon(
                      Icons.login_outlined,
                      color: Colors.grey,
                      size: 25,
                    ),
                    onPressed: () {
                      _showLogoutDialog(context);
                    },
                  ),
                ],
              ),
            ),
            SizedBox(height: 10),
            Container(
              width: MediaQuery.of(context).size.width * 0.9,
              margin: EdgeInsets.symmetric(
                  horizontal: MediaQuery.of(context).size.width * 0.05),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 20),
                  Container(
                    width: MediaQuery.of(context).size.width * 10,
                    height: 180,
                    color: Colors.white,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          width: 90,
                          height: 170,
                          margin: EdgeInsets.only(
                              left: MediaQuery.of(context).size.width * 0.015),
                          decoration: BoxDecoration(
                            color: Color(0xFF6456FB),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        DriversActivesView(userId: userId)),
                              );
                            },
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.watch_sharp,
                                  color: Colors.white,
                                  size: 25,
                                ),
                                SizedBox(height: 5),
                                Text(
                                  'HoS.',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 12,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ),
                        ),
                        Container(
                          width: 90,
                          height: 170,
                          decoration: BoxDecoration(
                            color: Color(0xFFFF5784),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        Driversview(userId: userId)),
                              );
                            },
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.supervised_user_circle_sharp,
                                  color: Colors.white,
                                  size: 25,
                                ),
                                SizedBox(height: 5),
                                Text(
                                  'Conductores.',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 12,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ),
                        ),
                        Container(
                          width: 90,
                          height: 170,
                          margin: EdgeInsets.only(
                              right: MediaQuery.of(context).size.width * 0.015),
                          decoration: BoxDecoration(
                            color: Color(0xFFFFC403),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        Fleetsview(userId: userId)),
                              );
                            },
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.directions_bus_filled,
                                  color: Colors.white,
                                  size: 25,
                                ),
                                SizedBox(height: 5),
                                Text(
                                  'Flotillas',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 12,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20),
                  Container(
                    width: MediaQuery.of(context).size.width * 10,
                    height: 180,
                    color: Colors.white,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          width: 90,
                          height: 170,
                          margin: EdgeInsets.only(
                              left: MediaQuery.of(context).size.width * 0.015),
                          decoration: BoxDecoration(
                            color: Color(0xFF6AFD8C),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        FuelCalculatorView(userId: userId)),
                              );
                            },
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.calculate,
                                  color: Colors.white,
                                  size: 25,
                                ),
                                SizedBox(height: 5),
                                Text(
                                  'Calculadora de Conbustible.',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 12,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ),
                        ),
                        Container(
                          width: 90,
                          height: 170,
                          decoration: BoxDecoration(
                            color: Color(0xFF6EF1FF),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        ResetPasswordView(userId: userId)),
                              );
                            },
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.abc_rounded,
                                  color: Colors.white,
                                  size: 25,
                                ),
                                SizedBox(height: 5),
                                Text(
                                  'Asignacion de viajes.',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 12,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ),
                        ),
                        Container(
                          width: 90,
                          height: 170,
                          margin: EdgeInsets.only(
                              right: MediaQuery.of(context).size.width * 0.015),
                          decoration: BoxDecoration(
                            color: Color(0xFFF06DFF),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: InkWell(
                            onTap: () async {
                              const url =
                                  'https://play.google.com/store/apps/details?id=com.itrybrand.tracker';
                              if (await canLaunch(url)) {
                                await launch(url);
                              } else {
                                throw 'No se puede abrir $url';
                              }
                            },
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.location_on,
                                  color: Colors.white,
                                  size: 25,
                                ),
                                SizedBox(height: 5),
                                Text(
                                  'Rutas.',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 12,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
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
