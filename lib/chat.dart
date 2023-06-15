import 'dart:convert';

import 'package:botic_xperience/helpers/request_handler.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'footer.dart';

class ChatPage extends StatefulWidget {
  List<dynamic> messages;
  final String channelId;

  ChatPage({required this.messages, required this.channelId});

  @override
  _ChatPageState createState() => _ChatPageState();
}


class _ChatPageState extends State<ChatPage> {
  TextEditingController _messageController = TextEditingController();

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF7289DA),
        title: Text('Chat'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              reverse: false,
              itemCount: widget.messages.length,
              padding: EdgeInsets.symmetric(vertical: 16.0),
              itemBuilder: (context, index) {
                final message = widget.messages[index];
                final author = message['author'];
                final content = message['content'];
                final avatarUrl = author['avatar'];
                final username = author['username'];

                return ListTile(
                  leading: CircleAvatar(
                    backgroundImage: NetworkImage(avatarUrl),
                  ),
                  title: Text(
                    username,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  subtitle: Text(content),
                );
              },
            ),
          ),
          _buildInputField(),
        ],
      ),
      bottomNavigationBar: Footer(),
    );
  }

  Widget _buildInputField() {
    return Container(
      color: Color(0xFF36393F),
      padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _messageController,
              decoration: InputDecoration(
                hintText: 'Type a message...',
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

  Future<void> _sendMessage() async {
    RequestHandler.request("create_message", "post", {
      'channel_id': widget.channelId,
      'message': _messageController.text,
    }, context);


    getMessages(widget.channelId);
    _messageController.clear();
    setState(() {});

  }

  Future<void> getMessages(String channelId) async {

    final response = await RequestHandler.request("get_messages", "post", {
      'channel_id': widget.channelId,
    }, context);

    setState(() {
      widget.messages = response;
    });

  }
}
