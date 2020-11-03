import 'package:flutter/material.dart';
import 'package:filcnaplo/ui/card.dart';
import 'package:filcnaplo/data/models/lesson.dart';
import 'package:flutter/rendering.dart';
import 'package:filcnaplo/modules/now/current_lesson/tile.dart';
class CurrentLessonCard extends BaseCard {
  final Lesson currentLesson;
  CurrentLessonCard(this.currentLesson);
  @SemanticsHintOverrides()
  Widget build(BuildContext context) {
    return BaseCard(
        child: CurrentLessonTile(
            currentLesson.subject.name,
            currentLesson.description,
            currentLesson.room,
            -DateTime.now().difference(currentLesson.end).inMinutes),
            padding: EdgeInsets.all(0)
    );
  }
}
