import 'dart:collection';

import 'package:flutter_test/flutter_test.dart';
import 'package:subway/functions.dart';

void main() {
  testWidgets('station function test', (WidgetTester tester) async {
    setStationInfo();
    List getDirectRoute({required int start, required int destination}) {
      int current = start;
      int sameLine = 0;
      for (var i = 0; i < lineInfo.length; i++) {
        List stList = lineInfo[i + 1]!;
        if (stList.contains(start) && stList.contains(destination)) {
          sameLine = i + 1;
          print('same line $sameLine');
          break;
        }
      }
      List prevRoute = [start];
      List nextRoute = [start];
      while (current != destination) {
        if (StationInfo.stationMap[current]!.nextStation[sameLine] != null) {
          current = StationInfo.stationMap[current]!.nextStation[sameLine];
          nextRoute.add(current);
        } else {
          nextRoute = [];
          break;
        }
      }
      print(nextRoute);

      current = start;
      while (current != destination) {
        if (StationInfo.stationMap[current]!.prevStation[sameLine] != null) {
          current = StationInfo.stationMap[current]!.prevStation[sameLine];
          prevRoute.add(current);
        } else {
          prevRoute = [];
          break;
        }
      }
      print(prevRoute);

      List shortest = [];
      if (nextRoute.length != 0 && prevRoute.length != 0) {
        prevRoute.length >= nextRoute.length
            ? shortest = nextRoute
            : shortest = prevRoute;
        return shortest;
      } else if (prevRoute.length == 0) {
        return nextRoute;
      } else {
        return prevRoute;
      }
    }

    List findMinimumTransferPath(int start, int destination) {
      Map<int, int> visited =
          {}; // Key: station number, Value: minimum transfers required to reach the station
      Map<int, List<int>> path = {
        start: [start]
      }; // Key: station number, Value: path to reach the station

      Queue<int> queue = Queue();
      queue.add(start);
      visited[start] = 0;

      while (queue.isNotEmpty) {
        var currentStation = queue.removeFirst();
        var currentTransfers = visited[currentStation]!;

        if (currentStation == destination) {
          break;
        }

        for (var line in StationInfo.stationMap[currentStation]!.lines ?? []) {
          for (var nextStation in lineInfo[line] ?? []) {
            if (!visited.containsKey(nextStation)) {
              visited[nextStation] = currentTransfers +
                  (line != StationInfo.stationMap[currentStation]!.lines.first
                      ? 1
                      : 0);
              path[nextStation] = List.from(path[currentStation]!)
                ..add(nextStation);

              queue.add(nextStation);
            }
          }
        }
      }
      print(path);
      if (path.containsKey(destination)) {
        List resultPath = [];
        for (var i = 0; i < path[destination]!.length - 1; i++) {
          if (path[destination]![i] != start ||
              path[destination]![i] != destination) {
            var result = getDirectRoute(
                start: path[destination]![i],
                destination: path[destination]![i + 1]);
            resultPath.add(result);
          }
        }
        List minPath = [];
        for (var i = 0; i < resultPath.length; i++) {
          for (var j = 0; j < resultPath[i].length; j++) {
            if (!minPath.contains(resultPath[i][j])) {
              minPath.add(resultPath[i][j]);
            }
          }
        }
        return minPath;
      }

      return [];
    }

    int startStation = 101; // Replace with your start station number
    int destinationStation =
        306; // Replace with your destination station number

    List minimumTransferPath =
        findMinimumTransferPath(startStation, destinationStation);
    if (minimumTransferPath.isEmpty) {
      print('No path found.');
    } else {
      print('Minimum transfer path: $minimumTransferPath');
    }
  });
}
