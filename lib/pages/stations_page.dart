import 'package:flutter/material.dart';
import 'package:subway/functions.dart';

class StationsPage extends StatefulWidget {
  const StationsPage({super.key});

  @override
  State<StationsPage> createState() => _StationsPageState();
}

class _StationsPageState extends State<StationsPage> {
  List stationsList = StationInfo.stationSet.toList();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('역'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              children: List.generate(
                stationsList.length,
                (index) => ListTile(
                  title: Text(stationsList[index].toString()),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
