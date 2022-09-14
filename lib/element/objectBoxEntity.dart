import 'package:objectbox/objectbox.dart';

@Entity()
class BordBox {
  int id;

  int code;
  String date;
  List<String> bordList;

  BordBox({
    this.id = 0,
    required this.code,
    required this.date,
    required this.bordList,
  });
}

@Entity()
class FiveminTickBox {
  int id;

  int code;
  String date;
  List<String> fiveminTickList;

  FiveminTickBox({
    this.id = 0,
    required this.code,
    required this.date,
    required this.fiveminTickList,
  });
}
