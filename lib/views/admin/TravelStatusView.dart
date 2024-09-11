import 'package:flutter/material.dart';
import '/views/HomeView.dart';

class TravelStatusView extends StatelessWidget {
  final int userId;

  TravelStatusView({required this.userId});

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
              MaterialPageRoute(builder: (context) => HomeView(userId: userId)),
            );
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Container(
              width: MediaQuery.of(context).size.width * 0.9,
              margin: EdgeInsets.only(
                  left: MediaQuery.of(context).size.width * 0.05, top: 20.0),
              padding: EdgeInsets.all(10.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 2,
                    blurRadius: 5,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Tienes un viaje',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15.0,
                    ),
                  ),
                  SizedBox(height: 10.0),
                  Text(
                    'Activa tu estado desde aquí',
                    style: TextStyle(
                      fontSize: 14.0,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                buildButton(Icons.mark_email_read_rounded, 'Cargado',
                    Colors.green, Colors.white),
                buildButton(Icons.route, 'En ruta', Colors.white, Colors.black),
                buildButton(Icons.connect_without_contact_sharp, 'En destino',
                    Colors.grey, Colors.white),
                buildButton(Icons.published_with_changes_outlined, 'Terminado',
                    Colors.grey, Colors.white),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget buildButton(
      IconData icon, String text, Color backgroundColor, Color textColor) {
    return Expanded(
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 2.0),
        padding: EdgeInsets.all(10.0),
        height: 30.0,
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: textColor, size: 7.0),
            SizedBox(width: 1.0),
            Text(
              text,
              style: TextStyle(
                color: textColor,
                fontWeight: FontWeight.bold,
                fontSize: 9,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
