import 'package:flutter/material.dart';
import 'package:subway/functions.dart';
import 'package:subway/pages/map_page.dart';
import 'package:subway/pages/result_page.dart';
import 'package:subway/pages/stations_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final SearchController _departureSearchController = SearchController();
  final SearchController _arrivalSearchController = SearchController();

  String selectedDept = '';
  String selectedArr = '';

  // these will be reused later
  final leading = const Icon(Icons.search);

  final searchbutton = [
    IconButton(
      icon: const Icon(Icons.search),
      onPressed: () {},
    ),
  ];
  List recentSearch = ['101', '102', '104', '121', '124'];

  @override
  void initState() {
    getStationInfo();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    BorderRadiusGeometry radius = const BorderRadius.only(
      topLeft: Radius.circular(24.0),
      topRight: Radius.circular(24.0),
    );
    return Scaffold(
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(150.0),
          child: AppBar(
            backgroundColor: Colors.deepPurple,
            toolbarHeight: 150,
            title: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SearchAnchor(
                    isFullScreen: false,
                    searchController: _departureSearchController,
                    builder:
                        (BuildContext context, SearchController controller) {
                      return SearchBar(
                        onChanged: (input) {
                          selectedDept = input;
                          _departureSearchController.text = input;
                        },
                        hintText: selectedDept,
                        trailing: [
                          IconButton(
                            icon: const Icon(Icons.compare_arrows_sharp),
                            onPressed: () {
                              String temp = selectedDept;
                              selectedDept = selectedArr;
                              selectedArr = temp;
                              _departureSearchController.text = selectedDept;
                              _arrivalSearchController.text = selectedArr;
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
                      selectedDept = keyword;
                      return keyword.toString() != ''
                          ? List.generate(
                                  StationInfo.stationSet.toList().length,
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
                                      selectedDept = item.toString();
                                      deptController.closeView(item.toString());
                                      FocusScope.of(context).unfocus();
                                    });
                                  },
                                ),
                              )
                          : List.generate(5, (index) => recentSearch[index])
                              .where((element) => element
                                  .toLowerCase()
                                  .startsWith(keyword.toLowerCase()))
                              .map(
                                (item) => ListTile(
                                  title: Text(item.toString()),
                                  onTap: () {
                                    setState(() {
                                      selectedDept = item.toString();
                                      deptController.closeView(item);
                                      FocusScope.of(context).unfocus();
                                    });
                                  },
                                ),
                              );
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SearchAnchor(
                    isFullScreen: false,
                    searchController: _arrivalSearchController,
                    builder:
                        (BuildContext context, SearchController controller) {
                      return SearchBar(
                        onChanged: (input) {
                          selectedArr = input;
                          _arrivalSearchController.text = input;
                        },
                        hintText: selectedArr,
                        trailing: [
                          IconButton(
                            icon: const Icon(Icons.search),
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => ResultPage(
                                            departure: selectedDept,
                                            arrival: selectedArr,
                                          )));
                            },
                          ),
                        ],
                        onTap: () {
                          _arrivalSearchController.openView();
                        },
                      );
                    },
                    suggestionsBuilder:
                        (BuildContext context, SearchController arrController) {
                      final keyword = arrController.value.text;
                      selectedArr = keyword;
                      return keyword.toString() != ''
                          ? List.generate(
                                  StationInfo.stationSet.toList().length,
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
                                      selectedArr = item.toString();
                                      arrController.closeView(item.toString());
                                      FocusScope.of(context).unfocus();
                                    });
                                  },
                                ),
                              )
                          : List.generate(5, (index) => recentSearch[index])
                              .where((element) => element
                                  .toString()
                                  .toLowerCase()
                                  .startsWith(keyword.toLowerCase()))
                              .map(
                                (item) => ListTile(
                                  title: Text(item.toString()),
                                  onTap: () {
                                    setState(() {
                                      selectedArr = item.toString();
                                      arrController.closeView(item);
                                      FocusScope.of(context).unfocus();
                                    });
                                  },
                                ),
                              );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GestureDetector(
              onTapUp: (detail) => Navigator.push(
                  context, MaterialPageRoute(builder: (context) => MapPage())),
              child: Card(
                child: Container(
                  width: 200,
                  height: 100,
                  child: Text('노선도'),
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Card(
                  child: Container(
                    width: 100,
                    height: 100,
                    child: Text('즐겨찾기'),
                  ),
                ),
                GestureDetector(
                  onTapUp: (detail) => Navigator.push(context,
                      MaterialPageRoute(builder: (context) => StationsPage())),
                  child: Card(
                    child: Container(
                      width: 100,
                      height: 100,
                      child: Text('역 정보'),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ));
  }
}
