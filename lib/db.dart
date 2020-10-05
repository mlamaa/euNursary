import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart'; 
import 'package:garderieeu/UserInfo.dart'; 
import 'auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:intl/intl.dart';

class DataBaseService {
  FirebaseStorage storage = FirebaseStorage.instance;
  FirebaseMessaging firebaseMessaging = new FirebaseMessaging();
  Firestore firestore = Firestore.instance;
  Auth auth = new Auth();

  // Future<DocumentSnapshot> GetRulesText(){
  //   return firestore.collection("MainData").document("RulesText").get();
  //
  //
  // }
  String getDateNow() {
    String Datehere = " ";
    DateTime datetime = DateTime.now();
    var formatter = new DateFormat("yyyy.MM.dd");
    Datehere = formatter.format(datetime);
    return Datehere;
  }

  Future saveTooken(String email, String type, BuildContext context) async {
    String getCollectionName() => type == "admin"
        ? "Admins"
        : type == "teacher"
            ? "Teachers"
            : type == "parents"
                ? "parents"
                : '';
    try {
      print("saving tookem");
      await firebaseMessaging.getToken().then((token) async {
        Map<String, dynamic> map = new Map<String, dynamic>();
        map["UserTooken"] = token;
        var data = await firestore
            .collection(getCollectionName())
            ?.document(email)
            ?.get();
        print(data);
        if (data != null) {
          firestore
              .collection(getCollectionName())
              .document(email)
              .updateData(map);
        } else {
          firestore
              .collection(getCollectionName())
              .document(email)
              .setData(map);
        }
      });
    } catch (error) {
//       final snackBar = SnackBar(content: Text('Error: '+error.toString()));
//
//       Scaffold.of(context).showSnackBar(snackBar);
      print('error while saving token $error');
    }
  }

  Future<DocumentSnapshot> getUserType(
      String email, BuildContext context) async {
    try {
      return await firestore.collection("UserTypes").document(email).get();
    } catch (error) {
      final snackBar = SnackBar(content: Text('Error: ' + error.toString()));

      Scaffold.of(context).showSnackBar(snackBar);
    }
  }

  Future<QuerySnapshot> getDatesOfData(BuildContext context) async {
    try {
      return await firestore
          .collection("ClassReports")
          .orderBy("Date", descending: true)
          .getDocuments();
    } catch (error) {
      final snackBar = SnackBar(content: Text('Error: ' + error.toString()));

      Scaffold.of(context).showSnackBar(snackBar);
      return null;
    }
  }

  Future<QuerySnapshot> getDatesOfStudentData(BuildContext context) async {
    try {
      return await firestore
          .collection("StudentsReports")
          .orderBy("Date", descending: true)
          .getDocuments();
    } catch (error) {
      final snackBar = SnackBar(content: Text('Error: ' + error.toString()));

      Scaffold.of(context).showSnackBar(snackBar);
    }
  }

  Future<void> setUserType(String email, Map map, BuildContext context) async {
    try {
      await firestore.collection("UserTypes").document(email).setData(map);
    } catch (error) {
      final snackBar = SnackBar(content: Text('Error: ' + error.toString()));
      Scaffold.of(context).showSnackBar(snackBar);
    }
  }

  Future<void> AddClassToDataBase(Map ClassMap, BuildContext context) async {
    try {
      await firestore.collection("classes").add(ClassMap);
    } catch (error) {
      final snackBar = SnackBar(content: Text('Error: ' + error.toString()));
      Scaffold.of(context).showSnackBar(snackBar);
    }
  }

  Future<void> EditClassToDataBase(
      Map ClassMap, String ID, BuildContext context) async {
    try {
      await firestore.collection("classes").document(ID).updateData(ClassMap);
    } catch (error) {
      final snackBar = SnackBar(content: Text('Error: ' + error.toString()));
      Scaffold.of(context).showSnackBar(snackBar);
    }
  }

  Future<QuerySnapshot> GetClasses(BuildContext context) {
    try {
      return firestore.collection("classes").getDocuments();
    } catch (error) {
      final snackBar = SnackBar(content: Text('Error: ' + error.toString()));
      Scaffold.of(context).showSnackBar(snackBar);
    }
  }

  Future<QuerySnapshot> GetClassStudents(String ClassId, BuildContext context) {
    try {
      return firestore
          .collection("classes")
          .document(ClassId)
          .collection("students")
          .getDocuments();
    } catch (error) {
      final snackBar = SnackBar(content: Text('Error: ' + error.toString()));
      Scaffold.of(context).showSnackBar(snackBar);
    }
  }

