import 'package:flutter/material.dart';

class MapPage extends StatefulWidget {
  const MapPage({super.key});

  @override
  State<MapPage> createState() => _MapPageState();
}

//TODO: 맵 가로모드
class _MapPageState extends State<MapPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(),
      body: Center(
        child: InteractiveViewer(
          maxScale: 6.0,
          minScale: 1.0,
          child: Image.asset('lib/assets/images/map.png'),
        ),
      ),
    );
  }
}
