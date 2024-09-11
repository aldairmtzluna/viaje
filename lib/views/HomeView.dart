import 'package:flutter/material.dart';
import '/views/CarScannerView.dart';
import '/views/HoursOfServiceView.dart';
import '/views/MessengerUsersView.dart';
import '/views/admin/TravelStatusView.dart';
import 'ResetPasswordView.dart';
import 'superAdmin/DriverRegisterView.dart';
import 'admin/RegisterFleetView.dart';
import 'admin/FuelCalculatorView.dart';
import 'superAdmin/HomeSuperAdminView.dart';
import 'admin/HomeAdminView.dart';
import 'LoginView.dart';
import 'package:url_launcher/url_launcher.dart';
import '../config/DBConnection.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class HomeView extends StatefulWidget {
  final int userId;

  HomeView({required this.userId});

  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  late String userName = '';
  late String numberUnit = '';

  @override
  void initState() {
    super.initState();
    _loadUserName();
    _loadUnitNumber();
  }

  Future<void> _loadUserName() async {
    try {
      final response = await http.get(Uri.parse(
          'https://whitesmoke-magpie-578690.hostingersite.com/index.php/usuarios?id_usuario=${widget.userId}'));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data.isNotEmpty) {
          setState(() {
            userName = data['nombre_usuario'] ?? 'Usuario no encontrado';
          });
        }
      } else {
        print('Error: ${response.statusCode}');
        // Manejar el error según sea necesario
      }
    } catch (e) {
      print('Error fetching user name: $e');
    }
  }

  Future<void> _loadUnitNumber() async {
    try {
      final response = await http.get(Uri.parse(
          'https://whitesmoke-magpie-578690.hostingersite.com/index.php/unidades?id_conductor_unidad=${widget.userId}'));

      if (response.statusCode == 200) {
        final dataUnit = json.decode(response.body);
        if (dataUnit.isNotEmpty) {
          setState(() {
            numberUnit = dataUnit['placa_unidad'] ?? 'Usuario no encontrado';
          });
        }
      } else {
        print('Error: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching unit number: $e');
    }
  }

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
                  color: Color(0xFFEF4136),
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text(
                "Cerrar Sesión",
                style: TextStyle(
                  fontSize: 16,
                  color: Color(0xFFEF4136),
                ),
              ),
              onPressed: () {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => LoginView()),
                  (Route<dynamic> route) => false,
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
                                MessengerUsersView(userId: widget.userId)),
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
                  Container(
                    height: 80,
                    color: Colors.white,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          width: 50,
                          height: 50,
                          margin: EdgeInsets.only(
                              left: MediaQuery.of(context).size.width * 0.05),
                          decoration: BoxDecoration(
                            color: Color(0xFFEF4136),
                          ),
                          child: Center(
                            child: Text(
                              'ON',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'De turno (00:00)',
                              style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            ),
                            SizedBox(height: 5),
                          ],
                        ),
                        Icon(
                          Icons.arrow_forward_ios,
                          color: Colors.grey,
                          size: 20,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20),
                  Container(
                    color: Colors.white,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 10),
                        Row(
                          children: [
                            Text(
                              'Conductor:',
                              style: TextStyle(
                                color: Colors.black,
                              ),
                            ),
                            Text(
                              '          $userName',
                              style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Spacer(),
                          ],
                        ),
                        SizedBox(height: 10),
                        Row(
                          children: [
                            Text(
                              'Unidad:',
                              style: TextStyle(
                                color: Colors.black,
                              ),
                            ),
                            Text(
                              '$numberUnit',
                              style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Spacer(),
                          ],
                        ),
                        SizedBox(height: 10),
                        Row(
                          children: [
                            Text(
                              'Envío',
                              style: TextStyle(
                                color: Colors.black,
                              ),
                            ),
                            Spacer(),
                          ],
                        ),
                        SizedBox(height: 10),
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
                            color: Color(0xFF229954),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => HoursOfServiceView()),
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
                            color: Color(0xFFFFC300),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        CarScannerView(userId: widget.userId)),
                              );
                            },
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.dashboard,
                                  color: Colors.white,
                                  size: 25,
                                ),
                                SizedBox(height: 5),
                                Text(
                                  'Inspección de vehículo.',
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
                            color: Color(0xFF8E44AD),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: InkWell(
                            onTap: () async {},
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.mode_of_travel_outlined,
                                  color: Colors.white,
                                  size: 25,
                                ),
                                SizedBox(height: 5),
                                Text(
                                  'Mis viajes.',
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
                              right: MediaQuery.of(context).size.width * 0.015),
                          decoration: BoxDecoration(
                            color: Color(0xFF75CEB9),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ResetPasswordView(
                                        userId: widget.userId)),
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
                                  'Estatus de conductor.',
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
                            color: Color(0xFFCE759A),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        HomeAdminView(userId: widget.userId)),
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
                                  'Vehículo.',
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
                              left: MediaQuery.of(context).size.width * 0.015),
                          decoration: BoxDecoration(
                            color: Color(0xFF5D6D7E),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => TravelStatusView(
                                        userId: widget.userId)),
                              );
                            },
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.summarize,
                                  color: Colors.white,
                                  size: 25,
                                ),
                                SizedBox(height: 5),
                                Text(
                                  'Documentos.',
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
