import 'dart:convert';
import 'package:botic_xperience/helpers/request_handler.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'chat.dart';
import 'footer.dart';
import 'voice.dart';

class ChannelsPage extends StatefulWidget {
  final Map<String, dynamic> channelsJson;

  ChannelsPage({required this.channelsJson});

  @override
  _ChannelsPageState createState() => _ChannelsPageState();
}

class _ChannelsPageState extends State<ChannelsPage> {
  List<dynamic> chatChannels = [];
  List<dynamic> voiceChannels = [];
  List<dynamic> peopleChannels = [];

  bool showChatChannels = false;
  bool showVoiceChannels = false;
  bool showPeopleChannels = false;

  @override
  void initState() {
    super.initState();
    chatChannels = widget.channelsJson['chat_channels'];
    voiceChannels = widget.channelsJson['voice_channels'];

    // Sayfa yüklendiğinde "People" kategorisine istek gönder
    _getPeopleChannels();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF7289DA),
        title: Text('Channels'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: EdgeInsets.all(16.0),
              children: [
                _buildCategoryHeader('Chat Channels', showChatChannels),
                if (showChatChannels) _buildChannelsList(chatChannels, Icons.chat_bubble, "chat"),
                SizedBox(height: 16.0),
                _buildCategoryHeader('Voice Channels', showVoiceChannels),
                if (showVoiceChannels) _buildChannelsList(voiceChannels, Icons.call, "voice"),
                SizedBox(height: 16.0),
                _buildCategoryHeader('People', showPeopleChannels),
                if (showPeopleChannels) _buildPeopleChannels(),
              ],
            ),
          ),
          Footer(),
        ],
      ),
    );
  }

  Widget _buildCategoryHeader(String category, bool isExpanded) {
    return GestureDetector(
      onTap: () {
        setState(() {
          if (category == 'Chat Channels') {
            showChatChannels = !showChatChannels;
          } else if (category == 'Voice Channels') {
            showVoiceChannels = !showVoiceChannels;
          } else if (category == 'People') {
            showPeopleChannels = !showPeopleChannels;
          }
        });
      },
      child: Container(
        color: Color(0xFF36393F),
        padding: EdgeInsets.symmetric(vertical: 8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              category,
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            Icon(
              isExpanded ? Icons.arrow_drop_up : Icons.arrow_drop_down,
              size: 30.0,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChannelsList(List<dynamic> channels, IconData iconData, type) {
    return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: channels.length,
      itemBuilder: (context, index) {
        final channel = channels[index];
        return ListTile(
          title: Text(
            channel['name'],
            style: TextStyle(
              fontSize: 16.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          subtitle: Text(
            channel['id'],
            style: TextStyle(
              fontSize: 14.0,
              color: Colors.grey,
            ),
          ),
          leading: Icon(iconData),
          trailing: Icon(Icons.arrow_forward),
          onTap: () {
            // Kanala tıklandığında yapılacak işlemler
            if(type == 'chat') RequestHandler.request("get_messages", "post", {"channel_id": channel['id']}, context);
            else _navigateToVoicePage(channel['id']);

          },
        );
      },
    );
  }

  Widget _buildPeopleChannels() {
    return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: peopleChannels.length,
      itemBuilder: (context, index) {
        final person = peopleChannels[index];
        Color presenceColor;
        switch (person['presence']) {
          case 'online':
            presenceColor = Colors.green;
            break;
          case 'idle':
            presenceColor = Colors.yellow;
            break;
          case 'dnd':
            presenceColor = Colors.red;
            break;
          case 'offline':
            presenceColor = Colors.grey;
            break;
          default:
            presenceColor = Colors.grey;
        }
        return GestureDetector(
          onTap: () {
            _showZoomedAvatar(person['avatarURL']);
          },
          child: ListTile(
            leading: Hero(
              tag: person['username'],
              child: CircleAvatar(
                backgroundImage: NetworkImage(person['avatarURL']),
              ),
            ),
            title: Text(person['username']),
            subtitle: Text(person['channel']),
            trailing: Text(
              person['presence'],
              style: TextStyle(
                color: presenceColor,
                fontWeight: FontWeight.bold,
              ),
            ),
            onLongPress: () {
              _showZoomedAvatar(person['avatarURL']);
            },
          ),
        );
      },
    );
  }
  void _showZoomedAvatar(String avatarUrl) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          child: Container(
            padding: EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Hero(
                  tag: avatarUrl,
                  child: CircleAvatar(
                    backgroundImage: NetworkImage(avatarUrl),
                    radius: 100.0,
                  ),
                ),
                SizedBox(height: 16.0),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _getPeopleChannels() async {

    var people = await RequestHandler.request("people", "post", {'guild_id': widget.channelsJson['guild_id']}, context);
    setState(()  {
      peopleChannels = people;
    });

  }

  void _navigateToVoicePage(String channelId) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => VoicePage(channelId: channelId),
      ),
    );
  }


}
