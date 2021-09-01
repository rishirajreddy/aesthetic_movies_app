import 'package:flutter/material.dart';
import 'package:flutter_application/provider/provider_google.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

class GoogleSignin extends StatefulWidget {
  @override
  _GoogleSigninState createState() => _GoogleSigninState();
}

class _GoogleSigninState extends State<GoogleSignin> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Hey There!",
                style: TextStyle(
                  fontSize: 25,
                ),
              ),
              Text(
                "Welcome Back",
                style: TextStyle(fontSize: 25),
              ),
              SizedBox(
                height: 25,
              ),
              TextButton(
                  style: TextButton.styleFrom(
                    backgroundColor: Colors.red,
                  ),
                  onPressed: () {
                    final provider = Provider.of<GoogleSiginProvider>(context,
                        listen: false);
                    provider.googleLogin();
                  },
                  child: Wrap(spacing: 8, children: [
                    Icon(
                      FontAwesomeIcons.google,
                      color: Colors.white,
                    ),
                    Text(
                      "SignIn With Google",
                      style: TextStyle(color: Colors.white, fontSize: 18),
                    ),
                  ]))
            ],
          ),
        ),
      ),
    );
  }
}
