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

@Entity()
class SymbolInfoListBox {
  int id;

  DateTime timestamp;
  List<String> symbolInfoList;

  SymbolInfoListBox({
    this.id = 0,
    required this.timestamp,
    required this.symbolInfoList,
  });
}

@Entity()
class MessageTestBox {
  @Id(assignable: true)
  int id;

  List<String> messageList;

  MessageTestBox({
    this.id = 0,
    required this.messageList,
  });
}
