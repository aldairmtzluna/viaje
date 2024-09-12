import 'package:flutter/material.dart';
import 'package:mysql1/mysql1.dart';
import 'package:intl/intl.dart';
import 'package:file_picker/file_picker.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'dart:io';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'dart:convert';

class ChatsView extends StatelessWidget {
  final Map<String, dynamic> user;
  final int currentUserId;

  const ChatsView({Key? key, required this.user, required this.currentUserId})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    String initials =
        user['nombre_usuario'][0] + user['apellido_paterno_usuario'][0];
    String fullName =
        user['nombre_usuario'] + ' ' + user['apellido_paterno_usuario'];

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFFEF4136),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.blue[200],
              ),
              padding: EdgeInsets.all(8),
              child: Text(
                initials,
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            ),
            SizedBox(width: 5),
            Text(
              fullName,
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 15,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.more_vert, color: Colors.white),
            onPressed: () {},
          ),
        ],
      ),
      body: ChatMessages(user: user, currentUserId: currentUserId),
      bottomSheet: InputBar(user: user, currentUserId: currentUserId),
    );
  }
}

class ChatMessages extends StatelessWidget {
  final Map<String, dynamic> user;
  final int currentUserId;

  const ChatMessages(
      {Key? key, required this.user, required this.currentUserId})
      : super(key: key);

  Stream<List<Map<String, dynamic>>> _fetchMessages(
      int userId, int currentUserId) async* {
    while (true) {
      try {
        final url =
            'https://whitesmoke-magpie-578690.hostingersite.com/index.php/mensajes?usuario_uno=$currentUserId&usuario_dos=$userId';
        final response = await http.get(Uri.parse(url));

        if (response.statusCode == 200) {
          final List<dynamic> jsonResponse = json.decode(response.body);
          yield jsonResponse.map((message) {
            return {
              'id_mensaje': message['id_mensaje'],
              'id_remitente_mensaje': message['id_remitente_mensaje'],
              'id_destinatario_mensaje': message['id_destinatario_mensaje'],
              'contenido_mensaje': message['contenido_mensaje'],
              'fecha_creacion_mensaje': message['fecha_creacion_mensaje'],
              'adjuntos_mensaje': message['adjuntos_mensaje'],
            };
          }).toList();
        } else {
          throw Exception('Error fetching messages: ${response.statusCode}');
        }
      } catch (e) {
        print('Error: $e');
      }

      await Future.delayed(Duration(seconds: 2));
    }
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Map<String, dynamic>>>(
      stream: _fetchMessages(user['id_usuario'], currentUserId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(child: Text('Sin mensajes.'));
        } else {
          List<Map<String, dynamic>> messages = snapshot.data!;
          Map<String, List<Map<String, dynamic>>> groupedMessages =
              _groupMessagesByDate(messages);

          return ListView.builder(
            padding: EdgeInsets.symmetric(vertical: 10, horizontal: 16),
            itemCount: groupedMessages.length,
            itemBuilder: (context, index) {
              String dateKey = groupedMessages.keys.elementAt(index);
              List<Map<String, dynamic>> dailyMessages =
                  groupedMessages[dateKey]!;
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildDateHeader(dateKey),
                  ...dailyMessages.map((message) {
                    bool isSender =
                        message['id_remitente_mensaje'] == currentUserId;
                    bool isDeletedForAll =
                        message['contenido_mensaje'] == 'Mensaje eliminado';
                    bool isMessageActive =
                        message['contenido_mensaje'] != 'Mensaje eliminado';
                    return MessageWidget(
                      message: message['contenido_mensaje'],
                      isSender: isSender,
                      messageId: message['id_mensaje'],
                      currentUserId: currentUserId,
                      isDeletedForAll: isDeletedForAll,
                      isMessageActive: isMessageActive,
                      timestamp:
                          DateTime.parse(message['fecha_creacion_mensaje']),
                      attachment: message['adjuntos_mensaje'],
                    );
                  }).toList(),
                ],
              );
            },
          );
        }
      },
    );
  }

  Map<String, List<Map<String, dynamic>>> _groupMessagesByDate(
      List<Map<String, dynamic>> messages) {
    Map<String, List<Map<String, dynamic>>> groupedMessages = {};

    for (var message in messages) {
      DateTime dateTime = DateTime.parse(message['fecha_creacion_mensaje']);
      String formattedDate = _formatDate(dateTime);

      if (!groupedMessages.containsKey(formattedDate)) {
        groupedMessages[formattedDate] = [];
      }

      groupedMessages[formattedDate]!.add(message);
    }

    return groupedMessages;
  }

  String _formatDate(DateTime dateTime) {
    DateTime now = DateTime.now();
    if (DateFormat('yyyyMMdd').format(now) ==
        DateFormat('yyyyMMdd').format(dateTime)) {
      return 'Hoy';
    } else if (DateFormat('yyyyMMdd').format(now.subtract(Duration(days: 1))) ==
        DateFormat('yyyyMMdd').format(dateTime)) {
      return 'Ayer';
    } else {
      return DateFormat('dd-MM-yyyy').format(dateTime);
    }
  }

  Widget _buildDateHeader(String dateKey) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      alignment: Alignment.center,
      child: Text(
        dateKey,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Colors.grey,
        ),
      ),
    );
  }
}

