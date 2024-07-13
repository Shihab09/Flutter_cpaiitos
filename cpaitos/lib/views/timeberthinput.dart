import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import '../model/headerwidget.dart';
import 'additionalinformation.dart';

class Timeberthin extends StatefulWidget {
  @override
  _TimeberthinState createState() => _TimeberthinState();
}

class _TimeberthinState extends State<Timeberthin> {
  TextEditingController pob = TextEditingController();
  TextEditingController firstline = TextEditingController();
  TextEditingController lastline = TextEditingController();
  TextEditingController dop = TextEditingController();
  TextEditingController berthcontroller = TextEditingController();

  late DateTime _pobDateTime;
  late DateTime _firstlineDateTime;
  late DateTime _lastlineDateTime;
  late DateTime _dopDateTime;

  String? request_for;
  String? vvd_gkey;
  String? rotation;
  String? berthFrom;
  String? isLoggedIn;

  String? berthname;
  List<String> berthDataArray = <String>[];

  @override
  initState() {
    super.initState();
    onpageload();
  }

  @override
  void dispose() {
    pob.dispose();
    firstline.dispose();
    lastline.dispose();
    dop.dispose();
    super.dispose();
  }

  void _cleartext() {
    pob.clear();
    firstline.clear();
    dop.clear();
    lastline.clear();
  }

  scaffoldtext(String text) {
    ScaffoldMessenger.of(this.context).showSnackBar(
      SnackBar(
        content: Text(text),
        backgroundColor: Colors.purple,
        margin: EdgeInsets.all(10),
        shape: StadiumBorder(),
        behavior: SnackBarBehavior.floating,
        action: SnackBarAction(
          label: 'ok',
          onPressed: _cleartext,
          disabledTextColor: Colors.white54,
          textColor: Colors.white,
        ),
      ),
    );
  }

  timechecker() {
    DateTime pobtime = DateTime.parse(_pobDateTime.toString());
    DateTime firstlinetime = DateTime.parse(_firstlineDateTime.toString());
    DateTime lastlinetime = DateTime.parse(_lastlineDateTime.toString());
    DateTime doptime = DateTime.parse(_dopDateTime.toString());

    if (request_for != null) {
      if (pobtime == "" ||
          firstlinetime == "" ||
          lastlinetime == "" ||
          doptime == "") {
        // ScaffoldMessenger.of(this.context).showSnackBar(
        //   SnackBar(
        //     content: Text("Please fill all fields"),
        //     backgroundColor: Colors.purple,
        //     margin: EdgeInsets.all(10),
        //     shape: StadiumBorder(),
        //     behavior: SnackBarBehavior.floating,
        //     action: SnackBarAction(
        //       label: 'ok',
        //       onPressed: _cleartext,
        //       disabledTextColor: Colors.white54,
        //       textColor: Colors.white,
        //     ),
        //   ),
        // );

        String msg = "Please fill all fields";
        scaffoldtext(msg);
      } else if (pobtime.isAtSameMomentAs(doptime) ||
          pobtime.isAfter(doptime)) {
        String msg = "Please give accurate time";
        scaffoldtext(msg);
        print("Please give accurate time");
      } else if (request_for == "shifting" ||
          firstlinetime.isAtSameMomentAs(lastlinetime) ||
          firstlinetime.isAfter(lastlinetime)) {
        String msg = "Please check your time input";
        scaffoldtext(msg);
      }
      // } else if (request_for == "shifting") {
      //   if (pobtime.isAtSameMomentAs(doptime)) {
      //     print("Both DateTime are at same moment.");
      //   }
      // } else if (request_for == "outgoing") {
      //   if (pobtime.isAtSameMomentAs(doptime)) {
      //     print("Both DateTime are at same moment.");
      //   }
      // }
    }
  }

  onpageload() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    setState(() {
      request_for = pref.getString('request_for');
      vvd_gkey = pref.getString('vvd_gkey');
      rotation = pref.getString('rotation');
      isLoggedIn = pref.getString('isLoggedIn');
    });

