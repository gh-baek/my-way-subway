import 'package:flutter/material.dart';
import 'package:subway/functions.dart';
import 'package:subway/pages/map_page.dart';
import 'package:subway/pages/result_page.dart';
import 'package:subway/pages/search_station_page.dart';
import 'bookmark_page.dart';
import 'package:subway/style.dart';
import 'dart:math';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

List<String> greetings = [
  '안녕하세요',
  '좋은 하루 되세요',
  '즐거운 하루 되세요',
  '오늘도 힘내세요',
];

class _HomePageState extends State<HomePage> {
  final SearchController _departureSearchController = SearchController();
  final SearchController _arrivalSearchController = SearchController();

  String _selectedDept = '';
  String _selectedArr = '';
  String inputText = '사용자'; //default

  String greeting = greetings[Random().nextInt(greetings.length)];

  // these will be reused later
  final Icon _leading = const Icon(Icons.search);

  final List<Widget> _searchButton = [
    IconButton(
      icon: const Icon(Icons.search),
      onPressed: () {},
    ),
  ];
  List _recentSearch = ['101', '102', '104', '121', '306'];

  @override
  void initState() {
    setStationInfo();
    super.initState();
  }

  TextEditingController _textFieldController = TextEditingController();
  _displayDialog(BuildContext context) async {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog (
          title: Text('닉네임 입력'),
          content: TextField(
            onChanged: (text) {
              setState(() {
                inputText = text;
              });
            },
            controller: _textFieldController,
            decoration: InputDecoration(hintText: "예시) 홍길동"),
          ),
          actions: <Widget>[
            new TextButton(
              child: new Text('확인'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            )
          ],
        );
      });
  }


  @override
  Widget build(BuildContext context) {
    BorderRadiusGeometry radius = const BorderRadius.only(
      topLeft: Radius.circular(24.0),
      topRight: Radius.circular(24.0),
    );
    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(300.0),
          child: AppBar(
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
                Text(
                  'MY WAY',
                  style: appBarTitleStyle,
                ),
                SizedBox(
                  height: 30,
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
                                icon: const Icon(Icons.compare_arrows_sharp),
                                onPressed: () {
                                  String temp = _selectedDept;
                                  _selectedDept = _selectedArr;
                                  _selectedArr = temp;
                                  _departureSearchController.text =
                                      _selectedDept;
                                  _arrivalSearchController.text = _selectedArr;
                                  setState(() {});
                                },
                              ),
                            ],
                            onTap: () {
                              print(_departureSearchController.value.text);
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
                                      StationInfo.stationSet.toList().length,
                                      (index) => StationInfo.stationSet
                                          .toList()[index])
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
                                          FocusScope.of(context).unfocus();
                                        });
                                      },
                                    ),
                                  )
                              : List.generate(
                                      5, (index) => _recentSearch[index])
                                  .where((element) => element
                                      .toLowerCase()
                                      .startsWith(keyword.toLowerCase()))
                                  .map(
                                    (item) => ListTile(
                                      title: Text(item.toString()),
                                      onTap: () {
                                        setState(() {
                                          _selectedDept = item.toString();
                                          deptController.closeView(item);
                                          FocusScope.of(context).unfocus();
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
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => ResultPage(
                                                departure: _selectedDept,
                                                arrival: _selectedArr,
                                              )));
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
                                      StationInfo.stationSet.toList().length,
                                      (index) => StationInfo.stationSet
                                          .toList()[index])
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
                                          FocusScope.of(context).unfocus();
                                        });
                                      },
                                    ),
                                  )
                              : List.generate(
                                      5, (index) => _recentSearch[index])
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
                                          arrController.closeView(item);
                                          FocusScope.of(context).unfocus();
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
        body: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 20, 0, 10),
                    child: Container(
                      width: 380,
                      height: 50,
                      child: Center(
                        child: Row(
                          children: [
                            Text(
                              greeting,
                              textAlign: TextAlign.left,
                              style: homeNicknameStyle,
                            ),
                            Text(
                              ', $inputText 님',
                              textAlign: TextAlign.left,
                              style: homeNicknameStyle,
                            ),
                          ],
                        ),
                      ),
                    ),
                ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: GestureDetector(
                      onTapUp: (detail) => Navigator.push(context,
                          MaterialPageRoute(builder: (context) => MapPage())),
                      child: Card(
                        child: Container(
                          width: 180,
                          height: 200,
                          child: Center(
                            child: Text(
                              '지하철 노선도',
                              style: homeMenuStyle,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: GestureDetector(
                      onTapUp: (detail) => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => SearchStation())),
                      child: Card(
                        child: Container(
                          width: 180,
                          height: 200,
                          child: Center(
                            child: Text(
                              '역 검색',
                              style: homeMenuStyle,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: GestureDetector(
                  onTapUp: (detail) => Navigator.push(context,
                      MaterialPageRoute(builder: (context) => BookmarkPage())),
                  child: Card(
                    child: Container(
                      width: 380,
                      height: 120,
                      child: Center(
                        child: Text(
                          '즐겨찾기',
                          style: homeMenuStyle,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: GestureDetector(
                      onTapUp: (detail) => Navigator.push(context,
                          MaterialPageRoute(builder: (context) => MapPage())),
                      child: Card(
                        child: Container(
                          width: 180,
                          height: 80,
                          child: Center(
                            child: Text(
                              '신고',
                              style: homeMenuStyle,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: GestureDetector(
                      onTap: () => _displayDialog(context),
                      child: Card(
                        child: Container(
                          width: 180,
                          height: 80,
                          child: Center(
                            child: Text(
                              '닉네임 설정',
                              style: homeMenuStyle,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ));
  }
}

//TODO: 실시간 시간표, 없는 역 검색 시, 역 아닌 것 검색 시, 즐겨찾기, 검색 전적 ...
