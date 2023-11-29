import 'package:flutter/material.dart';
import 'package:subway/functions.dart';
import 'package:subway/pages/station_info_page.dart';
import 'package:subway/style.dart';

class BookMarkPage extends StatefulWidget {
  const BookMarkPage({super.key});

  @override
  State<BookMarkPage> createState() => _BookMarkPageState();
}

class _BookMarkPageState extends State<BookMarkPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(150.0),
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
                      '즐겨찾기',
                      style: appBarTitleStyle,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          children: List.generate(
            bookMarkedList.length,
            (index) {
              List<Map<String, dynamic>> bookMarkList = bookMarkedList.toList();
              return ListTile(
                  leading: Icon(
                    Icons.subway_sharp,
                    color: lineColorMap[bookMarkList[index]['line']],
                    size: 35,
                  ),
                  title: Text(
                    '${bookMarkList[index]['station']}',
                    style:
                        TextStyle(fontSize: 20.0, fontWeight: FontWeight.w500),
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => StationInfoPage(
                          station: bookMarkList[index]['station'].toString(),
                          line: bookMarkList[index]['line'],
                        ),
                      ),
                    );
                  });
            },
          ),
        ),
      ),
    );
  }

  Widget _buildLineTile(int line) {
    return Card(
      color: Colors.white,
      child: ExpansionTile(
        leading: Icon(Icons.subway_sharp, color: lineColorMap[line]),
        title: Text(
          '${line}호선',
          style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w500),
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
