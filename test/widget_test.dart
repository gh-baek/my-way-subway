import 'package:flutter_test/flutter_test.dart';
import 'package:subway/functions.dart';

void main() {
  testWidgets('station function test', (WidgetTester tester) async {
    setStationInfo();
    Station st = StationInfo.stationList[0];
    print(st.station);
    print(st.lines);
    print(st.prevStation);
    print(st.nextStation);
  });
}
