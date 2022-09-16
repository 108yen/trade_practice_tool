class Bord {
  // タイムスタンプ
  final DateTime timeStamp;
  // 銘柄コード
  final String symbol;
  // 銘柄名
  final String symbolName;
  // 市場コード
  final int exchange;
  // 市場名称
  final String exchangeName;
  // 現値
  final double currentPrice;
  // 現値時刻
  final String currentPriceTime;
  // 現値前値比較
  final String currentPriceChangeStatus;
  // 現値ステータス
  final int currentPriceStatus;
  // 計算用現値
  final double calcPrice;
  // 前日終値
  final double previousClose;
  // 前日終値日付
  final String previousCloseTime;
  // 前日比
  final double changePreviousClose;
  // 暴落率
  final double changePreviousClosePer;
  // 始値
  final double openingPrice;
  // 始値時刻
  final String openingPriceTime;
  // 高値
  final double highPrice;
  // 高値時刻
  final String highPriceTime;
  // 安値
  final double lowPrice;
  // 安値時刻
  final String lowPriceTime;
  // 売買高
  final int tradingVolume;
  // 売買高時刻
  final String tradingVolumeTime;
  // VWAP
  final double vwap;
  // 売買代金
  final int tradingValue;
  // 最良売気配数量
  final int bidQty;
  // 最良売気配値段
  final double bidPrice;
  // 最良売気配時刻
  final String bidTime;
  // 最良売気配フラグ
  final String bidSign;
  // 売成行数量
  final int marketOrderSellQty;
  // 売気配数量1本目
  final Qty1 sell1;
  // 売気配数量2本目
  final Qty sell2;
  // 売気配数量3本目
  final Qty sell3;
  // 売気配数量4本目
  final Qty sell4;
  // 売気配数量5本目
  final Qty sell5;
  // 売気配数量6本目
  final Qty sell6;
  // 売気配数量7本目
  final Qty sell7;
  // 売気配数量8本目
  final Qty sell8;
  // 売気配数量9本目
  final Qty sell9;
  // 売気配数量10本目
  final Qty sell10;
  // 最良買気配数量
  final int askQty;
  // 最良買気配値段
  final double askPrice;
  // 最良買気配時刻
  final String askTime;
  // 最良買気配フラグ
  final String askSign;
  // 買成行数量
  final int marketOrderBuyQty;
  // 買気配数量1本目
  final Qty1 buy1;
  // 買気配数量2本目
  final Qty buy2;
  // 買気配数量3本目
  final Qty buy3;
  // 買気配数量4本目
  final Qty buy4;
  // 買気配数量5本目
  final Qty buy5;
  // 買気配数量6本目
  final Qty buy6;
  // 買気配数量7本目
  final Qty buy7;
  // 買気配数量8本目
  final Qty buy8;
  // 買気配数量9本目
  final Qty buy9;
  // 買気配数量10本目
  final Qty buy10;
  // OVER気配数量
  final int overSellQty;
  // UNDER気配数量
  final int underBuyQty;
  // 時価総額
  final double totalMarketValue;
  // 	銘柄種別
  final int securityType;

  Bord({
    timeStamp,
    required this.symbol,
    required this.symbolName,
    required this.exchange,
    required this.exchangeName,
    required this.currentPrice,
    required this.currentPriceTime,
    required this.currentPriceChangeStatus,
    required this.currentPriceStatus,
    required this.calcPrice,
    required this.previousClose,
    required this.previousCloseTime,
    required this.changePreviousClose,
    required this.changePreviousClosePer,
    required this.openingPrice,
    required this.openingPriceTime,
    required this.highPrice,
    required this.highPriceTime,
    required this.lowPrice,
    required this.lowPriceTime,
    required this.tradingVolume,
    required this.tradingVolumeTime,
    required this.vwap,
    required this.tradingValue,
    required this.bidQty,
    required this.bidPrice,
    required this.bidTime,
    required this.bidSign,
    required this.marketOrderSellQty,
    required this.sell1,
    required this.sell2,
    required this.sell3,
    required this.sell4,
    required this.sell5,
    required this.sell6,
    required this.sell7,
    required this.sell8,
    required this.sell9,
    required this.sell10,
    required this.askQty,
    required this.askPrice,
    required this.askTime,
    required this.askSign,
    required this.marketOrderBuyQty,
    required this.buy1,
    required this.buy2,
    required this.buy3,
    required this.buy4,
    required this.buy5,
    required this.buy6,
    required this.buy7,
    required this.buy8,
    required this.buy9,
    required this.buy10,
    required this.overSellQty,
    required this.underBuyQty,
    required this.totalMarketValue,
    required this.securityType,
  }) : this.timeStamp = (timeStamp != null ? timeStamp : DateTime.now());

  Bord.fromJson(Map<String, dynamic> json)
      : symbol = json['Symbol'],
        symbolName = json['SymbolName'],
        exchange = json['Exchange'],
        exchangeName = json['ExchangeName'],
        currentPrice = json['CurrentPrice'].toDouble(),
        currentPriceTime = json['CurrentPriceTime'],
        currentPriceChangeStatus = json['CurrentPriceChangeStatus'],
        currentPriceStatus = json['CurrentPriceStatus'],
        calcPrice = json['CalcPrice'].toDouble(),
        previousClose = json['PreviousClose'].toDouble(),
        previousCloseTime = json['PreviousCloseTime'],
        changePreviousClose = json['ChangePreviousClose'].toDouble(),
        changePreviousClosePer = json['ChangePreviousClosePer'].toDouble(),
        openingPrice = json['OpeningPrice'].toDouble(),
        openingPriceTime = json['OpeningPriceTime'],
        highPrice = json['HighPrice'].toDouble(),
        highPriceTime = json['HighPriceTime'],
        lowPrice = json['LowPrice'].toDouble(),
        lowPriceTime = json['LowPriceTime'],
        tradingVolume = json['TradingVolume'].toInt(),
        tradingVolumeTime = json['TradingVolumeTime'],
        vwap = json['VWAP'].toDouble(),
        tradingValue = json['TradingValue'].toInt(),
        bidQty = json['BidQty'].toInt(),
        bidPrice = json['BidPrice'].toDouble(),
        bidTime = json['BidTime'],
        bidSign = json['BidSign'],
        marketOrderSellQty = json['MarketOrderSellQty'].toInt(),
        sell1 = Qty1(
          json['Sell1']['Price'].toDouble(),
          json['Sell1']['Qty'].toInt(),
          json['Sell1']['Time'],
          json['Sell1']['Sign'],
        ),
        sell2 = Qty(
          json['Sell2']['Price'].toDouble(),
          json['Sell2']['Qty'].toInt(),
        ),
        sell3 = Qty(
          json['Sell3']['Price'].toDouble(),
          json['Sell3']['Qty'].toInt(),
        ),
        sell4 = Qty(
          json['Sell4']['Price'].toDouble(),
          json['Sell4']['Qty'].toInt(),
        ),
        sell5 = Qty(
          json['Sell5']['Price'].toDouble(),
          json['Sell5']['Qty'].toInt(),
        ),
        sell6 = Qty(
          json['Sell6']['Price'].toDouble(),
          json['Sell6']['Qty'].toInt(),
        ),
        sell7 = Qty(
          json['Sell7']['Price'].toDouble(),
          json['Sell7']['Qty'].toInt(),
        ),
        sell8 = Qty(
          json['Sell8']['Price'].toDouble(),
          json['Sell8']['Qty'].toInt(),
        ),
        sell9 = Qty(
          json['Sell9']['Price'].toDouble(),
          json['Sell9']['Qty'].toInt(),
        ),
        sell10 = Qty(
          json['Sell10']['Price'].toDouble(),
          json['Sell10']['Qty'].toInt(),
        ),
        askQty = json['AskQty'].toInt(),
        askPrice = json['AskPrice'].toDouble(),
        askTime = json['AskTime'],
        askSign = json['AskSign'],
        marketOrderBuyQty = json['MarketOrderBuyQty'].toInt(),
        buy1 = Qty1(
          json['Buy1']['Price'].toDouble(),
          json['Buy1']['Qty'].toInt(),
          json['Buy1']['Time'],
          json['Buy1']['Sign'],
        ),
        buy2 = Qty(
          json['Buy2']['Price'].toDouble(),
          json['Buy2']['Qty'].toInt(),
        ),
        buy3 = Qty(
          json['Buy3']['Price'].toDouble(),
          json['Buy3']['Qty'].toInt(),
        ),
        buy4 = Qty(
          json['Buy4']['Price'].toDouble(),
          json['Buy4']['Qty'].toInt(),
        ),
        buy5 = Qty(
          json['Buy5']['Price'].toDouble(),
          json['Buy5']['Qty'].toInt(),
        ),
        buy6 = Qty(
          json['Buy6']['Price'].toDouble(),
          json['Buy6']['Qty'].toInt(),
        ),
        buy7 = Qty(
          json['Buy7']['Price'].toDouble(),
          json['Buy7']['Qty'].toInt(),
        ),
        buy8 = Qty(
          json['Buy8']['Price'].toDouble(),
          json['Buy8']['Qty'].toInt(),
        ),
        buy9 = Qty(
          json['Buy9']['Price'].toDouble(),
          json['Buy9']['Qty'].toInt(),
        ),
        buy10 = Qty(
          json['Buy10']['Price'].toDouble(),
          json['Buy10']['Qty'].toInt(),
        ),
        overSellQty = json['OverSellQty'].toInt(),
        underBuyQty = json['UnderBuyQty'].toInt(),
        totalMarketValue = json['TotalMarketValue'],
        securityType = json['SecurityType'],
        timeStamp =
            json.containsKey('timeStamp') ? json['timeStamp'] : DateTime.now();

  Map<String, dynamic> toJson() => {
        'TimeStamp': '${timeStamp}',
        'Symbol': symbol,
        'SymbolName': symbolName,
        'Exchange': exchange,
        'ExchangeName': exchangeName,
        'CurrentPrice': currentPrice,
        'CurrentPriceTime': currentPriceTime,
        'CurrentPriceChangeStatus': currentPriceChangeStatus,
        'CurrentPriceStatus': currentPriceStatus,
        'CalcPrice': calcPrice,
        'PreviousClose': previousClose,
        'PreviousCloseTime': previousCloseTime,
        'ChangePreviousClose': changePreviousClose,
        'ChangePreviousClosePer': changePreviousClosePer,
        'OpeningPrice': openingPrice,
        'OpeningPriceTime': openingPriceTime,
        'HighPrice': highPrice,
        'HighPriceTime': highPriceTime,
        'LowPrice': lowPrice,
        'LowPriceTime': lowPriceTime,
        'TradingVolume': tradingVolume,
        'TradingVolumeTime': tradingVolumeTime,
        'VWAP': vwap,
        'TradingValue': tradingValue,
        'BidQty': bidQty,
        'BidPrice': bidPrice,
        'BidTime': bidTime,
        'BidSign': bidSign,
        'MarketOrderSellQty': marketOrderSellQty,
        'Sell1': {
          'Price': sell1.price,
          'Qty': sell1.qty,
          'Time': sell1.time,
          'Sign': sell1.sign,
        },
        'Sell2': {
          'Price': sell2.price,
          'Qty': sell2.qty,
        },
        'Sell3': {
          'Price': sell3.price,
          'Qty': sell3.qty,
        },
        'Sell4': {
          'Price': sell4.price,
          'Qty': sell4.qty,
        },
        'Sell5': {
          'Price': sell5.price,
          'Qty': sell5.qty,
        },
        'Sell6': {
          'Price': sell6.price,
          'Qty': sell6.qty,
        },
        'Sell7': {
          'Price': sell7.price,
          'Qty': sell7.qty,
        },
        'Sell8': {
          'Price': sell8.price,
          'Qty': sell8.qty,
        },
        'Sell9': {
          'Price': sell9.price,
          'Qty': sell9.qty,
        },
        'Sell10': {
          'Price': sell10.price,
          'Qty': sell10.qty,
        },
        'AskQty': askQty,
        'AskPrice': askPrice,
        'AskTime': askTime,
        'AskSign': askSign,
        'MarketOrderBuyQty': marketOrderBuyQty,
        'Buy1': {
          'Price': buy1.price,
          'Qty': buy1.qty,
          'Time': buy1.time,
          'Sign': buy1.sign,
        },
        'Buy2': {
          'Price': buy2.price,
          'Qty': buy2.qty,
        },
        'Buy3': {
          'Price': buy3.price,
          'Qty': buy3.qty,
        },
        'Buy4': {
          'Price': buy4.price,
          'Qty': buy4.qty,
        },
        'Buy5': {
          'Price': buy5.price,
          'Qty': buy5.qty,
        },
        'Buy6': {
          'Price': buy6.price,
          'Qty': buy6.qty,
        },
        'Buy7': {
          'Price': buy7.price,
          'Qty': buy7.qty,
        },
        'Buy8': {
          'Price': buy8.price,
          'Qty': buy8.qty,
        },
        'Buy9': {
          'Price': buy9.price,
          'Qty': buy9.qty,
        },
        'Buy10': {
          'Price': buy10.price,
          'Qty': buy10.qty,
        },
        'OverSellQty': overSellQty,
        'UnderBuyQty': underBuyQty,
        'TotalMarketValue': totalMarketValue,
        'SecurityType': securityType,
      };
}

class Qty {
  // 値段
  final double price;
  // 数量
  final int qty;

  Qty(this.price, this.qty);
}

class Qty1 extends Qty {
  // 時刻
  final String time;
  // 気配フラグ
  final String sign;

  Qty1(double price, int Qty, this.time, this.sign) : super(price, Qty);
}
