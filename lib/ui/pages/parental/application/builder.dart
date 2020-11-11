import 'package:filcnaplo/data/context/app.dart';
import 'package:filcnaplo/data/models/application.dart';
import 'package:filcnaplo/ui/pages/parental/application/tile.dart';

class ApplicationBuilder {
  List<ApplicationTile> applicationTiles = [];

  void build() {
    List<Application> applications = app.user.sync.application.data;

    applications.sort((a, b) => -a.sendDate.compareTo(b.sendDate));

    applicationTiles = applications.map((t) => ApplicationTile(t)).toList();
  }
}
