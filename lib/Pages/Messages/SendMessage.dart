import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:garderieeu/Tools.dart';
import 'package:garderieeu/Colors.dart';
import 'package:garderieeu/db.dart';
import 'package:garderieeu/widgets.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:intl/intl.dart';
import 'package:dropdown_search/dropdown_search.dart';

class SendMessage extends StatefulWidget {
  @override
  _SendMessageState createState() => _SendMessageState();
}

class _SendMessageState extends State<SendMessage> {
  DataBaseService dataBaseService = new DataBaseService();
  TextEditingController MessageTextController = new TextEditingController();
  TextEditingController TtileTextController = new TextEditingController();
  String group = "class";
  Widget newWidget = Container();

  Studetns CurrentStudent = new Studetns(" ", " ", " ");
  List<Studetns> studetnsList = new List<Studetns>();
  getStudetns() async {
    await dataBaseService.GetStudents(context).then((values) {
      for (int i = 0; i < values.documents.length; i++) {
        Studetns studetns = new Studetns(" ", " ", " ");
        studetns.ParentEmail = values.documents[i].data["parentEmail"];
        studetns.name = values.documents[i].data["name"];
        studetns.ID = values.documents[i].documentID;

        setState(() {
          studetnsList.add(studetns);
        });
      }
    });
  }

  Class CurrentStudentClass = new Class(" ", " ");
  List<Class> classesList = new List<Class>();
  getClasses() async {
    await dataBaseService.GetClasses(context).then((values) {
      for (int i = 0; i < values.documents.length; i++) {
        Class classes = new Class(" ", " ");
        classes.ID = values.documents[i].documentID;
        classes.name = values.documents[i].data["ClassName"];

        setState(() {
          classesList.add(classes);
        });
      }
    });
  }

