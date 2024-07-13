class Vessel {
  final String? vvd_gkey;
  final String? name;
  final String? ib_vyg;
  final String? ob_vyg;
  final String? phase_num;
  final String? phase_str;
  final String? agent;
  final String? noOfDays;
  final String? eta;
  final String? close_day;

  Vessel(
      {required this.vvd_gkey,
      required this.name,
      required this.ib_vyg,
      this.ob_vyg,
      this.phase_num,
      this.phase_str,
      this.agent,
      this.noOfDays,
      this.close_day,
      this.eta});

  factory Vessel.fromJson(Map<String, dynamic> json) {
    return Vessel(
      vvd_gkey: json['VVD_GKEY'],
      name: json['NAME'],
      ib_vyg: json['IB_VYG'],
      ob_vyg: json['OB_VYG'],
      phase_num: json['PHASE_NUM'],
      phase_str: json['PHASE_STR'],
      agent: json['AGENT'],
      noOfDays: json[''],
      close_day: json['CLOSE_DATE'],
      eta: json['ETA'],
    );
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['VVD_GKEY'] = vvd_gkey;
    data['NAME'] = name;
    data['IB_VYG'] = ib_vyg;
    data['OB_VYG'] = ob_vyg;
    data['PHASE_NUM'] = phase_num;
    data['PHASE_STR'] = phase_str;
    data['AGENT'] = agent;
    data[''] = noOfDays;
    data['CLOSE_DATE'] = close_day;
    data['ETA'] = eta;

    return data;
  }
}