class InputBar extends StatefulWidget {
  final Map<String, dynamic> user;
  final int currentUserId;

  const InputBar({Key? key, required this.user, required this.currentUserId})
      : super(key: key);

  @override
  _InputBarState createState() => _InputBarState();
}

class _InputBarState extends State<InputBar> {
  final TextEditingController _messageController = TextEditingController();
  final FlutterSoundRecorder _recorder = FlutterSoundRecorder();
  bool _isRecording = false;
  File? _selectedFile;

  @override
  void initState() {
    super.initState();
    _recorder.openAudioSession();
  }

  @override
  void dispose() {
    _messageController.dispose();
    _recorder.closeAudioSession();
    super.dispose();
  }

  Future<void> _sendMessage({String? attachmentPath}) async {
    String messageContent = _messageController.text.trim();
    if (messageContent.isEmpty && attachmentPath == null) return;

    final url =
        'https://whitesmoke-magpie-578690.hostingersite.com/index.php/mensajes';

    try {
      final response = await http.post(
        Uri.parse(url),
        body: json.encode({
          'id_remitente_mensaje': widget.currentUserId,
          'id_destinatario_mensaje': widget.user['id_usuario'],
          'contenido_mensaje': messageContent,
          'adjuntos_mensaje': attachmentPath,
        }),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        setState(() {
          _messageController.clear();
        });
      } else {
        print('Failed to send message: ${response.body}');
      }
    } catch (e) {
      print('Error sending message: $e');
    }
  }

  Future<void> _sendFile(File file) async {
    await _sendMessage(attachmentPath: file.path);
  }

  Future<void> _pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();

