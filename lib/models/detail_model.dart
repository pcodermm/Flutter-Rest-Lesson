class DetailModel {
  DetailModel({
    int? id,
    String? title,
    String? body,
    String? photo,
  }) {
    _id = id;
    _title = title;
    _body = body;
    _photo = photo;
  }

  DetailModel.fromJson(dynamic json) {
    _id = json['id'];
    _title = json['title'];
    _body = json['body'];
    _photo = json['photo'];
  }
  int? _id;
  String? _title;
  String? _body;
  String? _photo;

  int? get id => _id;
  String? get title => _title;
  String? get body => _body;
  String? get photo => _photo;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['title'] = _title;
    map['body'] = _body;
    map['photo'] = _photo;
    return map;
  }
}
