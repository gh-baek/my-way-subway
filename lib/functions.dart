import 'package:dijkstra/dijkstra.dart';
import 'package:excel/excel.dart';
import 'package:flutter/services.dart';

class StationInfo {
  static late Set stationSet = Set(); // 전체 역 종류
  static late List<List> pairList = []; // 역 간 그래프
  static late Graph timeGraph = Graph({}); // 역 간 소요 시간 그래프
  static late Graph distGraph = Graph({}); // 역 간 거리 그래프
  static late Graph costGraph = Graph({}); // 역 간 비용 그래프
}

//역(노드)로 구성된 그래프
class Graph {
  final Map<dynamic, Map> nodes;

  Graph(this.nodes);
}

//역 정보 및 그래프를 받아오는 함수
//앱 실행 최초에만 실행하여 각 정보 전역 변수에 저장
void getStationInfo() async {
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
    // print(costGraph.nodes);
  }
}

// 길 찾기 함수: 파라미터는 departure(출발역)와 arrival(도착역)
Map findBestWay({required int departure, required int arrival}) {
  //var output = Dijkstra.findPathFromPairsList(stationInfo.pairList, departure, arrival);
  var timeOutput = Dijkstra.findPathFromGraph(
      StationInfo.timeGraph.nodes, departure, arrival);
  var distOutput = Dijkstra.findPathFromGraph(
      StationInfo.distGraph.nodes, departure, arrival);
  var costOutput = Dijkstra.findPathFromGraph(
      StationInfo.costGraph.nodes, departure, arrival);

  print("best time output:");
  print(timeOutput);
  print("best distance output:");
  print(distOutput);
  print("best cost output:");
  print(costOutput);

  return {'time': timeOutput, 'dist': distOutput, 'cost': costOutput};
}
