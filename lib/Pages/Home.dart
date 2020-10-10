import "package:firebase_auth/firebase_auth.dart";
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

import '../Colors.dart';
import "../Tools.dart";
import '../UserInfo.dart';
import '../auth.dart';
import '../db.dart';
import '../services/FirebaseMessageService.dart';
import '../widgets.dart';
import 'ChangePass.dart';
import 'ClassReport/Admin/AdminClassReport.dart';
import 'ClassReport/Parent/ParentClassReport.dart';
import 'ClassReport/Teacher/TeacherClassReport.dart';
import 'Classes/Classes.dart';
import 'Messages/RecieveMessages.dart';
import 'Messages/SendMessage.dart';
import 'Parents/Parents.dart';
import 'StudentReport//Admin/AdminStudentReport.dart';
import 'StudentReport/Teacher/TeacherStudentReport.dart';
import 'Students/Students.dart';
import 'Teachers/TeachersClass.dart';
import "login.dart";

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;
}

class _HomePageState extends State<HomePage> {
  DataBaseService dataBaseService = new DataBaseService();
  // FirebaseMessaging firebaseMessaging = new FirebaseMessaging();

  bool isAuthenticated = false;
  Auth auth = new Auth();

  List<Widget> mainWidgets = new List<Widget>();
  // List<Widget> TeacherWidgets=new List<Widget>();
  // List<Widget> ParentWidgets=new List<Widget>();

  getUserType(String email) async {
    await dataBaseService.getUserType(email, context).then((value) async {
      UserCurrentInfo.Type = value.data["type"];
      if (UserCurrentInfo.Email != null && UserCurrentInfo.Type != null)
        await dataBaseService.saveTooken(
            UserCurrentInfo.Email, UserCurrentInfo.Type, context);
      // print(UserCurrentInfo.Type+"a");
      setState(() {
        setMainWidgets();
      });
    });
  }

