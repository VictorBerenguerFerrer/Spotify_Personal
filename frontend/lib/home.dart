import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:just_audio/just_audio.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _controller = TextEditingController();
  final player = AudioPlayer();
  bool _loading = false;

  Future<void> _downloadAndPlay() async {
    setState(() => _loading = true);

    final url = _controller.text.trim();
    if (url.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Por favor, pega un enlace de YouTube')),
      );
      setState(() => _loading = false);
      return;
    }

    try {
      // Cambia <TU_IP> por la IP o dominio de tu backend
      final response = await http.get(Uri.parse('http://<TU_IP>:8000/download_audio?url=$url'));
      
      if (response.statusCode == 200) {
        final dir = await getApplicationDocumentsDirectory();
        final file = File('${dir.path}/audio.mp3');
        await file.writeAsBytes(response.bodyBytes);
        await player.setFilePath(file.path);
        await player.play();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al descargar el audio')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    } finally {
      setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("YouTube Audio Extractor")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _controller,
              decoration: InputDecoration(
                labelText: "Pega el enlace de YouTube",
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: _loading ? null : _downloadAndPlay,
              child: Text(_loading ? "Descargando..." : "Extraer audio"),
            ),
          ],
        ),
      ),
    );
  }
}
