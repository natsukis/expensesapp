class Expense{
  int _id;
  String _article;
  String _type;
  String _description;
  String _date;
  int _price;
  String _method;

  Expense(this._article, this._price,this._type, this._date, this._description, this._method);
  Expense.withId(this._id,this._article, this._price, this._type, this._date, this._description, this._method);

  int get id => _id;
  String get article => _article;
  String get description => _description;
  String get date => _date;
  String get type => _type;
  int get price => _price;
  String get method => _method;

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

 set type (String newType){
    _type = newType;
 }

 set method (String newMethod){
    _method = newMethod;
}

Map<String, dynamic> toMap(){
  var map = Map<String, dynamic>();
  map["article"] = _article;
  map["description"] = _description;
  map["price"] = _price;
  map["type"] = _type;
  map["date"] = _date;
  map["method"] = _method;
  if (_id != null){
    map["id"] = _id;
  }
  return map;  
}

Expense.fromObject(dynamic o){
  this._id = o["id"];
  this._article = o["article"];
  this._description = o["description"];
  this._price = o["price"];
  this._type = o["type"];
  this._date = o["date"];
  this._method = o["method"];
}

}