  @override
  void initState() { 
    getClasses();
    getStudetns();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    TextStyle myTextStyle = TextStyle(
        fontSize: 20, color: MyColors.color1, fontWeight: FontWeight.bold);

    if (group == "class") {
      newWidget = Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Text(
            "Student Class:",
            style: myTextStyle,
          ),
          Container(
            width: 10,
          ),
          Container(
            width: 200,
            height: 50,
            decoration: BoxDecoration(
              borderRadius: Tools.myBorderRadius2,
              // color: MyColors.color1
            ),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 0, 0),
              child: DropdownSearch<Class>(
                  mode: Mode.DIALOG,
                  showSearchBox: true,
                  // showSelectedItem: true,
                  itemAsString: (Class s) => s.name,
                  onFind: (String filter) async {
                    if (filter.length != 0) {
                      List<Class> classesCurrentList = new List<Class>();
                      for (int i = 0; i < classesList.length; i++) {
                        if (classesList[i].name.contains(filter)) {
                          classesCurrentList.add(classesList[i]);
                        }
                      }
                      return classesCurrentList;
                    } else {
                      return classesList;
                    }
                  },
                  label: "class",
                  hint: "class Name",
                  // popupItemDisabled: (String s) => s.startsWith('I'),
                  onChanged: (Class s) {
                    CurrentStudentClass = s;
                  },
                  selectedItem: CurrentStudentClass),
            ),
          ),
        ],
      );
    } else if (group == "student") {
      newWidget = Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Text(
            "Student Name:",
            style: myTextStyle,
          ),
          Container(
            width: 10,
          ),
          Container(
            width: 200,
            height: 50,
            decoration: BoxDecoration(
              borderRadius: Tools.myBorderRadius2,
              // color: MyColors.color1
            ),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 0, 0),
              child: DropdownSearch<Studetns>(
                  mode: Mode.DIALOG,
                  showSearchBox: true,
                  // showSelectedItem: true,
                  itemAsString: (Studetns s) => s.name,
                  onFind: (String filter) async {
                    if (filter.length != 0) {
                      List<Studetns> studentsCurrentList = new List<Studetns>();
                      for (int i = 0; i < studetnsList.length; i++) {
                        if (studetnsList[i].name.contains(filter)) {
                          studentsCurrentList.add(studetnsList[i]);
                        }
                      }
                      return studentsCurrentList;
                    } else {
                      return studetnsList;
                    }
                  },
                  label: "Student name",
                  hint: "Student Name",
                  // popupItemDisabled: (String s) => s.startsWith('I'),
                  onChanged: (Studetns s) {
                    CurrentStudent = s;
                  },
                  selectedItem: CurrentStudent),
            ),
          ),
        ],
      );
    } else {
      newWidget = Container();
    }

    return Scaffold(
      backgroundColor: MyColors.color4,
      appBar: myAppBar(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: 50,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Text(
                    "class",
                    style: myTextStyle,
                  ),
                  Container(
                    width: 15,
                  ),
                  Radio(
                    value: "class",
                    groupValue: group,
                    onChanged: (T) {
                      setState(() {
                        group = T;
                      });
                    },
                  ),
                  Container(
                    width: 5,
                  ),
                  Text(
                    "student",
                    style: myTextStyle,
                  ),
                  Container(
                    width: 5,
                  ),
                  Radio(
                    value: "student",
                    groupValue: group,
                    onChanged: (T) {
                      setState(() {
                        group = T;
                      });
                    },
                  ),
                  Container(
                    width: 5,
                  ),
                  Text(
                    "all",
                    style: myTextStyle,
                  ),
                  Container(
                    width: 5,
                  ),
                  Radio(
                    value: "all",
                    groupValue: group,
                    onChanged: (T) {
                      setState(() {
                        group = T;
                      });
                    },
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: newWidget,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                color: Colors.white,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(15, 0, 0, 0),
                  child: TextField(
                    maxLines: 1,
                    controller: TtileTextController,
                    style: TextStyle(color: MyColors.color1, fontSize: 16),
                    decoration: InputDecoration(
                        hintText: " Title ...",
                        hintStyle: TextStyle(
                          color: MyColors.color1,
                          fontSize: 16,
                        ),
                        border: InputBorder.none),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                color: Colors.white,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(15, 0, 0, 0),
                  child: TextField(
                    maxLines: 5,
                    controller: MessageTextController,
                    style: TextStyle(color: MyColors.color1, fontSize: 16),
                    decoration: InputDecoration(
                        hintText: " Message ...",
                        hintStyle: TextStyle(
                          color: MyColors.color1,
                          fontSize: 16,
                        ),
                        border: InputBorder.none),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: InkWell(
                onTap: () {
                  if (MessageTextController.text != null &&
                      TtileTextController.text != null) {
                    if (group == "class") {
                      if (CurrentStudentClass.name != " ") {
                        print("message: " +
                            MessageTextController.text +
                            " to class: " +
                            CurrentStudentClass.ID);
                        dataBaseService.sendClassMessages(
                            CurrentStudentClass.ID,
                            MessageTextController.text,
                            TtileTextController.text,
                            context);
                        Navigator.pop(context);
                      }
                    } else if (group == "student") {
                      if (CurrentStudent.name != " ") {
                        print("message: " +
                            MessageTextController.text +
                            " to class: " +
                            CurrentStudent.ParentEmail);
                        dataBaseService.sendStudentMessages(
                            CurrentStudent.ParentEmail,
                            MessageTextController.text,
                            TtileTextController.text,
                            context);
                        Navigator.pop(context);
                      }
                    } else {
                      dataBaseService.sendAllMessage(MessageTextController.text,
                          TtileTextController.text, context);
                      Navigator.pop(context);
                    }
                  }
                },
                child: Container(
                  child: Tools.MyButton("Send"),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class Class {
  String ID;
  String name;

  Class(this.ID, this.name);
}

class Studetns {
  String ParentEmail;
  String ID;
  String name;

  Studetns(this.ParentEmail, this.name, this.ID);
}
