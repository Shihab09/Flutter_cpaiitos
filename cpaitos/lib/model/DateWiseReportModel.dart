class DateWiseReportModel {
  DateWiseReportModel({
    required this.vvdGkey,
    required this.importRotationNo,
    required this.vesselName,
    required this.nameOfMaster,
    required this.inputType,
  });

  DateWiseReportModel.fromJson(dynamic json) {
    vvdGkey = json['vvd_gkey'];
    importRotationNo = json['Import_Rotation_No'];
    vesselName = json['Vessel_Name'];
    nameOfMaster = json['Name_of_Master'];
    inputType = json['input_type'];
  }
  String? vvdGkey;
  String? importRotationNo;
  String? vesselName;
  String? nameOfMaster;
  String? inputType;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['vvd_gkey'] = vvdGkey;
    map['Import_Rotation_No'] = importRotationNo;
    map['Vessel_Name'] = vesselName;
    map['Name_of_Master'] = nameOfMaster;
    map['input_type'] = inputType;
    return map;
  }
}
