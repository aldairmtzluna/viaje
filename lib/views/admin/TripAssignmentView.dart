import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TripAssignmentView extends StatefulWidget {
  final int idConductor;
  final int idUnidad;

  TripAssignmentView({required this.idConductor, required this.idUnidad});

  @override
  _TripAssignmentViewState createState() => _TripAssignmentViewState();
}

class _TripAssignmentViewState extends State<TripAssignmentView> {
  DateTime? selectedStartDate;
  TimeOfDay? selectedStartTime;
  DateTime? selectedEndDate;
  TimeOfDay? selectedEndTime;
  String? tripType;
  String? startLocation;
  String? endLocation;
  TextEditingController startLocationController = TextEditingController();
  TextEditingController endLocationController = TextEditingController();

  Future<void> _selectDateTime(BuildContext context, bool isStartDate) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );

    if (pickedDate != null) {
      TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
      );

      if (pickedTime != null) {
        setState(() {
          if (isStartDate) {
            selectedStartDate = pickedDate;
            selectedStartTime = pickedTime;
          } else {
            selectedEndDate = pickedDate;
            selectedEndTime = pickedTime;
          }
        });
      }
    }
  }

  Future<void> _showDateTimeModal(
      BuildContext context, bool isStartDate) async {
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        DateTime tempDate = isStartDate
            ? selectedStartDate ?? DateTime.now()
            : selectedEndDate ?? DateTime.now();
        TimeOfDay tempTime = isStartDate
            ? selectedStartTime ?? TimeOfDay.now()
            : selectedEndTime ?? TimeOfDay.now();

        return AlertDialog(
          title: Text(isStartDate ? 'Hora de Salida' : 'Hora de Llegada'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: Text("Fecha"),
                trailing: Text(DateFormat('yyyy-MM-dd').format(tempDate)),
                onTap: () async {
                  DateTime? picked = await showDatePicker(
                    context: context,
                    initialDate: tempDate,
                    firstDate: DateTime.now(),
                    lastDate: DateTime(2101),
                  );
                  if (picked != null) {
                    setState(() {
                      tempDate = picked;
                    });
                  }
                },
              ),
              ListTile(
                title: Text("Hora"),
                trailing: Text(tempTime.format(context)),
                onTap: () async {
                  TimeOfDay? picked = await showTimePicker(
                    context: context,
                    initialTime: tempTime,
                  );
                  if (picked != null) {
                    setState(() {
                      tempTime = picked;
                    });
                  }
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              child: Text(
                "Fijar Hora",
                style: TextStyle(
                  color: Color(0xFFEF4136),
                  fontSize: 10.5,
                ),
              ),
              onPressed: () {
                setState(() {
                  if (isStartDate) {
                    selectedStartDate = tempDate;
                    selectedStartTime = tempTime;
                  } else {
                    selectedEndDate = tempDate;
                    selectedEndTime = tempTime;
                  }
                });
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _submitTrip() {
    final creationDate = DateTime.now().toUtc();
    final startDateTime = DateTime(
      selectedStartDate!.year,
      selectedStartDate!.month,
      selectedStartDate!.day,
      selectedStartTime!.hour,
      selectedStartTime!.minute,
    );
    final endDateTime = DateTime(
      selectedEndDate!.year,
      selectedEndDate!.month,
      selectedEndDate!.day,
      selectedEndTime!.hour,
      selectedEndTime!.minute,
    );

    final tripData = {
      'matricula_viaje':
          'AV${String.fromCharCode(65 + (DateTime.now().second % 26))}${DateTime.now().millisecond}',
      'id_conductor_viaje': widget.idConductor,
      'id_unidad_viaje': widget.idUnidad,
      'tipo_viaje': tripType,
      'fecha_asignacion_viaje': creationDate.toIso8601String(),
      'fecha_inicio_viaje': startDateTime.toIso8601String(),
      'fecha_fin_viaje': endDateTime.toIso8601String(),
      'estado_viaje': 'Asignado',
      // Agregar observaciones aquí si se guardaron
    };

    // Enviar tripData a la base de datos
  }

  TextField _buildLocationTextField(TextEditingController controller,
      String labelText, bool isStartLocation) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: labelText,
        suffixIcon: IconButton(
          icon: Icon(Icons.clear),
          onPressed: () {
            controller.clear();
            setState(() {
              if (isStartLocation) {
                startLocation = null;
              } else {
                endLocation = null;
              }
            });
          },
        ),
      ),
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
        title: Text(
          'Asignar Viaje',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    icon: Icon(
                      Icons.access_time,
                      color: Color(0xFFEF4136),
                      size: 15,
                    ),
                    label: Text(
                      selectedStartDate != null && selectedStartTime != null
                          ? DateFormat('yyyy-MM-dd – kk:mm').format(
                              DateTime(
                                selectedStartDate!.year,
                                selectedStartDate!.month,
                                selectedStartDate!.day,
                                selectedStartTime!.hour,
                                selectedStartTime!.minute,
                              ),
                            )
                          : "Hora de Salida",
                      style: TextStyle(
                        color: Color(0xFFEF4136),
                        fontSize: 10.5,
                      ),
                    ),
                    onPressed: () {
                      _showDateTimeModal(context, true);
                    },
                  ),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton.icon(
                    icon: Icon(
                      Icons.access_time,
                      color: Color(0xFFEF4136),
                      size: 15,
                    ),
                    label: Text(
                      selectedEndDate != null && selectedEndTime != null
                          ? DateFormat('yyyy-MM-dd – kk:mm').format(
                              DateTime(
                                selectedEndDate!.year,
                                selectedEndDate!.month,
                                selectedEndDate!.day,
                                selectedEndTime!.hour,
                                selectedEndTime!.minute,
                              ),
                            )
                          : "Hora de Llegada",
                      style: TextStyle(
                        color: Color(0xFFEF4136),
                        fontSize: 10.5,
                      ),
                    ),
                    onPressed: () {
                      _showDateTimeModal(context, false);
                    },
                  ),
                ),
              ],
            ),
            DropdownButton<String>(
              value: tripType,
              hint: Text("Selecciona el tipo de viaje"),
              items: [
                DropdownMenuItem(
                  child: Row(
                    children: [Icon(Icons.arrow_forward), Text(" Solo ida")],
                  ),
                  value: "1",
                ),
                DropdownMenuItem(
                  child: Row(
                    children: [Icon(Icons.swap_horiz), Text(" Ida y vuelta")],
                  ),
                  value: "2",
                ),
                DropdownMenuItem(
                  child: Row(
                    children: [
                      Icon(Icons.more_horiz),
                      Text(" Más de un destino")
                    ],
                  ),
                  value: "3",
                ),
              ],
              onChanged: (String? newValue) {
                setState(() {
                  tripType = newValue;
                });
              },
            ),
            _buildLocationTextField(
                startLocationController, "Ubicación de Salida", true),
            _buildLocationTextField(
                endLocationController, "Ubicación de Llegada", false),
            SizedBox(
              width: MediaQuery.of(context).size.width *
                  0.8, // 80% del ancho de la pantalla
              // Elimina la altura fija o establece una altura más grande
              child: Container(
                margin: EdgeInsets.only(top: 20),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFFEF4136), // Color de fondo
                  ),
                  onPressed: () {
                    _submitTrip();
                  },
                  child: Text(
                    "Listo",
                    style: TextStyle(
                      color: Colors.white, // Color blanco para el texto
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
