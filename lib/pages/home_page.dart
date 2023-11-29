import 'package:flutter/material.dart';
import 'package:subway/functions.dart';
import 'package:subway/pages/map_page.dart';
import 'package:subway/pages/result_page.dart';
import 'package:subway/pages/search_station_page.dart';
import 'package:subway/style.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final SearchController _departureSearchController = SearchController();
  final SearchController _arrivalSearchController = SearchController();

  String _selectedDept = '';
  String _selectedArr = '';

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
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
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
                    MaterialPageRoute(builder: (context) => MapPage())),
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
          ],
        ));
  }
}

//TODO: 없는 역 검색 시, 역 아닌 것 검색 시, ...
