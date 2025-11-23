import 'package:flutter/material.dart';

class AlarmaPopup extends StatefulWidget {
  @override
  _AlarmaPopupState createState() => _AlarmaPopupState();
}

class _AlarmaPopupState extends State<AlarmaPopup> {
  int _horaSeleccionada = 0;
  int _minutoSeleccionado = 0;
  TextEditingController _tituloController = TextEditingController();

  // Días de la semana con nombre completo
  Map<String, bool> diasSeleccionados = {
    "L": false,
    "M": false,
    "X": false,
    "J": false,
    "V": false,
    "S": false,
    "D": false,
  };

  final Map<String, String> nombresDias = {
    "L": "Lunes",
    "M": "Martes",
    "X": "Miércoles",
    "J": "Jueves",
    "V": "Viernes",
    "S": "Sábado",
    "D": "Domingo",
  };

  Future<void> seleccionarHora() async {
    // Cerrar el teclado antes de abrir el picker
    FocusScope.of(context).unfocus();

    // Esperar un frame para que se cierre el teclado
    await Future.delayed(Duration(milliseconds: 200));

    final TimeOfDay? nuevaHora = await showTimePicker(
      context: context,
      initialTime: TimeOfDay(hour: _horaSeleccionada, minute: _minutoSeleccionado),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: Theme.of(context).copyWith(
            timePickerTheme: TimePickerThemeData(
              hourMinuteTextStyle: TextStyle(fontSize: 48, fontWeight: FontWeight.bold),
            ),
          ),
          child: MediaQuery(
            data: MediaQuery.of(context).copyWith(
              alwaysUse24HourFormat: true,
            ),
            child: child!,
          ),
        );
      },
    );

    if (nuevaHora != null) {
      setState(() {
        _horaSeleccionada = nuevaHora.hour;
        _minutoSeleccionado = nuevaHora.minute;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
      contentPadding: EdgeInsets.all(20),
      insetPadding: EdgeInsets.symmetric(horizontal: screenWidth * 0.025), // 95% ancho
      title: Center(
        child: Text(
          "Nueva Alarma",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 26),
        ),
      ),
      content: Container(
        width: screenWidth * 0.95,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Campo Título
              TextField(
                controller: _tituloController,
                style: TextStyle(fontSize: 18),
                decoration: InputDecoration(
                  labelText: "Título de la alarma",
                  labelStyle: TextStyle(fontSize: 18),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),

              SizedBox(height: 20),

              // Texto "Seleccionar hora"
              Text(
                "Seleccionar hora",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey.shade700,
                ),
              ),

              SizedBox(height: 10),

              // Hora y Minuto separados
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Botón Hora
                  Expanded(
                    child: GestureDetector(
                      onTap: seleccionarHora,
                      child: Container(
                        padding: EdgeInsets.symmetric(vertical: 12),
                        decoration: BoxDecoration(
                          color: Color(0xFFFF69B4).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(15),
                          border: Border.all(
                            color: Color(0xFFFF69B4),
                            width: 2,
                          ),
                        ),
                        child: Column(
                          children: [
                            Text(
                              "Hora",
                              style: TextStyle(
                                fontSize: 20,
                                color: Colors.grey.shade600,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            SizedBox(height: 5),
                            Text(
                              _horaSeleccionada.toString().padLeft(2, '0'),
                              style: TextStyle(
                                fontSize: 48,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFFFF69B4),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  // Separador ":"
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 12),
                    child: Text(
                      ":",
                      style: TextStyle(
                        fontSize: 48,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFFFF69B4),
                      ),
                    ),
                  ),

                  // Botón Minuto
                  Expanded(
                    child: GestureDetector(
                      onTap: seleccionarHora,
                      child: Container(
                        padding: EdgeInsets.symmetric(vertical: 12),
                        decoration: BoxDecoration(
                          color: Color(0xFFFF69B4).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(15),
                          border: Border.all(
                            color: Color(0xFFFF69B4),
                            width: 2,
                          ),
                        ),
                        child: Column(
                          children: [
                            Text(
                              "Minutos",
                              style: TextStyle(
                                fontSize: 20,
                                color: Colors.grey.shade600,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            SizedBox(height: 5),
                            Text(
                              _minutoSeleccionado.toString().padLeft(2, '0'),
                              style: TextStyle(
                                fontSize: 48,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFFFF69B4),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              SizedBox(height: 20),

              // Texto "Días de la semana"
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Días de la semana",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey.shade700,
                  ),
                ),
              ),

              SizedBox(height: 10),

              // Días en grid de 2 columnas
              GridView.count(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                crossAxisCount: 2,
                mainAxisSpacing: 10,
                crossAxisSpacing: 10,
                childAspectRatio: 3.5,
                children: nombresDias.keys.map((dia) {
                  final bool activo = diasSeleccionados[dia]!;
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        diasSeleccionados[dia] = !activo;
                      });
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: activo ? Color(0xFFFF69B4) : Colors.grey.shade200,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Center(
                        child: Text(
                          nombresDias[dia]!,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: activo ? Colors.white : Colors.grey.shade700,
                          ),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ],
          ),
        ),
      ),

      // Botones inferior
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(
            "Cancelar",
            style: TextStyle(fontSize: 18, color: Colors.grey.shade600),
          ),
        ),
        ElevatedButton(
          onPressed: () {
            if (_tituloController.text.isEmpty) {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  title: Row(
                    children: [
                      Icon(Icons.warning_amber_rounded, color: Colors.orange, size: 28),
                      SizedBox(width: 10),
                      Text(
                        'Campo requerido',
                        style: TextStyle(fontSize: 22),
                      ),
                    ],
                  ),
                  content: Text(
                    'Debes escribir un título para la alarma',
                    style: TextStyle(fontSize: 20),
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text(
                        'Entendido',
                        style: TextStyle(fontSize: 20),
                      ),
                    ),
                  ],
                ),
              );
              return;
            }

            // Filtrar días seleccionados
            List<String> dias = diasSeleccionados.entries
                .where((e) => e.value)
                .map((e) => e.key)
                .toList();

            // Si no seleccionó días, usar el día de hoy
            if (dias.isEmpty) {
              final hoy = DateTime.now().weekday;
              const mapaInverso = {
                DateTime.monday: "L",
                DateTime.tuesday: "M",
                DateTime.wednesday: "X",
                DateTime.thursday: "J",
                DateTime.friday: "V",
                DateTime.saturday: "S",
                DateTime.sunday: "D",
              };
              dias = [mapaInverso[hoy]!];
              print('ℹ️ No se seleccionaron días, usando hoy: ${mapaInverso[hoy]}');
            }

            // Convertir hora a string tipo 09:30
            final horaString =
                "${_horaSeleccionada.toString().padLeft(2, '0')}:${_minutoSeleccionado.toString().padLeft(2, '0')}";

            final nuevaAlarma = {
              "id": DateTime.now().millisecondsSinceEpoch,
              "hora": horaString,
              "titulo": _tituloController.text,
              "activa": true,
              "dias": dias,
              "sound": true,
              "vibration": true,
            };

            Navigator.pop(context, nuevaAlarma);
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Color(0xFFFF69B4),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            padding: EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          ),
          child: Text(
            "Guardar",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
          ),
        ),
      ],
    );
  }
}