  Future<String> GetUserPassword(BuildContext context) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getString("UserId");
    } catch (error) {
      final snackBar = SnackBar(content: Text('Error: ' + error.toString()));
      Scaffold.of(context).showSnackBar(snackBar);
    }
  }

  Future<void> authenticateTeacher(
      Map classMap, String email, String pass, BuildContext context) async {
    try {
      await Auth.register(email, pass);
      await addTeacherToDataBase(classMap, email, context);
      // await auth.createUser(email, pass).then((value1) {
      //   if(value1!=null&&value1!=UserCurrentInfo.Email)
      //   {
      //     print("creatingg");
      //     GetUserPassword(context).then((value) {
      //       auth.signIn(UserCurrentInfo.Email, value).then((value) {
      //         AddTeacherToDataBase(classMap,email,context);
      //       });

      //     });
      //   }
      //   else{
      //     print("whyyyy");
      //   }
      // });
    } catch (error) {
      final snackBar = SnackBar(content: Text('Error: ' + error.toString()));
      Scaffold.of(context).showSnackBar(snackBar);

      Future.delayed(const Duration(milliseconds: 2000), () {
        Navigator.pop(context);
      });
    }
  }

  Future<void> addTeacherToDataBase(
      Map classMap, String email, BuildContext context) async {
    try {
      Map<String, String> map = new Map<String, String>();
      map["type"] = "teacher";
      await firestore
          .collection("Teachers")
          .document(email)
          .setData(classMap)
          .then((value) {
        setUserType(email, map, context);
      });
    } catch (error) {
      final snackBar = SnackBar(content: Text('Error: ' + error.toString()));
      Scaffold.of(context).showSnackBar(snackBar);
    }
  }

  Future<DocumentSnapshot> getSingleTeacher(
      String email, BuildContext context) async {
    try {
      return await firestore.collection("Teachers").document(email).get();
    } catch (error) {
      final snackBar = SnackBar(content: Text('Error: ' + error.toString()));
      Scaffold.of(context).showSnackBar(snackBar);
      return null;
    }
  }

  Future<DocumentSnapshot> GetSingleClass(
      String ClassID, BuildContext context) async {
    try {
      return await firestore.collection("classes").document(ClassID).get();
    } catch (error) {
      final snackBar = SnackBar(content: Text('Error: ' + error.toString()));
      Scaffold.of(context).showSnackBar(snackBar);
    }
  }

  Future<DocumentSnapshot> GetSingleStudent(
      String ID, BuildContext context) async {
    try {
      return await firestore.collection("students").document(ID).get();
    } catch (error) {
      final snackBar = SnackBar(content: Text('Error: ' + error.toString()));
      Scaffold.of(context).showSnackBar(snackBar);
    }
  }

  Future<DocumentSnapshot> GetSingleParent(
      String ParentEmail, BuildContext context) async {
    try {
      return await firestore.collection("parents").document(ParentEmail).get();
    } catch (error) {
      final snackBar = SnackBar(content: Text('Error: ' + error.toString()));
      Scaffold.of(context).showSnackBar(snackBar);
    }
  }

  Future<void> editTeacherToDataBase(
      Map classMap, String email, BuildContext context) async {
    Map<String, String> map = new Map<String, String>();
    map["type"] = "teacher";
    await firestore
        .collection("Teachers")
        .document(email)
        .updateData(classMap)
        .then((value) {
      setUserType(email, map, context);
    });
  }

  // Future<void> EditTeacherToDataBase(Map ClassMap,String Email)async{
  //   await firestore.collection("Teachers").document(Email).updateData(ClassMap);
  // }

  Future<QuerySnapshot> GetTeachers(BuildContext context) {
    try {
      return firestore.collection("Teachers").getDocuments();
    } catch (error) {
      final snackBar = SnackBar(content: Text('Error: ' + error.toString()));
      Scaffold.of(context).showSnackBar(snackBar);
    }
  }

  Future<QuerySnapshot> GetParents(BuildContext context) {
    try {
      return firestore.collection("parents").getDocuments();
    } catch (error) {
      final snackBar = SnackBar(content: Text('Error: ' + error.toString()));
      Scaffold.of(context).showSnackBar(snackBar);
    }
  }

  Future<DocumentSnapshot> GetSingleParents(
      String Email, BuildContext context) {
    try {
      return firestore.collection("parents").document(Email).get();
    } catch (error) {
      final snackBar = SnackBar(content: Text('Error: ' + error.toString()));
      Scaffold.of(context).showSnackBar(snackBar);
    }
  }

  Future<void> AuthenticateParent(
      Map classMap, String email, String pass, BuildContext context) async {
    try {
      await Auth.register(email, pass);
      AddParentToDataBase(classMap, email,pass, context);

      // await auth.createUser(Email, Pass).then((valuee) {
      //   if(valuee!=null&&valuee!=UserCurrentInfo.Email)
      //   {
      //     print("creatingg");
      //     GetUserPassword(context).then((value) {
      //       auth.signIn(UserCurrentInfo.Email, value).then((value) {
      //         AddParentToDataBase(ClassMap,Email,context);
      //       });

      //     });
      //   }
      //   else{
      //     print("whyyyy");
      //   }
      // });
    } catch (error) {
      final snackBar = SnackBar(content: Text('Error: ' + error.toString()));
      Scaffold.of(context).showSnackBar(snackBar);
      Future.delayed(const Duration(milliseconds: 2000), () {
        Navigator.pop(context);
      });
    }
  }

  Future<void> AddParentToDataBase(
      Map ClassMap, String Email,String pass, BuildContext context) async {
    try {
      Map<String, String> map = new Map<String, String>();
      map["type"] = "parent";
      await firestore
          .collection("parents")
          .document(Email)
          .setData(ClassMap)
          .then((value) {
        setUserType(Email, map, context);
      });
    } catch (error) {
      final snackBar = SnackBar(content: Text('Error: ' + error.toString()));
      Scaffold.of(context).showSnackBar(snackBar);
    }
  }

  Future<void> EditParentToDataBase(
      Map ClassMap, String Email, BuildContext context) async {
    try {
      Map<String, String> map = new Map<String, String>();
      map["type"] = "parent";
      await firestore
          .collection("parents")
          .document(Email)
          .updateData(ClassMap)
          .then((value) {
        setUserType(Email, map, context);
      });
    } catch (error) {
      final snackBar = SnackBar(content: Text('Error: ' + error.toString()));
      Scaffold.of(context).showSnackBar(snackBar);
    }
  }

  Future<QuerySnapshot> GetStudents(BuildContext context) {
    try {
      return firestore.collection("students").getDocuments();
    } catch (error) {
      final snackBar = SnackBar(content: Text('Error: ' + error.toString()));
      Scaffold.of(context).showSnackBar(snackBar);
    }
  }

  Future<void> AddStudentTODataBase(Map ClassMap, String classID,
      String ParentEmail, BuildContext context) async {
    try {
      await firestore
          .collection("parents")
          .document(ParentEmail)
          .get()
          .then((value) {
        List<dynamic> ChildsClassesId;
        ChildsClassesId = value.data["ChildsClassesId"];

        if (ChildsClassesId != null) {
          for (int i = 0; i < ChildsClassesId.length; i++) {
            if (ChildsClassesId[i] == classID) {
              ChildsClassesId.removeAt(i);
            }
          }
        } else {
          ChildsClassesId = new List<dynamic>();
        }

        ChildsClassesId.add(classID);
        Map<String, dynamic> newMap = new Map<String, dynamic>();
        newMap["ChildsClassesId"] = ChildsClassesId;

        firestore
            .collection("parents")
            .document(ParentEmail)
            .updateData(newMap)
            .then((value) {
          firestore.collection("students").add(ClassMap).then((value) {
            firestore
                .collection("classes")
                .document(classID)
                .collection("students")
                .document(value.documentID)
                .setData(ClassMap);
            firestore
                .collection("parents")
                .document(ParentEmail)
                .collection("child")
                .document(value.documentID)
                .setData(ClassMap);
          });
        });
      });
    } catch (error) {
      final snackBar = SnackBar(content: Text('Error: ' + error.toString()));
      Scaffold.of(context).showSnackBar(snackBar);
    }
  }

  Future<void> EdittStudentTODataBase(Map ClassMap, String classID,
      String ParentEmail, String StudentId, BuildContext context) async {
    try {
      await firestore
          .collection("parents")
          .document(ParentEmail)
          .get()
          .then((value) {
        List<dynamic> ChildsClassesId;
        ChildsClassesId = value.data["ChildsClassesId"];

        if (ChildsClassesId != null) {
          for (int i = 0; i < ChildsClassesId.length; i++) {
            if (ChildsClassesId[i] == classID) {
              ChildsClassesId.removeAt(i);
            }
          }
        } else {
          ChildsClassesId = new List<dynamic>();
        }

        ChildsClassesId.add(classID);
        Map<String, dynamic> newMap = new Map<String, dynamic>();
        newMap["ChildsClassesId"] = ChildsClassesId;

        firestore
            .collection("parents")
            .document(ParentEmail)
            .updateData(newMap)
            .then((value) {
          firestore
              .collection("students")
              .document(StudentId)
              .updateData(ClassMap)
              .then((value) {
            firestore
                .collection("classes")
                .document(classID)
                .collection("students")
                .document(StudentId)
                .setData(ClassMap);
            firestore
                .collection("parents")
                .document(ParentEmail)
                .collection("child")
                .document(StudentId)
                .setData(ClassMap);
          });
        });
      });
    } catch (error) {
      final snackBar = SnackBar(content: Text('Error: ' + error.toString()));

      Scaffold.of(context).showSnackBar(snackBar);
    }
  }

  // reports

  //
  Future<QuerySnapshot> GetClassReports(
      String DateOfReprt, BuildContext context) {
    try {
      print("from db" + DateOfReprt);
      return firestore
          .collection("ClassReports")
          .document(DateOfReprt)
          .collection("Reports")
          .orderBy("Date", descending: true)
          .getDocuments();
    } catch (error) {
      final snackBar = SnackBar(content: Text('Error: ' + error.toString()));

      Scaffold.of(context).showSnackBar(snackBar);
    }
  }

  Future<QuerySnapshot> GetQuestionsOfReport(
      String ReportID, String DateOfReprt, BuildContext context) {
    try {
      print(DateOfReprt + "from database" + ReportID);
      return firestore
          .collection("ClassReports")
          .document(DateOfReprt)
          .collection("Reports")
          .document(ReportID)
          .collection("Questions")
          .getDocuments();
    } catch (error) {
      final snackBar = SnackBar(content: Text('Error: ' + error.toString()));

      Scaffold.of(context).showSnackBar(snackBar);
    }
  }

  SendClassReport(Map DataMap, List<QuestionAndAnswers> QuestionsMap,
      String ClassID, String DateOfReprt, BuildContext context) async {
    try {
      Map<String, dynamic> ThisDateMap = new Map<String, dynamic>();
      ThisDateMap["Date"] = DateOfReprt;
      firestore
          .collection("ClassReports")
          .document(DateOfReprt)
          .setData(ThisDateMap);
      await firestore
          .collection("ClassReports")
          .document(DateOfReprt)
          .collection("Reports")
          .document(ClassID)
          .collection("Questions")
          .getDocuments()
          .then((value1) {
        for (int o = 0; o < value1.documents.length; o++) {
          firestore
              .collection("ClassReports")
              .document(DateOfReprt)
              .collection("Reports")
              .document(ClassID)
              .collection("Questions")
              .document(value1.documents[o].documentID)
              .delete();
        }
      });

      await firestore
          .collection("ClassReports")
          .document(DateOfReprt)
          .collection("Reports")
          .document(ClassID)
          .setData(DataMap)
          .then((value) {
        // print(value.documentID);
        print(QuestionsMap.length.toString());
        for (int i = 0; i < QuestionsMap.length; i++) {
          print(QuestionsMap[i].question);
          Map<String, dynamic> QuestionsAndAnswersMapp =
              new Map<String, dynamic>();
          QuestionsAndAnswersMapp["Question"] = QuestionsMap[i].question;
          if (QuestionsMap[i].answer != null) {
            QuestionsAndAnswersMapp["Answer"] = QuestionsMap[i].answer;
          } else {
            QuestionsAndAnswersMapp["Answer"] = QuestionsMap[i].answers;
          }

          firestore
              .collection("ClassReports")
              .document(DateOfReprt)
              .collection("Reports")
              .document(ClassID)
              .collection("Questions")
              .add(QuestionsAndAnswersMapp);
        }
      });
    } catch (error) {
      final snackBar = SnackBar(content: Text('Error: ' + error.toString()));

      Scaffold.of(context).showSnackBar(snackBar);
    }
  }

  Future<DocumentSnapshot> GetClassReportsTemplates(BuildContext context) {
    try {
      return firestore.collection("ReportTemplates").document("Class").get();
    } catch (error) {
      final snackBar = SnackBar(content: Text('Error: ' + error.toString()));

      Scaffold.of(context).showSnackBar(snackBar);
    }
  }

  Future<QuerySnapshot> GetClassReportTemplateQuestions(BuildContext context) {
    try {
      return firestore
          .collection("ReportTemplates")
          .document("Class")
          .collection("Questions")
          .getDocuments();
    } catch (error) {
      final snackBar = SnackBar(content: Text('Error: ' + error.toString()));

      Scaffold.of(context).showSnackBar(snackBar);
    }
  }

  SendNewClassReportTempplate(
      List<ClassReportItems> classReportItems, BuildContext context) async {
    try {
      Map<String, dynamic> DataMap = new Map<String, dynamic>();
      DataMap["Date"] = FieldValue.serverTimestamp();
      DataMap["ReportTemplateMaker"] = UserCurrentInfo.UID;
      // DataMap["ReportName"]=ReportName;
      await firestore
          .collection("ReportTemplates")
          .document("Class")
          .collection("Questions")
          .getDocuments()
          .then((value1) {
        for (int o = 0; o < value1.documents.length; o++) {
          firestore
              .collection("ReportTemplates")
              .document("Class")
              .collection("Questions")
              .document(value1.documents[o].documentID)
              .delete();
        }
        firestore
            .collection("ReportTemplates")
            .document("Class")
            .setData(DataMap)
            .then((value) {
          for (int i = 0; i < classReportItems.length; i++) {
            Map<String, dynamic> QuestionsAndAnswersMapp =
                new Map<String, dynamic>();
            QuestionsAndAnswersMapp["MultipleChoice"] =
                classReportItems[i].MultipleChoice;
            QuestionsAndAnswersMapp["Question"] = classReportItems[i].Question;
            QuestionsAndAnswersMapp["TheChoices"] =
                classReportItems[i].TheChoices;
            QuestionsAndAnswersMapp["Type"] = classReportItems[i].Type;
            QuestionsAndAnswersMapp["choicesCount"] =
                classReportItems[i].choicesCount;

            firestore
                .collection("ReportTemplates")
                .document("Class")
                .collection("Questions")
                .add(QuestionsAndAnswersMapp);
          }
        });
      });
    } catch (error) {
      final snackBar = SnackBar(content: Text('Error: ' + error.toString()));

      Scaffold.of(context).showSnackBar(snackBar);
    }
  }

  // studeent reports

  //
  Future<QuerySnapshot> GetStudentReports(String datee, BuildContext context) {
    try {
      return firestore
          .collection("StudentsReports")
          .document(datee)
          .collection("Reports")
          .orderBy("Date", descending: true)
          .getDocuments();
    } catch (error) {
      final snackBar = SnackBar(content: Text('Error: ' + error.toString()));

      Scaffold.of(context).showSnackBar(snackBar);
    }
  }

  Future<QuerySnapshot> GetQuestionsOfStudentReport(
      String ReportID, BuildContext context) {
    try {
      return firestore
          .collection("StudentsReports")
          .document(getDateNow())
          .collection("Reports")
          .document(ReportID)
          .collection("Questions")
          .getDocuments();
    } catch (error) {
      final snackBar = SnackBar(content: Text('Error: ' + error.toString()));

      Scaffold.of(context).showSnackBar(snackBar);
    }
  }

  SendStudentReport(Map DataMap, List<QuestionAndAnswers> QuestionsMap,
      String StudentId, BuildContext context) async {
    try {
      Map<String, dynamic> ThisDateMap = new Map<String, dynamic>();
      ThisDateMap["Date"] = getDateNow();
      firestore
          .collection("StudentsReports")
          .document(getDateNow())
          .setData(ThisDateMap);

      await firestore
          .collection("StudentsReports")
          .document(getDateNow())
          .collection("Reports")
          .document(StudentId)
          .collection("Questions")
          .getDocuments()
          .then((value1) {
        for (int o = 0; o < value1.documents.length; o++) {
          firestore
              .collection("StudentsReports")
              .document(getDateNow())
              .collection("Reports")
              .document(StudentId)
              .collection("Questions")
              .document(value1.documents[o].documentID)
              .delete();
        }
      });

      await firestore
          .collection("StudentsReports")
          .document(getDateNow())
          .collection("Reports")
          .document(StudentId)
          .setData(DataMap)
          .then((value) {
        // print(value.documentID);
        print(QuestionsMap.length.toString());
        for (int i = 0; i < QuestionsMap.length; i++) {
          print(QuestionsMap[i].question);
          Map<String, dynamic> QuestionsAndAnswersMapp =
              new Map<String, dynamic>();
          QuestionsAndAnswersMapp["Question"] = QuestionsMap[i].question;
          if (QuestionsMap[i].answer != null) {
            QuestionsAndAnswersMapp["Answer"] = QuestionsMap[i].answer;
          } else {
            QuestionsAndAnswersMapp["Answer"] = QuestionsMap[i].answers;
          }

          firestore
              .collection("StudentsReports")
              .document(getDateNow())
              .collection("Reports")
              .document(StudentId)
              .collection("Questions")
              .add(QuestionsAndAnswersMapp);
        }
      });
    } catch (error) {
      final snackBar = SnackBar(content: Text('Error: ' + error.toString()));

      Scaffold.of(context).showSnackBar(snackBar);
    }
  }

  Future<DocumentSnapshot> GetStudentReportsTemplates(BuildContext context) {
    try {
      return firestore.collection("ReportTemplates").document("Student").get();
    } catch (error) {
      final snackBar = SnackBar(content: Text('Error: ' + error.toString()));

      Scaffold.of(context).showSnackBar(snackBar);
    }
  }

  Future<QuerySnapshot> GetStudentReportTemplateQuestions(
      BuildContext context) {
    try {
      return firestore
          .collection("ReportTemplates")
          .document("Student")
          .collection("Questions")
          .getDocuments();
    } catch (error) {
      final snackBar = SnackBar(content: Text('Error: ' + error.toString()));

      Scaffold.of(context).showSnackBar(snackBar);
    }
  }

  SendNewStudentReportTempplate(
      List<StudentReportItems> studentReportItems, BuildContext context) async {
    try {
      Map<String, dynamic> DataMap = new Map<String, dynamic>();
      DataMap["Date"] = FieldValue.serverTimestamp();
      DataMap["ReportTemplateMaker"] = UserCurrentInfo.UID;
      // DataMap["ReportName"]=ReportName;
      await firestore
          .collection("ReportTemplates")
          .document("Student")
          .collection("Questions")
          .getDocuments()
          .then((value1) {
        for (int o = 0; o < value1.documents.length; o++) {
          firestore
              .collection("ReportTemplates")
              .document("Student")
              .collection("Questions")
              .document(value1.documents[o].documentID)
              .delete();
        }
        firestore
            .collection("ReportTemplates")
            .document("Student")
            .setData(DataMap)
            .then((value) {
          for (int i = 0; i < studentReportItems.length; i++) {
            Map<String, dynamic> QuestionsAndAnswersMapp =
                new Map<String, dynamic>();
            QuestionsAndAnswersMapp["MultipleChoice"] =
                studentReportItems[i].MultipleChoice;
            QuestionsAndAnswersMapp["Question"] =
                studentReportItems[i].Question;
            QuestionsAndAnswersMapp["TheChoices"] =
                studentReportItems[i].TheChoices;
            QuestionsAndAnswersMapp["Type"] = studentReportItems[i].Type;
            QuestionsAndAnswersMapp["choicesCount"] =
                studentReportItems[i].choicesCount;

            firestore
                .collection("ReportTemplates")
                .document("Student")
                .collection("Questions")
                .add(QuestionsAndAnswersMapp);
          }
        });
      });
    } catch (error) {
      final snackBar = SnackBar(content: Text('Error: ' + error.toString()));

      Scaffold.of(context).showSnackBar(snackBar);
    }
  }

  DeleteClassReport(String ClassReportID, BuildContext context,
      Function refresh, String DateOfReprt) async {
    try {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(" "),
            content: Text("Are you sure you want to delete this Class Report"),
            actions: [
              FlatButton(
                child: Text("yes"),
                onPressed: () {
                  //yes
                  print("yesssss");
                  firestore
                      .collection("ClassReports")
                      .document(DateOfReprt)
                      .collection("Reports")
                      .document(ClassReportID)
                      .delete()
                      .then((value) {
                    refresh(DateOfReprt);
                    Navigator.pop(context);
                  });
                },
              ),
              FlatButton(
                child: Text("no"),
                onPressed: () {
                  //no
                  print("nooooooooo");
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    } catch (error) {
      final snackBar = SnackBar(content: Text('Error: ' + error.toString()));

      Scaffold.of(context).showSnackBar(snackBar);
    }
  }

  DeleteStudentReport(
      String StudentReportID, BuildContext context, Function refresh) async {
    try {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(" "),
            content:
                Text("Are you sure you want to delete this Student Report"),
            actions: [
              FlatButton(
                child: Text("yes"),
                onPressed: () {
                  //yes
                  print("yesssss");
                  firestore
                      .collection("StudentsReports")
                      .document(getDateNow())
                      .collection("Reports")
                      .document(StudentReportID)
                      .delete()
                      .then((value) {
                    refresh(getDateNow());
                    Navigator.pop(context);
                  });
                },
              ),
              FlatButton(
                child: Text("no"),
                onPressed: () {
                  //no
                  print("nooooooooo");
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    } catch (error) {
      final snackBar = SnackBar(content: Text('Error: ' + error.toString()));

      Scaffold.of(context).showSnackBar(snackBar);
    }
  }

  DeleteStudent(
      String StudentId, BuildContext context, Function refresh) async {
    try {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(" "),
            content: Text("Are you sure you want to delete this student"),
            actions: [
              FlatButton(
                child: Text("yes"),
                onPressed: () {
                  //yes
                  print("yesssss");
                  firestore
                      .collection("students")
                      .document(StudentId)
                      .delete()
                      .then((value) {
                    refresh();
                    Navigator.pop(context);
                  });
                },
              ),
              FlatButton(
                child: Text("no"),
                onPressed: () {
                  //no
                  print("nooooooooo");
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    } catch (error) {
      final snackBar = SnackBar(content: Text('Error: ' + error.toString()));

      Scaffold.of(context).showSnackBar(snackBar);
    }
  }

  DeleteStudentFromClass(String StudentId, String ClassID, BuildContext context,
      Function refresh) async {
    try {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(" "),
            content: Text("Are you sure you want to delete this student"),
            actions: [
              FlatButton(
                child: Text("yes"),
                onPressed: () {
                  //yes
                  print("yesssss");
                  firestore
                      .collection("classes")
                      .document(ClassID)
                      .collection("students")
                      .document(StudentId)
                      .delete()
                      .then((value) {
                    refresh();
                    Navigator.pop(context);
                  });
                },
              ),
              FlatButton(
                child: Text("no"),
                onPressed: () {
                  //no
                  print("nooooooooo");
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    } catch (error) {
      final snackBar = SnackBar(content: Text('Error: ' + error.toString()));

      Scaffold.of(context).showSnackBar(snackBar);
    }
    // print(ClassID+"   ");
  }

  deleteTeacher(
      String teacherEmail,String teacherPassword, BuildContext context, Function refresh) async {
    try {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(" "),
            content: Text("Are you sure you want to delete this student"),
            actions: [
              FlatButton(
                child: Text("yes"),
                onPressed: () async {
                  //yes
                  print("yesssss");
                  await auth.deleteUser(teacherEmail, teacherPassword);
                  firestore
                      .collection("Teachers")
                      .document(teacherEmail)
                      .delete()
                      .then((value) {
                    refresh();
                    Navigator.pop(context);
                  });
                },
              ),
              FlatButton(
                child: Text("no"),
                onPressed: () {
                  //no
                  print("nooooooooo");
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    } catch (error) {
      final snackBar = SnackBar(content: Text('Error: ' + error.toString()));

      Scaffold.of(context).showSnackBar(snackBar);
    }
  }

  DeleteClass(String ClassID, BuildContext context, Function refresh) async {
    try {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(" "),
            content: Text("Are you sure you want to delete this student"),
            actions: [
              FlatButton(
                child: Text("yes"),
                onPressed: () {
                  //yes
                  print("yesssss");
                  firestore
                      .collection("classes")
                      .document(ClassID)
                      .delete()
                      .then((value) {
                    refresh();
                    Navigator.pop(context);
                  });
                },
              ),
              FlatButton(
                child: Text("no"),
                onPressed: () {
                  //no
                  print("nooooooooo");
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    } catch (error) {
      final snackBar = SnackBar(content: Text('Error: ' + error.toString()));

      Scaffold.of(context).showSnackBar(snackBar);
    }
  }

  deleteParent(
      String parentEmail,String parentPassword, BuildContext context, Function refresh) async {
    try {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(" "),
            content: Text("Are you sure you want to delete this student"),
            actions: [
              FlatButton(
                child: Text("yes"),
                onPressed: () async{
                  await auth.deleteUser(parentEmail, parentPassword);
                  print("yesssss");
                  firestore
                      .collection("parents")
                      .document(parentEmail)
                      .delete()
                      .then((value) {
                    refresh();
                    Navigator.pop(context);
                  });
                },
              ),
              FlatButton(
                child: Text("no"),
                onPressed: () =>
                  Navigator.of(context).pop(),
              ),
            ],
          );
        },
      );
    } catch (error) {
      final snackBar = SnackBar(content: Text('Error: ' + error.toString()));

      Scaffold.of(context).showSnackBar(snackBar);
    }
  }

  sendClassMessages(String ClassID, String Message, String Title,
      BuildContext context) async {
    try {
      List<String> ParentsToSendNotifications = new List<String>();
      firestore.collection("parents").getDocuments().then((value2) {
        for (int i = 0; i < value2.documents.length; i++) {
          for (int j = 0;
              j < value2.documents[i].data["ChildsClassesId"].length;
              j++) {
            if (value2.documents[i].data["ChildsClassesId"][j] == ClassID) {
              ParentsToSendNotifications.add(value2.documents[i].documentID);
            }
          }
        }
        Map<String, String> NotifMap = new Map<String, String>();
        NotifMap["message"] = Message;
        NotifMap["title"] = Title;

        for (int k = 0; k < ParentsToSendNotifications.length; k++) {
          firestore
              .collection("Notification")
              .document(ParentsToSendNotifications[k])
              .collection("notifications")
              .add(NotifMap);
        }
      });
    } catch (error) {
      final snackBar = SnackBar(content: Text('Error: ' + error.toString()));

      Scaffold.of(context).showSnackBar(snackBar);
    }
  }

  sendAllMessage(String Message, String Title, BuildContext context) async {
    try {
      List<String> ParentsToSendNotifications = new List<String>();
      firestore.collection("parents").getDocuments().then((value2) {
        for (int i = 0; i < value2.documents.length; i++) {
          ParentsToSendNotifications.add(value2.documents[i].documentID);
        }
        Map<String, String> NotifMap = new Map<String, String>();
        NotifMap["message"] = Message;
        NotifMap["title"] = Title;

        for (int k = 0; k < ParentsToSendNotifications.length; k++) {
          firestore
              .collection("Notification")
              .document(ParentsToSendNotifications[k])
              .collection("notifications")
              .add(NotifMap);
        }
      });
    } catch (error) {
      final snackBar = SnackBar(content: Text('Error: ' + error.toString()));

      Scaffold.of(context).showSnackBar(snackBar);
    }
  }

  sendStudentMessages(String ParentEmail, String Message, String Title,
      BuildContext context) async {
    try {
      Map<String, String> NotifMap = new Map<String, String>();
      NotifMap["message"] = Message;
      NotifMap["title"] = Title;
      await firestore
          .collection("Notification")
          .document(ParentEmail)
          .collection("notifications")
          .add(NotifMap);
    } catch (error) {
      final snackBar = SnackBar(content: Text('Error: ' + error.toString()));

      Scaffold.of(context).showSnackBar(snackBar);
    }
  }

  Future<QuerySnapshot> getMessages(
      String ParentEmail, BuildContext context) async {
    try {
      return await firestore
          .collection("Notification")
          .document(ParentEmail)
          .collection("notifications")
          .getDocuments();
    } catch (error) {
      final snackBar = SnackBar(content: Text('Error: ' + error.toString()));

      Scaffold.of(context).showSnackBar(snackBar);
    }
  }

  Future<void> ChangePassword(String password) async {
    FirebaseUser user = await auth.currentUser();

    //Pass in the password to updatePassword.
    user.updatePassword(password).then((_) {
      print("Succesfull changed password");
    }).catchError((error) {
      print("Password can't be changed" + error.toString());
      //This might happen, when the wrong password is in, the user isn't found, or if the user hasn't logged in recently.
    });
  }
}

class QuestionAndAnswers {
  String question, answer;
  List<dynamic> answers;
}

class ClassReportItems {
  bool isAdded;
  String Type;
  List<dynamic> TheChoices;
  String Question;
  bool MultipleChoice;
  int choicesCount;
}

class StudentReportItems {
  bool isAdded;
  String Type;
  List<dynamic> TheChoices;
  String Question;
  bool MultipleChoice;
  int choicesCount;
}

class CreatingStudentReportSomeInfo {
  static List<StudentReportItems> CreatingStudentsReportItems =
      new List<StudentReportItems>();
}

class CreatingReportSomeInfo {
  static List<ClassReportItems> CreatingReportItems =
      new List<ClassReportItems>();
}
