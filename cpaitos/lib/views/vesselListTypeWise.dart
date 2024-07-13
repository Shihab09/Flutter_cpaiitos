import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'vesseldetails.dart';

class Vessellist extends StatefulWidget {
  @override
  _VessellistWidgetState createState() => _VessellistWidgetState();
}

class _VessellistWidgetState extends State<Vessellist> {
  List<dynamic> _futureVessels = [];
  // dynamic vessel;
  List filteredTempVesselList = [];
  List<dynamic> vListTemp = [];
  bool visible = false;
  String searchString = " ";
  TextEditingController _textEditingController = TextEditingController();

  void filterVessel(value) {
    setState(() {
      _futureVessels = vListTemp
          .where((vlist) => vlist['name']!
                      .toLowerCase()
                      .contains(value.toLowerCase()) !=
                  false
              ? vlist['name']!.toLowerCase().contains(value.toLowerCase())
              : vlist['ib_vyg']!.toLowerCase().contains(value.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Vessel List"),
        backgroundColor: Colors.blueGrey,
      ),
      body: //Expanded(
          //child:
          _textEditingController.text.isNotEmpty && _futureVessels.isEmpty
              ? Center(
                  child: Padding(
                    padding: EdgeInsets.all(10.0),
                    child: Column(
                      children: const [
                        Padding(
                          padding: EdgeInsets.all(5.0),
                          child: Text(
                            'No results found,\nPlease try different keyword',
                            style: TextStyle(
                                fontSize: 14, fontWeight: FontWeight.normal),
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              : _futureVessels.isNotEmpty
                  ? Padding(
                      padding: const EdgeInsets.all(5),
                      child: Column(
                        verticalDirection: VerticalDirection.down,
                        children: [
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 15.0),
                            child: TextField(
                              onChanged: (value) {
                                setState(() {
                                  //your code
                                  filterVessel(value);
                                });
                              },
                              decoration: InputDecoration(
                                labelText: 'Search Vessel',
                                prefixIcon: const Icon(Icons.search),
                                contentPadding:
                                    const EdgeInsets.fromLTRB(8, 5, 10, 5),
                                fillColor: Colors.white,
                                filled: true,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(2.0),
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: Container(
                              decoration: const BoxDecoration(
                                image: DecorationImage(
                                    opacity: -30,
                                    image: AssetImage("images/cpa.png"),
                                    fit: BoxFit.cover),
                              ),
                              width: MediaQuery.of(context).size.width,
                              height: MediaQuery.of(context).size.height,
                              padding: const EdgeInsets.symmetric(
                                  vertical: 10.0, horizontal: 2.0),
                              child: ListView.separated(
                                  itemCount: _futureVessels.length,
                                  separatorBuilder:
                                      (BuildContext context, int index) =>
                                          const Divider(),
                                  itemBuilder: (context, index) {
                                    dynamic vessel = _futureVessels[index];
                                    dynamic name = vessel!['name'];
                                    dynamic rotation = vessel!['ib_vyg'];
                                    dynamic agent = vessel!['agent'];
                                    dynamic eta = vessel!['eta'];
                                    return Container(
                                        color: (index % 2 == 0)
                                            ? Color.fromARGB(95, 212, 231, 241)
                                            : Color.fromARGB(84, 212, 210, 234),
                                        child: ListTile(
                                          key: ValueKey(
                                              _futureVessels[index]["id"]),
                                          isThreeLine: true,
                                          trailing:
                                              const Icon(Icons.navigate_next),
                                          title: Text(
                                              // ignore: prefer_interpolation_to_compose_strings
                                              '${'Vessel Name:' + name + '\n' + 'Agent:' + agent}\nETA:' +
                                                  eta),
                                          subtitle: Text("Rotation:$rotation"),
                                          onTap: () {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        Vesseldetails(vessel)));
                                          },
                                        ));
                                  }),
                            ),
                          ),
                        ],
                      ),
                    )
                  : Center(
                      child: Visibility(
                        maintainSize: true,
                        maintainAnimation: true,
                        maintainState: true,
                        visible: visible,
                        child: const SpinKitThreeBounce(color: Colors.green),
                      ),
                    ),
      // ),
    );
  }

  @override
  void initState() {
    super.initState();
    fetchVessels();
  }

  void fetchVessels() async {
    const baseUrl = 'http://cpatos.gov.bd/tosapi';
    visible = true;
    SharedPreferences pref = await SharedPreferences.getInstance();
    final listtype = pref.getString('request_for');
    String? isLoggedIn = pref.getString('isLoggedIn');
    pref.setString('request_for:', listtype!);
    pref.setString('isLoggedIn:', isLoggedIn!);

    // print(listtype);

    final queryParams = {'request_for': listtype};
    final uri = Uri.parse('$baseUrl/pilot/v03212023/live/get_vessel_list.php');
    final response = await http.post(uri, body: queryParams);
    if (response.statusCode == 200) {
      // if (isLoggedIn == "true") {
      final jsondata = json.decode(response.body);
      setState(() {
        visible = false;
        _futureVessels = filteredTempVesselList = vListTemp = jsondata['data'];
      });
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
}
// }
