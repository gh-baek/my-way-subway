import 'dart:core';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:subway/functions.dart';
import 'package:subway/style.dart';

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
  Map<String, List> _resultMap = {};

  final SearchController _departureSearchController = SearchController();
  final SearchController _arrivalSearchController = SearchController();

  late String _selectedDept;
  late String _selectedArr;

  late TabController _tabController;

  final _tabs = [
    Tab(
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: primaryBlue, width: 1)),
        child: Align(
          alignment: Alignment.center,
          child: Text(
            "최소 시간",
          ),
        ),
      ),
    ),
    Tab(
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: primaryBlue, width: 1)),
        child: Align(
          alignment: Alignment.center,
          child: Text(
            "최단 거리",
          ),
        ),
      ),
    ),
    Tab(
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: primaryBlue, width: 1)),
        child: Align(
          alignment: Alignment.center,
          child: Text(
            "최소 비용",
          ),
        ),
      ),
    ),
    Tab(
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: primaryBlue, width: 1)),
        child: Align(
          alignment: Alignment.center,
          child: Text(
            "최소 환승",
          ),
        ),
      ),
    ),
  ];

  @override
  void initState() {
    _tabController = TabController(length: 4, vsync: this);
    _resultMap = findBestWay(
        departure: int.parse(widget.departure),
        arrival: int.parse(widget.arrival));

    super.initState();
    _selectedDept = widget.departure;
    _selectedArr = widget.arrival;
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  late SharedPreferences prefs;

  Future<String> _setInit() async {
    prefs = await SharedPreferences.getInstance();

    return prefs.toString();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _setInit(),
      builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
        if (snapshot.hasData) {
          return GestureDetector(
            onTap: () {
              FocusNode currentFocus = FocusScope.of(context);
              if (!currentFocus.hasPrimaryFocus) {
                currentFocus.unfocus();
              }
            },
            child: Scaffold(
              backgroundColor: Colors.white,
              appBar: PreferredSize(
                preferredSize: const Size.fromHeight(300.0),
                child: AppBar(
                  elevation: 0,
                  automaticallyImplyLeading: false,
                  backgroundColor: primaryBlue,
                  toolbarHeight: 300,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.vertical(
                      bottom: Radius.circular(30),
                    ),
                  ),
                  title: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Stack(
                        children: [
                          Container(
                            alignment: Alignment.centerLeft,
                            child: IconButton(
                              icon: Icon(Icons.arrow_back, color: Colors.white),
                              onPressed: () => Navigator.of(context).pop(),
                            ),
                          ),
                          Center(
                            child: Text(
                              '추천 경로',
                              style: appBarTitleStyle,
                            ),
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Column(
                          children: [
                            SearchAnchor(
                              isFullScreen: false,
                              searchController: _departureSearchController,
                              builder: (BuildContext context,
                                  SearchController controller) {
                                return SearchBar(
                                  shape: MaterialStateProperty.all(
                                      const ContinuousRectangleBorder(
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(75),
                                      topRight: Radius.circular(75),
                                    ),
                                  )),
                                  onChanged: (input) {
                                    _selectedDept = input;
                                    _departureSearchController.text = input;
                                  },
                                  hintText: _selectedDept,
                                  trailing: [
                                    IconButton(
                                      icon: const Icon(
                                          Icons.compare_arrows_sharp),
                                      onPressed: () {
                                        String temp = _selectedDept;
                                        _selectedDept = _selectedArr;
                                        _selectedArr = temp;
                                        _departureSearchController.text =
                                            _selectedDept;
                                        _arrivalSearchController.text =
                                            _selectedArr;
                                        setState(() {});
                                      },
                                    ),
                                  ],
                                  onTap: () {
                                    print(
                                        _departureSearchController.value.text);
                                    _departureSearchController.openView();
                                  },
                                );
                              },
                              suggestionsBuilder: (BuildContext context,
                                  SearchController deptController) {
                                final keyword = deptController.value.text;
                                _selectedDept = keyword;
                                return keyword.toString() != ''
                                    ? List.generate(
                                            StationInfo.stationSet
                                                .toList()
                                                .length,
                                            (index) => StationInfo.stationSet.toList()[index])
                                        .where((element) => element
                                            .toString()
                                            .toLowerCase()
                                            .startsWith(keyword
                                                .toString()
                                                .toLowerCase()))
                                        .map(
                                          (item) => ListTile(
                                            title: Text(item.toString()),
                                            onTap: () {
                                              setState(() {
                                                _selectedDept = item.toString();
                                                deptController
                                                    .closeView(item.toString());
                                                FocusScope.of(context)
                                                    .unfocus();
                                              });
                                            },
                                          ),
                                        )
                                    : List.generate(recentSearchQueue.length,
                                            (index) => recentSearchQueue.toList()[index])
                                        .where((element) => element
                                            .toString()
                                            .toLowerCase()
                                            .startsWith(keyword.toLowerCase()))
                                        .map(
                                          (item) => ListTile(
                                            title: Text(item.toString()),
                                            onTap: () {
                                              setState(() {
                                                _selectedDept = item.toString();
                                                deptController
                                                    .closeView(item.toString());
                                                FocusScope.of(context)
                                                    .unfocus();
                                              });
                                            },
                                          ),
                                        );
                              },
                            ),
                            SearchAnchor(
                              isFullScreen: false,
                              searchController: _arrivalSearchController,
                              builder: (BuildContext context,
                                  SearchController controller) {
                                return SearchBar(
                                  shape: MaterialStateProperty.all(
                                      const ContinuousRectangleBorder(
                                    borderRadius: BorderRadius.only(
                                      bottomLeft: Radius.circular(75),
                                      bottomRight: Radius.circular(75),
                                    ),
                                  )),
                                  onChanged: (input) {
                                    _selectedArr = input;
                                    _arrivalSearchController.text = input;
                                  },
                                  hintText: _selectedArr,
                                  trailing: [
                                    IconButton(
                                      icon: const Icon(Icons.search),
                                      onPressed: () {
                                        if (StationInfo.stationSet.contains(
                                                int.parse(_selectedDept)) &&
                                            StationInfo.stationSet.contains(
                                                int.parse(_selectedArr)) &&
                                            _selectedDept != _selectedArr) {
                                          if (recentSearchQueue.length >= 10) {
                                            recentSearchQueue.removeFirst();
                                            recentSearchQueue.removeFirst();
                                          }
                                          if (!recentSearchQueue.contains(
                                              int.parse(_selectedDept))) {
                                            recentSearchQueue
                                                .add(int.parse(_selectedDept));
                                          }
                                          if (!recentSearchQueue.contains(
                                              int.parse(_selectedArr))) {
                                            recentSearchQueue
                                                .add(int.parse(_selectedArr));
                                          }
                                          var origList =
                                              recentSearchQueue.toList();

                                          List<String> strList = origList
                                              .map((i) => i.toString())
                                              .toList();
                                          print(strList);
                                          if (prefs.containsKey(
                                              'recentSearchQueue')) {
                                            prefs.remove('recentSearchQueue');
                                          }
                                          prefs.setStringList(
                                              'recentSearchQueue', strList);

                                          Navigator.pushReplacement(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      ResultPage(
                                                        departure:
                                                            _selectedDept,
                                                        arrival: _selectedArr,
                                                      )));
                                        } else {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            //없는 역, 역이 아닌 것을 검색 시 오류 메세지 출력
                                            SnackBar(
                                              backgroundColor: Colors.redAccent,
                                              content: const Text(
                                                '해당 역이 존재하지 않습니다.',
                                              ),
                                              duration:
                                                  const Duration(seconds: 3),
                                              action: SnackBarAction(
                                                label: 'X',
                                                textColor: Colors.white,
                                                onPressed: () {},
                                              ),
                                            ),
                                          );
                                        }
                                      },
                                    ),
                                  ],
                                  onTap: () {
                                    _arrivalSearchController.openView();
                                  },
                                );
                              },
                              suggestionsBuilder: (BuildContext context,
                                  SearchController arrController) {
                                final keyword = arrController.value.text;
                                _selectedArr = keyword;
                                return keyword.toString() != ''
                                    ? List.generate(
                                            StationInfo.stationSet
                                                .toList()
                                                .length,
                                            (index) =>
                                                StationInfo.stationSet.toList()[index])
                                        .where((element) => element
                                            .toString()
                                            .toLowerCase()
                                            .startsWith(keyword.toLowerCase()))
                                        .map(
                                          (item) => ListTile(
                                            title: Text(item.toString()),
                                            onTap: () {
                                              setState(() {
                                                _selectedArr = item.toString();
                                                arrController
                                                    .closeView(item.toString());
                                                FocusScope.of(context)
                                                    .unfocus();
                                              });
                                            },
                                          ),
                                        )
                                    : List.generate(
                                            recentSearchQueue.length,
                                            (index) =>
                                                recentSearchQueue.toList()[index])
                                        .where((element) => element
                                            .toString()
                                            .toLowerCase()
                                            .startsWith(keyword.toString().toLowerCase()))
                                        .map(
                                          (item) => ListTile(
                                            title: Text(item.toString()),
                                            onTap: () {
                                              setState(() {
                                                _selectedArr = item.toString();
                                                arrController
                                                    .closeView(item.toString());
                                                FocusScope.of(context)
                                                    .unfocus();
                                              });
                                            },
                                          ),
                                        );
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              body: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: TabBar(
                      controller: _tabController,
                      labelColor: Colors.white,
                      labelStyle: selectedTabBarStyle,
                      unselectedLabelStyle: unselectedTabBarStyle,
                      unselectedLabelColor: Colors.grey,
                      indicator: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: primaryBlue),
                      tabs: _tabs,
                    ),
                  ),
                  Expanded(
                    child: TabBarView(
                      controller: _tabController,
                      children: [
                        ResultTab(type: 'time'),
                        ResultTab(type: 'dist'),
                        ResultTab(type: 'cost'),
                        ResultTab(type: 'transfer'),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        } else {
          return Scaffold(
            backgroundColor: primaryBlue,
            body: const CircularProgressIndicator(
              color: Colors.white,
            ),
          );
        }
      },
    );
  }

  int getTotalTime({required List result}) {
    int time = 0;
    for (var i = 0; i < result.length - 1; i++) {
      time += StationInfo.timeGraph.nodes[result[i]]?[result[i + 1]] as int;
    }
    return time;
  }

  int getTotalDist({required List result}) {
    int dist = 0;
    for (var i = 0; i < result.length - 1; i++) {
      dist += StationInfo.distGraph.nodes[result[i]]?[result[i + 1]] as int;
    }
    return dist;
  }

  int getTotalCost({required List result}) {
    int cost = 0;
    for (var i = 0; i < result.length - 1; i++) {
      cost += StationInfo.costGraph.nodes[result[i]]?[result[i + 1]] as int;
    }
    return cost;
  }

  Column ResultTab({required String type}) {
    int totalTime = getTotalTime(result: _resultMap[type]!);
    int totalDist = getTotalDist(result: _resultMap[type]!);
    int totalCost = getTotalCost(result: _resultMap[type]!);

    int minute = totalTime ~/ 60;
    int sec = totalTime % 60;
    print(totalTime);
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              border: Border.all(color: Colors.black12, width: 1),
            ),
            width: 400,
            height: 130,
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(25.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '소요시간',
                          style: resultTextStyle,
                        ),
                        Text(
                          '$minute분 $sec초',
                          style: resultTimeStyle,
                        )
                      ],
                    ),
                  ),
                  VerticalDivider(),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Row(
                        children: [
                          Text('거리 ', style: resultTextStyle),
                          Text('${totalDist / 1000}km', style: resultTextStyle),
                        ],
                      ),
                      Row(
                        children: [
                          Text(
                            '비용 ',
                            style: resultTextStyle,
                          ),
                          Text('${totalCost}원', style: resultTextStyle),
                        ],
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
        Expanded(
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Padding(
              padding: const EdgeInsets.only(left: 50.0, right: 50.0),
              child: Column(
                children: [
                  ListView.builder(
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    physics: const BouncingScrollPhysics(),
                    itemCount: _resultMap[type]!.length,
                    itemBuilder: (BuildContext context, int index) {
                      if (index == 0) {
                        return _buildResultList(
                            station: _resultMap[type]![index], text: '탑승');
                      } else if (index == _resultMap[type]!.length - 1) {
                        return _buildResultList(
                            station: _resultMap[type]![index], text: '하차');
                      } else {
                        return _buildResultList(
                            station: _resultMap[type]![index]);
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  //TODO: 호선 어떻게 지정
  Widget _buildResultList({required station, String text = ''}) {
    return Container(
      color: Colors.white,
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 15,
                height: 60,
                color: lineColorMap[StationInfo.stationMap[station]?.lines[0]],
              ),
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Text(
                          '$station   ',
                          style: resultTileStyle,
                        ),
                        Text(
                          '$text ',
                          style: resultTileStyle,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
