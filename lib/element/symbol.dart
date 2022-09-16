class Symbol {
  final String bisCategory;
  final double totalMarketValue;
  final double totalStocks;
  final int fiscalYearEndBasic;
  final bool kCMarginBuy;
  final bool kCMarginSell;
  final bool marginBuy;
  final bool marginSell;
  final String displayName;
  final int exchange;
  final String exchangeName;
  final double tradingUnit;
  final String priceRangeGroup;
  final double upperLimit;
  final double lowerLimit;
  final String symbol;
  final String symbolName;

  Symbol(
    this.bisCategory,
    this.totalMarketValue,
    this.totalStocks,
    this.fiscalYearEndBasic,
    this.kCMarginBuy,
    this.kCMarginSell,
    this.marginBuy,
    this.marginSell,
    this.displayName,
    this.exchange,
    this.exchangeName,
    this.tradingUnit,
    this.priceRangeGroup,
    this.upperLimit,
    this.lowerLimit,
    this.symbol,
    this.symbolName,
  );

  Symbol.fromJson(Map<String, dynamic> json)
      : bisCategory = json['BisCategory'],
        totalMarketValue = json['TotalMarketValue'],
        totalStocks = json['TotalStocks'],
        fiscalYearEndBasic = json['FiscalYearEndBasic'],
        kCMarginBuy = json['KCMarginBuy'] == 'true',
        kCMarginSell = json['KCMarginSell'] == 'true',
        marginBuy = json['MarginBuy'] == 'true',
        marginSell = json['MarginSell'] == 'true',
        displayName = json['DisplayName'],
        exchange = json['Exchange'],
        exchangeName = json['ExchangeName'],
        tradingUnit = json['TradingUnit'],
        priceRangeGroup = json['PriceRangeGroup'],
        upperLimit = json['UpperLimit'],
        lowerLimit = json['LowerLimit'],
        symbol = json['Symbol'],
        symbolName = json['SymbolName'];

  Map<String, dynamic> toJson() => {
        'BisCategory': bisCategory,
        'TotalMarketValue': totalMarketValue,
        'TotalStocks': totalStocks,
        'FiscalYearEndBasic': fiscalYearEndBasic,
        'KCMarginBuy': kCMarginBuy ? 'true' : 'false',
        'KCMarginSell': kCMarginSell ? 'true' : 'false',
        'MarginBuy': marginBuy ? 'true' : 'false',
        'MarginSell': marginSell ? 'true' : 'false',
        'DisplayName': displayName,
        'Exchange': exchange,
        'ExchangeName': exchangeName,
        'TradingUnit': tradingUnit,
        'PriceRangeGroup': priceRangeGroup,
        'UpperLimit': upperLimit,
        'LowerLimit': lowerLimit,
        'Symbol': symbol,
        'SymbolName': symbolName,
      };
}
