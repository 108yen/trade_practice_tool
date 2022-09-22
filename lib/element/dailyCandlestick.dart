class DailyCandlestick {
  DailyCandlestick(this.previousDayClose) {
    priceLimitRange = _caluculatePriceLimitRange(previousDayClose);
    stopHeight = previousDayClose + priceLimitRange;
    stopLow = previousDayClose - priceLimitRange;
  }
  double previousDayClose;
  double dailyOpen = 0;
  double dailyHeight = 0;
  double dailyLow = 0;
  double dailyClose = 0;
  late double stopHeight;
  late double stopLow;
  late double priceLimitRange;
  double priceUpRate = 0;
  int x4 = 0;

  setPreviousDayClose(double previousDayClose) {
    this.previousDayClose = previousDayClose;

    priceLimitRange = _caluculatePriceLimitRange(previousDayClose);
    stopHeight = previousDayClose + priceLimitRange;
    stopLow = previousDayClose - priceLimitRange;
  }

  bool alreadySetPreviousDayClose() {
    return previousDayClose != 0;
  }

  setOpenValue(double open) {
    dailyOpen = open;
    dailyHeight = open;
    dailyLow = open;
    dailyClose = open;
  }

  bool alreadySetOpen() {
    return dailyOpen != 0;
  }

  updateValue(double price) {
    priceUpRate = ((price - previousDayClose) / previousDayClose) * 100;
    if (price > stopHeight) {
      stopHeight += priceLimitRange * 3;
      x4 = 1;
    }
    if (price < stopLow) {
      stopLow -= priceLimitRange * 3;
      x4 = 2;
    }
    dailyClose = price;
    if (dailyHeight < price) {
      dailyHeight = price;
    }
    if (dailyLow > price) {
      dailyLow = price;
    }
  }

  double _caluculatePriceLimitRange(double open) {
    if (open < 100) {
      return 30;
    } else if (open < 200) {
      return 50;
    } else if (open < 500) {
      return 80;
    } else if (open < 700) {
      return 100;
    } else if (open < 1000) {
      return 150;
    } else if (open < 1500) {
      return 300;
    } else if (open < 2000) {
      return 400;
    } else if (open < 3000) {
      return 500;
    } else if (open < 5000) {
      return 700;
    } else if (open < 7000) {
      return 1000;
    } else if (open < 10000) {
      return 1500;
    } else if (open < 15000) {
      return 3000;
    } else if (open < 20000) {
      return 4000;
    } else if (open < 30000) {
      return 5000;
    } else if (open < 50000) {
      return 7000;
    } else if (open < 70000) {
      return 10000;
    } else if (open < 100000) {
      return 15000;
    } else if (open < 150000) {
      return 30000;
    } else if (open < 200000) {
      return 40000;
    } else if (open < 300000) {
      return 50000;
    } else if (open < 500000) {
      return 70000;
    } else if (open < 700000) {
      return 100000;
    } else if (open < 1000000) {
      return 150000;
    } else if (open < 1500000) {
      return 300000;
    } else if (open < 2000000) {
      return 400000;
    } else if (open < 3000000) {
      return 500000;
    } else if (open < 5000000) {
      return 700000;
    } else if (open < 7000000) {
      return 1000000;
    } else if (open < 10000000) {
      return 1500000;
    } else if (open < 15000000) {
      return 3000000;
    } else if (open < 20000000) {
      return 4000000;
    } else if (open < 30000000) {
      return 5000000;
    } else if (open < 50000000) {
      return 7000000;
    } else {
      return 10000000;
    }
  }
}
