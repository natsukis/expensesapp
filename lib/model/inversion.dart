class Inversion{
  int _id;
  String _article;
  String _description;
  String _date;
  int _price;

  Inversion(this._article, this._price, this._date, [this._description]);
  Inversion.withId(this._id,this._article, this._price, this._date, [this._description]);

  int get id => _id;
  String get article => _article;
  String get description => _description;
  String get date => _date;
  int get price => _price;

set article (String newArticle){
    _article = newArticle;
}

set description (String newDescription){
  if(newDescription.length <= 255){
    _description = newDescription;
  }
}

set price (int newPrice){
  if(newPrice >=0){
    _price = newPrice;
  }
}

set date (String newDate){
    _date = newDate;
 }

Map<String, dynamic> toMap(){
  var map = Map<String, dynamic>();
  map["article"] = _article;
  map["description"] = _description;
  map["price"] = _price;
  map["date"] = _date;
  if (_id != null){
    map["id"] = _id;
  }
  return map;  
}

Inversion.fromObject(dynamic o){
  this._id = o["id"];
  this._article = o["article"];
  this._description = o["description"];
  this._price = o["price"];
  this._date = o["date"];
}

}