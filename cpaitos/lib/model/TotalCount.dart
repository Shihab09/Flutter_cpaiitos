

class TotalCount {

  final String total_vsl_arrival;
  final String total_vsl_depart;
  final String total_vsl_shift;
  final String total_vsl_cancel;

  const TotalCount({
    required this.total_vsl_arrival,
    required this.total_vsl_depart,
    required this.total_vsl_shift,
    required this.total_vsl_cancel,
  });

  factory TotalCount.fromJson(Map<String, dynamic> json) {
    return TotalCount(
      total_vsl_arrival: json['total_vsl_arrival'],
      total_vsl_depart: json['total_vsl_depart'],
      total_vsl_shift: json['total_vsl_shift'],
      total_vsl_cancel: json['total_vsl_cancel'],

    );
  }

  Map<String,dynamic> toJson()=>{
    total_vsl_arrival: 'total_vsl_arrival',
    total_vsl_depart: 'total_vsl_depart',
    total_vsl_shift:'total_vsl_shift',
    total_vsl_cancel: 'total_vsl_cancel',
  };
}