    if (result != null) {
      setState(() {
        _selectedFile = File(result.files.single.path!);
      });
      await _sendFile(_selectedFile!);
    }
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _selectedFile = File(pickedFile.path);
      });
      await _sendFile(_selectedFile!);
    }
  }

  Future<void> _pickVideo() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickVideo(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _selectedFile = File(pickedFile.path);
      });
      await _sendFile(_selectedFile!);
    }
  }

  Future<void> _recordVoice() async {
    if (_isRecording) {
      _stopRecording();
    } else {
      _startRecording();
    }
  }

  Future<void> _startRecording() async {
    await _recorder.startRecorder(
      toFile: 'voice_message.aac',
    );
    setState(() {
      _isRecording = true;
    });
  }

  Future<void> _stopRecording() async {
    String? path = await _recorder.stopRecorder();
    setState(() {
      _isRecording = false;
    });
    if (path != null) {
      setState(() {
        _selectedFile = File(path);
      });
      await _sendFile(_selectedFile!);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80,
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.symmetric(horizontal: 10),
      color: Colors.grey[200],
      child: Row(
        children: [
          IconButton(
            icon: Icon(Icons.attach_file),
            onPressed: _pickFile,
          ),
          IconButton(
            icon: Icon(Icons.photo),
            onPressed: _pickImage,
          ),
          IconButton(
            icon: Icon(Icons.videocam),
            onPressed: _pickVideo,
          ),
          IconButton(
            icon: Icon(_isRecording ? Icons.mic_off : Icons.mic),
            onPressed: _recordVoice,
          ),
          Expanded(
            child: TextField(
              controller: _messageController,
              decoration: InputDecoration(
                hintText: 'Escribe un mensaje...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),
          ),
          SizedBox(width: 8),
          IconButton(
            icon: Icon(Icons.send),
            onPressed: () => _sendMessage(),
          ),
        ],
      ),
    );
  }
}

class MessageWidget extends StatelessWidget {
  final String message;
  final bool isSender;
  final int messageId;
  final int currentUserId;
  final bool isDeletedForAll;
  final bool isMessageActive;
  final DateTime timestamp;
  final String? attachment; // Add this line

  const MessageWidget({
    Key? key,
    required this.message,
    required this.isSender,
    required this.messageId,
    required this.currentUserId,
    required this.isDeletedForAll,
    required this.isMessageActive,
    required this.timestamp,
    this.attachment, // Add this line
  }) : super(key: key);

  Future<void> _editMessage(BuildContext context) async {
    final TextEditingController _editController = TextEditingController();
    _editController.text = message;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Editar mensaje'),
        content: TextField(
          controller: _editController,
          decoration: InputDecoration(
            hintText: 'Escribe tu mensaje...',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Cancelar',
              style: TextStyle(
                fontSize: 16,
                color: Color(0xFFEF4136),
              ),
            ),
          ),
          TextButton(
            onPressed: () async {
              String editedMessage = _editController.text.trim();
              if (editedMessage.isNotEmpty) {
                final url =
                    'https://whitesmoke-magpie-578690.hostingersite.com/index.php/mensajes';
                try {
                  final response = await http.put(
                    Uri.parse(url),
                    body: json.encode({
                      'id_mensaje': messageId,
                      'contenido_mensaje': editedMessage,
                    }),
                    headers: {'Content-Type': 'application/json'},
                  );

                  if (response.statusCode == 200) {
                    Navigator.pop(context);
                  } else {
                    print('Failed to edit message: ${response.body}');
                  }
                } catch (e) {
                  print('Error editing message: $e');
                }
              }
            },
            child: Text(
              'Guardar',
              style: TextStyle(
                fontSize: 16,
                color: Color(0xFFEF4136),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _deleteMessageForAll(BuildContext context) async {
    bool confirmDelete = await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Confirmar eliminación'),
        content: Text(
            '¿Estás seguro de que quieres eliminar este mensaje para todos?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(
              'Cancelar',
              style: TextStyle(
                fontSize: 16,
                color: Color(0xFFEF4136),
              ),
            ),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(
              'Eliminar',
              style: TextStyle(
                fontSize: 16,
                color: Color(0xFFEF4136),
              ),
            ),
          ),
        ],
      ),
    );

    if (confirmDelete) {
      final url =
          'https://whitesmoke-magpie-578690.hostingersite.com/index.php/mensajes';
      try {
        final response = await http.put(
          Uri.parse(url),
          body: json.encode({
            'id_mensaje': messageId,
            'contenido_mensaje': 'Mensaje eliminado',
          }),
          headers: {'Content-Type': 'application/json'},
        );

        if (response.statusCode != 200) {
          print('Failed to delete message for all: ${response.body}');
        }
      } catch (e) {
        print('Error deleting message for all: $e');
      }
    }
  }

  Future<void> _deleteMessageForMe(int messageId) async {
    final url = Uri.parse(
        'https://whitesmoke-magpie-578690.hostingersite.com/index.php/mensajes?id_mensaje=$messageId');

    try {
      final response = await http.delete(url);

      if (response.statusCode == 200) {
        print('Mensaje eliminado exitosamente');
      } else if (response.statusCode == 404) {
        print('Mensaje no encontrado');
      } else {
        print('Error al eliminar el mensaje: ${response.statusCode}');
      }
    } catch (e) {
      print('Error deleting message for me: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    String formattedTime = DateFormat('HH:mm').format(timestamp);
    return Align(
      alignment: isSender ? Alignment.centerRight : Alignment.centerLeft,
      child: Column(
        crossAxisAlignment:
            isSender ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          GestureDetector(
            onLongPress: () {
              if (isSender) {
                showModalBottomSheet(
                  context: context,
                  builder: (context) => Wrap(
                    children: [
                      if (isDeletedForAll)
                        ListTile(
                          leading: Icon(Icons.delete_sweep),
                          title: Text('Eliminar para mí'),
                          onTap: () {
                            Navigator.pop(context);
                            _deleteMessageForMe(messageId);
                          },
                        ),
                      if (!isDeletedForAll && isMessageActive) ...[
                        ListTile(
                          leading: Icon(Icons.edit),
                          title: Text('Editar'),
                          onTap: () {
                            Navigator.pop(context);
                            _editMessage(context);
                          },
                        ),
                        ListTile(
                          leading: Icon(Icons.delete_sweep),
                          title: Text('Eliminar para mí'),
                          onTap: () {
                            Navigator.pop(context);
                            _deleteMessageForMe(messageId);
                          },
                        ),
                        ListTile(
                          leading: Icon(Icons.delete),
                          title: Text('Eliminar para todos'),
                          onTap: () {
                            Navigator.pop(context);
                            _deleteMessageForAll(context);
                          },
                        ),
                      ]
                    ],
                  ),
                );
              }
            },
            child: Container(
              margin: EdgeInsets.symmetric(vertical: 4),
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: isSender
                    ? const Color.fromARGB(255, 222, 97, 88)
                    : Colors.grey[200],
                borderRadius: BorderRadius.only(
                  topLeft: isSender ? Radius.circular(20) : Radius.zero,
                  topRight: isSender ? Radius.zero : Radius.circular(20),
                  bottomLeft: Radius.circular(20),
                  bottomRight: isSender ? Radius.zero : Radius.circular(20),
                ),
              ),
              child: Column(
                crossAxisAlignment: isSender
                    ? CrossAxisAlignment.end
                    : CrossAxisAlignment.start,
                children: [
                  if (attachment != null) _buildAttachment(),
                  if (message.isNotEmpty)
                    Text(
                      message,
                      style: TextStyle(
                        color: isSender ? Colors.white : Colors.black,
                      ),
                    ),
                  SizedBox(height: 5),
                  Text(
                    formattedTime,
                    style: TextStyle(
                      color: isSender ? Colors.white70 : Colors.black54,
                      fontSize: 10,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAttachment() {
    if (attachment!.endsWith('.jpg') || attachment!.endsWith('.png')) {
      return Image.file(File(attachment!),
          width: 200, height: 200, fit: BoxFit.cover);
    } else if (attachment!.endsWith('.mp4')) {
      return Text('Video adjunto');
    } else if (attachment!.endsWith('.aac')) {
      return Text('Audio adjunto');
    } else {
      return Text('Archivo adjunto');
    }
  }
}
