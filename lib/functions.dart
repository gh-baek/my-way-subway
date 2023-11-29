import 'package:dijkstra/dijkstra.dart';
import 'package:excel/excel.dart';
import 'package:flutter/services.dart';

Map lineInfo = {
  1: [
    101,
    102,
    103,
    104,
    105,
    106,
    107,
    108,
    109,
    110,
    111,
    112,
    113,
    114,
    115,
    116,
    117,
    118,
    119,
    120,
    121,
    122,
    123
  ],
  2: [
    101,
    201,
    202,
    203,
    204,
    205,
    206,
    207,
    208,
    209,
    210,
    211,
    212,
    213,
    214,
    215,
    216,
    217
  ],
  3: [207, 301, 302, 303, 304, 123, 305, 306, 307, 308, 107],
  4: [
    104,
    401,
    307,
    402,
    403,
    404,
    405,
    406,
    407,
    115,
    408,
    409,
    410,
    411,
    412,
    413,
    414,
    415,
    416,
    417,
    216
  ],
  5: [209, 501, 502, 503, 504, 122, 505, 506, 403, 507, 109],
  6: [
    601,
    602,
    121,
    603,
    604,
    605,
    606,
    116,
    607,
    608,
    609,
    412,
    610,
    611,
    612,
    613,
    614,
    615,
    616,
    417,
    617,
    618,
    619,
    620,
    621,
    622
  ],
  7: [202, 303, 503, 601, 701, 702, 703, 704, 705, 706, 416, 707, 614],
  8: [113, 801, 802, 803, 409, 608, 804, 805, 806, 705, 618, 214],
  9: [112, 901, 406, 605, 902, 119, 903, 702, 904, 621, 211]
};

// 즐겨찾기 등록한 Station Set
// {'station': station num, 'line': line}
List<Map<String, dynamic>> bookMarkedList = [];

class StationInfo {
  static Set stationSet = Set(); // 전체 역 종류
  static List<List> pairList = []; // 역 간 그래프
  //static Map stationLine = {};
  static Graph timeGraph = Graph({}); // 역 간 소요 시간 그래프
  static Graph distGraph = Graph({}); // 역 간 거리 그래프
  static Graph costGraph = Graph({}); // 역 간 비용 그래프
  static List<Station> stationList = []; //Station List
  static Map<int, Station> stationMap = {}; //{역번호: Station} 각 역에 대한 Station Map
  static Map congestionMap = {
    1: {},
    2: {},
    3: {},
    4: {},
    5: {},
    6: {},
    7: {},
    8: {},
    9: {},
  };
}

//역(노드)로 구성된 그래프
class Graph {
  final Map<dynamic, Map> nodes;

  Graph(this.nodes);
}

//역 정보 클래스
class Station {
  int station;
  List<int> lines;
  Map prevStation; //{line1: prevSt of line1, line2: prevSt of line2}
  Map nextStation;

  Station(
      {required this.station,
      required this.prevStation,
      required this.nextStation,
      required this.lines});
}

void setStationList() {
  for (var st in StationInfo.stationSet) {
    List<int> lineList = [];

    //해당 역을 지나는 모든 노선 찾기
    for (var entry in lineInfo.entries) {
      if (entry.value.contains(st)) {
        lineList.add(entry.key);
      }
    }
    // prevStation과 nextStation 일단 -1로 설정 후 모든 역의 노선 정보가 정해진 후 할당 예정
    Station station =
        Station(station: st, prevStation: {}, nextStation: {}, lines: lineList);
    StationInfo.stationList.add(station);
  }

  //모든 역과 각 역의 각 노선에 대한 이전, 다음역 할당
  for (var i = 0; i < StationInfo.stationList.length; i++) {
    Station st = StationInfo.stationList[i];
    Map prevSt = {}; //{line1: prevSt of line1, line2: prevSt of line2}
    Map nextSt = {}; //{line1: nextSt of line1, line2: nextSt of line2}

    for (var pair in StationInfo.pairList) {
      if (pair.contains(st.station)) {
        for (var line in st.lines) {
          if (st.station == pair[0]) {
            if (lineInfo[line].contains(pair[1])) {
              nextSt[line] = pair[1];
            }
          } else {
            if (lineInfo[line].contains(pair[0])) {
              prevSt[line] = pair[0];
            }
          }
        }
      }
    }

    StationInfo.stationList[i].prevStation = prevSt;
    StationInfo.stationList[i].nextStation = nextSt;
    StationInfo.stationMap[st.station] = StationInfo.stationList[i];
  }
}

