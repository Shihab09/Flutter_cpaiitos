import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:dio/dio.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:path/path.dart' as p;

class VesselWiseReport extends StatefulWidget {
  final File file;
  final String url;

  const VesselWiseReport({
    Key? key,
    required this.file,
    required this.url,
  }) : super(key: key);

  @override
  VesselWiseReportPdf createState() => VesselWiseReportPdf();
}

class VesselWiseReportPdf extends State<VesselWiseReport> {
  @override
  Widget build(BuildContext context) {
    final name = basename(widget.file.path);
    return Scaffold(
      appBar: AppBar(
        title: Text(name),
        actions: [
          IconButton(
            onPressed: () async {
              await saveFile(widget.url, "VesselReport.pdf");
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text(
                    'success',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              );
            },
            icon: const Icon(Icons.download_rounded),
          ),
        ],
      ),
      body: PDFView(
        filePath: widget.file.path,
      ),
    );
  }

  Future<bool> saveFile(String url, String fileName) async {
    try {
      if (await _requestPermission(Permission.photos)) {
        Directory? directory;
        // directory = await getExternalStorageDirectory();
        directory = await getExternalStorageDirectory();
        if (kDebugMode) {
          print("directory path=====");
          print(directory);
        }
        String newPath = "";
        List<String> paths = directory!.path.split("/");
        for (int x = 1; x < paths.length; x++) {
          String folder = paths[x];
          if (folder != "Android") {
            newPath += "/" + folder;
          } else {
            break;
          }
        }
        newPath = newPath + "/PDF_Download";
        if (kDebugMode) {
          print("file path=====");
          print(newPath);
        }
        directory = Directory(newPath);

        File saveFile = File(directory.path + "/$fileName");
        if (kDebugMode) {
          print(directory);
          print(saveFile.path);
        }
        if (!await directory.exists()) {
          await directory.create(recursive: true);
        }
        if (await directory.exists()) {
          await Dio().download(
            url,
            saveFile.path,
          );
        }
      } else {
        if (kDebugMode) {
          print("permission not granted");
        }
      }
      return true;
    } catch (e) {
      if (kDebugMode) {
        print("Erroorrrr 1111");
      }
      return false;
    }
  }

  Future<bool> _requestPermission(Permission permission) async {
    if (await permission.isGranted) {
      if (kDebugMode) {
        print("Permission true");
      }
      return true;
    } else {
      PermissionStatus result = await Permission.photos.request();
      // Permission.photos
      if (result.isGranted) {
        return true;
      } else if (Platform.isIOS || result.isPermanentlyDenied) {
        //Permission.requestInstallPackages();
        openAppSettings();
      }

      // if (result == PermissionStatus.granted) {
      //   if (kDebugMode) {
      //     print("Permission true");
      //   }
      //   return true;
      // } else {
      //   openAppSettings();
      // }

      // Map<Permission, PermissionStatus> statuses =
      //     await [Permission.storage].request();

      // if (kDebugMode) {
      //   print("Permission settings");
      //   print(statuses[Permission.storage]);
      // }
      // if (await Permission.storage.isPermanentlyDenied) {
      //   // The user opted to never again see the permission request dialog for this
      //   // app. The only way to change the permission's status now is to let the
      //   // user manually enable it in the system settings.
      //   if (kDebugMode) {
      //     print("Permission settings Permission.storage");
      //   }
      //   openAppSettings();
      // }
    }
    return false;
  }
}
