import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import '../model/headerwidget.dart';
import '../utils/urlconstants.dart' as url;
import 'package:path/path.dart';
import 'VesselWiseReport.dart';

class finalsubmit extends StatefulWidget {
  @override
  _finalsubmitState createState() => _finalsubmitState();
}

class _finalsubmitState extends State<finalsubmit> {
  TextEditingController _vslNameController = TextEditingController();
  TextEditingController _callSignController = TextEditingController();
  TextEditingController _grtController = TextEditingController();
  TextEditingController _nrtConroller = TextEditingController();
  TextEditingController _deckCargoController = TextEditingController();
  TextEditingController _LOAController = TextEditingController();
  TextEditingController _flagController = TextEditingController();
  TextEditingController _AgentController = TextEditingController();
  TextEditingController _rotationController = TextEditingController();
  TextEditingController _pilotController = TextEditingController();
  TextEditingController _addpilotController = TextEditingController();
  TextEditingController _addtugController = TextEditingController();
  TextEditingController _remarksController = TextEditingController();
  TextEditingController _tugnameController = TextEditingController();
  TextEditingController pob = TextEditingController();
  TextEditingController dop = TextEditingController();
  TextEditingController firstline = TextEditingController();
  TextEditingController lastline = TextEditingController();
  TextEditingController _berthfromcontroller = TextEditingController();
  TextEditingController _berthincontroller = TextEditingController();

  late DateTime pobdate;
  late DateTime dopdate;
  late DateTime firstlinedate;
  late DateTime lastlinedate;

  String? request_for;
  String? vvd_gkey;
  String? rotation;
  String? berthFrom;
  String? berthname;
  String? isLoggedIn;

  List<String> berthDataArray = <String>[];

  @override
  initState() {
    super.initState();
    onpageload();
  }

  @override
  void dispose() {
    _vslNameController.dispose();
    _AgentController.dispose();
    _addpilotController.dispose();
    _addtugController.dispose();
    _callSignController.dispose();
    _deckCargoController.dispose();
    _flagController.dispose();
    _grtController.dispose();
    _nrtConroller.dispose();
    _pilotController.dispose();
    _remarksController.dispose();
    _rotationController.dispose();
    _tugnameController.dispose();
    _LOAController.dispose();
    pob.dispose();
    dop.dispose();
    firstline.dispose();
    lastline.dispose();
    _berthfromcontroller.dispose();
    _berthincontroller.dispose();

    super.dispose();
  }

  onpageload() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    setState(() {
      request_for = pref.getString('request_for');
      vvd_gkey = pref.getString('vvd_gkey');
      rotation = pref.getString('rotation');
      berthFrom = pref.getString('berthFrom');
      berthname = pref.getString('berthname');
      isLoggedIn = pref.getString('isLoggedIn');
    });

    fetchberth(request_for, vvd_gkey);
    getAllFinalData();

    // vesselEventAction(pob.text, firstline.text, lastline.text, dop.text);

    // if(request_for!=""){}
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
      // berthFrom = jsondata['berthFrom'];

      var data = jsondata['data'];
      // actvberth = data['berth_name'];
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

  // vesselEventEdit() async {}

