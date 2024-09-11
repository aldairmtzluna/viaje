import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'admin/HomeAdminView.dart';
import 'superAdmin/HomeSuperAdminView.dart';
import 'HomeView.dart';

class LoginView extends StatefulWidget {
  @override
  _LoginViewState createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final TextEditingController _usuarioController = TextEditingController();
  final TextEditingController _contrasenaController = TextEditingController();

  Future<void> _login() async {
    String usuario = _usuarioController.text.trim();
    String contrasena = _contrasenaController.text.trim();

    if (usuario.isEmpty && contrasena.isEmpty) {
      _showMessage('Usuario y contraseña obligatorios');
    } else if (usuario.isEmpty) {
      _showMessage('Ingrese usuario');
    } else if (contrasena.isEmpty) {
      _showMessage('Ingrese contraseña');
    } else {
      try {
        final response = await http.post(
          Uri.parse(
              'https://whitesmoke-magpie-578690.hostingersite.com/index.php/login'),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode(<String, String>{
            'usuario_usuario': usuario,
            'contraseña_usuario': contrasena,
          }),
        );

        if (response.statusCode == 200) {
          final Map<String, dynamic> responseBody = jsonDecode(response.body);

          if (responseBody.containsKey('id_usuario')) {
            int userId = responseBody['id_usuario'];
            int rol = responseBody['rol_usuario'];

            // Guardar el estado de sesión en SharedPreferences
            SharedPreferences prefs = await SharedPreferences.getInstance();
            await prefs.setInt('userId', userId);
            await prefs.setInt('userRole', rol);
            await prefs.setBool('loggedIn', true);

            // Navegar a la vista correspondiente según el rol del usuario
            _navigateToHomeView(rol, userId);
          } else {
            _showMessage(responseBody['message']);
          }
        } else {
          _showMessage('Error al conectar con el servidor');
        }
      } catch (e) {
        _showMessage('Error de conexión: $e');
      }
    }
  }

  void _navigateToHomeView(int rol, int userId) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) {
          switch (rol) {
            case 1:
              return HomeSuperAdminView(userId: userId);
            case 2:
              return HomeAdminView(userId: userId);
            case 3:
              return HomeView(userId: userId);
            default:
              return Scaffold(
                body: Center(
                  child: Text('Rol desconocido'),
                ),
              );
          }
        },
      ),
    );
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFEF4136),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: MediaQuery.of(context).size.width * 0.9,
              padding: EdgeInsets.symmetric(horizontal: 10),
              height: 250,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                children: [
                  SizedBox(height: 20),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.9,
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      children: [
                        SizedBox(width: 10),
                        Icon(
                          Icons.person,
                          color: Colors.white,
                          size: 20,
                        ),
                        SizedBox(width: 10),
                        Expanded(
                          child: TextField(
                            controller: _usuarioController,
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: 'Usuario',
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.9,
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      children: [
                        SizedBox(width: 10),
                        Icon(
                          Icons.lock,
                          color: Colors.white,
                          size: 20,
                        ),
                        SizedBox(width: 10),
                        Expanded(
                          child: TextField(
                            controller: _contrasenaController,
                            obscureText: true,
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: 'Contraseña',
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 0),
                  Row(
                    children: [
                      Container(
                        margin: EdgeInsets.symmetric(
                          horizontal: MediaQuery.of(context).size.width * 0.05,
                        ),
                        width: 10,
                        height: 10,
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Color(0xFF3685CD),
                            width: 1,
                          ),
                        ),
                      ),
                      Transform.translate(
                        offset: Offset(-20.0, 0.0),
                        child: TextButton(
                          onPressed: () {},
                          child: Text(
                            'Recordarme.',
                            style: TextStyle(
                              color: Color(0xFF3685CD),
                              fontSize: 10,
                            ),
                          ),
                        ),
                      ),
                      TextButton(
                        onPressed: () {},
                        child: Padding(
                          padding: EdgeInsets.only(left: 50),
                          child: Text(
                            'Olvidé mi contraseña.',
                            style: TextStyle(
                              color: Color(0xFF3685CD),
                              fontSize: 10,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 0),
                  ElevatedButton(
                    onPressed: _login,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFFEF4136),
                      minimumSize:
                          Size(MediaQuery.of(context).size.width * 0.8, 25),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width * 0.75,
                      height: 45,
                      child: Center(
                        child: Text(
                          'Entrar',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors
                                .white, // Cambia el color del texto a blanco
                          ),
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

void main() {
  runApp(MaterialApp(
    home: LoginView(),
  ));
}
