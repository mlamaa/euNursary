import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import "package:firebase_auth/firebase_auth.dart";
import 'package:garderieeu/Colors.dart';
import 'package:garderieeu/UserInfo.dart';
import "login.dart";
import 'package:garderieeu/auth.dart';
import 'package:garderieeu/widgets.dart';
import "package:garderieeu/Tools.dart";
import 'package:garderieeu/db.dart';
import 'Classes/Classes.dart';
import 'Teachers/TeachersClass.dart';
import 'Parents/Parents.dart';
import 'Students/Students.dart';
import 'ClassReport/Admin/AdminClassReport.dart';
import 'ClassReport/Parent/ParentClassReport.dart';
import 'ClassReport/Teacher/TeacherClassReport.dart';
import 'StudentReport//Admin/AdminStudentReport.dart';
import 'StudentReport/Parent/ParentStudentReport.dart';
import 'StudentReport/Teacher/TeacherStudentReport.dart';
import 'dart:io';
import 'Messages/SendMessage.dart';
import 'Messages/RecieveMessages.dart';
import 'ChangePass.dart';


class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;
}

class _HomePageState extends State<HomePage> {
  DataBaseService dataBaseService = new DataBaseService();
  FirebaseMessaging firebaseMessaging=new FirebaseMessaging();

  bool isAuthenticated=false;
  Auth auth = new Auth();

  List<Widget> MainWidgets=new List<Widget>();
  // List<Widget> TeacherWidgets=new List<Widget>();
  // List<Widget> ParentWidgets=new List<Widget>();

  getUserType(String Email) async{
    await dataBaseService.GetUserType(Email,context).then((value) {
      UserCurrentInfo.Type=value.data["type"];
      // print(UserCurrentInfo.Type+"a");
      setState(() {
        setMainWidgets();
      });
    });
  }

  CheckIfAuthenticated() async{
    await widget.firebaseAuth.currentUser().then((value) {
      if(value==null){
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>new LoginPage(auth: auth,)));
      }else{
        getUserType(value.email);
        UserCurrentInfo.Email=value.email;
        UserCurrentInfo.UID=value.uid;
        dataBaseService.SaveTooken(UserCurrentInfo.Email,UserCurrentInfo.Type,context);
        setState(() {
          isAuthenticated=true;
        });
      }
    });
  }

  logout() async{
    await auth.signOut().then((value) {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>new LoginPage(auth: auth,)));
    });
  }


  void goToPage(String tag , BuildContext context)
  {
    if(tag == "Logout")
    {
      logout();
      return;
    }

    Navigator.push(context, MaterialPageRoute(builder: (context) {


      switch(tag)
      {

        case "Classes" :
          return new Classes();
          case "Change Password" :
          return new ChangePass();

        case "Messages" :{
          if(UserCurrentInfo.Type=="admin"){
            return new SendMessage();
          }else if(UserCurrentInfo.Type=="teacher"){
            return new SendMessage();

          }else{
            return new RecieveMessages();
          }
          return HomePage();
        }


        case "Students" :
          return new Students();

        case "Parents":
          return new Parents();

        case "Teachers":
          return new Teachers();

        case "Class Report":{
          if(UserCurrentInfo.Type=="admin"){
            return new AdminClassReport();
          }else if(UserCurrentInfo.Type=="teacher"){
            return new TeacherClassReport();

          }else{
            return new ParentClassReport();
          }
          return new ParentClassReport();
        }


        case "Student Report":{
          if(UserCurrentInfo.Type=="admin"){
            return new AdminStudentReport();
          }else if(UserCurrentInfo.Type=="teacher"){
            return new TeacherStudentReport();

          }else{
            return new ParentStudentReport();
          }
          return new ParentClassReport();
        }

      }


      return HomePage();

    }));


  }

  Container makeDashboardItem(BuildContext context , String title, IconData icon) {

    TextStyle DashBoardTextStyle= TextStyle(fontFamily: 'Montserrat', fontSize: 22.0,color: Colors.white,fontWeight: FontWeight.bold,);


    return Container(
       color: MyColors.color4,
        // color:MyColors.color1 ,
        // elevation: 1.0,
        margin: new EdgeInsets.all(8.0),
        child: Container(
          decoration: BoxDecoration(
              borderRadius: Tools.myBorderRadius,
              color: MyColors.color1),
          child: new InkWell(
            onTap: () => goToPage(title ,  context) ,
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
                    fit:BoxFit.fitWidth,
                    child: new Text(title,
                        style: DashBoardTextStyle,textAlign: TextAlign.center ,
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

  setMainWidgets(){
    if(UserCurrentInfo.Type=="admin"){
      MainWidgets=<Widget>[
        makeDashboardItem(context , "Classes", Icons.account_balance),
        makeDashboardItem(context , "Teachers", Icons.person_outline),
        makeDashboardItem(context , "Students", Icons.account_box),
        makeDashboardItem(context , "Parents", Icons.person_pin_circle),
        makeDashboardItem(context , "Class Report", Icons.report),
        makeDashboardItem(context , "Student Report", Icons.report_problem),
        makeDashboardItem(context , "Messages", Icons.message),
        // makeDashboardItem(context , "ReportStudent", Icons.alarm),
        makeDashboardItem(context , "Change Password", Icons.build),
        makeDashboardItem(context , "Logout", Icons.keyboard_backspace),


      ];
    }else if(UserCurrentInfo.Type=="teacher"){
      MainWidgets=<Widget>[
        makeDashboardItem(context , "Class Report", Icons.report),
        makeDashboardItem(context , "Student Report", Icons.report_problem),
        makeDashboardItem(context , "Messages", Icons.message),
        makeDashboardItem(context , "Change Password", Icons.build),
        makeDashboardItem(context , "Logout", Icons.keyboard_backspace)

      ];
    }else{
      MainWidgets=<Widget>[
        makeDashboardItem(context , "Class Report", Icons.report),
        makeDashboardItem(context , "Student Report", Icons.report_problem),
        makeDashboardItem(context , "Messages", Icons.message),
        makeDashboardItem(context , "Change Password", Icons.build),
        makeDashboardItem(context , "Logout", Icons.keyboard_backspace)

      ];
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    CheckIfAuthenticated();

    // firebaseMessaging.configure(
    //   onMessage: (Map<String, dynamic> message) async {
    //     print("onMessage: $message");
    //     // _showItemDialog(message);
    //   },
    //   onLaunch: (Map<String, dynamic> message) async {
    //     print("onLaunch: $message");
    //     // _navigateToItemDetail(message);
    //   },
    //   onResume: (Map<String, dynamic> message) async {
    //     print("onResume: $message");
    //     // _navigateToItemDetail(message);
    //   },
    // );
    //
    // if(Platform.isIOS){
    //        firebaseMessaging.requestNotificationPermissions(
    //       const IosNotificationSettings(sound: true, badge: true, alert: true, provisional: false),
    //     );
    // }

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColors.color4,
      appBar: MyAppBar("title"),
      body: SafeArea(
        child: isAuthenticated?
        Center(
          child:  Container(
            padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 2.0),
            child: GridView.count(
              crossAxisCount: 2,
              padding: EdgeInsets.all(3.0),
              children: MainWidgets,
            ),
          ),

        )

            :Center(
          child: CircularProgressIndicator(),
        )
        ,
      ),
    );
  }
}
