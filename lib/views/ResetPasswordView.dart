import 'dart:ui';
import 'package:flutter/material.dart';
import 'LoginView.dart';

class ResetPasswordView extends StatelessWidget {
  final int userId;

  ResetPasswordView({required this.userId});

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
      body: Padding(
        padding: EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Establezca su nueva contraseña.',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20.0),
            Container(
              width: MediaQuery.of(context).size.width * 0.8,
              child: Text(
                'A continuación ingrese su nueva contraseña.',
                style: TextStyle(fontSize: 16),
                textAlign: TextAlign.center,
              ),
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
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: 'Contraseña',
                ),
                obscureText: true,
              ),
            ),
            SizedBox(height: 20),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.8,
              height: 45,
              child: ElevatedButton(
                onPressed: () {
                  // Implement your password reset logic here
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFFEF4136),
                  minimumSize:
                      Size(MediaQuery.of(context).size.width * 0.8, 25),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                child: Text(
                  'Restablecer',
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Color(0xFFEF4136),
          border: Border(
            top: BorderSide(width: 1.0, color: Colors.transparent),
          ),
        ),
        child: TextButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => LoginView()),
            );
          },
          child: Text(
            'Volver al inicio de sesión.',
            style: TextStyle(color: Colors.white),
          ),
        ),
      ),
    );
  }
}
