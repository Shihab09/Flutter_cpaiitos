import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import 'finalsummaryview.dart';

class Additionalinfo extends StatefulWidget {
  @override
  _AdditionalinfoState createState() => _AdditionalinfoState();
}

class _AdditionalinfoState extends State<Additionalinfo> {
  bool is_main_engine_ok = true;
  bool is_acnchors_ok = true;
  bool is_rudder_indicator_ok = true;
  bool is_rpm_indicator_ok = true;
  bool is_bow_therster_available = true;
  bool is_complying_soal_convention = true;
  bool is_night = false;
  bool is_holiday = false;

  TextEditingController _addtugcontroller = TextEditingController();
  TextEditingController _addpilotcontroller = TextEditingController();
  TextEditingController _draughtcontroller = TextEditingController();
  TextEditingController _remarkscontroller = TextEditingController();
  TextEditingController _tugnamecontroller = TextEditingController();

  String? dop;

  String? rotation;
  String? berthfrm;

  String? request_for;
  String? vvd_gkey;
  String? isLoggedIn;

  String? berthname;
  // List<String> berthDataArray = <String>[];

  @override
  void dispose() {
    _addtugcontroller.dispose();
    _addpilotcontroller.dispose();
    _draughtcontroller.dispose();
    _tugnamecontroller.dispose();
    _remarkscontroller.dispose();
    super.dispose();
  }

  @override
  initState() {
    super.initState();
    onpageloaded();
  }

  vslEventAction() async {
    const baseUrl = 'http://cpatos.gov.bd/tosapi';
    print("Vsl Fuction called=======");
    print(request_for);
    int engine = 0;
    int anchore = 0;
    int rudder = 0;
    int rpm = 0;
    int bowthurster = 0;
    int soalconvention = 0;
    int daynight = 0;
    int holiday = 0;
    if (is_main_engine_ok == true) {
      engine = 1;
    }
    if (is_acnchors_ok == true) {
      anchore = 1;
    }
    if (is_rudder_indicator_ok == true) {
      rudder = 1;
    }
    if (is_rpm_indicator_ok == true) {
      rpm = 1;
    }
    if (is_bow_therster_available == true) {
      bowthurster = 1;
    }
    if (is_complying_soal_convention == true) {
      soalconvention = 1;
    }
    if (is_night == true) {
      daynight = 1;
    }
    if (is_holiday == true) {
      holiday = 1;
    }

    final param = {
      'rotation': rotation,
      'vvd_gkey': vvd_gkey,
      'pilot_name': "Shihab",
      'request_type': 'additional',
      'request_for': request_for,
      'draught': _draughtcontroller.text.toString(),
      'addiPilot': _addpilotcontroller.text.toString(),
      'addiTug': _addtugcontroller.text.toString(),
      'remarks': _remarkscontroller.text.toString(),
      'tug_name': _tugnamecontroller.text.toString(),
      'is_main_engine_ok': engine.toString(),
      'is_acnchors_ok': anchore.toString(),
      'is_rudder_indicator_ok': rudder.toString(),
      'is_rpm_indicator_ok': rpm.toString(),
      'is_bow_therster_available': bowthurster.toString(),
      'is_complying_soal_convention': soalconvention.toString(),
      'is_night': daynight.toString(),
      'is_holiday': holiday.toString(),
    };
    // print(rotation);
    // print(vvd_gkey);
    // print(_draughtcontroller.text.toString());
    // print(_addpilotcontroller.text.toString());
    // print(_addtugcontroller.text.toString());
    // print(_remarkscontroller.text.toString());
    // print(_tugnamecontroller.text.toString());
    // print(engine);
    // print(anchore);
    // print(rudder);
    // print(rpm);
    // print(bowthurster);
    // print(soalconvention);
    // print(daynight);
    // print(holiday);
    //  print(rotation);

    final uri = Uri.parse('$baseUrl/pilot/v03212023/live/set_vessel_event.php');
    print(uri);
    final response = await http.post(uri, body: param);
    print(response.statusCode);

    if (response.statusCode == 200) {
      var jsondata = json.decode(response.body);
      print(jsondata);
      var success = jsondata['success'];
      if (success == "1") {
        print("successsssssssssssssss");
        // print(rotation);

        // print(berthFrom);
        // print(dop.text);

        SharedPreferences pref = await SharedPreferences.getInstance();
        await pref.setString('vvd_gkey', vvd_gkey!);
        await pref.setString('rotation', rotation!);
        await pref.setString('request_for', request_for!);
        await pref.setString('berthFrom', berthfrm!);
        await pref.setString('berthname', berthname!);
        await pref.setString('isLoggedIn', isLoggedIn!);
        // await pref.setString('dop', dop.text);
      }
    }
  }

