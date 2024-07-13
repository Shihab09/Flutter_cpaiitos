// ignore: file_names
// ignore_for_file: library_private_types_in_public_api, camel_case_types, avoid_print

import 'dart:convert';
import 'package:sticky_headers/sticky_headers/widget.dart';
import '../model/PostsModel.dart';
import '../views/ReportListView.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import '../utils/urlconstants.dart' as url;
import 'package:shared_preferences/shared_preferences.dart';

import 'vesselListTypeWise.dart';

class PilotageLandingPage extends StatefulWidget {
  const PilotageLandingPage({super.key});

  @override
  _pilotagelandingState createState() => _pilotagelandingState();
}

class _pilotagelandingState extends State<PilotageLandingPage> {
//late Future<TotalCount?> futureValue;

  List<Data> dataList = [];
  String? startDate;
  String? endDate;
  String? userId;
  String? isLoggedIn;

  sharedpref() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    userId = pref.getString("user_id")!;
    isLoggedIn = pref.getString("isLoggedIn");
    await pref.setString('isLoggedIn', isLoggedIn!);
    // await pref.setString('rotation', Rotaion!);
  }

  Future<List<Data>> getPostApi() async {
    print("print user id====");
    print(userId);
    // SharedPreferences pref = await SharedPreferences.getInstance();
    // userId = pref.getString("user_id")!;
    final body = {'user_id': userId};
    final urlString = Uri.parse(url.UrlConstants().TOTALCOUNTAPI());
    final response = await http.post(urlString, body: body);

    var jsonData = json.decode(response.body);
    final dataCount = jsonData['data'];
    print(dataCount);
    if (response.statusCode == 200) {
      for (Map i in dataCount) {
        dataList.add(Data.fromJson(i));
      }
      print(dataList[0].totalVslArrival);
      return dataList;
    } else {
      return dataList;
    }
  }

  List<String> listHeader = ['Summary', 'Services', 'Reports'];
  List<String> servicesTitle = ['Incoming', 'Shifting', 'Outgoing', 'Cancel'];
  List<String> servicesImage = [
    'assets/images/incomin_vsl.png',
    'assets/images/shifting_vsl.png',
    'assets/images/outgoing_vsl.png',
    'assets/images/cancel.png'
  ];
  List<String> summaryTitle = [
    'Total Incoming',
    'Total Shifting',
    'Total Outgoing',
    'Total Cancel'
  ];

  List<String> listTitle = [
    'title1',
    'title2',
  ];
  var size, height, width;
  TextEditingController fromDateinput = TextEditingController();
  TextEditingController toDateinput = TextEditingController();
  String dropdownvalue = 'Service Type';

  // List of items in our dropdown menu
  var items = [
    'Service Type',
    'Incoming',
    'Shifting',
    'Outgoing',
    'Cancel',
    'All'
  ];
  String someVal = '';
  @override
  initState() {
    super.initState();
    sharedpref();
  }

  // MySnackBar(message, context) {
  //   return ScaffoldMessenger.of(context)
  //       .showSnackBar(SnackBar(content: Text(message)));
  // }

  @override
  Widget build(BuildContext context) {
    //size = MediaQuery.of(context).size;
    //height = size.height;
    //width = size.width;
    // print("height====2023");
    //print(height);
    return Scaffold(
      appBar: AppBar(
        title: const Text("Pilotage Module"),
        backgroundColor: Colors.blueGrey,
      ),
      body: pilotageWidget(),
    );
  }

  Widget pilotageWidget() {
    return ListView.builder(
      itemCount: listHeader.length,
      itemBuilder: (context, index) {
        return StickyHeader(
          header: Container(
            height: 38.0,
            color: Colors.white70,
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            alignment: Alignment.centerLeft,
            child: Text(
              listHeader[index],
              style: const TextStyle(
                  color: Colors.black,
                  fontSize: 20,
                  fontWeight: FontWeight.bold),
            ),
          ),
          content: Container(
              margin: const EdgeInsets.all(5),
              //width: MediaQuery.of(context).size.width,
              //height: MediaQuery.of(context).size.height,
              color: Color.fromARGB(250, 242, 238, 238),
              child: LayoutBuilder(builder: (context, constraints) {
                if (index == 0) {
                  return GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: 4,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 4,
                      childAspectRatio: 1,
                    ),
                    itemBuilder: (contxt, index) {
                      return Container(
                        margin: const EdgeInsets.all(5),
                        //height: MediaQuery.of(context).size.height / 4,
                        //color: Color.fromARGB(31, 3, 16, 198),
                        child: Card(
                          semanticContainer: true,
                          // clipBehavior: Clip.antiAliasWithSaveLayer,
                          //margin: EdgeInsets.all(10),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(100)),
                          shadowColor: const Color.fromRGBO(176, 234, 205, 1),
                          color: const Color.fromRGBO(176, 234, 205, 1),
                          elevation: 10,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              FutureBuilder(
                                future: getPostApi(),
                                builder: (context, snapshot) {
                                  if (snapshot.hasData) {
                                    print('response future data====');
                                    print(snapshot.data?[0].totalVslArrival);
                                    if (index == 0) {
                                      return Text(
                                        '${snapshot.data?[0].totalVslArrival}',
                                        maxLines: 1,
                                        textAlign: TextAlign.center,
                                        style: const TextStyle(
                                          fontSize: 16,
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      );
                                    } else if (index == 1) {
                                      return Text(
                                        '${snapshot.data?[0].totalVslShift}',
                                        maxLines: 1,
                                        textAlign: TextAlign.center,
                                        style: const TextStyle(
                                          fontSize: 16,
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      );
                                    } else if (index == 2) {
                                      return Text(
                                        '${snapshot.data?[0].totalVslDepart}',
                                        maxLines: 1,
                                        textAlign: TextAlign.center,
                                        style: const TextStyle(
                                          fontSize: 16,
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      );
                                    } else if (index == 3) {
                                      return Text(
                                        '${snapshot.data?[0].totalVslCancel}',
                                        maxLines: 1,
                                        textAlign: TextAlign.center,
                                        style: const TextStyle(
                                          fontSize: 16,
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      );
                                    }
                                  } else if (snapshot.hasError) {
                                    print('${snapshot.error}');
                                    return const Text('2222');
                                  }
                                  // By default, show a loading spinner.
                                  return const CircularProgressIndicator();
                                },
                              ),
                              Text(
                                summaryTitle[index],
                                maxLines: 2,
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  fontSize: 10,
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }, //item builder
                  );
                } else if (index == 1) {
                  return GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: 4,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 4,
                      childAspectRatio: 1,
                    ),
                    itemBuilder: (contxt, index) {
                      return GestureDetector(
                        onTap: () async {
                          if (index == 0) {
                            SharedPreferences pref =
                                await SharedPreferences.getInstance();
                            pref.setString('request_for', 'incoming');
                            //incoming
                            // ignore: use_build_context_synchronously
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => Vessellist()),
                            );
                          } else if (index == 1) {
                            SharedPreferences pref =
                                await SharedPreferences.getInstance();
                            pref.setString('request_for', 'shifting');
                            //shifting
                            // ignore: use_build_context_synchronously
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => Vessellist()),
                            );
                          } else if (index == 2) {
                            SharedPreferences pref =
                                await SharedPreferences.getInstance();
                            pref.setString('request_for', 'outgoing');
                            //outgoing
                            // ignore: use_build_context_synchronously
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => Vessellist()),
                            );
                          } else if (index == 3) {
                            SharedPreferences pref =
                                await SharedPreferences.getInstance();
                            pref.setString('request_for', 'cancel');
                            //cancel
                            // ignore: use_build_context_synchronously
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => Vessellist()),
                            );
                          }
                        },
                        child: Card(
                          elevation: 20,
                          shadowColor: Colors.black,
                          color: Colors.greenAccent[100],
                          child: Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              image: DecorationImage(
                                image: AssetImage(servicesImage[index]),
                                fit: BoxFit
                                    .fill, // Make the image stretch to fill the container
                              ),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Text(
                                  servicesTitle[index],
                                  maxLines: 1,
                                  textAlign: TextAlign.end,
                                  style: const TextStyle(
                                    fontSize: 14,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    backgroundColor:
                                        Color.fromARGB(255, 12, 11, 11),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ), //Card

                        // ],
                        // ),
                        // ),
                      );
                    }, //item builder
                  );
                } else {
                  return GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: 1,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 1,
                      childAspectRatio: 1,
                    ),
                    itemBuilder: (context, indx) {
                      return Card(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                          shadowColor: const Color.fromRGBO(176, 234, 205, 1),
                          color: const Color.fromRGBO(176, 234, 205, 1),
                          //elevation: 115,
                          child: Column(children: [
                            Table(
                              children: [
                                TableRow(children: [
                                  TableCell(
                                    verticalAlignment:
                                        TableCellVerticalAlignment.middle,
                                    child: TextField(
                                      controller: fromDateinput,
                                      decoration: const InputDecoration(
                                          icon: Icon(Icons.calendar_today),
                                          labelText: "From Date"),
                                      readOnly: true,
                                      onTap: () async {
                                        DateTime? fromDate =
                                            await showDatePicker(
                                                context: context,
                                                initialDate: DateTime.now(),
                                                firstDate: DateTime(2000),
                                                lastDate: DateTime(2101));
                                        if (fromDate != null) {
                                          print(fromDate);
                                          String formattedDate =
                                              DateFormat('yyyy-MM-dd')
                                                  .format(fromDate);
                                          //print(fromDate);
                                          setState(() {
                                            fromDateinput.text = formattedDate;
                                            startDate = fromDateinput.text;
                                          });
                                        } else {
                                          print("From Date is not selected");
                                        }
                                      },
                                    ),
                                  ),
                                  TextField(
                                    controller: toDateinput,
                                    decoration: const InputDecoration(
                                        icon: Icon(Icons.calendar_today),
                                        labelText: "To Date"),
                                    readOnly: true,
                                    onTap: () async {
                                      DateTime? toDate = await showDatePicker(
                                          context: context,
                                          initialDate: DateTime.now(),
                                          firstDate: DateTime(2000),
                                          lastDate: DateTime(2101));
                                      if (toDate != null) {
                                        print(toDate);
                                        String formattedDate =
                                            DateFormat('yyyy-MM-dd')
                                                .format(toDate);
                                        print(toDate);
                                        setState(() {
                                          toDateinput.text = formattedDate;
                                          endDate = toDateinput.text;
                                        });
                                      } else {
                                        print(" To Date is not selected");
                                      }
                                    },
                                  ),
                                ]),
                                TableRow(children: [
                                  TableCell(
                                    verticalAlignment:
                                        TableCellVerticalAlignment.middle,
                                    child: SizedBox(
                                      height: 70,
                                      width: 500,
                                      child: Center(
                                        child: DropdownButton(
                                          // Initial Value
                                          value: dropdownvalue,

                                          // Down Arrow Icon
                                          icon: const Icon(
                                              Icons.keyboard_arrow_down),
                                          // Array list of items
                                          items: items.map((String items) {
                                            return DropdownMenuItem(
                                              value: items,
                                              child: Text(items),
                                            );
                                          }).toList(),
                                          // After selecting the desired option,it will
                                          // change button value to selected value
                                          onChanged: (String? newValue) {
                                            setState(() {
                                              dropdownvalue = newValue!;
                                            });
                                          },
                                        ),
                                      ),
                                    ),
                                  ),
                                  TableCell(
                                    verticalAlignment:
                                        TableCellVerticalAlignment.middle,
                                    child: SizedBox(
                                      height: 70,
                                      child: Center(
                                          child: ElevatedButton(
                                              onPressed: () {
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          ReportListView(
                                                            vesselText:
                                                                dropdownvalue,
                                                            startDate:
                                                                startDate,
                                                            endDate: endDate,
                                                          )),
                                                );
                                                // getDateWiseReportApi();
                                                // FutureBuilder(
                                                //     future:
                                                //         getDateWiseReportApi(),
                                                //     builder: (context, snapshot) {
                                                //       if (snapshot.hasData) {

                                                //       }
                                                //       return const CircularProgressIndicator();
                                                //       //print('In Builder');
                                                //       //print(snapshot.data);
                                                //       //return Text("View");
                                                //     });
                                                //   // MySnackBar(
                                                //   //     dropdownvalue, context);
                                              },
                                              child: const Text("View"))),
                                    ),
                                  ),
                                ]),
                              ],
                            )
                          ]));
                    },
                  );
                }
              })),
        );
      },
      shrinkWrap: true,
    );
  }
}
