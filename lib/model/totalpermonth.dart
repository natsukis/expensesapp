class TotalPerMonth {
  int _year;

  int _january = 0;
  int _february = 0;
  int _march = 0;
  int _april = 0;
  int _may = 0;
  int _june = 0;
  int _july = 0;
  int _august = 0;
  int _september = 0;
  int _october = 0;
  int _november = 0;
  int _december = 0;

  TotalPerMonth.withYear(this._year);

  TotalPerMonth(
      this._year,
      this._january,
      this._february,
      this._march,
      this._april,
      this._may,
      this._june,
      this._july,
      this._august,
      this._september,
      this._october,
      this._november,
      this._december);

  int get year => _year;
  int get january => _january;
  int get february => _february;
  int get march => _march;
  int get april => _april;
  int get may => _may;
  int get june => _june;
  int get july => _july;
  int get august => _august;
  int get september => _september;
  int get october => _october;
  int get november => _november;
  int get december => _december;

  set year(int newYear) {
    _year = newYear;
  }

  set january(int newArticle) {
    _january = newArticle;
  }

  set february(int newArticle) {
    _february = newArticle;
  }

  set march(int newArticle) {
    _march = newArticle;
  }

  set april(int newArticle) {
    _april = newArticle;
  }

  set may(int newArticle) {
    _may = newArticle;
  }

  set june(int newArticle) {
    _june = newArticle;
  }

  set july(int newArticle) {
    _july = newArticle;
  }

  set august(int newArticle) {
    _august = newArticle;
  }

  set september(int newArticle) {
    _september = newArticle;
  }

  set october(int newArticle) {
    _october = newArticle;
  }

  set november(int newArticle) {
    _november = newArticle;
  }

  set december(int newArticle) {
    _december = newArticle;
  }

  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();
    map["year"] = _year;
    map["january"] = _january;
    map["february"] = _february;
    map["march"] = _march;
    map["april"] = _april;
    map["may"] = _may;
    map["june"] = _june;
    map["july"] = _july;
    map["august"] = _august;
    map["september"] = _september;
    map["october"] = _october;
    map["november"] = _november;
    map["december"] = _december;

    return map;
  }

  TotalPerMonth.fromObject(dynamic o) {
    this._year = o["year"];
    this._january = o["january"];
    this._february = o["february"];
    this._march = o["march"];
    this._april = o["april"];
    this._may = o["may"];
    this._june = o["june"];
    this._july = o["july"];
    this._august = o["august"];
    this._september = o["september"];
    this._october = o["october"];
    this._november = o["november"];
    this._december = o["december"];
  }
}
