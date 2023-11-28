import 'package:flutter/material.dart';
import 'package:subway/functions.dart';
import 'package:subway/pages/station_info_page.dart';

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
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(100.0),
        child: AppBar(
          backgroundColor: Colors.deepPurple,
          toolbarHeight: 100,
          title: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: SearchAnchor(
                  isFullScreen: false,
                  searchController: _searchController,
                  builder: (BuildContext context, SearchController controller) {
                    return SearchBar(
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
                  suggestionsBuilder:
                      (BuildContext context, SearchController controller) {
                    final keyword = controller.value.text;
                    _selectedSt = keyword;
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
                                    _selectedSt = item.toString();
                                    controller.closeView(item.toString());
                                    FocusScope.of(context).unfocus();
                                  });
                                },
                              ),
                            )
                        : List.generate(5, (index) => _selectedSt[index])
                            .where((element) => element
                                .toLowerCase()
                                .startsWith(keyword.toLowerCase()))
                            .map(
                              (item) => ListTile(
                                title: Text(item.toString()),
                                onTap: () {
                                  setState(() {
                                    _selectedSt = item.toString();
                                    controller.closeView(item);
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
        children: [
          Expanded(
            child: ListView(
              children: List.generate(
                bookmarkList.length,
                (index) => ListTile(
                    title: Text(bookmarkList[index].toString()),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => StationInfoPage(
                            station: bookmarkList[index].toString(),
                          ),
                        ),
                      );
                    }),
              ),
            ),
          )
        ],
      ),
    );
  }
}
