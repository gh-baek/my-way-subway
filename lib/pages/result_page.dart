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

class _ResultPageState extends State<ResultPage>
    with SingleTickerProviderStateMixin {
  Map _resultMap = {};

  late TabController _tabController;

  final _selectedColor = Color(0xff1a73e8);
  final _unselectedColor = Color(0xff5f6368);
  final _tabs = [
    Tab(text: '최소 시간'),
    Tab(text: '최단 거리'),
    Tab(text: '최소 비용'),
    Tab(text: '최소 환승'),
  ];

  @override
  void initState() {
    _tabController = TabController(length: 4, vsync: this);
    _resultMap = findBestWay(
        departure: int.parse(widget.departure),
        arrival: int.parse(widget.arrival));
    super.initState();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        bottom: TabBar(
          controller: _tabController,
          tabs: _tabs,
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          ResultTab(type: 'time'),
          ResultTab(type: 'dist'),
          ResultTab(type: 'cost'),
          ResultTab(type: 'time'),
        ],
      ),
    );
  }

  int getTotalTime({required List result}) {
    int time = 0;
    for (var i = 0; i < result.length - 1; i++) {
      time += int.parse(StationInfo.timeGraph.nodes[result[i]]?[result[i + 1]]);
    }
    return time;
  }

  Column ResultTab({required String type}) {
    return Column(
      children: [
        Container(
          child: Column(
            children: [
              Text('소요시간'),
              Text(getTotalTime(result: _resultMap[type]).toString()),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('거리: '),
                  Text('비용: '),
                ],
              )
            ],
          ),
        ),
        Expanded(
          child: ListView(
            children: List.generate(
              _resultMap[type].length,
              (index) => ListTile(
                title: Text((_resultMap[type][index]).toString()),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
