

import 'package:hive/hive.dart';

@HiveType(typeId: 0)
class NotesModel extends HiveObject{

  @HiveField(0)// keys for hive
  String title;

  @HiveField(1)
  String description;
  NotesModel({required this.title,required this.description});

}