//역 정보 및 그래프를 받아오는 함수
//앱 실행 최초에만 실행하여 각 정보 전역 변수에 저장
void setStationInfo() async {
  ByteData data = await rootBundle.load("lib/data/stations.xlsx");
  List<int> bytes =
      data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
  var excel = Excel.decodeBytes(bytes);

  for (var table in excel.tables.keys) {
    // print(table); //sheet Name
    // print(excel.tables[table]?.maxCols);
    // print(excel.tables[table]?.maxRows);
    int maxRows = excel.tables[table]!.maxRows; //엑셀에 저장된 행(거리, 비용, 시간 역간 정보) 개수
    List stations = []; //(역1, 역2, 시간(초), 거리(미터), 비용(원))

    for (var i = 1; i < maxRows; i++) {
      Map data = {
        'st1': 0,
        'st2': 0,
        'time': 0,
        'dist': 0,
        'cost': 0,
      };
      data['st1'] = excel.tables[table]?.rows[i][0]!.value;
      data['st2'] = excel.tables[table]?.rows[i][1]!.value;
      data['time'] = excel.tables[table]?.rows[i][2]!.value;
      data['dist'] = excel.tables[table]?.rows[i][3]!.value;
      data['cost'] = excel.tables[table]?.rows[i][4]!.value;
      stations.add(data);
    }

    // 모든 역 입렵 -> set 형식이므로 중복은 제거
    StationInfo.stationSet = {};
    for (var i = 0; i < maxRows - 1; i++) {
      StationInfo.stationSet.add(stations[i]['st1']);
      StationInfo.stationSet.add(stations[i]['st2']);
    }

    // 역 간 연결 정보를 저장
    StationInfo.pairList = [];
    for (var i = 0; i < maxRows - 1; i++) {
      StationInfo.pairList.add([stations[i]['st1'], stations[i]['st2']]);
    }
    Map<dynamic, Map> timeNodes = {};
    Map<dynamic, Map> distNodes = {};
    Map<dynamic, Map> costNodes = {};

    //역 간 소요 시간에 대한 timeGraph 생성 for문
    for (var st in StationInfo.stationSet) {
      Map data = {};
      for (var i = 0; i < maxRows - 1; i++) {
        if (stations[i]['st1'] == st) {
          data[stations[i]['st2']] = stations[i]['time'];
        } else if (stations[i]['st2'] == st) {
          data[stations[i]['st1']] = stations[i]['time'];
        }
      }
      timeNodes[st] = data;
    }
    StationInfo.timeGraph = Graph(timeNodes);
    //print(timeGraph.nodes);

    //역 간 거리에 대한 distGraph 생성 for문
    for (var st in StationInfo.stationSet) {
      Map data = {};
      for (var i = 0; i < maxRows - 1; i++) {
        if (stations[i]['st1'] == st) {
          data[stations[i]['st2']] = stations[i]['dist'];
        } else if (stations[i]['st2'] == st) {
          data[stations[i]['st1']] = stations[i]['dist'];
        }
      }
      distNodes[st] = data;
    }
    StationInfo.distGraph = Graph(distNodes);

    //역 간 비용에 대한 costGraph 생성 for문
    for (var st in StationInfo.stationSet) {
      Map data = {};
      for (var i = 0; i < maxRows - 1; i++) {
        if (stations[i]['st1'] == st) {
          data[stations[i]['st2']] = stations[i]['cost'];
        } else if (stations[i]['st2'] == st) {
          data[stations[i]['st1']] = stations[i]['cost'];
        }
      }
      costNodes[st] = data;
    }
    StationInfo.costGraph = Graph(costNodes);
  }

  setStationList();
  setCongestionInfo();
}

void setCongestionInfo() async {
  ByteData data = await rootBundle.load("lib/data/congestion.xlsx");
  List<int> bytes =
      data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
  var excel = Excel.decodeBytes(bytes);

  for (var table in excel.tables.keys) {
    // print(table); //sheet Name
    // print(excel.tables[table]?.maxCols);
    // print(excel.tables[table]?.maxRows);

    int maxRows = excel.tables[table]!.maxRows; //엑셀에 저장된 행(거리, 비용, 시간 역간 정보) 개수
    int maxCols =
        excel.tables[table]!.maxColumns; //엑셀에 저장된 행(거리, 비용, 시간 역간 정보) 개수
    int line = 0;

    for (var i = 1; i < maxRows; i++) {
      line = excel.tables[table]?.rows[i][0]!.value;

      List congestions = [];
      int station = excel.tables[table]?.rows[i][1]!.value;

      for (var j = 2; j < maxCols; j++) {
        congestions.add(excel.tables[table]?.rows[i][j]!.value.toDouble());
      }
      StationInfo.congestionMap[line][station] = congestions;
    }
  }
}

// 길 찾기 함수: 파라미터는 departure(출발역)와 arrival(도착역)
Map<String, List> findBestWay({required int departure, required int arrival}) {
  //var output = Dijkstra.findPathFromPairsList(stationInfo.pairList, departure, arrival);
  var timeOutput = Dijkstra.findPathFromGraph(
      StationInfo.timeGraph.nodes, departure, arrival);
  var distOutput = Dijkstra.findPathFromGraph(
      StationInfo.distGraph.nodes, departure, arrival);
  var costOutput = Dijkstra.findPathFromGraph(
      StationInfo.costGraph.nodes, departure, arrival);

  // print("best time output:");
  // print(timeOutput);
  // print("best distance output:");
  // print(distOutput);
  // print("best cost output:");
  // print(costOutput);

  return {'time': timeOutput, 'dist': distOutput, 'cost': costOutput};
}

//BFS 알고리즘 적용한 최소 환승 길찾기 함수
