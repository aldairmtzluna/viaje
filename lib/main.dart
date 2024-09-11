import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'views/LoginView.dart';
import 'views/HomeView.dart';
import 'views/admin/HomeAdminView.dart';
import 'views/superAdmin/HomeSuperAdminView.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Obtener las SharedPreferences de manera asíncrona
  SharedPreferences prefs = await SharedPreferences.getInstance();

  // Verificar si el usuario está logueado
  bool loggedIn = prefs.getBool('loggedIn') ?? false;

  runApp(MaterialApp(
    home: loggedIn
        ? getHomeView(prefs)
        : LoginView(), // Decide qué vista mostrar basada en el estado de la sesión
  ));
}

Widget getHomeView(SharedPreferences prefs) {
  return FutureBuilder<int>(
    future: getStoredUserRole(prefs),
    builder: (BuildContext context, AsyncSnapshot<int> snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting) {
        // Muestra un indicador de carga mientras se obtiene el rol del usuario
        return CircularProgressIndicator();
      } else {
        if (snapshot.hasError) {
          return Text('Error al obtener el rol del usuario');
        } else {
          int rol =
              snapshot.data ?? -1; // Obtén el rol del usuario del snapshot

          // Devuelve la vista correspondiente basada en el rol del usuario
          switch (rol) {
            case 1:
              return HomeSuperAdminView(userId: getUserId(prefs));
            case 2:
              return HomeAdminView(userId: getUserId(prefs));
            case 3:
              return HomeView(userId: getUserId(prefs));
            default:
              return LoginView(); // En caso de que el rol no sea reconocido, redirige a la pantalla de login
          }
        }
      }
    },
  );
}

Future<int> getStoredUserRole(SharedPreferences prefs) async {
  return prefs.getInt('userRole') ??
      -1; // Devuelve -1 si no se encuentra un rol almacenado
}

int getUserId(SharedPreferences prefs) {
  return prefs.getInt('userId') ??
      -1; // Devuelve -1 si no se encuentra un userId almacenado
}
