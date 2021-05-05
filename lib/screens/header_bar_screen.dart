import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:save_my_password/screens/home_screen.dart';

class HeaderBarScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            icon: Icon(Icons.home),
            onPressed: () {},
          ),
          IconButton(
            icon: Icon(Icons.close),
            onPressed: () {
              SystemNavigator.pop();
            },
          ),
        ],
      ),
      body: HomeScreen(),
    );
  }
}
