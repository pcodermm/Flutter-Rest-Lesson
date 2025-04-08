class DeleteModel {
  DeleteModel({
    String? result,
  }) {
    _result = result;
  }

  DeleteModel.fromJson(dynamic json) {
    _result = json['result'];
  }
  String? _result;

  String? get result => _result;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['result'] = _result;
    return map;
  }
}
