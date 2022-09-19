/// Candle model wich holds a single candle data.
/// It contains five required double variables that hold a single candle data: high, low, open, close and volume.
/// It can be instantiated using its default constructor or fromJson named custructor.
class Candle {
  /// DateTime for the candle
  final DateTime date;

  /// The highet price during this candle lifetime
  /// It if always more than low, open and close
  final double high;

  /// The lowest price during this candle lifetime
  /// It if always less than high, open and close
  final double low;

  /// Price at the beginnig of the period
  final double open;

  /// Price at the end of the period
  final double close;

  /// Volume is the number of shares of a
  /// security traded during a given period of time.
  final double volume;

  bool get isBull => open <= close;

  Candle({
    required this.date,
    required this.high,
    required this.low,
    required this.open,
    required this.close,
    required this.volume,
  });

  Candle.fromJson(Map<String, dynamic> json)
      : date = DateTime.parse(json['date']),
        high = json['high'].toDouble(),
        low = json['low'].toDouble(),
        open = json['open'].toDouble(),
        close = json['close'].toDouble(),
        volume = json['volume'].toDouble();

  Map<String, dynamic> toJson() => {
        'date': '${date}',
        'high': high,
        'low': low,
        'open': open,
        'close': close,
        'volume': volume,
      };
}
