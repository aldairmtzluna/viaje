import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'ChatsView.dart';
import 'dart:math';

class MessengerUsersView extends StatefulWidget {
  final int userId;

  MessengerUsersView({required this.userId});

  @override
  _MessengerUsersViewState createState() => _MessengerUsersViewState();
}

class _MessengerUsersViewState extends State<MessengerUsersView> {
  late Future<List<Map<String, dynamic>>> _messagedUsers;
  late Future<List<Map<String, dynamic>>> _allUsers;

  final List<Color> _colors = [
    Colors.red[200]!,
    Colors.blue[200]!,
    Colors.green[200]!,
    Colors.yellow[200]!,
    Colors.orange[200]!,
    Colors.purple[200]!,
    Colors.pink[200]!,
    Colors.teal[200]!,
    Colors.cyan[200]!,
    Colors.lime[200]!,
  ];

  @override
  void initState() {
    super.initState();
    _messagedUsers = _fetchMessagedUsers();
    _allUsers = _fetchAllUsers();
  }

  Future<List<Map<String, dynamic>>> _fetchMessagedUsers() async {
    final response = await http.get(Uri.parse(
        'https://whitesmoke-magpie-578690.hostingersite.com/index.php/usuarios/involucrados?id_usuario=${widget.userId}'));

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      return data.map((user) {
        return {
          'id_usuario': user['id_usuario'],
          'nombre_usuario': user['nombre_usuario'],
          'apellido_paterno_usuario': user['apellido_paterno_usuario'],
          'rol_usuario': user['rol_usuario'],
          'genero_usuario': user['genero_usuario'],
          'nombre_inicial': user['nombre_inicial'],
          'apellido_inicial': user['apellido_inicial'],
        };
      }).toList();
    } else {
      throw Exception('Failed to load users');
    }
  }

  Future<List<Map<String, dynamic>>> _fetchAllUsers() async {
    final response = await http.get(Uri.parse(
        'https://whitesmoke-magpie-578690.hostingersite.com/index.php/usuarios/excepto?id_usuario=${widget.userId}'));

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      return data.map((user) {
        return {
          'id_usuario': user['id_usuario'],
          'nombre_usuario': user['nombre_usuario'],
          'apellido_paterno_usuario': user['apellido_paterno_usuario'],
          'rol_usuario': user['rol_usuario'],
          'genero_usuario': user['genero_usuario'],
          'nombre_inicial': user['nombre_inicial'],
          'apellido_inicial': user['apellido_inicial'],
        };
      }).toList();
    } else {
      throw Exception('Failed to load users');
    }
  }

  String _getRole(int roleId, int gender) {
    if (roleId == 1) {
      return 'SuperAdmin';
    } else if (roleId == 2) {
      return 'Admin';
    } else if (roleId == 3) {
      if (gender == 1) {
        return 'Conductora';
      } else if (gender == 2) {
        return 'Conductor';
      } else {
        return 'Desconocido';
      }
    } else {
      return 'Desconocido';
    }
  }

  Widget _buildUserList(List<Map<String, dynamic>> users) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: users.asMap().entries.map((entry) {
        int index = entry.key;
        Map<String, dynamic> user = entry.value;

        String initials = user['nombre_inicial'] + user['apellido_inicial'];
        String fullName =
            user['nombre_usuario'] + ' ' + user['apellido_paterno_usuario'];

        Color randomColor = _colors[Random().nextInt(_colors.length)];
        bool isOdd = index % 2 != 0;

        return Container(
          color: isOdd ? Colors.grey[200] : Colors.white,
          padding: EdgeInsets.all(10),
          child: InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        ChatsView(user: user, currentUserId: widget.userId)),
              );
            },
            child: Row(
              children: [
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: randomColor,
                    borderRadius: BorderRadius.circular(50),
                  ),
                  child: Center(
                    child: Text(
                      initials,
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        fullName,
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                      ),
                      Text(
                        _getRole(user['rol_usuario'], user['genero_usuario']),
                        style: TextStyle(
                          color: Colors.black54,
                          fontSize: 12,
                        ),
                      ),
                      SizedBox(height: 5),
                      Text(
                        'Mensaje de remitente para destinatario.',
                        style: TextStyle(
                          fontSize: 10,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
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
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              color: Colors.grey[200],
              height: 50,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
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
                      Icons.menu,
                      color: Colors.black,
                      size: 25,
                    ),
                  ),
                  Text(
                    'Mensajes.',
                    style: TextStyle(
                      color: Color(0xFFEF4136),
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
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
                      Icons.search,
                      color: Colors.black,
                      size: 25,
                    ),
                  ),
                ],
              ),
            ),
            FutureBuilder<List<Map<String, dynamic>>>(
              future: _messagedUsers,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(child: Text('Sin mensajes.'));
                } else {
                  return _buildUserList(snapshot.data!);
                }
              },
            ),
            Divider(color: Colors.black),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Todos los usuarios:',
                style: TextStyle(
                  color: Color(0xFFEF4136),
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            ),
            FutureBuilder<List<Map<String, dynamic>>>(
              future: _allUsers,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(child: Text('No hay usuarios.'));
                } else {
                  return _buildUserList(snapshot.data!);
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