  checkIfAuthenticated() async {
    await widget.firebaseAuth.currentUser().then((value) {
      if (value == null) {
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => new LoginPage(
                      auth: auth,
                    )));
      } else {
        getUserType(value.email);
        UserCurrentInfo.Email = value.email;
        UserCurrentInfo.UID = value.uid;
        setState(() {
          isAuthenticated = true;
        });
      }
    });
  }

  logout() async {
    await auth.signOut().then((value) {
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => new LoginPage(
                    auth: auth,
                  )));
    });
  }

  void goToPage(String tag, BuildContext context) {
    if (tag == "Logout") {
      logout();
      return;
    }

    Navigator.push(context, MaterialPageRoute(builder: (context) {
      switch (tag) {
        case "Classes":
          return new Classes();
        case "Change Password":
          return new ChangePass();

        case "Messages":
          {
            if (UserCurrentInfo.Type == "admin") {
              return new SendMessage();
            } else if (UserCurrentInfo.Type == "teacher") {
              return new SendMessage();
            }
            return new RecieveMessages();
          }

        case "Students":
          return new Students();

        case "Parents":
          return new Parents();

        case "Teachers":
          return new Teachers();

        case "Class Report":
          {
            if (UserCurrentInfo.Type == "admin") {
              return new AdminClassReport();
            } else if (UserCurrentInfo.Type == "teacher") {
              return new TeacherClassReport();
            }
            return new ParentClassReport();
          }

        case "Student Report":
          {
            if (UserCurrentInfo.Type == "admin") {
              return new AdminStudentReport();
            } else if (UserCurrentInfo.Type == "teacher") {
              return new TeacherStudentReport();
            }
            return new ParentClassReport();
          }
      }

      return HomePage();
    }));
  }

  Container makeDashboardItem(
      BuildContext context, String title, IconData icon) {
    TextStyle dashBoardTextStyle = TextStyle(
      fontFamily: 'Montserrat',
      fontSize: 22.0,
      color: Colors.white,
      fontWeight: FontWeight.bold,
    );

    return Container(
        color: MyColors.color4,
        // color:MyColors.color1 ,
        // elevation: 1.0,
        margin: new EdgeInsets.all(8.0),
        child: Container(
          decoration: BoxDecoration(
              borderRadius: Tools.myBorderRadius, color: MyColors.color1),
          child: new InkWell(
            onTap: () => goToPage(title, context),
            // onPressed: () => login(context) ,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.end,
              mainAxisSize: MainAxisSize.min,
              verticalDirection: VerticalDirection.down,
              children: <Widget>[
                SizedBox(height: 15.0),
                Center(
                    child: Icon(
                  icon,
                  size: 90.0,

                  color: MyColors.color2, //Colors.black,
                )),
                SizedBox(height: 7.0),
                new Center(
                  child: FittedBox(
                    fit: BoxFit.fitWidth,
                    child: new Text(
                      title,
                      style: dashBoardTextStyle, textAlign: TextAlign.center,
                      maxLines: 2,
                      // maxLines: 3,
                      //new TextStyle(fontSize: 18.0, color: Colors.black)
                    ),
                  ),
                ),
                SizedBox(height: 10.0),
              ],
            ),
          ),
        ));
  }

  setMainWidgets() {
    if (UserCurrentInfo.Type == "admin") {
      mainWidgets = <Widget>[
        makeDashboardItem(context, "Classes", Icons.account_balance),
        makeDashboardItem(context, "Teachers", Icons.person_outline),
        makeDashboardItem(context, "Students", Icons.account_box),
        makeDashboardItem(context, "Parents", Icons.person_pin_circle),
        makeDashboardItem(context, "Class Report", Icons.report),
        makeDashboardItem(context, "Student Report", Icons.report_problem),
        makeDashboardItem(context, "Messages", Icons.message),
        // makeDashboardItem(context , "ReportStudent", Icons.alarm),
        makeDashboardItem(context, "Change Password", Icons.build),
        makeDashboardItem(context, "Logout", Icons.keyboard_backspace),
      ];
    } else if (UserCurrentInfo.Type == "teacher") {
      mainWidgets = <Widget>[
        makeDashboardItem(context, "Class Report", Icons.report),
        makeDashboardItem(context, "Student Report", Icons.report_problem),
        makeDashboardItem(context, "Messages", Icons.message),
        makeDashboardItem(context, "Change Password", Icons.build),
        makeDashboardItem(context, "Logout", Icons.keyboard_backspace)
      ];
    } else {
      mainWidgets = <Widget>[
        makeDashboardItem(context, "Class Report", Icons.report),
        makeDashboardItem(context, "Student Report", Icons.report_problem),
        makeDashboardItem(context, "Messages", Icons.message),
        makeDashboardItem(context, "Change Password", Icons.build),
        makeDashboardItem(context, "Logout", Icons.keyboard_backspace)
      ];
    }
  }

  @override
  void initState() {
    checkIfAuthenticated();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColors.color4,
      appBar: true
          ? AppBar(
              title: InkWell(
                  onTap: () {
                    FirebaseMessageService.sendMessageToGroup('classID',
                        'A new Report been added', 'Tap to view details', {});
                  },
                  child: Text('click')),
              actions: [
                IconButton(
                    icon: Icon(Icons.send),
                    onPressed: () async {
                      await FirebaseMessageService.subscribeTOAdmin();
                    }),
              ],
            )
          : myAppBar(),
      body: SafeArea(
        child: isAuthenticated
            ? Center(
                child: Container(
                  padding:
                      EdgeInsets.symmetric(vertical: 20.0, horizontal: 2.0),
                  child: GridView.count(
                    crossAxisCount: 2,
                    padding: EdgeInsets.all(3.0),
                    children: mainWidgets,
                  ),
                ),
              )
            : Center(
                child: CircularProgressIndicator(),
              ),
      ),
    );
  }
}
