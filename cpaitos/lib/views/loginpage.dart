import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../model/AuthService .dart';
import 'pilotagelandingPage.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  String? username;
  String? password;

  AuthService _authService = AuthService('http://cpatos.gov.bd/tosapi');

  void _cleartext() {
    _usernameController.clear();
    _passwordController.clear();
  }

  onpageload() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    setState(() {
      pref.setString('user_id', username!);
      // password = pref.getString('vvd_gkey');
      // rotation = pref.getString('rotation');
    });
  }

  void _onLoginButtonPressed() async {
    if (_formKey.currentState!.validate()) {
      username = _usernameController.text.trim();
      password = _passwordController.text.trim();

      bool isLoggedIn = await _authService.login(username!, password!);
      print(isLoggedIn);

      // print(loggedin);
      SharedPreferences pref = await SharedPreferences.getInstance();
      String? success = pref.getString('success');
      String? message = pref.getString('message');
      pref.setString('isLoggedIn', isLoggedIn as String);

      if (isLoggedIn) {
        // Navigate to the home screen or any other authenticated screens
        // Navigator.pushReplacementNamed(context, '/home'); // Replace '/home' with your home route
        // ignore: use_build_context_synchronously

        // print('success:$success');
        // print('message:$message');
        // print('success:$message');
        // final success = data['success'];
        onpageload();
        Navigator.push(
          this.context,
          MaterialPageRoute(builder: (context) => PilotageLandingPage()),
        );
        _cleartext();
      } else {
        print('object');
        ScaffoldMessenger.of(this.context).showSnackBar(
          SnackBar(
            content: Text(message!),
            backgroundColor: Colors.purple,
            margin: EdgeInsets.all(10),
            shape: StadiumBorder(),
            behavior: SnackBarBehavior.floating,
            action: SnackBarAction(
              label: 'Dismiss',
              onPressed: _cleartext,
              disabledTextColor: Colors.white54,
              textColor: Colors.white,
            ),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Please Login Here"),
      ),
      body: Container(
        // ignore: prefer_const_constructors

        padding: EdgeInsets.symmetric(horizontal: 20.0),
        decoration: BoxDecoration(
          // image: DecorationImage(
          //     opacity: 10,
          //     image: AssetImage("images/cpa11.jpeg"),
          //     fit: BoxFit.cover),
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color.fromRGBO(238, 130, 235, 0.722),
              Color.fromARGB(255, 40, 68, 230),
              Color.fromARGB(203, 9, 100, 211),
              Color.fromARGB(255, 77, 57, 229),
            ],
            stops: [0.1, 0.4, 0.7, 0.9],
          ),
        ),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height * .09,
                padding: EdgeInsets.all(5),
                child: Center(
                  child: Text(
                    "CPA TOS",
                    style: TextStyle(color: Colors.black87, fontSize: 40),
                  ),
                ),
                color: Colors.black12,
              ),
              SizedBox(height: 20),
              CircleAvatar(
                radius: 50.0,
                backgroundColor: Colors.white,
                child: Icon(
                  Icons.lock,
                  color: Color(0xFF398AE5),
                  size: 50.0,
                ),
              ),
              SizedBox(height: 48.0),
              TextFormField(
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter your password';
                  }
                  return null;
                },
                onSaved: (value) {
                  username = value!;
                },
                controller: _usernameController,
                keyboardType: TextInputType.name,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white.withOpacity(0.3),
                  labelText: 'User Name',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(40.0),
                  ),
                ),
              ),
              SizedBox(height: 16.0),
              TextFormField(
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter your password';
                  }
                  return null;
                },
                onSaved: (value) {
                  password = value!;
                },
                obscureText: true,
                controller: _passwordController,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white.withOpacity(0.3),
                  labelText: 'Password',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(40.0),
                  ),
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                child: Text(
                  'Log In',
                ),
                onPressed: _onLoginButtonPressed,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
