import 'dart:convert';
import 'package:botic_xperience/helpers/request_handler.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'footer.dart';

class VoicePage extends StatefulWidget {
  final String channelId;

  VoicePage({required this.channelId});

  @override
  _VoicePageState createState() => _VoicePageState();
}

class _VoicePageState extends State<VoicePage> {
  TextEditingController _messageController = TextEditingController();
  String responseMessage = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF7289DA),
        title: Text('Voice Page'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(height: 16.0),
          Padding(
            padding: EdgeInsets.all(16.0),
            child: Text('Channel ID: ${widget.channelId}', style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold)),
          ),
          _buildInputField(),
          SizedBox(height: 16.0),
          ElevatedButton(
            onPressed: () {
              _joinChannel();
            },
            child: Text('Connect/Disconnect'),
            style: ElevatedButton.styleFrom(
              foregroundColor: Colors.white, backgroundColor: Color(0xFF7289DA),
              padding: EdgeInsets.symmetric(vertical: 16.0),
            ),
          ),
          SizedBox(height: 16.0),
          SizedBox(height: 16.0),
          ElevatedButton(
            onPressed: () {
              _pauseResume();
            },
            child: Text('Pause/Resume'),
            style: ElevatedButton.styleFrom(
              foregroundColor: Colors.white, backgroundColor: Color(0xFF7289DA),
              padding: EdgeInsets.symmetric(vertical: 16.0),
            ),
          ),
        ],
      ),
      bottomNavigationBar: Footer(),
    );
  }

  Widget _buildInputField() {
    return Container(
      color: Color(0xFF36393F),
      padding: EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _messageController,
              decoration: InputDecoration(
                hintText: 'put a youtube link...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20.0),
                ),
                contentPadding: EdgeInsets.symmetric(horizontal: 16.0),
              ),
            ),
          ),
          SizedBox(width: 8.0),
          IconButton(
            icon: Icon(Icons.send),
            onPressed: () {
              _sendMessage();
            },
          ),
        ],
      ),
    );
  }

  void _joinChannel() async {
    final body = {'channel_id': widget.channelId};

    final jsonResponse = await RequestHandler.request("join", "post", body, context);
    setState(() {
      _showAlertDialog(jsonResponse['message']);
    });

  }

  void _sendMessage() async {
    final body = {
      'channel_id': widget.channelId,
      'link': _messageController.text,
    };

    final jsonResponse = await RequestHandler.request("play", "post", body, context);
    _showAlertDialog(jsonResponse['message']);

  }

  void _pauseResume() async {
    final body = {'channel_id': widget.channelId};

    final jsonResponse = await RequestHandler.request("pause", "post", body, context);

    _showAlertDialog(jsonResponse['message']);

  }

  void _showAlertDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Response'),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }
}
