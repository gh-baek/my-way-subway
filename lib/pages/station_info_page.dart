import 'package:flutter/material.dart';

class StationInfoPage extends StatefulWidget {
  final String station;

  const StationInfoPage({super.key, required this.station});

  @override
  State<StationInfoPage> createState() => _StationInfoPageState();
}

class _StationInfoPageState extends State<StationInfoPage> {
  MaterialColor _barColor = Colors.green;

  @override
  void initState() {
    // TODO: implement initState

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: _barColor,
        title: Text('역 정보'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            height: 100,
            decoration: BoxDecoration(
              color: _barColor,
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(50),
                bottomRight: Radius.circular(50),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text('prev'),
                Text(widget.station),
                Text('next'),
              ],
            ),
          ),
          Container(
            color: Colors.white,
            child: const IntrinsicHeight(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      children: [
                        Text('이번 열차'),
                        Text('3분 45초'),
                        Text('다음 열차'),
                        Text('3분 45초'),
                      ],
                    ),
                  ),
                  VerticalDivider(
                    width: 20,
                    thickness: 2,
                    indent: 10,
                    endIndent: 10,
                    color: Colors.grey,
                  ),
                  Expanded(
                    child: Column(
                      children: [
                        Text('이번 열차'),
                        Text('3분 45초'),
                        Text('다음 열차'),
                        Text('3분 45초'),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: OutlinedButton(
                    onPressed: () {},
                    child: Text('지하철 노선도'),
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: OutlinedButton(
                    onPressed: () {},
                    child: Text('즐겨찾기'),
                  ),
                ),
              ),
            ],
          ),
          Divider(),
          Container(
            child: Column(
              children: [
                Text('역 내 혼잡도'),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
