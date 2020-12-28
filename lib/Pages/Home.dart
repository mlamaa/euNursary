import "package:firebase_auth/firebase_auth.dart";
import 'package:flutter/material.dart';

import '../Colors.dart';
import "../Tools.dart";
import '../UserInfo.dart';
import '../auth.dart';
import '../db.dart';
import '../widgets.dart';
import 'ChangePass.dart';
import 'Classes/Classes.dart';
import 'Messages/RecieveMessages.dart';
import 'Messages/SendMessage.dart';
import 'Parents/Parents.dart';
import 'Reports/Class/Admin/AdminClassReport.dart';
import 'Reports/Class/Parent/ParentClassReport.dart';
import 'Reports/Class/Teacher/TeacherClassReport.dart';
import 'Reports/Student/Admin/AdminStudentReport.dart';
import 'Reports/Student/Parent/ParentStudentReport.dart';
import 'Reports/Student/Teacher/TeacherStudentReport.dart';
import 'Students/Students.dart';
import 'Teachers/TeachersClass.dart';
import "login.dart";

const classes = "Classes";
const Enseignants = "Enseignants";
const Enfant = "Enfant";
const parents = "Parents";
const Rapport_classe = "Rapport de classe";
const Rapport_etudiant = "Rapport étudiant";
const Messages = "Messages";
const Changer_MDP = "Changer MDP";
const Sortie = "Sortie";

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
      UserCurrentInfo.currentUserType = value.data["type"];
      if (UserCurrentInfo.email != null && UserCurrentInfo.currentUserType != null)
        await dataBaseService.saveTooken(
            UserCurrentInfo.email, UserCurrentInfo.currentUserType, context);
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
        UserCurrentInfo.email = value.email;
        UserCurrentInfo.currentUserId = value.uid;
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
    if (tag == Sortie) {
      logout();
      return;
    }

    Navigator.push(context, MaterialPageRoute(builder: (context) {
      print(tag);
      switch (tag) {
        case classes:
          return new Classes();
        case Changer_MDP:
          return new ChangePass();

        case Messages:
          {
            if (UserCurrentInfo.currentUserType == "admin") {
              return new SendMessage();
            } else if (UserCurrentInfo.currentUserType == "teacher") {
              return new SendMessage();
            }
            return new RecieveMessages();
          }

        case Enfant:
          return new Students();

        case parents:
          return new Parents();

        case Enseignants:
          return new Teachers();

        case Rapport_classe:
          {
            if (UserCurrentInfo.currentUserType == "admin") {
              return new AdminClassReport();
            } else if (UserCurrentInfo.currentUserType == "teacher") {
              return new TeacherClassReport();
            }
            return new ParentClassReport();
          }

        case Rapport_etudiant:
          {
            if (UserCurrentInfo.currentUserType == "admin") {
              return new AdminStudentReport();
            } else if (UserCurrentInfo.currentUserType == "teacher") {
              return new TeacherStudentReport();
            }
            return new ParentStudentReport();
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
    if (UserCurrentInfo.currentUserType == "admin") {
      mainWidgets = <Widget>[
        makeDashboardItem(context, classes, Icons.home_repair_service_rounded),
        makeDashboardItem(context, Enseignants, Icons.person_outline),
        makeDashboardItem(context, Enfant, Icons.account_box),
        makeDashboardItem(context, parents, Icons.person_pin_circle),
        makeDashboardItem(context, Rapport_classe, Icons.wysiwyg),
        makeDashboardItem(context, Rapport_etudiant, Icons.child_care),
        makeDashboardItem(context, Messages, Icons.email_outlined),
        makeDashboardItem(context, Changer_MDP, Icons.security),
        makeDashboardItem(context, Sortie, Icons.logout),
      ];
    } else if (UserCurrentInfo.currentUserType == "teacher") {
      mainWidgets = <Widget>[
        makeDashboardItem(context, Rapport_classe, Icons.wysiwyg),
        makeDashboardItem(context, Rapport_etudiant, Icons.child_care),
        makeDashboardItem(context, Messages, Icons.email_outlined),
        makeDashboardItem(context, Changer_MDP, Icons.email_outlined),
        makeDashboardItem(context, Sortie, Icons.logout)
      ];
    } else {
      mainWidgets = <Widget>[
        makeDashboardItem(context, Rapport_classe, Icons.wysiwyg),
        makeDashboardItem(context, Rapport_etudiant, Icons.child_care),
        makeDashboardItem(context, Messages, Icons.email_outlined),
        makeDashboardItem(context, Changer_MDP, Icons.email_outlined),
        makeDashboardItem(context, Sortie, Icons.logout)
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
      appBar: myAppBar(),
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
