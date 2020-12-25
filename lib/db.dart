import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:garderieeu/UserInfo.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'auth.dart';
import 'helpers/HelperContext.dart';
import 'services/FirebaseMessageService.dart';

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

  Future saveTooken(String email, String type, BuildContext context) =>
      firebaseMessaging.getToken().then((token) => firestore
          .collection('notification')
          .document('tokens')
          .setData({email: token}, merge: true));

  Future<DocumentSnapshot> getUserType(String email, BuildContext context) async {
    try {
      return await firestore.collection("UserTypes").document(email).get();
    } catch (error) {
      HelperContext.showMessage(context, 'Error: ' + error.toString());
    }
  }

  Future<QuerySnapshot> getDatesOfData(BuildContext context) async {
    try {
      return await firestore
          .collection("ClassReports")
          .orderBy("Date", descending: true)
          .getDocuments();
    } catch (error) {
      HelperContext.showMessage(context, 'Error: ' + error.toString());
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
      HelperContext.showMessage(context, 'Error: ' + error.toString());
    }
  }

  Future<void> setUserType(String email, Map map, BuildContext context) async {
    try {
      await firestore.collection("UserTypes").document(email).setData(map);
    } catch (error) {
      HelperContext.showMessage(context, 'Error: ' + error.toString());
    }
  }

  Future<void> AddClassToDataBase(Map ClassMap, BuildContext context) async {
    try {
      await firestore.collection("classes").add(ClassMap);
    } catch (error) {
      HelperContext.showMessage(context, 'Error: ' + error.toString());
    }
  }

  Future<void> EditClassToDataBase(Map ClassMap, String ID, BuildContext context) async {
    try {
      await firestore.collection("classes").document(ID).updateData(ClassMap);
    } catch (error) {
      HelperContext.showMessage(context, 'Error: ' + error.toString());
    }
  }

  Future<QuerySnapshot> GetClasses(BuildContext context) {
    try {
      return firestore.collection("classes").getDocuments();
    } catch (error) {
      HelperContext.showMessage(context, 'Error: ' + error.toString());
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
      HelperContext.showMessage(context, 'Error: ' + error.toString());
    }
  }

  Future<String> GetUserPassword(BuildContext context) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getString("UserId");
    } catch (error) {
      HelperContext.showMessage(context, 'Error: ' + error.toString());
    }
  }

  Future<void> authenticateTeacher(Map classMap, String email, String pass, BuildContext context) async {
    try {
      await Auth.register(email, pass);
      await addTeacherToDataBase(classMap, email, context);
    } catch (error) {
      HelperContext.showMessage(context, 'Error: ' + error.toString());
      Future.delayed(const Duration(milliseconds: 2000), () {
        Navigator.pop(context);
      });
    }
  }

  Future<List<String>> getTeacherClasses(String email)async{
    var data = await firestore
        .collection("Teachers")
        .document(email)
        .get();
    return (data.data['Classes'] as List).map((e) => e.toString()).toList();
  }

  Future<void> addTeacherToDataBase(Map classMap, String email, BuildContext context) async {
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
      HelperContext.showMessage(context, 'Error: ' + error.toString());
    }
  }

  Future<DocumentSnapshot> getSingleTeacher(String email, BuildContext context) async {
    try {
      return await firestore.collection("Teachers").document(email).get();
    } catch (error) {
      HelperContext.showMessage(context, 'Error: ' + error.toString());
      return null;
    }
  }

  Future<DocumentSnapshot> GetSingleClass(String ClassID, BuildContext context) async {
    try {
      return await firestore.collection("classes").document(ClassID).get();
    } catch (error) {
      HelperContext.showMessage(context, 'Error: ' + error.toString());
    }
  }

  Future<DocumentSnapshot> GetSingleStudent(String ID, BuildContext context) async {
    try {
      return await firestore.collection("students").document(ID).get();
    } catch (error) {
      HelperContext.showMessage(context, 'Error: ' + error.toString());
    }
  }

  Future<DocumentSnapshot> GetSingleParent(String ParentEmail, BuildContext context) async {
    try {
      return await firestore.collection("parents").document(ParentEmail).get();
    } catch (error) {
      HelperContext.showMessage(context, 'Error: ' + error.toString());
    }
  }

  Future<void> editTeacherToDataBase(Map classMap, String email, BuildContext context) async {
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
      HelperContext.showMessage(context, 'Error: ' + error.toString());
    }
  }

  Future<QuerySnapshot> GetParents(BuildContext context) {
    try {
      return firestore.collection("parents").getDocuments();
    } catch (error) {
      HelperContext.showMessage(context, 'Error: ' + error.toString());
    }
  }

  Future<DocumentSnapshot> GetSingleParents(String Email, BuildContext context) {
    try {
      return firestore.collection("parents").document(Email).get();
    } catch (error) {
      HelperContext.showMessage(context, 'Error: ' + error.toString());
    }
  }

  Future<void> AuthenticateParent(Map classMap, String email, String pass, BuildContext context) async {
    try {
      await Auth.register(email, pass);
      AddParentToDataBase(classMap, email, pass, context);

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
      HelperContext.showMessage(context, 'Error: ' + error.toString());
      Future.delayed(const Duration(milliseconds: 2000), () {
        Navigator.pop(context);
      });
    }
  }

  Future<void> AddParentToDataBase(Map ClassMap, String Email, String pass, BuildContext context) async {
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
      HelperContext.showMessage(context, 'Error: ' + error.toString());
    }
  }

  Future<void> EditParentToDataBase(Map ClassMap, String Email, BuildContext context) async {
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
      HelperContext.showMessage(context, 'Error: ' + error.toString());
    }
  }

  Future<QuerySnapshot> GetStudents(BuildContext context) {
    try {
      return firestore.collection("students").getDocuments();
    } catch (error) {
      HelperContext.showMessage(context, 'Error: ' + error.toString());
    }
  }

  Future<void> addStudentTODataBase(Map classMap, String classID,
      String parentEmail, BuildContext context) async {
    try {
      await firestore
          .collection("parents")
          .document(parentEmail)
          .get()
          .then((value) {
        List<dynamic> childsClassesId;
        childsClassesId = value.data["ChildsClassesId"];

        if (childsClassesId != null) {
          for (int i = 0; i < childsClassesId.length; i++) {
            if (childsClassesId[i] == classID) {
              childsClassesId.removeAt(i);
            }
          }
        } else {
          childsClassesId = new List<dynamic>();
        }

        childsClassesId.add(classID);
        Map<String, dynamic> newMap = new Map<String, dynamic>();
        newMap["ChildsClassesId"] = childsClassesId;

        firestore
            .collection("parents")
            .document(parentEmail)
            .updateData(newMap)
            .then((value) {
          firestore.collection("students").add(classMap).then((value) {
            firestore
                .collection("classes")
                .document(classID)
                .collection("students")
                .document(value.documentID)
                .setData(classMap);
            firestore
                .collection("parents")
                .document(parentEmail)
                .collection("child")
                .document(value.documentID)
                .setData(classMap);
          });
        });
      });
      firestore.collection('notification').document('tokens').get().then(
              (tokens) => (tokens?.data?.containsKey(parentEmail) ?? false)
              ? firestore
              .collection('notification')
              .document(classID)
              .setData({parentEmail: tokens.data[parentEmail]}, merge: true)
              : false);
    } catch (error) {
      HelperContext.showMessage(context, 'Error: ' + error.toString());
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
      HelperContext.showMessage(context, 'Error: ' + error.toString());
    }
  }

  // reports

  //
  Future<QuerySnapshot> GetClassReports(String reportDate, BuildContext context) {
    try {
      print("from db" + reportDate);
      return firestore
          .collection("ClassReports")
          .document(reportDate)
          .collection("Reports")
          .orderBy("Date", descending: true)
          .getDocuments();
    } catch (error) {
      HelperContext.showMessage(context, 'Error: ' + error.toString());
    }
  }

  Future<List<dynamic>> GetQuestionsOfReport(String ReportID, String DateOfReprt, BuildContext context, String reportType) async{
    try {
      print(DateOfReprt + "from database" + ReportID);
      List<dynamic> list = (await firestore
          .collection(reportType == 'Class' ? "ClassReports" : "StudentsReports")
          .document(DateOfReprt)
          .collection("Reports")
          .document(ReportID)
          .collection("Questions")
          .getDocuments()).documents;
      return list;
    } catch (error) {
      HelperContext.showMessage(context, 'Error: ' + error.toString());
    }
  }

  Future<void> sendReport(Map dataMap, var questionsMap,
      String classID, String dateOfReprt, BuildContext context,String reportType) async {
    try {
      //print('to saveee ------> : ' + questionsMap['A9000'].controller.text);
      Map<String, dynamic> thisDateMap = new Map<String, dynamic>();
      thisDateMap["Date"] = dateOfReprt;
      await firestore
          .collection(reportType == 'Class'? "ClassReports" : "StudentsReports")
          .document(dateOfReprt)
          .setData(thisDateMap).then((value){
        firestore
            .collection(reportType == 'Class'? "ClassReports" : "StudentsReports")
            .document(dateOfReprt)
            .collection("Reports")
            .document(classID)
            .collection("Questions")
            .getDocuments().then((value)async {
          for (var doc in value.documents) {
          await firestore
                .collection(reportType == 'Class'? "ClassReports" : "StudentsReports")
                .document(dateOfReprt)
                .collection("Reports")
                .document(classID)
                .collection("Questions")
                .document(doc.documentID)
                .delete();
          }
        });
      });
      // var documents = (await firestore
      //     .collection(reportType == 'Class'? "ClassReports" : "StudentsReports")
      //     .document(dateOfReprt)
      //     .collection("Reports")
      //     .document(classID)
      //     .collection("Questions")
      //     .getDocuments()).documents;
      //
      //   for (var doc in documents) {
      //     await firestore
      //         .collection(reportType == 'Class'? "ClassReports" : "StudentsReports")
      //         .document(dateOfReprt)
      //         .collection("Reports")
      //         .document(classID)
      //         .collection("Questions")
      //         .document(doc.documentID)
      //         .delete();
      //   }
      //

      await firestore
          .collection(reportType == 'Class'? "ClassReports" : "StudentsReports")
          .document(dateOfReprt)
          .collection("Reports")
          .document(classID)
          .setData(dataMap).then((value) async{
        print(questionsMap.length.toString());
        int i = 0;
        for (var item in questionsMap.entries) {
          //print(questionsMap[i].question);
          Map<String, dynamic> questionsAndAnswersMapp =
          new Map<String, dynamic>();
          questionsAndAnswersMapp["Question"] = item.value.Question;
          questionsAndAnswersMapp["index"] = i++;
          if(item.value != null){
            if(item.value.Type == 'choices'){
              if(item.value.MultipleChoice != null && item.value.MultipleChoice == true){
                if(item.value.answersList != null){
                  questionsAndAnswersMapp["Answer"] = item.value.answersList;
                }else
                  continue;
              }else{
                if (item.value.controller.text != null &&
                    item.value.controller.text.isNotEmpty) {
                  if(item.value.Type == 'text')
                    print('textttttttt : ' +item.value.controller.text);
                  questionsAndAnswersMapp["Answer"] = item.value.controller.text;
                } else
                  continue;
              }
            }else{
              if (item.value.controller.text != null &&
                  item.value.controller.text.isNotEmpty) {
                if(item.value.Type == 'text')
                  print('textttttttt : ' +item.value.controller.text);
                questionsAndAnswersMapp["Answer"] = item.value.controller.text;
              } else
                continue;
            }
          }else
            continue;



          await firestore
              .collection(reportType == 'Class'? "ClassReports" : "StudentsReports")
              .document(dateOfReprt)
              .collection("Reports")
              .document(classID)
              .collection("Questions")
              .add(questionsAndAnswersMapp);
        }

      });

        // // print(value.documentID);
        // print(questionsMap.length.toString());
        // int i = 0;
        // for (var item in questionsMap.entries) {
        //   //print(questionsMap[i].question);
        //   Map<String, dynamic> questionsAndAnswersMapp =
        //   new Map<String, dynamic>();
        //   questionsAndAnswersMapp["Question"] = item.value.Question;
        //   questionsAndAnswersMapp["index"] = i++;
        //   if(item.value.Type == 'choices'){
        //     if(item.value.MultipleChoice){
        //       if(item.value.answersList != null){
        //         questionsAndAnswersMapp["Answer"] = item.value.answersList;
        //       }else
        //         continue;
        //     }else{
        //       if (item.value.controller.text != null &&
        //           item.value.controller.text.isNotEmpty) {
        //         if(item.value.Type == 'text')
        //           print('textttttttt : ' +item.value.controller.text);
        //         questionsAndAnswersMapp["Answer"] = item.value.controller.text;
        //       } else
        //         continue;
        //     }
        //   }else{
        //     if (item.value.controller.text != null &&
        //         item.value.controller.text.isNotEmpty) {
        //       if(item.value.Type == 'text')
        //       print('textttttttt : ' +item.value.controller.text);
        //       questionsAndAnswersMapp["Answer"] = item.value.controller.text;
        //     } else
        //       continue;
        //   }
        //
        //
        //   await firestore
        //       .collection(reportType == 'Class'? "ClassReports" : "StudentsReports")
        //       .document(dateOfReprt)
        //       .collection("Reports")
        //       .document(classID)
        //       .collection("Questions")
        //       .add(questionsAndAnswersMapp);
        // }


      //FirebaseFuncitons.notifyParents();
      FirebaseMessageService.sendMessageToGroup(
          classID, 'A new Report been added', '', {});
    } catch (error) {
      print('error: ' + error.toString());
      HelperContext.showMessage(context, 'Error: ' + error.toString());
    }
  }

  Future<DocumentSnapshot> GetClassReportsTemplates(BuildContext context) {
    try {
      return firestore.collection("ReportTemplates").document("Class").get();
    } catch (error) {
      HelperContext.showMessage(context, 'Error: ' + error.toString());
    }
  }

  // Future<List<dynamic>> GetClassReportTemplateQuestions(BuildContext context) async{
  //   try {
  //     var fb = (await firestore
  //         .collection("ReportTemplates")
  //         .document("Class")
  //         .collection("Questions")
  //         .getDocuments()).documents;
  //   } catch (error) {
  //     HelperContext.showMessage(context, 'Error: ' + error.toString());
  //   }
  // }

  Future<QuerySnapshot> GetReportTemplateQuestions(BuildContext context,String reportType) {
    try {
      return firestore
          .collection("ReportTemplates")
          .document(reportType)
          .collection("Questions")
          .getDocuments();
    } catch (error) {
      HelperContext.showMessage(context, 'Error: ' + error.toString());
    }
  }

  SendNewClassReportTempplate(
      List<ClassReportItems> classReportItems, BuildContext context) async {
    try {
      Map<String, dynamic> DataMap = new Map<String, dynamic>();
      DataMap["Date"] = FieldValue.serverTimestamp();
      DataMap["ReportTemplateMaker"] = UserCurrentInfo.currentUserId;

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
      });
      for (int i = 0; i < classReportItems.length; i++) {
        if (classReportItems[i].Question.isEmpty) continue;
        Map<String, dynamic> QuestionsAndAnswersMapp =
            new Map<String, dynamic>();
        QuestionsAndAnswersMapp["MultipleChoice"] =
            classReportItems[i].MultipleChoice;
        QuestionsAndAnswersMapp["Question"] = classReportItems[i].Question;
        QuestionsAndAnswersMapp["TheChoices"] = classReportItems[i].TheChoices;
        QuestionsAndAnswersMapp["Type"] = classReportItems[i].Type;
        QuestionsAndAnswersMapp["choicesCount"] =
            classReportItems[i].choicesCount;
        String prefix = '';
        int divresult = (i / 10).toInt();
        if (divresult == 0)
          prefix = 'A';
        else if (divresult == 1)
          prefix = 'B';
        else if (divresult == 2)
          prefix = 'C';
        else if (divresult == 3) prefix = 'D';

        firestore
            .collection("ReportTemplates")
            .document("Class")
            .collection("Questions")
            .document(prefix + ((i % 10) * 1000).toString())
            .setData(QuestionsAndAnswersMapp);
      }
    } catch (error) {
      HelperContext.showMessage(context, 'Error: ' + error.toString());
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
      HelperContext.showMessage(context, 'Error: ' + error.toString());
    }
  }

  Future<QuerySnapshot> GetQuestionsOfStudentReport(String ReportID, BuildContext context) {
    try {
      return firestore
          .collection("StudentsReports")
          .document(getDateNow())
          .collection("Reports")
          .document(ReportID)
          .collection("Questions")
          .getDocuments();
    } catch (error) {
      HelperContext.showMessage(context, 'Error: ' + error.toString());
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
      HelperContext.showMessage(context, 'Error: ' + error.toString());
    }
  }

  Future<DocumentSnapshot> GetStudentReportsTemplates(BuildContext context) {
    try {
      return firestore.collection("ReportTemplates").document("Student").get();
    } catch (error) {
      HelperContext.showMessage(context, 'Error: ' + error.toString());
    }
  }

  Future<QuerySnapshot> GetStudentReportTemplateQuestions(BuildContext context) {
    try {
      return firestore
          .collection("ReportTemplates")
          .document("Student")
          .collection("Questions")
          .getDocuments();
    } catch (error) {
      HelperContext.showMessage(context, 'Error: ' + error.toString());
    }
  }

  SendNewStudentReportTempplate(List<StudentReportItems> studentReportItems, BuildContext context) async {
    try {
      Map<String, dynamic> DataMap = new Map<String, dynamic>();
      DataMap["Date"] = FieldValue.serverTimestamp();
      DataMap["ReportTemplateMaker"] = UserCurrentInfo.currentUserId;
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
      });

      for (int i = 0; i < studentReportItems.length; i++) {
        if (studentReportItems[i].Question.isEmpty)
          continue;
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
        String prefix = '';
        int divresult = (i / 10).toInt();
        if (divresult == 0)
          prefix = 'A';
        else if (divresult == 1)
          prefix = 'B';
        else if (divresult == 2)
          prefix = 'C';
        else if (divresult == 3) prefix = 'D';

        firestore
            .collection("ReportTemplates")
            .document("Student")
            .collection("Questions")
            .document(prefix + ((i % 10) * 1000).toString())
            .setData(QuestionsAndAnswersMapp);
      }
    } catch (error) {
      HelperContext.showMessage(context, 'Error: ' + error.toString());
    }
  }

  sendClassMessages(String ClassID, String Message, String Title,
      BuildContext context) async {
    try {
      List<String> parentsToSendNotifications = new List<String>();
      firestore.collection("parents").getDocuments().then((value2) {
        for (int i = 0; i < value2.documents.length; i++) {
          for (int j = 0;
          j < value2.documents[i].data["ChildsClassesId"].length;
          j++) {
            if (value2.documents[i].data["ChildsClassesId"][j] == ClassID) {
              parentsToSendNotifications.add(value2.documents[i].documentID);
            }
          }
        }
        Map<String, String> notifMap = new Map<String, String>();
        notifMap["message"] = Message;
        notifMap["title"] = Title;

        for (int k = 0; k < parentsToSendNotifications.length; k++) {
          firestore
              .collection("Notification")
              .document(parentsToSendNotifications[k])
              .collection("notifications")
              .add(notifMap);
        }
      });
      FirebaseMessageService.sendMessageToGroup(ClassID, Title, Message, {});
    } catch (error) {
      HelperContext.showMessage(context, 'Error: ' + error.toString());
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
      FirebaseMessageService.sendMessageToGroup('tokens', Title, Message, {});
    } catch (error) {
      HelperContext.showMessage(context, 'Error: ' + error.toString());
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
      FirebaseMessageService.sendMessageToGroup(ParentEmail, Title, Message, {},
          singleMessage: true);
    } catch (error) {
      HelperContext.showMessage(context, 'Error: ' + error.toString());
    }
  }

  Future<QuerySnapshot> getMessages(String ParentEmail, BuildContext context) async {
    try {
      return await firestore
          .collection("Notification")
          .document(ParentEmail)
          .collection("notifications")
          .getDocuments();
    } catch (error) {
      HelperContext.showMessage(context, 'Error: ' + error.toString());
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
      HelperContext.showMessage(context, 'Error: ' + error.toString());
    }
  }

  DeleteStudentReport(String StudentReportID, BuildContext context, Function refresh) async {
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
      HelperContext.showMessage(context, 'Error: ' + error.toString());
    }
  }

  deleteStudent(String parentEmail, String classID, String studentId,
      BuildContext context, Function refresh) async {
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
                      .document(studentId)
                      .delete()
                      .then((value) {
                    refresh();
                    Navigator.pop(context);
                  });
                  firestore
                      .collection('notification')
                      .document(classID)
                      .setData({parentEmail: FieldValue.delete()}, merge: true);
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
      HelperContext.showMessage(context, 'Error: ' + error.toString());
    }
  }

  deleteStudentFromClass(String parentEmail, String studentId, String classID,
      BuildContext context, Function refresh) async {
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
                      .document(classID)
                      .collection("students")
                      .document(studentId)
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
      HelperContext.showMessage(context, 'Error: ' + error.toString());
    }
    // print(ClassID+"   ");
  }

  deleteTeacher(String teacherEmail, String teacherPassword,
      BuildContext context, Function refresh) async {
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
      HelperContext.showMessage(context, 'Error: ' + error.toString());
    }
  }

  DeleteClass(String classID, BuildContext context, Function refresh) async {
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
                      .document(classID)
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
      HelperContext.showMessage(context, 'Error: ' + error.toString());
    }
  }

  deleteParent(String parentEmail, String parentPassword, BuildContext context,
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
                onPressed: () async {
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
                onPressed: () => Navigator.of(context).pop(),
              ),
            ],
          );
        },
      );
    } catch (error) {
      HelperContext.showMessage(context, 'Error: ' + error.toString());
    }
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