  onpageloaded() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    setState(() {
      dop = pref.getString('dop');
      vvd_gkey = pref.getString('vvd_gkey');
      rotation = pref.getString('rotation');
      request_for = pref.getString('request_for');
      berthfrm = pref.getString('berthFrom');
      berthname = pref.getString('berthname');
      isLoggedIn = pref.getString('isLoggedIn');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueGrey,
        title: Text('Additional Information'),
      ),
      body: SingleChildScrollView(
        child: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
                opacity: -30,
                image: AssetImage("images/cpa.png"),
                fit: BoxFit.cover),
          ),
          width: MediaQuery.of(context).size.width,
          padding: const EdgeInsets.all(16.0),
          //  color: Color.fromARGB(255, 255, 255, 255),
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.all(2),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _addtugcontroller,
                        decoration: InputDecoration(
                          labelText: 'Additional Tug',
                          labelStyle: TextStyle(
                              fontSize: 12, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Expanded(
                      child: TextField(
                        controller: _addpilotcontroller,
                        decoration: InputDecoration(
                            labelText: 'Additional Pilot',
                            labelStyle: TextStyle(
                                fontSize: 12, fontWeight: FontWeight.bold)),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.all(2),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _draughtcontroller,
                        decoration: InputDecoration(
                            labelText: 'DRAUGHT(MAX)',
                            labelStyle: TextStyle(
                                fontSize: 12, fontWeight: FontWeight.bold)),
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Expanded(
                      child: TextField(
                        controller: _remarkscontroller,
                        decoration: InputDecoration(
                            labelText: 'Remarks',
                            labelStyle: TextStyle(
                                fontSize: 12, fontWeight: FontWeight.bold)),
                      ),
                    ),
                  ],
                ),
              ),
              //  SizedBox(height: 5.0),
              Padding(
                padding: EdgeInsets.all(16),
                child: Center(
                  child: TextField(
                    controller: _tugnamecontroller,
                    decoration: InputDecoration(
                        labelText: 'Tug Name',
                        labelStyle: TextStyle(
                            fontSize: 12, fontWeight: FontWeight.bold)),
                  ),
                ),
              ),
              SizedBox(height: 16.0),
              Column(
                children: [
                  Padding(
                    padding: EdgeInsets.all(2),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Main Engines in good working Condition?',
                          style: TextStyle(fontSize: 12),
                        ),
                        Switch(
                            value: is_main_engine_ok,
                            onChanged: (newvalue) {
                              setState(() {
                                is_main_engine_ok = newvalue;
                              });
                            })
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.zero,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Anchors in Good Working Conditions?',
                          style: TextStyle(fontSize: 12),
                        ),
                        Switch(
                            value: is_acnchors_ok,
                            onChanged: (newvalue) {
                              setState(() {
                                is_acnchors_ok = newvalue;
                              });
                            })
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.zero,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Rudder Indicator in Good Conditions?',
                          style: TextStyle(fontSize: 12),
                        ),
                        Switch(
                            value: is_rudder_indicator_ok,
                            onChanged: (newvalue) {
                              setState(() {
                                is_rudder_indicator_ok = newvalue;
                              });
                            })
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.zero,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'RPM Indicator in Good Conditions?',
                          style: TextStyle(fontSize: 12),
                        ),
                        Switch(
                            value: is_rpm_indicator_ok,
                            onChanged: (newvalue) {
                              setState(() {
                                is_rpm_indicator_ok = newvalue;
                              });
                            })
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.zero,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Bow Thruster Available',
                          style: TextStyle(fontSize: 12),
                        ),
                        Switch(
                            value: is_bow_therster_available,
                            onChanged: (newvalue) {
                              setState(() {
                                is_bow_therster_available = newvalue;
                              });
                            })
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.zero,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Complying Solas Convention?',
                          style: TextStyle(fontSize: 12),
                        ),
                        Switch(
                            value: is_complying_soal_convention,
                            onChanged: (newvalue) {
                              setState(() {
                                is_complying_soal_convention = newvalue;
                              });
                            })
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.zero,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Is Night Shift?',
                          style: TextStyle(fontSize: 12),
                        ),
                        Switch(
                            value: is_night,
                            onChanged: (newvalue) {
                              setState(() {
                                is_night = newvalue;
                              });
                            })
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.zero,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Is Holiday?',
                          style: TextStyle(fontSize: 12),
                        ),
                        Switch(
                            value: is_holiday,
                            onChanged: (newvalue) {
                              setState(() {
                                is_holiday = newvalue;
                              });
                            })
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: () async {
                  if (_addpilotcontroller.text != "" ||
                      _addtugcontroller.text != "" ||
                      _tugnamecontroller.text != "") {
                    await vslEventAction();
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => finalsubmit()));
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
                },
                child: Text(
                  'Submit',
                  style: TextStyle(fontSize: 14),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
