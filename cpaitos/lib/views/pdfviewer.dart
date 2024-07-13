import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class PDFViewerScreen extends StatelessWidget {
  final String pdfUrl;

  PDFViewerScreen({required this.pdfUrl});

  @override
  Widget build(BuildContext context) {
    print(pdfUrl);
    return Scaffold(
      appBar: AppBar(
        title: Text('Final Pilot'),
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: SfPdfViewer.network(
          pdfUrl,
        ),
      ),
    );
  }
}











// import 'dart:js';

// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'package:path_provider/path_provider.dart';
// import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
// import 'dart:io';

// // class PDFViewerScreen extends StatefulWidget {
// //    PDFViewerScreen({super.key});
// //   // = 'http://ctevt.org.np/uploads/docs/2020-05-11_Diploma%20in%20Forestry%202013.pdf';
// //   // PDFViewerScreen({required this.pdfUrl});

// //   // @override
// //   // State<PDFViewerScreen> createState() => _PDFViewerScreenState();
// // }

// class PDFViewerScreen extends StatelessWidget {
//   late PdfViewerController _pdfViewerController;
//   late PdfTextSearchResult _searchResult;

//   //String url = "https://docs.google.com/gview?embedded=true&url=$pdfUrl";
//   String pdfUrl =
//       'https://docs.google.com/gview?embedded=true&url=http://cpatos.gov.bd/PcsOracle/index.php/pilotageApp/ReportController/Report/2023_3463/149385559/incoming/devpilot';

//   Future<void> _downloadPdf() async {
//     //show popup
//     showDialog(
//       context: this.context,
//       barrierDismissible: false,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: Text('Downloading...'),
//           content: LinearProgressIndicator(),
//         );
//       },
//     );

//     // download the file
//     final response = await http.get(Uri.parse(pdfUrl));
//     final directory = await getApplicationDocumentsDirectory();
//     String fileName = pdfUrl;
//     print('fileName $fileName');
//     final file = File('${directory.path}/$fileName');
//     await file.writeAsBytes(response.bodyBytes);

//     // remove popup
//     Navigator.pop(context); // Hide the downloading popup
//     ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//       content: Text('$fileName downloaded.'),
//       action: SnackBarAction(
//         label: 'Go to \nDownloads',
//         onPressed: () {
//           Navigator.popUntil(context, (route) => false);
//           Navigator.of(context).pushNamed('/downloads');
//         },
//       ),
//     ));
//   }

//   @override
//   void initState() {
//     _pdfViewerController = PdfViewerController();
//     _searchResult = PdfTextSearchResult();
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Column(
//           children: [
//             const Text(
//               'View and download',
//               textScaleFactor: 0.8,
//             ),
//             Text(
//               'Double tap to zoom',
//               textScaleFactor: 0.6,
//             )
//           ],
//         ),
//         actions: <Widget>[
//           IconButton(
//             icon: const Icon(
//               Icons.search,
//               color: Colors.white,
//             ),
//             onPressed: () {
//               _searchResult = _pdfViewerController.searchText(
//                 'the',
//               );
//               if (kIsWeb) {
//                 setState(() {});
//               } else {
//                 _searchResult.addListener(() {
//                   if (_searchResult.hasResult) {
//                     setState(() {});
//                   }
//                 });
//               }
//             },
//           ),
//           Visibility(
//             visible: _searchResult.hasResult,
//             child: IconButton(
//               icon: const Icon(
//                 Icons.clear,
//                 color: Colors.white,
//               ),
//               onPressed: () {
//                 setState(() {
//                   _searchResult.clear();
//                 });
//               },
//             ),
//           ),
//           Visibility(
//             visible: _searchResult.hasResult,
//             child: IconButton(
//               icon: const Icon(
//                 Icons.keyboard_arrow_up,
//                 color: Colors.white,
//               ),
//               onPressed: () {
//                 _searchResult.previousInstance();
//               },
//             ),
//           ),
//           Visibility(
//             visible: _searchResult.hasResult,
//             child: IconButton(
//               icon: const Icon(
//                 Icons.keyboard_arrow_down,
//                 color: Colors.white,
//               ),
//               onPressed: () {
//                 _searchResult.nextInstance();
//               },
//             ),
//           ),
//         ],
//       ),
//       body: SfPdfViewer.network(
//         pdfUrl,
//         controller: _pdfViewerController,
//         currentSearchTextHighlightColor: Colors.yellow.withOpacity(0.6),
//         otherSearchTextHighlightColor: Colors.yellow.withOpacity(0.3),
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: () {
//           _downloadPdf();
//         },
//         tooltip: 'Download PDF',
//         child: const Icon(Icons.download),
//       ),
//     );
//   }
// }













