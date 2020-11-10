import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:garderieeu/auth.dart';
import 'package:garderieeu/helpers/HelperContext.dart';
import 'Home.dart';
import 'package:garderieeu/widgets.dart';
import 'package:garderieeu/Colors.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:garderieeu/Tools.dart';

class LoginPage extends StatefulWidget {
  LoginPage({this.auth});
  final BaseAuth auth;
//  final Function initst;
//  final VoidCallback onSignedIn;
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> with TickerProviderStateMixin {
  AnimationController animationController;
  Animation logoanimation;
  String _email, _password, _emailpassword;
  FocusNode focusNode;

  bool isLoading = false;

  final scaffoldKey = GlobalKey<ScaffoldState>();
  final formKey = GlobalKey<FormState>();
  final formKey1 = GlobalKey<FormState>();
  void initState() {
    super.initState();
    animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 1500),
    );
    logoanimation =
        CurvedAnimation(parent: animationController, curve: Curves.easeOut);
    logoanimation.addListener(() => this.setState(() {}));
    animationController.forward();
    focusNode = FocusNode();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    animationController.dispose();
    super.dispose();
  }

  Future<void> SavePass(String pass) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString("UserId", pass);
  }

  void _submit(BuildContext context) {
    final form = formKey.currentState;
    if (form.validate()) {
      setState(() {
        isLoading = true;
      });
      form.save();
      print("Email: $_email Password: $_password");
      SavePass(_password);
      _login(context);
    }
  }

  _login(BuildContext context) async {
    String uid;
    try {
      if (isNumeric(_email)) {
        uid = await widget.auth.signIn(_email + "@app.com", _password);
      } else {
        uid = await widget.auth.signIn(_email, _password);
      }
      print("Signed in : $uid");
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => HomePage()));
    } catch (e) {
      HelperContext.showMessage(context, "Error in Signing in!");
      setState(() {
        isLoading = false;
      });
      print("Errorrr _login: $e");
    }
  }

  bool isNumeric(String s) {
    if (s == null) {
      return false;
    }
    return double.parse(s, (e) => null) != null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: myAppBar(),
        key: scaffoldKey,
        body: isLoading
            ? Center(
                child: CircularProgressIndicator(),
              )
            : Container(
//              height: 100,
                padding: EdgeInsets.only(left: 20.0, right: 20.0),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        height: 70.0,
                      ),
//
                      Padding(padding: EdgeInsets.only(top: 10.0)),
                      Container(
                          width: 200,
                          height: 200,
                          child: Image.asset("assets/logos/appstore.png")),
                      Container(
                        height: 25.0,
                      ),
                      Form(
                        key: formKey,
                        child: Column(
                          children: <Widget>[
                            TextFormField(
                              keyboardType: TextInputType.emailAddress,
                              decoration: InputDecoration(
                                hintText: "Enter Email/phone",
                                labelText: "Email/phone",
                                labelStyle: TextStyle(color: MyColors.color1),
                                hintStyle: TextStyle(color: MyColors.color1),
                                icon: Icon(
                                  Icons.mail,
                                  color: MyColors.color1,
                                ),
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8.0)),
                              ),
                              style: TextStyle(color: MyColors.color1),
                              validator: (val) {
                                return !val.contains('@')
                                    ? (val.length != 8 && !isNumeric(val)
                                        ? "Email or Phone not valid"
                                        : null)
                                    : null;
                              },
                              onSaved: (val) => _email = val,
                              onFieldSubmitted: (val) => FocusScope.of(context)
                                  .requestFocus(focusNode),
                            ),
                            new Padding(padding: EdgeInsets.only(top: 30.0)),
                            TextFormField(
                              decoration: InputDecoration(
                                hintText: "Enter Password",
                                labelText: "Password",
                                labelStyle: TextStyle(color: MyColors.color1),
                                hintStyle: TextStyle(color: MyColors.color1),
                                icon: Icon(
                                  Icons.lock,
                                  color: MyColors.color1,
                                ),
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8.0)),
                              ),
                              obscureText: true,
                              style: TextStyle(color: MyColors.color1),
                              validator: (val) =>
                                  val.length < 6 ? "Password too short" : null,
                              onSaved: (val) => _password = val,
                              focusNode: focusNode,
                            ),
                          ],
                        ),
                      ),
                      Padding(padding: EdgeInsets.only(top: 60.0)),
                      InkWell(
                        onTap: () {
                          _submit(context);
                        },
                        child: Container(
                          height: 45.0,
                          // width: 200.0,
                          decoration: BoxDecoration(
                            borderRadius: Tools.myBorderRadius2,
                            color: MyColors.color1,
                          ),
                          child: Center(
                            child: Text(
                              "LOGIN",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20.0,
                                fontFamily: "Karla",
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),

                      Container(
                        height: 20,
                      ),
                      Text(
                        "Phone: +961 70 12 34 56",
                        style: TextStyle(
                            fontSize: 20,
                            color: MyColors.color1,
                            fontWeight: FontWeight.bold),
                      ),
                      Text(
                        "Address: +961 70 12 34 56",
                        style: TextStyle(
                            fontSize: 20,
                            color: MyColors.color1,
                            fontWeight: FontWeight.bold),
                      ),
                      Padding(padding: EdgeInsets.only(top: 20.0)),
                    ],
                  ),
                ),
              ));
  }
}
