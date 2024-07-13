import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import '../model/ImageTextButton.dart';
import 'additionalinformation.dart';
import 'finalsummaryview.dart';
import 'loginpage.dart';
import 'pilotagelandingPage.dart';
import 'timeberthinput.dart';
import 'vesselListTypeWise.dart';

final Uri _url = Uri.parse("http://cpatos.gov.bd/");

class HomePage extends StatelessWidget {
  var size, height, width;

  Future<void> _launchUrl() async {
    if (!await launchUrl(_url)) {
      throw Exception('Could not launch $_url');
    }
  }

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    height = size.height;
    width = size.width;

    final drawerHeader = UserAccountsDrawerHeader(
      accountName: Text('Dev Pilot'),
      accountEmail: Text('devpilot@gmail.com'),
      currentAccountPicture: const CircleAvatar(
        child: FlutterLogo(size: 42.0),
      ),
    );
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blueGrey,
          title: Text('CPA iTOS'),
        ),
        drawer: Drawer(
          backgroundColor: Color.fromARGB(255, 58, 123, 134),
          child: ListView(
            children: <Widget>[
              drawerHeader,
              ListTile(
                title: Text('Incoming'),
                onTap: () async {
                  SharedPreferences pref =
                      await SharedPreferences.getInstance();
                  pref.setString('request_for', "incoming");
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Vessellist()),
                  );
                  // Close the drawer
                },
              ),
              ListTile(
                title: Text('Shifting'),
                onTap: () async {
                  SharedPreferences pref =
                      await SharedPreferences.getInstance();
                  pref.setString('request_for', "shifting");
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Vessellist()),
                  );
                  // Close the drawer
                },
              ),
              ListTile(
                title: Text('Outgoing'),
                onTap: () async {
                  SharedPreferences pref =
                      await SharedPreferences.getInstance();
                  pref.setString('request_for', "outgoing");
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Vessellist()),
                  );
                  // Close the drawer
                },
              ),
              // Generated code for this Divider Widget...
              Divider(
                thickness: 1,
                color: Colors.grey,
              ),
              ListTile(
                title: Text('Helpline'),
                onTap: () {
                  // Handle navigation to Screen 2
                  Navigator.pop(context); // Close the drawer
                },
              ),
              ListTile(
                title: Text('Logout'),
                onTap: () {
                  Navigator.pop(context); // Close the drawer
                },
              ),
            ],
          ),
        ),
        body: SingleChildScrollView(
            child: Container(
          // decoration: const BoxDecoration(
          //   image: DecorationImage(
          //       opacity: 10,
          //       image: AssetImage("images/cpa11.jpeg"),
          //       fit: BoxFit.cover),
          // ),
          color: Color.fromARGB(255, 16, 51, 45),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            verticalDirection: VerticalDirection.down,
            mainAxisSize: MainAxisSize.max,
            children: [
              Container(
                  margin: const EdgeInsets.all(15),
                  width: width,
                  height: height / 3.5,
                  child: ImageTextButton(
                    image: "images/cpaweb.jpg",
                    text: "CPA TOS WEBSITE",
                    imageHeight: height,
                    imageWidth: width,
                    onPressed: _launchUrl,
                  )
                  // ElevatedButton(
                  //   style: ElevatedButton.styleFrom(
                  //       backgroundColor: Color.fromARGB(255, 26, 43, 41)),
                  //   onPressed: _launchUrl,
                  //   child: const Text('CPA TOS Website'),
                  // ),
                  ),
              Container(
                width: width,
                height: height / 3.5,
                margin: const EdgeInsets.all(15),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 5,
                      child: Container(
                          width: width / 2,
                          height: height,
                          margin: EdgeInsets.all(10),
                          child: ImageTextButton(
                            image: "images/cpagate.jpg",
                            text: "PILOTAGE",
                            imageHeight: height,
                            imageWidth: width,
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => LoginPage()));
                            },
                          )),
                    ),
                    SizedBox(width: 5),
                    Expanded(
                      flex: 5,
                      child: Container(
                          width: width / 2,
                          height: height,
                          margin: EdgeInsets.all(10),
                          child: ImageTextButton(
                            image: "images/cpagate.jpg",
                            text: "TOS GATE PASS",
                            imageHeight: height,
                            imageWidth: width,
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => LoginPage()));
                            },
                          )),
                    ),
                  ],
                ),
              ),
              Container(
                  margin: EdgeInsets.all(15),
                  width: width,
                  height: height / 5.5,
                  child: ImageTextButton(
                    image: "images/cpafee.jpg",
                    text: "TRUCK ENTRY FEE",
                    imageHeight: height,
                    imageWidth: width,
                    onPressed: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => LoginPage()));
                    },
                  )),
              Container(
                width: width,
                height: height / 3.5,
                margin: EdgeInsets.all(15),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 5,
                      child: Container(
                          width: width / 2,
                          height: height,
                          margin: EdgeInsets.all(10),
                          child: ImageTextButton(
                            image: "images/cpagatein.png",
                            text: "GATE IN",
                            imageHeight: height,
                            imageWidth: width,
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => LoginPage()));
                            },
                          )),
                    ),
                    SizedBox(width: 5),
                    Expanded(
                      flex: 5,
                      child: Container(
                          width: width / 2,
                          height: height,
                          margin: EdgeInsets.all(10),
                          child: ImageTextButton(
                            image: "images/cpagateout.png",
                            text: "GATE OUT",
                            imageHeight: height,
                            imageWidth: width,
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => LoginPage()));
                            },
                          )),
                    ),
                  ],
                ),
              ),
              Container(
                width: width,
                height: height / 3.5,
                margin: EdgeInsets.all(15),
                child: Row(
                  children: [
                    Expanded(
                      flex: 5,
                      child: Container(
                          width: width / 2,
                          height: height,
                          margin: EdgeInsets.all(10),
                          child: ImageTextButton(
                            image: "images/refer.jpg",
                            text: "REFER ENTRY",
                            imageHeight: height,
                            imageWidth: width,
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => LoginPage()));
                            },
                          )),
                    ),
                    SizedBox(width: 5),
                    Expanded(
                      flex: 5,
                      child: Container(
                          width: width / 2,
                          height: height,
                          margin: EdgeInsets.all(10),
                          child: ImageTextButton(
                            image: "images/water.png",
                            text: "WATER SUPPLY",
                            imageHeight: height,
                            imageWidth: width,
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => LoginPage()));
                            },
                          )),
                    ),
                  ],
                ),
              ),
              Container(
                width: width,
                height: height / 3.5,
                margin: EdgeInsets.all(15),
                child: Row(
                  children: [
                    Expanded(
                      flex: 5,
                      child: Container(
                          width: width / 2,
                          height: height,
                          margin: EdgeInsets.all(10),
                          child: ImageTextButton(
                            image: "images/import.jpg",
                            text: "IMPORT DISCHARGE",
                            imageHeight: height,
                            imageWidth: width,
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => LoginPage()));
                            },
                          )),
                    ),
                    SizedBox(width: 5),
                    Expanded(
                      flex: 5,
                      child: Container(
                          width: width / 2.15,
                          height: height,
                          margin: EdgeInsets.all(10),
                          child: ImageTextButton(
                            image: "images/export.jpg",
                            text: "EXPORT LOADING",
                            imageHeight: height,
                            imageWidth: width,
                            onPressed: _launchUrl,
                          )),
                    ),
                  ],
                ),
              ),
            ],
          ),
        )));
  }
}
