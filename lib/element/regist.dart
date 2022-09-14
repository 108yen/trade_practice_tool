class Regist {
  final String symbol;
  final int exchange;

  Regist({
    required this.symbol,
    required this.exchange,
  });

  Regist.fromJson(Map<String, dynamic> json)
      : symbol = json['Symbol'],
        exchange = json['Exchange'];
}
