import 'package:filcnaplo/ui/pages/absences/absence/tile.dart';
import 'package:filcnaplo/data/context/app.dart';
import 'package:filcnaplo/data/models/absence.dart';

class AbsenceBuilder {
  List<AbsenceTile> absenceTiles = [];

  void build() {
    absenceTiles = [];
    List<Absence> absences = app.user.sync.absence.data
        .where((absence) => absence.type.name == "hianyzas")
        .toList();

    absences.sort(
      (a, b) => -a.date.compareTo(b.date),
    );

    absences.forEach((absence) => absenceTiles.add(AbsenceTile(absence)));
  }
}

// Absence States
// Igazolatlan red x
// Igazolt     green tick
// Igazolando  yellow clock