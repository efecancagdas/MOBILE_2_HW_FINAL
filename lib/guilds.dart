import 'package:botic_xperience/helpers/request_handler.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'channels.dart';
import 'footer.dart';

class GuildsPage extends StatelessWidget {
  final List<Map<String, dynamic>> guilds;

  GuildsPage({required this.guilds});


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF7289DA),
        title: Text('Guilds'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: guilds.length,
              itemBuilder: (context, index) {
                final guild = guilds[index];
                return ListTile(
                  leading: guild['icon'] != null
                      ? Image.network(guild['icon'])
                      : Icon(Icons.no_photography),
                  title: Text(guild['name']),
                  subtitle: Text(guild['id']),
                  onTap: () {
                    RequestHandler.request("get_channels", "post", {"guild_id": guild['id']}, context);
                  },
                );
              },
            ),
          ),
          Footer(),
        ],
      ),
    );
  }
}
