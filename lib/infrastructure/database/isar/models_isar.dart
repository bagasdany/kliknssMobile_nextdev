import 'package:isar/isar.dart';

@collection
class Error {
  Id id = Isar.autoIncrement; // you can also use id = null to auto increment

  @Index(type: IndexType.value)
  String? title;

  List<Errors>? error;

  @enumerated
  Status status = Status.pending;
}

@embedded
class Errors {
  String? function;
  Map? params;
  String? endpoint;
}

enum Status {
  draft,
  pending,
  sent,
}