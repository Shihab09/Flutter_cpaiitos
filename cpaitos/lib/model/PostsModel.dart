/// success : "1"
/// message : "Data\nFound"
/// data : [{"total_vsl_arrival":"277","total_vsl_depart":"261","total_vsl_shift":"17","total_vsl_cancel":"4"}]

class PostsModel {
  PostsModel({
      String? success, 
      String? message, 
      List<Data>? data,}){
    _success = success;
    _message = message;
    _data = data;
}

  PostsModel.fromJson(dynamic json) {
    _success = json['success'];
    _message = json['message'];
    if (json['data'] != null) {
      _data = [];
      json['data'].forEach((v) {
        _data?.add(Data.fromJson(v));
      });
    }
  }
  String? _success;
  String? _message;
  List<Data>? _data;
PostsModel copyWith({  String? success,
  String? message,
  List<Data>? data,
}) => PostsModel(  success: success ?? _success,
  message: message ?? _message,
  data: data ?? _data,
);
  String? get success => _success;
  String? get message => _message;
  List<Data>? get data => _data;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['success'] = _success;
    map['message'] = _message;
    if (_data != null) {
      map['data'] = _data?.map((v) => v.toJson()).toList();
    }
    return map;
  }

}

/// total_vsl_arrival : "277"
/// total_vsl_depart : "261"
/// total_vsl_shift : "17"
/// total_vsl_cancel : "4"

class Data {
  Data({
      String? totalVslArrival, 
      String? totalVslDepart, 
      String? totalVslShift, 
      String? totalVslCancel,}){
    _totalVslArrival = totalVslArrival;
    _totalVslDepart = totalVslDepart;
    _totalVslShift = totalVslShift;
    _totalVslCancel = totalVslCancel;
}

  Data.fromJson(dynamic json) {
    _totalVslArrival = json['total_vsl_arrival'];
    _totalVslDepart = json['total_vsl_depart'];
    _totalVslShift = json['total_vsl_shift'];
    _totalVslCancel = json['total_vsl_cancel'];
  }
  String? _totalVslArrival;
  String? _totalVslDepart;
  String? _totalVslShift;
  String? _totalVslCancel;
Data copyWith({  String? totalVslArrival,
  String? totalVslDepart,
  String? totalVslShift,
  String? totalVslCancel,
}) => Data(  totalVslArrival: totalVslArrival ?? _totalVslArrival,
  totalVslDepart: totalVslDepart ?? _totalVslDepart,
  totalVslShift: totalVslShift ?? _totalVslShift,
  totalVslCancel: totalVslCancel ?? _totalVslCancel,
);
  String? get totalVslArrival => _totalVslArrival;
  String? get totalVslDepart => _totalVslDepart;
  String? get totalVslShift => _totalVslShift;
  String? get totalVslCancel => _totalVslCancel;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['total_vsl_arrival'] = _totalVslArrival;
    map['total_vsl_depart'] = _totalVslDepart;
    map['total_vsl_shift'] = _totalVslShift;
    map['total_vsl_cancel'] = _totalVslCancel;
    return map;
  }

}