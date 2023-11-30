import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:subway/functions.dart';
import 'package:subway/pages/map_page.dart';
import 'package:subway/style.dart';

class StationInfoPage extends StatefulWidget {
  final String station;
  final int line;

  const StationInfoPage({super.key, required this.station, this.line = 2});

  @override
  State<StationInfoPage> createState() => _StationInfoPageState();
}

class _StationInfoPageState extends State<StationInfoPage>
    with SingleTickerProviderStateMixin {
  late Station _currentSt;
  late TabController _tabController;
  late int _selectedLine;

  @override
  void initState() {
    _selectedLine = widget.line;
    _currentSt = StationInfo.stationMap[int.parse(widget.station)]!;
    int initialIndex;

    if (_currentSt.lines[0] == widget.line) {
      initialIndex = 0;
    } else {
      initialIndex = 1;
    }
    _tabController = TabController(
        initialIndex: initialIndex,
        length: _currentSt.lines.length,
        vsync: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> tabs = [];
    for (var line in _currentSt.lines) {
      tabs.add(Tab(
        child: Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: lineColorMap[line]!, width: 1)),
          child: Align(
            alignment: Alignment.center,
            child: Text(
              "${line}호선",
              style: TextStyle(fontSize: 18.0),
            ),
          ),
        ),
      ));
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(230.0),
        child: AppBar(
          elevation: 0,
          automaticallyImplyLeading: false,
          backgroundColor: lineColorMap[_selectedLine],
          toolbarHeight: 230,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              bottom: Radius.circular(20),
            ),
          ),
          title: Container(
            height: 200,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Stack(
                  alignment: Alignment.topCenter,
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
                        '역 정보',
                        style: appBarTitleStyle,
                      ),
                    ),
                  ],
                ),
                Stack(
                  alignment: Alignment.bottomCenter,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: GestureDetector(
                        child: Container(
                          alignment: Alignment.centerLeft,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Icon(
                                _currentSt.prevStation[_selectedLine] != null
                                    ? Icons.arrow_back_ios
                                    : Icons.first_page_sharp,
                                color: Colors.white,
                              ),
                              Text(
                                _currentSt.prevStation[_selectedLine] != null
                                    ? '${_currentSt.prevStation[_selectedLine]}'
                                    : '',
                                style: stInfoStyle,
                              ),
                            ],
                          ),
                        ),
                        onTap: () {
                          if (_currentSt.prevStation[_selectedLine] != null) {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => StationInfoPage(
                                  station: _currentSt.prevStation[_selectedLine]
                                      .toString(),
                                  line: _selectedLine,
                                ),
                              ),
                            );
                          }
                        },
                      ),
                    ),
                    Center(
                      child: Container(
                        width: 100,
                        height: 45,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Center(
                          child: Text(
                            '${_currentSt.station}',
                            style: TextStyle(
                              fontSize: 24.0,
                              color: lineColorMap[_selectedLine],
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: GestureDetector(
                        child: Container(
                          alignment: Alignment.centerRight,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Text(
                                _currentSt.nextStation[_selectedLine] != null
                                    ? '${_currentSt.nextStation[_selectedLine]}'
                                    : '',
                                style: stInfoStyle,
                              ),
                              Icon(
                                _currentSt.nextStation[_selectedLine] != null
                                    ? Icons.arrow_forward_ios
                                    : Icons.last_page_sharp,
                                color: Colors.white,
                              ),
                            ],
                          ),
                        ),
                        onTap: () {
                          if (_currentSt.nextStation[_selectedLine] != null) {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => StationInfoPage(
                                  station: _currentSt.nextStation[_selectedLine]
                                      .toString(),
                                  line: _selectedLine,
                                ),
                              ),
                            );
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
      body: SizedBox(
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: TabBar(
                isScrollable: false,
                onTap: (index) {
                  if (_selectedLine == _currentSt.lines[0]) {
                    _selectedLine = _currentSt.lines[1];
                  } else {
                    _selectedLine = _currentSt.lines[0];
                  }

                  setState(() {});
                },
                controller: _tabController,
                labelColor: Colors.white,
                labelStyle: selectedTabBarStyle,
                unselectedLabelStyle: unselectedTabBarStyle,
                unselectedLabelColor: Colors.grey,
                indicator: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: lineColorMap[_selectedLine],
                ),
                tabs: tabs,
              ),
            ),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: List.generate(
                    _currentSt.lines.length, (index) => _buildStInfo()),
              ),
            ),
          ],
        ),
      ),
    );
  }

  bool _containMap({required targetMap}) {
    for (var map in bookMarkedList) {
      if (mapEquals(map, targetMap)) {
        return true;
      }
    }
    return false;
  }

  Column _buildStInfo() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          width: 400,
          height: 200,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15),
            border: Border.all(color: Colors.black12, width: 1),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              SizedBox(
                width: 150,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('이번 열차'),
                    Center(
                        child: Text(
                      '곧 도착',
                      style: TextStyle(
                        fontSize: 20.0,
                        color: Colors.red,
                        fontWeight: FontWeight.w600,
                      ),
                    )),
                    Text('다음 열차'),
                    Center(
                        child: Text(
                      '7분',
                      style: TextStyle(
                        fontSize: 20.0,
                        color: Colors.red,
                        fontWeight: FontWeight.w600,
                      ),
                    )),
                  ],
                ),
              ),
              VerticalDivider(
                indent: 10.0,
                endIndent: 10.0,
              ),
              SizedBox(
                width: 150,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('이번 열차'),
                    Center(
                        child: Text(
                      '곧 도착',
                      style: TextStyle(
                        fontSize: 20.0,
                        color: Colors.red,
                        fontWeight: FontWeight.w600,
                      ),
                    )),
                    Text('다음 열차'),
                    Center(
                        child: Text(
                      '7분',
                      style: TextStyle(
                        fontSize: 20.0,
                        color: Colors.red,
                        fontWeight: FontWeight.w600,
                      ),
                    )),
                  ],
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(
            top: 10.0,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              GestureDetector(
                child: Container(
                  width: 180,
                  height: 50,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.black12, width: 1),
                  ),
                  child: const Center(
                    child: Text(
                      '지하철 노선도',
                      style: TextStyle(
                          fontSize: 16.0, fontWeight: FontWeight.w500),
                    ),
                  ),
                ),
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => MapPage()));
                },
              ),
              GestureDetector(
                child: Container(
                  width: 180,
                  height: 50,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.black12, width: 1),
                  ),
                  child: Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _containMap(targetMap: {
                          'station': _currentSt.station,
                          'line': _selectedLine
                        })
                            ? const Icon(
                                Icons.star,
                                color: Colors.yellow,
                              )
                            : const Icon(
                                Icons.star_border,
                              ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            _containMap(targetMap: {
                              'station': _currentSt.station,
                              'line': _selectedLine
                            })
                                ? '즐겨찾기 해제'
                                : '즐겨찾기 등록',
                            style: const TextStyle(
                              fontSize: 16.0,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                onTap: () {
                  print(bookMarkedList);

                  for (var map in bookMarkedList) {
                    if (mapEquals(map, {
                      'station': _currentSt.station,
                      'line': _selectedLine
                    })) {
                      bookMarkedList.remove(map);
                      setState(() {});
                      return;
                    }
                  }
                  bookMarkedList.add(
                      {'station': _currentSt.station, 'line': _selectedLine});

                  setState(() {});
                },
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(
            top: 10.0,
          ),
          child: Container(
            width: 400,
            height: 200,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15),
              border: Border.all(color: Colors.black12, width: 1),
            ),
            child: _buildCongestionInfo(),
          ),
        ),
      ],
    );
  }

  //도착 예정 시간
  //int _getArrivalTime() {}

  String _getCongestion() {
    DateTime dt = DateTime.now();
    int index = (dt.hour - 5);
    double currentCong = 0.0;
    if (index >= 0) {
      currentCong =
          StationInfo.congestionMap[_selectedLine][_currentSt.station][index];
    }

    String congState = 'zzz';
    if (currentCong >= 0 && currentCong < 35) {
      congState = '쾌적';
    } else if (currentCong >= 35 && currentCong < 70) {
      congState = '양호';
    } else if (currentCong >= 70) {
      congState = '혼잡';
    }
    return congState;
  }

  Column _buildCongestionInfo() {
    String congState = _getCongestion();
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.all(10.0),
          child: Text(
            '역 내 혼잡도',
            style: TextStyle(
              fontSize: 18.0,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(15.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildCongIcon(congState: congState),
              Column(
                children: [
                  const Text(
                    '현재 시간대는',
                    style: TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  Row(
                    children: [
                      Text(
                        congState,
                        style: const TextStyle(
                          fontSize: 24.0,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const Text(
                        ' 입니다',
                        style: TextStyle(
                          fontSize: 16.0,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Icon _buildCongIcon({required String congState}) {
    switch (congState) {
      case 'zzz':
        return const Icon(
          Icons.hotel_sharp,
          size: 75.0,
        );
      case '쾌적':
        return const Icon(
          Icons.mood_outlined,
          size: 75.0,
          color: Colors.green,
        );
      case '양호':
        return const Icon(
          Icons.sentiment_neutral_outlined,
          size: 75.0,
          color: Colors.orange,
        );
      case '혼잡':
        return const Icon(
          Icons.mood_bad_outlined,
          size: 75.0,
          color: Colors.redAccent,
        );

      default:
        return const Icon(
          Icons.do_not_disturb_on_total_silence_rounded,
          size: 75.0,
        );
    }
  }
}
