import 'package:filcnaplo/data/context/app.dart';
import 'package:filcnaplo/data/models/test.dart';
import 'package:filcnaplo/ui/pages/planner/tests/tile.dart';

class TestBuilder {
  List<List<TestTile>> testTiles = [[], []];

  void build() {
    testTiles = [[], []];

    List<Test> tests = app.user.sync.test.data;

    tests.sort((a, b) => -a.date.compareTo(b.date));

    testTiles[0] = tests
        .where((t) => t.date.isAfter(DateTime.now()))
        .map((t) => TestTile(t, false))
        .toList();

    testTiles[1] = tests
        .where((t) => t.date.isBefore(DateTime.now()))
        .map((t) => TestTile(t, true))
        .toList();
  }
}
