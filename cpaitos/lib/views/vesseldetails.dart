import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '../model/Vessel.dart';
import 'timeberthinput.dart';

// class Vesseldetails extends StatefulWidget {
//   // List<String> Vessel vessel;
//   final String? vessel;

//   Vesseldetails({Key? key, required this.vessel}) : super(key: key);
//fetchVesselsdetails();
class Vesseldetails extends StatefulWidget {
  dynamic vessel;
  Vesseldetails(this.vessel, {super.key});

  @override
  _VesseldetailsState createState() => _VesseldetailsState();
}

class _VesseldetailsState extends State<Vesseldetails> {
  TextEditingController? _vslnameController = TextEditingController();
  TextEditingController? _masternameController = TextEditingController();
  TextEditingController? _flagController = TextEditingController();
  TextEditingController? _grtController = TextEditingController();
  TextEditingController? _nrtController = TextEditingController();
  TextEditingController? _dechcargoController = TextEditingController();
  TextEditingController? _loaController = TextEditingController();
  TextEditingController? _localagentController = TextEditingController();
  TextEditingController? _lastportController = TextEditingController();
  TextEditingController? _nextportController = TextEditingController();
  TextEditingController? _rotationController = TextEditingController();

  // String? _selectedOption;
  String CHANNEL = "1";
  String? _selectvalue = "Karnaphuli";
  dynamic vvd_gkey;
  dynamic Rotaion;
  dynamic request_for;
  String? isLoggedIn;

  @override
  initState() {
    Rotaion = widget.vessel['ib_vyg'];
    vvd_gkey = widget.vessel['vvd_gkey'];
    super.initState();

    // fetchVesselsdetails('${widget.rotation}');
    fetchVesselsdetails(Rotaion);
    //  sharedpref();

    print(Rotaion);
    print("object");
  }

  // sharedpref() async {
  //   SharedPreferences pref = await SharedPreferences.getInstance();
  //   request_for = pref.getString("request_for");
  //   isLoggedIn = pref.getString("isLoggedIn");

  //   await pref.setString('request_for', request_for!);
  //   await pref.setString('isLoggedIn', isLoggedIn!);
  //   await pref.setString('vvd_gkey', vvd_gkey!);
  //   await pref.setString('rotation', Rotaion!);
  //   print(request_for);
  // }

  @override
  void dispose() {
    _vslnameController?.dispose();
    _masternameController?.dispose();
    _flagController?.dispose();
    _grtController?.dispose();
    _nrtController?.dispose();
    _dechcargoController?.dispose();
    _loaController?.dispose();
    _localagentController?.dispose();
    _lastportController?.dispose();
    _nextportController?.dispose();
    _rotationController?.dispose();
    super.dispose();
  }

  Future<String?> addVesselsdetails(rot) async {
    const baseUrl = 'http://cpatos.gov.bd/tosapi';
    final param = {
      'vsl_name': _vslnameController?.text.toString(),
      'master_name': _masternameController?.text.toString(),
      'vvd_gkey': vvd_gkey.toString(),
      'flag': _flagController?.text.toString(),
      'grt': _flagController?.text.toString(),
      'nrt': _flagController?.text.toString(),
      'deck_cargo': _dechcargoController?.text.toString(),
      'loa': _loaController?.text.toString(),
      'local_agent': _localagentController?.text.toString(),
      'last_port': _lastportController?.text.toString(),
      'next_port': _nextportController?.text.toString(),
      'rotation': rot.toString(),
      'entry_by': "Null",
      'channel': CHANNEL.toString(),
    };
    final uri =
        Uri.parse('$baseUrl/pilot/v03212023/live/set_vessel_details.php');
    print(uri);

    final response = await http.post(uri, body: param);
    //print(response.statusCode);

    if (response.statusCode == 200) {
      var jsondata = json.decode(response.body);
      print("jsondata");
      String success = jsondata['success'];
      if (success == "1") {
        var message = jsondata['message'];
        print(message);
      }
    } else {
      print(vvd_gkey);
    }
  }