    fetchberth(request_for, vvd_gkey);
    await pref.setString('isLoggedIn', isLoggedIn!);
    print(isLoggedIn!);
  }

  fetchberth(request, vvd) async {
    const baseUrl = 'http://cpatos.gov.bd/tosapi';

    print(request_for);

    final param = {'request_for': request, 'vvd_gkey': vvd};
    final uri = Uri.parse('$baseUrl/pilot/v03212023/live/get_berth_list.php');
    print(uri);
    final response = await http.post(uri, body: param);
    print(response.statusCode);

    if (response.statusCode == 200) {
      var jsondata = json.decode(response.body);
      print(jsondata);
      var success = jsondata['success'];
      berthFrom = jsondata['berthFrom'];

      var data = jsondata['data'];
      if (success == "1") {
        for (int i = 0; i < data.length; i++) {
          berthDataArray.add(data[i]['berth_name']);
        }
        print(berthDataArray);
      } else {
        print("Berth Data No Found!!");
      }

      // return success;
    } else {
      print(request);
    }
  }

  vesselEventAction(String pb, String first, String last, String dp) async {
    const baseUrl = 'http://cpatos.gov.bd/tosapi';

    print(request_for);
    // pb = pob.text;
    // first = firstline.text;
    // last = lastline.text;
    // dp = dop.text;

    final param = {
      'rotation': rotation,
      'vvd_gkey': vvd_gkey,
      'request_type': request_for,
      'pilot_name': "devpilot",
      'pob': pb,
      'lastLine': last,
      'firstLine': first,
      'dop': dp,
      'final_submit': "0",
      'berth_from': berthFrom,
      'berth': berthname
    };
    final uri = Uri.parse('$baseUrl/pilot/v03212023/live/set_vessel_event.php');
    print(uri);
    final response = await http.post(uri, body: param);
    print(response.statusCode);

    if (response.statusCode == 200) {
      var jsondata = json.decode(response.body);
      print(jsondata);
      var success = jsondata['success'];
      if (success == "1") {
        print("successive");
        // print(rotation);

        // print(berthFrom);
        // print(dop.text);

        SharedPreferences pref = await SharedPreferences.getInstance();
        await pref.setString('vvd_gkey', vvd_gkey!);
        await pref.setString('rotation', rotation!);
        await pref.setString('request_for', request_for!);
        await pref.setString('berthFrom', berthFrom!);
        await pref.setString('dop', dop.text);
        await pref.setString('isLoggedIn', 'true');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Pilot Operation"),
        backgroundColor: Colors.blueGrey,
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: pob,
              readOnly: true,
              onTap: () => _selectDateTime1(context),
              // ignore: prefer_const_constructors
              decoration: InputDecoration(
                labelText: 'P.O.B',
                labelStyle: const TextStyle(
                  color: Colors.black87,
                  fontSize: 15,
                ),
                suffixIcon: const Icon(Icons.calendar_today),
              ),
            ),

            if (request_for == 'shifting') ...[
              Padding(
                // ignore: prefer_const_constructors
                padding: EdgeInsets.symmetric(
                  vertical: 10,
                ),
                child: Autocomplete(
                  // initialValue: TextEditingValue(text: 'Enter Berth Name'),
                  optionsBuilder: (TextEditingValue textEditingValue) {
                    if (textEditingValue.text == '') {
                      return const Iterable<String>.empty();
                    } else {
                      List<String> matches = <String>[];
                      matches.addAll(berthDataArray);

                      matches.retainWhere((s) {
                        return s
                            .toLowerCase()
                            .contains(textEditingValue.text.toLowerCase());
                      });
                      return matches;
                    }
                  },

                  onSelected: (String selection) {
                    setState(() {
                      if (request_for == 'incoming') {
                        berthFrom = 'SEA';
                      } else
                        berthFrom = selection;
                    });
                  },
                ),
                // ignore: prefer_const_constructors

                // return const CircularProgressIndicator();
              ),
            ],
            const SizedBox(height: 16.0),
            TextField(
              controller: firstline,
              readOnly: true,
              onTap: () => _selectDateTime2(context),
              // ignore: prefer_const_constructors
              decoration: InputDecoration(
                labelText: 'First Line Ashore',
                labelStyle: const TextStyle(
                  color: Colors.black87,
                  fontSize: 15,
                ),
                suffixIcon: const Icon(Icons.calendar_today),
              ),
            ),
            SizedBox(height: 16.0),
            if (request_for == "shifting") ...[
              TextField(
                controller: lastline,
                readOnly: true,
                onTap: () => _selectDateTime3(context),
                // ignore: prefer_const_constructors

                decoration: InputDecoration(
                  labelText: 'Last Line Ashore',
                  labelStyle: const TextStyle(
                    color: Colors.black87,
                    fontSize: 15,
                  ),
                  suffixIcon: const Icon(Icons.calendar_today),
                ),
              ),
            ],

            const SizedBox(height: 16.0),
            TextField(
              controller: dop,
              readOnly: true,
              onTap: () => _selectDateTime4(context),
              // ignore: prefer_const_constructors
              decoration: InputDecoration(
                labelText: 'D.O.P',
                labelStyle: const TextStyle(
                  color: Colors.black87,
                  fontSize: 15,
                ),
                suffixIcon: const Icon(Icons.calendar_today),
              ),
            ),
            SizedBox(height: 10),
            // Container(
            //   padding: EdgeInsets.symmetric(vertical: 5),
            //   child: const Center(
            //     child: Text(
            //       "Enter Berth Name Below:",
            //       style: TextStyle(
            //           color: Colors.black87,
            //           fontSize: 15,
            //           fontWeight: FontWeight.bold),
            //     ),
            //   ),
            // ),
            HeaderWidget("Enter Berth:"),
            Padding(
              // ignore: prefer_const_constructors
              padding: EdgeInsets.symmetric(
                vertical: 10,
              ),
              child: Autocomplete(
                // initialValue: TextEditingValue(text: 'Enter Berth Name'),
                optionsBuilder: (TextEditingValue textEditingValue) {
                  if (textEditingValue.text == '') {
                    return const Iterable<String>.empty();
                  } else {
                    List<String> matches = <String>[];
                    matches.addAll(berthDataArray);

                    matches.retainWhere((s) {
                      return s
                          .toLowerCase()
                          .contains(textEditingValue.text.toLowerCase());
                    });
                    return matches;
                  }
                },

                onSelected: (String selection) {
                  setState(() {
                    berthname = selection;
                  });
                },
              ),
              // ignore: prefer_const_constructors

              // return const CircularProgressIndicator();
            ),
            ElevatedButton(
              onPressed: () async {
                timechecker();
                SharedPreferences pref = await SharedPreferences.getInstance();
                await pref.setString('berthname', berthname!);
                var pbo = pob.text.toString();
                var fstln = firstline.text.toString();
                var lstln = lastline.text.toString();
                var dbo = dop.text.toString();
                if (isLoggedIn == "true") {
                  vesselEventAction(pbo, fstln, lstln, dbo);
                  // ignore: use_build_context_synchronously
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => Additionalinfo()));
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
              child: Text('Proceed'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _selectDateTime1(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
    );

    if (picked != null) {
      // ignore: use_build_context_synchronously
      final TimeOfDay? selectedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
      );

      if (selectedTime != null) {
        final DateTime combinedDateTime = DateTime(
          picked.year,
          picked.month,
          picked.day,
          selectedTime.hour,
          selectedTime.minute,
        );

        setState(() {
          _pobDateTime = combinedDateTime;
          pob.text = DateFormat('yyyy-MM-dd HH:mm').format(combinedDateTime);
        });
      }
    }
  }

  Future<void> _selectDateTime2(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
    );

    if (picked != null) {
      // ignore: use_build_context_synchronously
      final TimeOfDay? selectedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
      );

      if (selectedTime != null) {
        final DateTime combinedDateTime = DateTime(
          picked.year,
          picked.month,
          picked.day,
          selectedTime.hour,
          selectedTime.minute,
        );

        setState(() {
          _firstlineDateTime = combinedDateTime;
          firstline.text =
              DateFormat('yyyy-MM-dd HH:mm').format(combinedDateTime);
        });
      }
    }
  }

  Future<void> _selectDateTime3(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
    );

    if (picked != null) {
      // ignore: use_build_context_synchronously
      final TimeOfDay? selectedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
      );

      if (selectedTime != null) {
        final DateTime combinedDateTime = DateTime(
          picked.year,
          picked.month,
          picked.day,
          selectedTime.hour,
          selectedTime.minute,
        );

        setState(() {
          _lastlineDateTime = combinedDateTime;
          lastline.text =
              DateFormat('yyyy-MM-dd HH:mm').format(combinedDateTime);
        });
      }
    }
  }

  Future<void> _selectDateTime4(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
    );

    if (picked != null) {
      // ignore: use_build_context_synchronously
      final TimeOfDay? selectedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
      );

      if (selectedTime != null) {
        final DateTime combinedDateTime = DateTime(
          picked.year,
          picked.month,
          picked.day,
          selectedTime.hour,
          selectedTime.minute,
        );

        setState(() {
          _dopDateTime = combinedDateTime;
          dop.text = DateFormat('yyyy-MM-dd HH:mm').format(combinedDateTime);
        });
      }
    }
  }
}
