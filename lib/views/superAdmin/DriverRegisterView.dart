import 'package:flutter/material.dart';
import 'PhotosDriverView.dart';

class DriverRegisterView extends StatelessWidget {
  final int userId;

  DriverRegisterView({required this.userId});

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
                        Navigator.pop(context);
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
                            text: 'CONDUCTOR.',
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
            SizedBox(height: 15),
            Container(
              width: MediaQuery.of(context).size.width * 0.9,
              padding: EdgeInsets.symmetric(horizontal: 10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Colors.grey[200],
              ),
              child: TextField(
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: 'Nombre(s).',
                ),
              ),
            ),
            SizedBox(height: 25),
            Container(
              width: MediaQuery.of(context).size.width * 0.9,
              padding: EdgeInsets.symmetric(horizontal: 10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Colors.grey[200],
              ),
              child: TextField(
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: 'Apellido Paterno.',
                ),
              ),
            ),
            SizedBox(height: 25),
            Container(
              width: MediaQuery.of(context).size.width * 0.9,
              padding: EdgeInsets.symmetric(horizontal: 10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Colors.grey[200],
              ),
              child: TextField(
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: 'Apellido Materno.',
                ),
              ),
            ),
            SizedBox(height: 25),
            Container(
              width: MediaQuery.of(context).size.width * 0.9,
              padding: EdgeInsets.symmetric(horizontal: 10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Colors.grey[200],
              ),
              child: TextField(
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: 'Correo',
                ),
              ),
            ),
            SizedBox(height: 25),
            Container(
              width: MediaQuery.of(context).size.width * 0.9,
              padding: EdgeInsets.symmetric(horizontal: 10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Colors.grey[200],
              ),
              child: TextField(
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: 'Teléfono.',
                ),
              ),
            ),
            SizedBox(height: 25),
            Container(
              width: MediaQuery.of(context).size.width * 0.9,
              padding: EdgeInsets.symmetric(horizontal: 10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Colors.grey[200],
              ),
              child: TextField(
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: 'flotilla.',
                ),
              ),
            ),
            SizedBox(height: 25),
            Container(
              width: MediaQuery.of(context).size.width * 0.9,
              padding: EdgeInsets.symmetric(horizontal: 10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Colors.grey[200],
              ),
              child: TextField(
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: 'Unidad Asignada.',
                ),
              ),
            ),
            SizedBox(height: 25),
            Container(
              width: MediaQuery.of(context).size.width * 0.9,
              padding: EdgeInsets.symmetric(horizontal: 10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Colors.grey[200],
              ),
              child: TextField(
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: 'Contraseña.',
                ),
                obscureText: true,
              ),
            ),
            SizedBox(height: 25),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.8,
              height: 45,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => PhotosDriverView(userId: userId)),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFFEF4136),
                  minimumSize:
                      Size(MediaQuery.of(context).size.width * 0.9, 10),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                child: Text(
                  'Siguiente',
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ),
            ),
            SizedBox(height: 25),
          ],
        ),
      ),
    );
  }
}