  Future<String?> fetchVesselsdetails(_rotation) async {
    print("api called=====");
    const baseUrl = 'http://cpatos.gov.bd/tosapi';
    List<Vessel> list;
    SharedPreferences pref = await SharedPreferences.getInstance();
    request_for = pref.getString("request_for");
    isLoggedIn = pref.getString("isLoggedIn");

    await pref.setString('request_for', request_for!);
    await pref.setString('isLoggedIn', isLoggedIn!);
    await pref.setString('vvd_gkey', vvd_gkey!);
    await pref.setString('rotation', Rotaion!);
    Rotaion = _rotation;

    print(request_for);

    final param = {'rotation': Rotaion};
    final uri =
        Uri.parse('$baseUrl/pilot/v03212023/live/get_vessel_details.php');
    print(uri);
    print(CHANNEL);

    final response = await http.post(uri, body: param);
    //print(response.statusCode);

    if (response.statusCode == 200) {
      if (isLoggedIn == "true") {
        var jsondata = json.decode(response.body);
        print(jsondata);
        String success = jsondata['success'];
        if (success == "1") {
          var jsonvessel = jsondata['data'];
          // list = jsonvessel.map<Vessel>((json) => Vessel.fromJson(json)).toList();
          // // var test = json.encode(jsonvessel);
          // var lol = list[0];
          _vslnameController?.text = jsonvessel[0]['name'];
          _flagController?.text = jsonvessel[0]['flag'];
          _masternameController?.text = jsonvessel[0]['Name_of_Master'];
          _grtController?.text = jsonvessel[0]['gross_registered_ton'];
          _nrtController?.text = jsonvessel[0]['net_registered_ton'];
          _dechcargoController?.text = jsonvessel[0]['net_registered_ton'];
          ;
          _loaController?.text = jsonvessel[0]['loa_cm'];
          _localagentController?.text = jsonvessel[0]['localagent'];
          _lastportController?.text = jsonvessel[0]['last_port'].toString();

          _nextportController?.text = jsonvessel[0]['next_port'].toString();
          vvd_gkey = jsonvessel[0]['vvd_gkey'].toString();

          _rotationController?.text = _rotation.toString();
          ;
        }
      } else {
        print(_rotation);
      }
    } else {
      ScaffoldMessenger.of(this.context).showSnackBar(
        const SnackBar(
          content: Text("Please Login First"),
          backgroundColor: Colors.purple,
          margin: EdgeInsets.all(10),
          shape: StadiumBorder(),
          behavior: SnackBarBehavior.floating,
          // action: SnackBarAction(
          //   label: 'Dismiss',
          //   //onPressed: _cleartext,
          //   disabledTextColor: Colors.white54,
          //   textColor: Colors.white,
          // ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueGrey,
        title: const Text("Vessel Details"),
      ),
      body: SingleChildScrollView(
        child: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
                opacity: -40,
                image: AssetImage("images/cpa.png"),
                fit: BoxFit.cover),
          ),
          padding: const EdgeInsets.all(16.0),
          // color: Colors.green[50],

          child: Column(
            children: [
              TextField(
                controller: _vslnameController,
                enabled: false,
                decoration: const InputDecoration(
                  labelText: 'Vessel Name',
                  // fillColor: Color.fromRGBO(113, 180, 211, 0.98)
                ),
              ),
              SizedBox(height: 9.0),
              TextField(
                controller: _masternameController,
                decoration: const InputDecoration(
                  labelText: 'Master Name',
                ),
              ),
              SizedBox(height: 9.0),
              TextField(
                controller: _flagController,
                enabled: false,
                decoration: const InputDecoration(
                  labelText: 'Flag',
                ),
              ),
              SizedBox(height: 9.0),
              TextField(
                controller: _grtController,
                enabled: false,
                decoration: const InputDecoration(
                  labelText: 'GRT',
                ),
              ),
              SizedBox(height: 16.0),
              TextField(
                controller: _nrtController,
                enabled: false,
                decoration: const InputDecoration(
                  labelText: 'NRT',
                ),
              ),
              SizedBox(height: 16.0),
              TextField(
                controller: _dechcargoController,
                decoration: const InputDecoration(
                  labelText: 'Deck Cargo Ton',
                ),
              ),
              const SizedBox(height: 16.0),
              TextField(
                controller: _loaController,
                enabled: false,
                decoration: const InputDecoration(
                  labelText: 'LOA(CM)',
                ),
              ),
              SizedBox(height: 16.0),
              TextField(
                controller: _localagentController,
                enabled: false,
                decoration: const InputDecoration(
                  labelText: 'Local Agent',
                ),
              ),
              SizedBox(height: 16.0),
              TextField(
                controller: _lastportController,
                enabled: false,
                decoration: const InputDecoration(
                  labelText: 'Last Port',
                ),
              ),
              const SizedBox(height: 16.0),
              TextField(
                controller: _nextportController,
                enabled: false,
                decoration: const InputDecoration(
                  labelText: 'Next Port',
                ),
              ),
              SizedBox(height: 16.0),
              TextField(
                controller: _rotationController,
                enabled: false,
                decoration: const InputDecoration(
                  labelText: 'Rotation',
                ),
              ),
              SizedBox(height: 16.0),
              // Add more text fields as needed...
              Column(
                children: [
                  ListTile(
                    title: const Text('Karnaphuli'),
                    leading: Radio(
                      value: "Karnaphuli",
                      groupValue: _selectvalue,
                      onChanged: (String? value) {
                        setState(() {
                          _selectvalue = value;
                        });
                      },
                    ),
                  ),
                  ListTile(
                    title: const Text('Matarbari'),
                    leading: Radio(
                      value: "Matarbari",
                      groupValue: _selectvalue,
                      onChanged: (String? value) {
                        setState(() {
                          CHANNEL = "2";
                          _selectvalue = value;
                        });
                      },
                    ),
                  ),
                ],
              ),

              SizedBox(height: 16.0),

              ElevatedButton(
                onPressed: () async {
                  await addVesselsdetails(Rotaion);
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => Timeberthin()));
                  // sharedpref();
                },
                child: Text('Submit'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    throw UnimplementedError();
  }
}
