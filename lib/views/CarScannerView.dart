import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

class CarScannerView extends StatefulWidget {
  final int userId;

  const CarScannerView({Key? key, required this.userId}) : super(key: key);

  @override
  _CarScannerViewState createState() => _CarScannerViewState();
}

class _CarScannerViewState extends State<CarScannerView> {
  final Color primaryColor = const Color(0xFFEF4136);

  final List<String> checklistItems = [
    'Identificación del vehículo',
    'Matrícula',
    'Kilometraje',
    'Frenos de servicio',
    'Frenos de estacionamiento',
    'Freno de tambores/rotores',
    'Neumáticos',
    'Presión de aceite',
    'Radiador',
    'Batería',
    'Cables y conducto del combustible',
    'Silenciador',
    'Sistema de combustible',
    'Luces de cruce frontales',
    'Luces de freno',
    'Luces traseras',
    'Intermitentes',
    'Cinturones de seguridad',
    'Extintor de incendios',
    'Dirección asistida',
    'Suspensión',
    'Neumáticos y presión de aire',
    'Ruedas y llantas',
  ];

  final Map<String, bool> checklistStatus = {};
  final Map<String, File?> photoEvidence = {};

  @override
  void initState() {
    super.initState();
    for (var item in checklistItems) {
      checklistStatus[item] = false;
      photoEvidence[item] = null;
    }
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  Future<void> _submitInspection() async {
    try {
      bool allChecked = checklistStatus.values.every((status) => status);

      if (allChecked) {
        // Primero, realiza la solicitud GET para obtener el id_unidad
        final unitsResponse = await http.get(
          Uri.parse(
              'http://192.168.1.72/api/unidades?id_usuario_unidad=${widget.userId}'),
          headers: {'Content-Type': 'application/json'},
        );

        if (unitsResponse.statusCode == 200) {
          final List<dynamic> unitsData = jsonDecode(unitsResponse.body);

          if (unitsData.isNotEmpty) {
            // Asegúrate de que `id_unidad` se convierte a int si es necesario
            final int idUnidad =
                int.parse(unitsData[0]['id_unidad'].toString());

            final inspectionData = {
              'estado_inspeccion': 'Completada',
              'id_unidad_inspeccion': idUnidad,
              'id_usuario_inspeccion': widget.userId,
            };

            // Enviar datos de la inspección
            final inspectionResponse = await http.post(
              Uri.parse('http://192.168.1.72/api/inspecciones'),
              headers: {'Content-Type': 'application/json'},
              body: jsonEncode(inspectionData),
            );

            // Imprimir la respuesta completa para depuración
            print(
                "Respuesta del servidor (inspección): ${inspectionResponse.body}");

            if (inspectionResponse.statusCode == 200) {
              final responseBody = jsonDecode(inspectionResponse.body);

              // Obtener el valor de id_inspeccion_incrementado
              final incrementedResponse = await http.get(
                Uri.parse('http://192.168.1.72/api/inspecciones/incrementado'),
                headers: {'Content-Type': 'application/json'},
              );

              if (incrementedResponse.statusCode == 200) {
                final incrementedData = jsonDecode(incrementedResponse.body);
                var idInspeccionIncrementado =
                    incrementedData['id_inspeccion_incrementado'];

                // Asegurarse de que sea de tipo entero
                if (idInspeccionIncrementado is String) {
                  idInspeccionIncrementado =
                      int.parse(idInspeccionIncrementado);
                } else if (idInspeccionIncrementado is! int) {
                  throw Exception(
                      'Unexpected type for id_inspeccion_incrementado');
                }

                // Insertar detalles de inspección
                for (var item in checklistItems) {
                  final isApproved = checklistStatus[item] == true ? 1 : 0;
                  final photoPath = photoEvidence[item];
                  final photoBase64 = photoPath != null
                      ? base64Encode(photoPath.readAsBytesSync())
                      : '';

                  final detailData = {
                    'id_inspeccion_detalle':
                        idInspeccionIncrementado, // Aquí se usa el valor incrementado
                    'item_detalle': item,
                    'aprobado_detalle': isApproved,
                    'foto_evidencia_detalle': photoBase64,
                    'comentarios_detalle':
                        isApproved == 0 ? 'Requiere revisión' : '',
                  };

                  print("Enviando detalle de inspección para $item:");
                  print(jsonEncode(detailData)); // Imprime el JSON enviado

                  final detailResponse = await http.post(
                    Uri.parse('http://192.168.1.72/api/detalles_inspeccion'),
                    headers: {'Content-Type': 'application/json'},
                    body: jsonEncode(detailData),
                  );

                  print(
                      "Respuesta del servidor (detalle): ${detailResponse.body}"); // Imprime la respuesta del servidor

                  if (detailResponse.statusCode != 200) {
                    _showMessage(
                        'Error en el detalle del ítem: $item. Código: ${detailResponse.statusCode}, Mensaje: ${detailResponse.body}');
                    return; // Detener el proceso si hay un error en algún detalle
                  }
                }

                _showMessage('¡Inspección completada con éxito!');
              } else {
                _showMessage(
                    'Error al obtener id_inspeccion_incrementado. Código: ${incrementedResponse.statusCode}, Mensaje: ${incrementedResponse.body}');
              }
            } else {
              _showMessage(
                  'Error al completar la inspección. Código: ${inspectionResponse.statusCode}, Mensaje: ${inspectionResponse.body}');
            }
          } else {
            _showMessage('No se encontraron unidades para el usuario.');
          }
        } else {
          _showMessage(
              'Error al obtener las unidades. Código: ${unitsResponse.statusCode}, Mensaje: ${unitsResponse.body}');
        }
      } else {
        _showMessage(
            'Asegúrate de que todos los aspectos de tu vehículo están bien, si no es así sube una foto del estado de tu vehículo');
      }
    } catch (e) {
      _showMessage('Ocurrió un error inesperado: $e');
    }
  }

  Future<void> _takePhoto(String item) async {
    final ImagePicker _picker = ImagePicker();
    final XFile? photo = await _picker.pickImage(source: ImageSource.camera);

    if (photo != null) {
      setState(() {
        photoEvidence[item] = File(photo.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryColor,
        leading: CloseButton(color: Colors.white),
        title: const Text('Escanea tu vehículo',
            style: TextStyle(color: Colors.white)),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings, color: Colors.white),
            onPressed: () {
              // Acción al presionar el ícono de configuración
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            LinearProgressIndicator(
              value: checklistStatus.values.where((status) => status).length /
                  checklistItems.length,
              color: primaryColor,
              backgroundColor: Colors.grey[300],
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: checklistItems.length,
                itemBuilder: (context, index) {
                  String item = checklistItems[index];
                  return CheckboxListTile(
                    title: Row(
                      children: [
                        IconButton(
                          icon: Icon(
                            Icons.camera_alt,
                            color: photoEvidence[item] != null
                                ? Colors.green
                                : primaryColor,
                          ),
                          onPressed: () => _takePhoto(item),
                        ),
                        const SizedBox(width: 8),
                        Expanded(child: Text(item)),
                      ],
                    ),
                    value: checklistStatus[item],
                    onChanged: (bool? value) {
                      setState(() {
                        checklistStatus[item] = value ?? false;
                      });
                    },
                    controlAffinity: ListTileControlAffinity.leading,
                    activeColor: primaryColor,
                  );
                },
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _submitInspection,
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryColor,
                padding: const EdgeInsets.symmetric(
                    vertical: 16.0, horizontal: 32.0),
              ),
              child: const Text(
                'Inspección Finalizada',
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
