import 'package:flutter/material.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:subway/functions.dart';
import 'package:subway/pages/bookmark_page.dart';
import 'package:subway/pages/map_page.dart';
import 'package:subway/pages/result_page.dart';
import 'package:subway/pages/search_station_page.dart';
import 'package:subway/style.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final SearchController _departureSearchController = SearchController();
  final SearchController _arrivalSearchController = SearchController();

  //검색하기 위해 선택한 출발역과 도착역
  String _selectedDept = '';
  String _selectedArr = '';

  @override
  void initState() {
    //홈화면 시작 전 역 관련 정보 로드
    //TODO: shared_preference로 저장한 데이터 확인 후 로드
    setStationInfo();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    DateTime dt = DateTime.now();
    print(dt.hour);
    String timeText = '';
    if (dt.hour >= 5 && dt.hour < 12) {
      timeText = "좋은 아침 입니다";
    } else if (dt.hour >= 12 && dt.hour < 18) {
      timeText = "활기찬 오후 입니다";
    } else if (dt.hour >= 18 && dt.hour < 22) {
      timeText = "즐거운 저녁 입니다";
    } else {
      timeText = "좋은 밤 되세요";
    }
    return GestureDetector(
      onTap: () {
        FocusNode currentFocus = FocusScope.of(context);
        if (!currentFocus.hasPrimaryFocus) {
          currentFocus.unfocus();
        }
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(300.0),
          child: AppBar(
            backgroundColor: primaryBlue,
            toolbarHeight: 300,
            shape: const RoundedRectangleBorder(
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
                const SizedBox(
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
                                  setState(() {
                                    String temp = _selectedDept;
                                    _selectedDept = _selectedArr;
                                    _selectedArr = temp;
                                    _departureSearchController.text =
                                        _selectedDept;
                                    _arrivalSearchController.text =
                                        _selectedArr;
                                  });
                                },
                              ),
                            ],
                            onTap: () {
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
                                      recentSearchList.length,
                                      (index) =>
                                          recentSearchList.toList()[index])
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
                                  if (StationInfo.stationSet
                                          .contains(_selectedDept) &&
                                      StationInfo.stationSet
                                          .contains(_selectedDept)) {
                                    if (recentSearchList.length >= 10) {
                                      recentSearchList.removeFirst();
                                      recentSearchList.removeFirst();
                                    }
                                    recentSearchList.add(_selectedDept);
                                    recentSearchList.add(_selectedArr);
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => ResultPage(
                                                  departure: _selectedDept,
                                                  arrival: _selectedArr,
                                                )));
                                  } else {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      //없는 역, 역이 아닌 것을 검색 시 오류 메세지 출력
                                      SnackBar(
                                        backgroundColor: Colors.redAccent,
                                        content: const Text(
                                          '해당 역이 존재하지 않습니다.',
                                        ),
                                        duration: const Duration(seconds: 3),
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
                                      recentSearchList.length,
                                      (index) =>
                                          recentSearchList.toList()[index])
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
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(40.0),
              child: Container(
                alignment: Alignment.centerLeft,
                child: Text(
                  timeText,
                  style: const TextStyle(
                      fontSize: 24.0, fontWeight: FontWeight.w600),
                ),
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: GestureDetector(
                        onTapUp: (detail) => Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const MapPage())),
                        child: Card(
                          clipBehavior: Clip.antiAlias,
                          child: SizedBox(
                            width: 180,
                            height: 200,
                            child: Center(
                              child: Stack(
                                children: [
                                  const Image(
                                      image: AssetImage(
                                          'lib/assets/images/subwayline.png')),
                                  Center(
                                    child: Text(
                                      '지하철 노선도',
                                      style: homeMenuStyle,
                                    ),
                                  ),
                                ],
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
                                builder: (context) => const SearchStation())),
                        child: Card(
                          child: SizedBox(
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
                    onTapUp: (detail) => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const BookMarkPage())),
                    child: Card(
                      child: SizedBox(
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
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.redAccent,
          onPressed: () async {
            const number = '00000'; //set the number here
            await FlutterPhoneDirectCaller.callNumber(number);
          },
          child: Icon(
            Icons.phone,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}

//TODO: 실시간 시간표, 키보드 포커스, 최소 환승
//TODO: SharedPreference->즐겨찾기, 검색기록, 타임테이블, 신고
