import 'package:flutter/material.dart';
import 'package:subway/functions.dart';
import 'package:subway/pages/station_info_page.dart';
import 'package:subway/style.dart';

class SearchStation extends StatefulWidget {
  const SearchStation({super.key});

  @override
  State<SearchStation> createState() => _SearchStationState();
}

class _SearchStationState extends State<SearchStation> {
  final SearchController _searchController = SearchController();
  String _selectedSt = '';

  //List stationsList = StationInfo.stationSet.toList();
  List bookmarkList = [101, 403, 202, 404];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(160.0),
        child: AppBar(
          elevation: 0,
          automaticallyImplyLeading: false,
          backgroundColor: primaryBlue,
          toolbarHeight: 150,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              bottom: Radius.circular(20),
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
                      '역 검색',
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
                      searchController: _searchController,
                      builder:
                          (BuildContext context, SearchController controller) {
                        return SearchBar(
                          shape: MaterialStateProperty.all(
                              const ContinuousRectangleBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(25),
                            ),
                          )),
                          onChanged: (input) {
                            _selectedSt = input;
                            _searchController.text = input;
                          },
                          hintText: _selectedSt,
                          trailing: [
                            IconButton(
                              icon: const Icon(Icons.search),
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => StationInfoPage(
                                              station: _selectedSt,
                                            )));
                              },
                            ),
                          ],
                          onTap: () {
                            print(_searchController.value.text);
                            _searchController.openView();
                          },
                        );
                      },
                      suggestionsBuilder: (BuildContext context,
                          SearchController deptController) {
                        final keyword = deptController.value.text;
                        _selectedSt = keyword;
                        return List.generate(
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
                                    _selectedSt = item.toString();
                                    deptController.closeView(item.toString());
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
        scrollDirection: Axis.vertical,
        child: Column(
          children: [
            ListView.builder(
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              physics: const BouncingScrollPhysics(),
              itemCount: 9,
              itemBuilder: (BuildContext context, int index) {
                return _buildLineTile(index + 1);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLineTile(int line) {
    return Card(
      color: Colors.white,
      child: ExpansionTile(
        leading: Icon(
          Icons.subway_sharp,
          color: lineColorMap[line],
          size: 35,
        ),
        title: Text(
          '${line}호선',
          style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.w500),
        ),
        children: List.generate(
          lineInfo[line].length,
          (index) => ListTile(
              title: Text(lineInfo[line][index].toString()),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => StationInfoPage(
                      station: lineInfo[line][index].toString(),
                      line: line,
                    ),
                  ),
                );
              }),
        ),
      ),
    );
  }
}