  final_submit() async {
    const baseUrl = 'http://cpatos.gov.bd/tosapi';

    print(request_for);

    final param = {
      'rotation': rotation,
      'vvd_gkey': vvd_gkey,
      'request_type': request_for,
      'request_for': request_for,
      'addition_pilot': _addpilotController.text.toString(),
      'tug': _tugnameController.text.toString(),
      'remarks': _remarksController.text.toString(),
      'tug_name': _tugnameController.text.toString(),
      'pob': pob.text.toString(),
      'lastLine': lastline.text.toString(),
      'first_Line': firstline.text.toString(),
      'dop': dop.text.toString(),
      'final_submit': "1",
      'berth': berthname.toString(),
    };
    final uri = Uri.parse('$baseUrl/pilot/v03212023/live/set_vessel_event.php');
    print(uri);
    final response = await http.post(uri, body: param);
    print(response.statusCode);

    if (response.statusCode == 200) {
      if (isLoggedIn == "true") {
        var jsondata = json.decode(response.body);
        print(jsondata);
        var success = jsondata['success'];
        if (success == "1") {
          ScaffoldMessenger.of(this.context).showSnackBar(
            SnackBar(
              content: Text("Submitted Successfully"),
              backgroundColor: Colors.purple,
              margin: EdgeInsets.all(10),
              shape: StadiumBorder(),
              behavior: SnackBarBehavior.floating,
              action: SnackBarAction(
                label: 'ok',
                onPressed: success,
                disabledTextColor: Colors.white54,
                textColor: Colors.white,
              ),
            ),
          );

          SharedPreferences pref = await SharedPreferences.getInstance();
          await pref.setString('vvd_gkey', vvd_gkey!);
          await pref.setString('rotation', rotation!);
          await pref.setString('request_for', request_for!);
          await pref.setString('berthFrom', berthFrom!);
          await pref.setString('dop', dop.text);
        }
      }
    } else {
      ScaffoldMessenger.of(this.context).showSnackBar(
        const SnackBar(
          content: Text("Please Login First"),
          backgroundColor: Colors.purple,
          margin: EdgeInsets.all(10),
          shape: StadiumBorder(),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  getAllFinalData() async {
    // get_all_final_data.php
    const baseUrl = 'http://cpatos.gov.bd/tosapi';

    print(request_for);

    final param = {
      'request_for': request_for,
      'vvd_gkey': vvd_gkey,
      'rotation': rotation
    };
    final uri =
        Uri.parse('$baseUrl/pilot/v03212023/live/get_all_final_data.php');
    print(uri);
    final response = await http.post(uri, body: param);
    print(response.statusCode);

    if (response.statusCode == 200) {
      var jsondata = json.decode(response.body);
      print(jsondata);
      var success = jsondata['success'];
      //  berthFrom = jsondata['berthFrom'];

      if (success == "1") {
        var data = jsondata['data'];
        var heading_n4data = jsondata['heading_n4data'];
        if (data.length > 0) {
          var pilot_on_board = data[0]['pilot_on_board'];
          var pilot_off_board = data[0]['pilot_off_board'];
          var mooring_frm_time = data[0]['mooring_frm_time'];
          var mooring_to_time = data[0]['mooring_to_time'];
          var aditional_pilot = data[0]['aditional_pilot'];
          var aditional_tug = data[0]['aditional_tug'];
          var remarks = data[0]['remarks'];
          var tug_name = data[0]['tug_name'];
          var draught = data[0]['draught'];
          berthname = data[0]['berth'];

          if (heading_n4data.length > 0) {
            var radio_call_sign = heading_n4data[0]['RADIO_CALL_SIGN'];
            var loa_cm = heading_n4data[0]['loa_cm'];
            var gross_registered_ton =
                heading_n4data[0]['gross_registered_ton'];
            var net_registered_ton = heading_n4data[0]['net_registered_ton'];
            var localagent = heading_n4data[0]['localagent'];
            var Vessel_Name = heading_n4data[0]['vsl_name'];
            var flag = heading_n4data[0]['flag'];
            var beam_cm = heading_n4data[0]['beam_cm'];

            _callSignController.text = radio_call_sign.toString();
            _LOAController.text = loa_cm.toString();
            _grtController.text = gross_registered_ton.toString();
            _nrtConroller.text = net_registered_ton.toString();
            _AgentController.text = localagent.toString();
            _vslNameController.text = Vessel_Name.toString();
            _flagController.text = flag.toString();
            if (beam_cm == null) {
              _deckCargoController.text = "NIL";
            } else {
              _deckCargoController.text = beam_cm.toString();
            }
          }

          pob.text = pilot_on_board.toString();
          dop.text = pilot_off_board.toString();
          firstline.text = mooring_frm_time.toString();
          lastline.text = mooring_to_time.toString();
          //_pilotController.text=
          _addpilotController.text = aditional_pilot.toString();
          _addtugController.text = aditional_tug.toString();
          _remarksController.text = remarks.toString();
          _tugnameController.text = tug_name.toString();
          _rotationController.text = rotation.toString();
          _berthfromcontroller.text = berthFrom.toString();
          _berthincontroller.text = berthname.toString();
        }
        // return success;
      } else {
        print(request_for);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blueGrey,
          title: const Text('Final Summary'),
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
                padding: const EdgeInsets.all(2),
                child: Row(
                  children: [
                    Flexible(
                      child: TextField(
                        controller: _vslNameController,
                        decoration: const InputDecoration(
                          labelText: 'Vessel Name',
                          labelStyle: TextStyle(
                              fontSize: 12, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 15,
                    ),
                    Flexible(
                      child: TextField(
                        controller: _callSignController,
                        decoration: const InputDecoration(
                            labelText: 'Call Sign',
                            labelStyle: TextStyle(
                                fontSize: 12, fontWeight: FontWeight.bold)),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(2),
                child: Row(
                  children: [
                    Flexible(
                      child: TextField(
                        controller: _grtController,
                        decoration: const InputDecoration(
                          labelText: 'GRT',
                          labelStyle: TextStyle(
                              fontSize: 12, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 15,
                    ),
                    Flexible(
                      child: TextField(
                        controller: _nrtConroller,
                        decoration: const InputDecoration(
                            labelText: 'NRT',
                            labelStyle: TextStyle(
                                fontSize: 12, fontWeight: FontWeight.bold)),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(2),
                child: Row(
                  children: [
                    Flexible(
                      child: TextField(
                        controller: _deckCargoController,
                        decoration: const InputDecoration(
                          labelText: 'Deck Cargo',
                          labelStyle: TextStyle(
                              fontSize: 12, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 15,
                    ),
                    Flexible(
                      child: TextField(
                        controller: _LOAController,
                        decoration: const InputDecoration(
                            labelText: 'LOA(CM)',
                            labelStyle: TextStyle(
                                fontSize: 12, fontWeight: FontWeight.bold)),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(2),
                child: Row(
                  children: [
                    Flexible(
                      child: TextField(
                        controller: _flagController,
                        decoration: const InputDecoration(
                          labelText: 'Flag',
                          labelStyle: TextStyle(
                              fontSize: 12, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 15,
                    ),
                    Flexible(
                      child: TextField(
                        controller: _AgentController,
                        decoration: const InputDecoration(
                            labelText: 'Agent',
                            labelStyle: TextStyle(
                                fontSize: 12, fontWeight: FontWeight.bold)),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(2),
                child: Row(
                  children: [
                    Flexible(
                      child: TextField(
                        controller: _rotationController,
                        decoration: const InputDecoration(
                          labelText: 'Rotation',
                          labelStyle: TextStyle(
                              fontSize: 12, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 15,
                    ),
                    Flexible(
                      child: TextField(
                        controller: _pilotController,
                        decoration: const InputDecoration(
                            labelText: 'Pilot',
                            labelStyle: TextStyle(
                                fontSize: 12, fontWeight: FontWeight.bold)),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(2),
                child: Row(
                  children: [
                    Flexible(
                      child: TextField(
                        controller: _addpilotController,
                        decoration: const InputDecoration(
                          labelText: 'Additional Pilot',
                          labelStyle: TextStyle(
                              fontSize: 12, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 15,
                    ),
                    Flexible(
                      child: TextField(
                        controller: _addtugController,
                        decoration: const InputDecoration(
                            labelText: 'Additional Tug',
                            labelStyle: TextStyle(
                                fontSize: 12, fontWeight: FontWeight.bold)),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(2),
                child: Row(
                  children: [
                    Flexible(
                      child: TextField(
                        controller: _remarksController,
                        decoration: const InputDecoration(
                          labelText: 'Remarks',
                          labelStyle: TextStyle(
                              fontSize: 12, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 15,
                    ),
                    Flexible(
                      child: TextField(
                        controller: _tugnameController,
                        decoration: const InputDecoration(
                            labelText: 'Tug Name',
                            labelStyle: TextStyle(
                                fontSize: 12, fontWeight: FontWeight.bold)),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 5),
              HeaderWidget("P.O.B"),
              Container(
                // width: MediaQuery.of(context).size.width,
                // height: MediaQuery.of(context).size.height,
                color: Colors.orange[50],

                child: Column(
                  children: [
                    TextField(
                      controller: pob,
                      readOnly: true,
                      onTap: () => pobdatetime(context),
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
                    // Text(
                    //   "Berth From:",
                    //   style: TextStyle(
                    //       color: Color.fromARGB(255, 97, 2, 113),
                    //       fontWeight: FontWeight.bold),
                    // ),
                    if (request_for == 'incoming') ...[
                      TextField(
                        enabled: false,
                        controller: _berthfromcontroller,
                        decoration: const InputDecoration(
                            labelText: 'Shifting From',
                            labelStyle: TextStyle(
                                fontSize: 12, fontWeight: FontWeight.bold)),
                      ),
                    ] else ...[
                      Autocomplete(
                        initialValue: TextEditingValue(text: '$berthFrom'),
                        optionsBuilder: (TextEditingValue textEditingValue) {
                          if (textEditingValue.text == '') {
                            return const Iterable<String>.empty();
                          } else {
                            List<String> matches = <String>[];
                            matches.addAll(berthDataArray);

                            matches.retainWhere((s) {
                              return s.toLowerCase().contains(
                                  textEditingValue.text.toLowerCase());
                            });
                            return matches;
                          }
                        },
                        onSelected: (String selection) {
                          setState(() {
                            berthFrom = selection;
                          });
                        },
                      ),
                    ],

                    // ignore: prefer_const_constructors
                  ],
                ),
              ),
              const SizedBox(height: 5),
              if (request_for == 'shifting') ...[
                HeaderWidget("Last Line"),
                Container(
                  color: Colors.blue[50],
                  child: Column(
                    children: [
                      TextField(
                        controller: lastline,
                        readOnly: true,
                        onTap: () => lastlinedatetime(context),
                        // ignore: prefer_const_constructors
                        decoration: InputDecoration(
                          labelText: 'Last Line',
                          labelStyle: const TextStyle(
                            color: Colors.black87,
                            fontSize: 15,
                          ),
                          suffixIcon: const Icon(Icons.calendar_today),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
              const SizedBox(height: 5),
              HeaderWidget("First Line Ashore"),
              Container(
                color: Colors.yellow[100],
                child: Column(
                  children: [
                    TextField(
                      controller: firstline,
                      readOnly: true,
                      onTap: () => firstlinedatetime(context),
                      // ignore: prefer_const_constructors
                      decoration: InputDecoration(
                        labelText: 'First Line Time',
                        labelStyle: const TextStyle(
                          color: Colors.black87,
                          fontSize: 15,
                        ),
                        suffixIcon: const Icon(Icons.calendar_today),
                      ),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Text(
                      "Berth Name:",
                      style: TextStyle(
                          color: Colors.blue[900], fontWeight: FontWeight.bold),
                    ),

                    Autocomplete(
                      // initialValue:
                      //     TextEditingValue(text: "$berthname".toString()),
                      optionsBuilder: (TextEditingValue textEditingValue) {
                        if (textEditingValue.text == '') {
                          return const Iterable<String>.empty();
                        } else {
                          List<String> matches = [];
                          matches.addAll(berthDataArray);

                          matches.retainWhere((s) {
                            return s
                                .toLowerCase()
                                .contains(textEditingValue.text.toLowerCase());
                          });
                          return matches;
                        }
                      },
                      fieldViewBuilder: ((context, textEditingController,
                          focusNode, onFieldSubmitted) {
                        return TextFormField(
                          controller: _berthincontroller,
                          focusNode: focusNode,
                          onEditingComplete: onFieldSubmitted,
                          decoration:
                              const InputDecoration(hintText: 'Your hint text'),
                        );
                      }),
                      onSelected: (String selection) {
                        setState(() {
                          berthname = selection;
                        });
                      },
                    ),
                    // ignore: prefer_const_constructors
                  ],
                ),
              ),
              const SizedBox(
                height: 5,
              ),
              HeaderWidget("D.O.P"),
              Container(
                color: Colors.brown[50],
                child: Column(
                  children: [
                    TextField(
                      controller: dop,
                      readOnly: true,
                      onTap: () => dopdatetime(context),
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
                  ],
                ),
              ),
              const SizedBox(
                height: 5,
              ),
              ElevatedButton(
                onPressed: () async {
                  await final_submit();
                  // Navigator.push(context,
                  //     MaterialPageRoute(builder: (context) => HomePage()));
                  final api =
                      Uri.parse(url.UrlConstants().GETVESSELREPORTSPI());
                  String vesselRotation =
                      rotation.toString().replaceAll("/", "_");
                  final urlString =
                      "$api/$vesselRotation/$vvd_gkey/$request_for";
                  final file = await loadPdfFromNetwork(urlString);

                  openPdf(context, file, urlString);
                },
                child: const Text(
                  'Submit',
                  style: TextStyle(fontSize: 14),
                ),
              ),
            ],
          ),
        )));
  }

  Future<void> lastlinedatetime(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
    );

    if (picked != null) {
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
          lastlinedate = combinedDateTime;
          lastline.text =
              DateFormat('yyyy-MM-dd HH:mm').format(combinedDateTime);
        });
      }
    }
  }

  Future<void> firstlinedatetime(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
    );

    if (picked != null) {
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
          firstlinedate = combinedDateTime;
          firstline.text =
              DateFormat('yyyy-MM-dd HH:mm').format(combinedDateTime);
        });
      }
    }
  }

  Future<void> dopdatetime(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
    );

    if (picked != null) {
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
          dopdate = combinedDateTime;
          dop.text = DateFormat('yyyy-MM-dd HH:mm').format(combinedDateTime);
        });
      }
    }
  }

  Future<void> pobdatetime(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
    );

    if (picked != null) {
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
          pobdate = combinedDateTime;
          pob.text = DateFormat('yyyy-MM-dd HH:mm').format(combinedDateTime);
        });
      }
    }
  }

  Future<File> loadPdfFromNetwork(String url) async {
    final response = await http.get(Uri.parse(url));
    final bytes = response.bodyBytes;
    return _storeFile(url, bytes);
  }

  Future<File> _storeFile(String url, List<int> bytes) async {
    final filename = basename(url);
    final dir = await getApplicationDocumentsDirectory();
    final file = File('${dir.path}/$filename');
    await file.writeAsBytes(bytes, flush: true);
    if (kDebugMode) {
      print('$file');
    }
    return file;
  }

  void openPdf(BuildContext context, File file, String url) =>
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => VesselWiseReport(
            file: file,
            url: url,
          ),
        ),
      );
}
