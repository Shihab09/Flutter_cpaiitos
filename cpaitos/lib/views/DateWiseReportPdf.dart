import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

import '../model/DateWiseReportModel.dart';

// ignore: must_be_immutable
class DateWiseReportPdf extends StatelessWidget {
  //dynamic count;
  DateWiseReportPdf(
      {super.key,
      required this.data,
      required this.fromDate,
      required this.toDate,
      required this.reportName});
  //const DateWiseReportPdf(this.data, {Key? key}) : super(key: key);
  List<DateWiseReportModel> data;
  String fromDate;
  String toDate;
  String reportName;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('PDF Preview'),
      ),
      body: PdfPreview(
        build: (context) => makePdf(data),
      ),
    );
  }

  Future<Uint8List> makePdf(listData) async {
    final pdf = pw.Document();
    final ByteData bytes = await rootBundle.load('assets/images/cpa.png');
    final Uint8List byteList = bytes.buffer.asUint8List();
    //pw.Paragraph(text: Text("ALL VESSEL REPORT"));
    pdf.addPage(
      pw.MultiPage(
        margin: pw.EdgeInsets.all(30),
        build: (pw.Context context) => <pw.Widget>[
          pw.Table(
            defaultColumnWidth: pw.FixedColumnWidth(30.0),
            //border: pw.TableBorder.all(color: PdfColors.black),
            children: [
              pw.TableRow(children: [
                pw.Column(children: [
                  pw.Image(pw.MemoryImage(byteList),
                      fit: pw.BoxFit.fitHeight, height: 30, width: 30),
                ]),
                pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.center,
                    mainAxisAlignment: pw.MainAxisAlignment.center,
                    children: [
                      pw.Text("CHITTAGONG PORT AUTHORITY",
                          textAlign: pw.TextAlign.center,
                          style: pw.TextStyle(
                            fontSize: 16,
                            fontWeight: pw.FontWeight.bold,
                          )),
                      //pw.Divider(thickness: 1)
                    ]),
                pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.center,
                    mainAxisAlignment: pw.MainAxisAlignment.center,
                    children: [
                      pw.Text(" ",
                          textAlign: pw.TextAlign.center,
                          style: pw.TextStyle(
                            fontSize: 6,
                            fontWeight: pw.FontWeight.bold,
                          )),
                      //pw.Divider(thickness: 1)
                    ]),
              ]),
              pw.TableRow(children: [
                pw.Column(children: [
                  pw.Text(" ",
                      textAlign: pw.TextAlign.center,
                      style: pw.TextStyle(
                        fontSize: 6,
                        fontWeight: pw.FontWeight.bold,
                      )),
                ]),
                pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.center,
                    mainAxisAlignment: pw.MainAxisAlignment.center,
                    children: [
                      pw.Text("$reportName Report",
                          textAlign: pw.TextAlign.center,
                          style: pw.TextStyle(
                            fontSize: 10,
                            fontWeight: pw.FontWeight.bold,
                          )),
                      //pw.Divider(thickness: 1)
                    ]),
                pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.center,
                    mainAxisAlignment: pw.MainAxisAlignment.center,
                    children: [
                      pw.Text("Date $fromDate to $toDate ",
                          textAlign: pw.TextAlign.center,
                          style: pw.TextStyle(
                            fontSize: 6,
                            fontWeight: pw.FontWeight.bold,
                          )),
                      //pw.Divider(thickness: 1)
                    ]),
              ]),
            ],
          ),
          pw.Divider(thickness: 1),
          pw.ListView.builder(
            itemCount: data.length,
            itemBuilder: (_, int index) {
              // return pw.Text(data[index].importRotationNo!);
              return pw.Table(
                  defaultColumnWidth: pw.FixedColumnWidth(100.0),
                  border: pw.TableBorder.all(color: PdfColors.black),
                  children: [
                    if (index == 0)
                      pw.TableRow(children: [
                        pw.Column(
                            //crossAxisAlignment: pw.CrossAxisAlignment.center,
                            //mainAxisAlignment: pw.MainAxisAlignment.center,
                            children: [
                              pw.Text("ROTATION",
                                  style: pw.TextStyle(
                                    fontSize: 6,
                                    fontWeight: pw.FontWeight.bold,
                                  )),
                              //pw.Divider(thickness: 1)
                            ]),
                        pw.Column(
                            //crossAxisAlignment: pw.CrossAxisAlignment.center,
                            //mainAxisAlignment: pw.MainAxisAlignment.center,
                            children: [
                              pw.Text("VESSEL NAME",
                                  style: pw.TextStyle(
                                    fontSize: 6,
                                    fontWeight: pw.FontWeight.bold,
                                  )),
                              //pw.Divider(thickness: 1)
                            ]),
                        pw.Column(
                            crossAxisAlignment: pw.CrossAxisAlignment.center,
                            mainAxisAlignment: pw.MainAxisAlignment.center,
                            children: [
                              pw.Text("MASTER NAME",
                                  style: pw.TextStyle(
                                    fontSize: 6,
                                    fontWeight: pw.FontWeight.bold,
                                  )),
                              //pw.Divider(thickness: 1)
                            ]),
                      ]),
                    if (index >= 0)
                      pw.TableRow(children: [
                        pw.Column(
                            //crossAxisAlignment: pw.CrossAxisAlignment.center,
                            //mainAxisAlignment: pw.MainAxisAlignment.center,
                            children: [
                              pw.Text(data[index].importRotationNo!,
                                  style: pw.TextStyle(fontSize: 6)),
                              //pw.Divider(thickness: 1)
                            ]),
                        pw.Column(
                            //crossAxisAlignment: pw.CrossAxisAlignment.center,
                            //mainAxisAlignment: pw.MainAxisAlignment.center,
                            children: [
                              pw.Text(data[index].vesselName!,
                                  style: pw.TextStyle(fontSize: 6)),
                              //pw.Divider(thickness: 1)
                            ]),
                        pw.Column(
                            crossAxisAlignment: pw.CrossAxisAlignment.center,
                            mainAxisAlignment: pw.MainAxisAlignment.center,
                            children: [
                              pw.Text(data[index].nameOfMaster!,
                                  style: pw.TextStyle(fontSize: 6)),
                              //pw.Divider(thickness: 1)
                            ]),
                      ]),
                  ]);
            },
          ),
        ],
      ),
    );
    return pdf.save();
  }
}
