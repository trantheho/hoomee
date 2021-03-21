import 'package:flutter/material.dart';

import 'game_play.dart';

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> with SingleTickerProviderStateMixin {

  @override
  Widget build(BuildContext context) {
    return GamePlay(MediaQuery.of(context).size, 'assets/drawables/images/1_free.jpg', 6);
  }
}
