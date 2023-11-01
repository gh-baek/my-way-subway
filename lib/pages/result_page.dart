import 'package:flutter/material.dart';
import 'package:subway/functions.dart';

class ResultPage extends StatefulWidget {
  final String departure;
  final String arrival;

  ResultPage({Key? key, required this.departure, required this.arrival})
      : super(key: key);

  @override
  State<ResultPage> createState() => _ResultPageState();
}

class _ResultPageState extends State<ResultPage> {
  Map resultMap = {};

  @override
  void initState() {
    resultMap = findBestWay(
        departure: int.parse(widget.departure),
        arrival: int.parse(widget.arrival));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Result'),
      ),
      body: Column(
        children: List.generate(
          resultMap['time'].length,
          (index) => ListTile(
            title: Text((resultMap['time'][index]).toString()),
          ),
        ),
      ),
    );
  }
}
