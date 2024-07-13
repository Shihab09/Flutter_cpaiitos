// ignore_for_file: must_be_immutable

import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:convert';
import '../model/DateWiseReportModel.dart';
import '../utils/urlconstants.dart' as url;
import 'package:http/http.dart' as http;
import 'DateWiseReportPdf.dart';
import 'package:path/path.dart';

import 'VesselWiseReport.dart';

class ReportListView extends StatefulWidget {
  String? vesselText;
  String? startDate;
  String? endDate;

  ReportListView(
      {Key? key,
      required this.vesselText,
      required this.startDate,
      required this.endDate})
      : super(key: key);

  @override
  _reportListState createState() => _reportListState();
}

class _reportListState extends State<ReportListView> {
  String? vesselText;
  String? startDate;
  String? endDate;

  List<DateWiseReportModel> reportList = [];

  // @override
  // initState() {
  //   super.initState();
  //   getDateWiseReportApi();
  // }

  //Date wise Report
  Future<List<DateWiseReportModel>> getDateWiseReportApi(
      vesselText, startDate, endDate) async {
    print("Get date wise api data");
    print(vesselText);
    print(startDate);
    print(endDate);

    final body = {
      'user_id': 'p497',
      'report_type': vesselText,
      'start_date': startDate,
      'end_date': endDate,
    };
    final urlString = Uri.parse(url.UrlConstants().DATEWISEDATAAPI());
    final response = await http.post(urlString, body: body);

    var jsonData = json.decode(response.body);
    final dataCount = jsonData['data'];
    String success = jsonData["success"];

    if (response.statusCode == 200) {
      if (success == '1') {
        for (Map i in dataCount) {
          reportList.add(DateWiseReportModel.fromJson(i));
        }
      }

      //print("get report data");
      //print(reportList[0].importRotationNo);
      return reportList;
    } else {
      return reportList;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.vesselText}'),
        backgroundColor: Colors.blueGrey,
      ),
      body: FutureBuilder(
          future: getDateWiseReportApi('${widget.vesselText}',
              '${widget.startDate}', '${widget.endDate}'),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              //return Text(reportList[index].importRotationNo!);
              return ListView.builder(
                itemCount: reportList.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                      onTap: () async {
                        // const url =
                        // "http://cpatos.gov.bd/PcsOracle/index.php/pilotageApp/ReportController/Report/2918/122480708/incoming";

                        final api =
                            Uri.parse(url.UrlConstants().GETVESSELREPORTSPI());
                        String rotation = reportList[index]
                            .importRotationNo!
                            .replaceAll("/", "_");
                        final urlString =
                            "$api/$rotation/${reportList[index].vvdGkey!}/${reportList[index].inputType!}";

                        final file = await loadPdfFromNetwork(urlString);
                        openPdf(context, file, urlString);
                        // if (kDebugMode) {
                        //   print("open url======");
                        //   print(urlString);
                        // }
                      },
                      child: Card(
                        elevation: 10,
                        shadowColor: Colors.black,
                        color: const Color.fromARGB(255, 229, 237, 231),
                        child: SizedBox(
                          //width: 300,
                          height: 90,
                          child: Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Table(
                                  //defaultColumnWidth: FixedColumnWidth(200),
                                  //border: TableBorder.all(),
                                  children: [
                                    TableRow(
                                      children: [
                                        TableCell(
                                          verticalAlignment:
                                              TableCellVerticalAlignment.middle,
                                          child: Text(
                                            "Rotation :${reportList[index].importRotationNo!}",
                                            maxLines: 2,
                                            textAlign: TextAlign.center,
                                            style: const TextStyle(
                                              fontSize: 14,
                                              color: Colors.black,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                        TableCell(
                                          verticalAlignment:
                                              TableCellVerticalAlignment.middle,
                                          child: Text(
                                            "Vessel Name :${reportList[index].vesselName!}",
                                            maxLines: 3,
                                            textAlign: TextAlign.center,
                                            style: const TextStyle(
                                              fontSize: 14,
                                              color: Colors.black,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                        TableCell(
                                          verticalAlignment:
                                              TableCellVerticalAlignment.middle,
                                          child: Text(
                                            "Master Name :${reportList[index].nameOfMaster!}",
                                            maxLines: 3,
                                            textAlign: TextAlign.center,
                                            style: const TextStyle(
                                              fontSize: 14,
                                              color: Colors.black,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),
                        ),
                      ));
                },
              );
            } else {
              Text("Data not found");
            }
            return const Center(
              child: CircularProgressIndicator(),
            );

            //print('In Builder');
            //print(snapshot.data);
            //return Text("View");
          }),

      // ),
      //  ),
      //  )),
      //),
      // );
      // }),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(builder: (context) {
            return DateWiseReportPdf(
                data: reportList,
                fromDate: '${widget.startDate}',
                toDate: '${widget.endDate}',
                reportName: '${widget.vesselText}');
          }));
        },
        child: const Icon(Icons.picture_as_pdf_sharp),
      ),
    );
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
