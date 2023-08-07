import 'package:isar/isar.dart';

@Collection()
class DataModelError {
  int? id;
  Map<String, dynamic>? dataMap;

  DataModelError({this.id, this.dataMap});
}