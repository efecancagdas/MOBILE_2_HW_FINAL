import 'package:flutter/material.dart';
import 'helpers/request_handler.dart';

class Footer extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => RequestHandler.request("get_guilds", "get", null, context),
      child: Container(
        height: 50,
        color: Color(0xFF7289DA),
        child: Center(
          child: Text(
            'Go Server Screen',
            style: TextStyle(fontSize: 18, color: Colors.white),
          ),
        ),
      ),
    );
  }
}
