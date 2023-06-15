import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../channels.dart';
import '../chat.dart';
import '../guilds.dart';

class RequestHandler {
  static Future<dynamic> request(adress, type, body, context) async {
    var url = Uri.parse('http://45.136.4.38:5000/$adress');
    var response;
    if (type == 'get') {
      response = await http.get(url);
    } else {
      response = await http.post(
          url,
          body: json.encode(body),
          headers: {'Content-Type': 'application/json'}
      );
    }
    if (response.statusCode == 200) {
      //return response.body;
      var responsebody = response.body;

      switch(adress){

        case 'get_guilds':
          List<dynamic> guildsJson = jsonDecode(responsebody as String);
          List<Map<String, dynamic>> guilds = [];
          guildsJson.forEach((guild) {
            guilds.add(guild as Map<String, dynamic>);
          });
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => GuildsPage(guilds: guilds),
            ),
          );
          break;

        case 'get_channels':
          Map<String, dynamic> channelsJson = jsonDecode(responsebody);
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ChannelsPage(channelsJson: channelsJson),
            ),
          );
          break;

        case 'get_messages':
          final jsonBody = json.decode(responsebody) as List<dynamic>;

          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ChatPage(messages: jsonBody, channelId: body['channel_id'],),
            ),
          );

          return json.decode(responsebody) as List<dynamic>;
          break;

        case "people":
          return json.decode(responsebody) as List<dynamic>;
          break;
        case "join":
        case "play":
        case"pause":
          return json.decode(responsebody);
      }
    }
    return null;
  }
}