import 'package:flutter_test/flutter_test.dart';
import 'package:subway/functions.dart';
import 'package:subway/main.dart';

void main() {
  testWidgets('station function test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MyApp());
    getStationInfo();
    findBestWay(departure: 123, arrival: 503);
  });
}
