class Berth {
  late int gkey;
  late String berthName;

  // Add more properties based on the API response

  Berth({required this.gkey, required this.berthName});

  Berth.fromJson(Map<String, dynamic> json) {
    gkey = json['gkey'];
    berthName = json['berth_name'];
  }
}
