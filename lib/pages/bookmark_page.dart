import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:subway/functions.dart';
import 'package:subway/pages/station_info_page.dart';
import 'package:subway/style.dart';

class BookMarkPage extends StatefulWidget {
  const BookMarkPage({super.key});

  @override
  State<BookMarkPage> createState() => _BookMarkPageState();
}

class _BookMarkPageState extends State<BookMarkPage> {
  late SharedPreferences prefs;

  Future<String> _setInit() async {
    prefs = await SharedPreferences.getInstance();
    print(bookMarkList);

    return prefs.toString();
  }

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
          shape: const RoundedRectangleBorder(
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
                      icon: const Icon(Icons.arrow_back, color: Colors.white),
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
      body: FutureBuilder(
        future: _setInit(),
        builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
          if (snapshot.hasData) {
            return SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Column(
                children: List.generate(
                  bookMarkList.length,
                  (index) {
                    List bookmarks = bookMarkList.toList();
                    return ListTile(
                        leading: Icon(
                          Icons.subway_sharp,
                          color: lineColorMap[bookmarks[index]['line']],
                          size: 35,
                        ),
                        title: Text(
                          '${bookmarks[index]['station']}',
                          style: const TextStyle(
                              fontSize: 20.0, fontWeight: FontWeight.w500),
                        ),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => StationInfoPage(
                                station: bookmarks[index]['station'].toString(),
                                line: bookmarks[index]['line'],
                              ),
                            ),
                          ).then((value) => setState(() {}));
                        });
                  },
                ),
              ),
            );
          } else {
            return const CircularProgressIndicator();
          }
        },
      ),
    );
  }
}
