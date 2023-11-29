import 'dart:collection';

import 'package:flutter_test/flutter_test.dart';
import 'package:subway/functions.dart';

void main() {
  testWidgets('station function test', (WidgetTester tester) async {
    setStationInfo();
    // Station st = StationInfo.stationList[0];
    // print(st.station);
    // print(st.lines);
    // print(st.prevStation);
    // print(st.nextStation);
    List<int> findMinimumTransferRouteBFS(int start, int destination) {
      Queue<List<int>> queue = Queue();
      Map<int, List<int>> visited = {};
      Map<int, int> transferCounts = {};
      List<List<int>> shortestPaths = [];

      queue.add([start]);
      transferCounts[start] = 0;

      while (queue.isNotEmpty) {
        var currentPath = queue.removeFirst();
        var currentStation = currentPath.last;

        if (currentStation == destination) {
          shortestPaths.add(currentPath);
          continue;
        }

        for (var line in StationInfo.stationMap[currentStation]!.lines) {
          var next = StationInfo.stationMap[currentStation]!.nextStation[line];
          if (next != null && !visited.containsKey(next)) {
            List<int> newPath = List.from(currentPath);
            newPath.add(next);

            if (StationInfo.stationMap[next]!.lines.contains(line)) {
              transferCounts[next] = transferCounts[currentStation]!;
            } else {
              transferCounts[next] = transferCounts[currentStation]! + 1;
            }

            queue.add(newPath);
            visited[next] = newPath;
          }
        }

        for (var line in StationInfo.stationMap[currentStation]!.lines) {
          var prev = StationInfo.stationMap[currentStation]!.prevStation[line];
          if (prev != null && !visited.containsKey(prev)) {
            List<int> newPath = List.from(currentPath);
            newPath.add(prev);

            if (StationInfo.stationMap[prev]!.lines.contains(line)) {
              transferCounts[prev] = transferCounts[currentStation]!;
            } else {
              transferCounts[prev] = transferCounts[currentStation]! + 1;
            }

            queue.add(newPath);
            visited[prev] = newPath;
          }
        }
      }

      if (shortestPaths.isNotEmpty) {
        int minTransfers = transferCounts[shortestPaths.first.last]!;
        for (var path in shortestPaths) {
          if (transferCounts[path.last]! < minTransfers) {
            minTransfers = transferCounts[path.last]!;
          }
        }

        shortestPaths
            .retainWhere((path) => transferCounts[path.last] == minTransfers);
        shortestPaths.sort((a, b) => a.length.compareTo(b.length));

        return shortestPaths.first;
      }

      return []; // 목적지까지 경로를 찾을 수 없는 경우 빈 리스트 반환
    }

    int startStation = 103;
    int destinationStation = 306;

    List minimumTransferRoute =
        findMinimumTransferRouteBFS(startStation, destinationStation);

    if (minimumTransferRoute.isEmpty) {
      print('경로를 찾을 수 없습니다.');
    } else {
      print('최소 환승 루트: $minimumTransferRoute');
    }
  });
}
