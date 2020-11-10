import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:garderieeu/Colors.dart';
import 'package:garderieeu/Tools.dart';
import 'package:garderieeu/db.dart';
import 'package:garderieeu/widgets.dart';

class ClassStudents extends StatefulWidget {
  final String ClassId;
  ClassStudents({this.ClassId});

  @override
  _ClassStudentsState createState() => _ClassStudentsState();
}

class _ClassStudentsState extends State<ClassStudents> {
  List<SingleStudentObject> listOfStudents = new List<SingleStudentObject>();
  DataBaseService dataBaseService = new DataBaseService();

  GetStudents() async {
    await dataBaseService.GetClassStudents(widget.ClassId, context)
        .then((value) {
      for (int i = 0; i < value.documents.length; i++) {
        SingleStudentObject singleStudentObject = new SingleStudentObject();
        singleStudentObject.ParentEmail =
            value.documents[i].data["parentEmail"];
        singleStudentObject.Name = value.documents[i].data["name"];
        singleStudentObject.StudentIdinClass = value.documents[i].documentID;
        singleStudentObject.Class = value.documents[i].data["class"];
        setState(() {
          listOfStudents.add(singleStudentObject);
        });
      }
    });
  }

  Widget ItemsHere() {
    return Flexible(
      child: Padding(
        padding: EdgeInsets.fromLTRB(15, 15, 15, 5),
        child: ListView(  
            children: List.generate(listOfStudents.length, (index) {
          return SingleParent(
              refresh: GetStudents,
              context: context,
              slass: listOfStudents[index].Class,
              email: listOfStudents[index].ParentEmail,
              name: listOfStudents[index].Name,
              studentID: listOfStudents[index].StudentIdinClass);
        })),
      ),
    );
  }

  @override
  void initState() {
    GetStudents();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColors.color4,
      appBar: myAppBar(),
      body: Column(
        children: <Widget>[
          ItemsHere(),
        ],
      ),
    );
  }
}

class SingleParent extends StatefulWidget {
  final String name;
  final String email;
  final String slass;
  final String studentID;
  final Function refresh;
  final BuildContext context;
  SingleParent(
      {this.name,
      this.email,
      this.slass,
      this.studentID,
      this.context,
      this.refresh});

  @override
  _SingleParentState createState() => _SingleParentState();
}

class _SingleParentState extends State<SingleParent> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 0, 0, 10),
      child: Container(
        // height: 80,
        decoration: BoxDecoration(
            borderRadius: Tools.myBorderRadius2, color: Colors.white),

        child: Center(
          child: Column(
            children: <Widget>[
              Container(
                height: 10,
              ),
              Text(
                widget.name,
                style: TextStyle(
                    fontSize: 25,
                    color: MyColors.color1,
                    fontWeight: FontWeight.bold),
              ),
              Container(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.all(4.0),
                child: Text(
                  "Parent: " + widget.email,
                  style: TextStyle(
                    fontSize: 20,
                    color: MyColors.color1,
                  ),
                ),
              ),
              Container(
                height: 10,
              ), 
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[ 
                  InkWell(
                    onTap: () {
                      
                      DataBaseService database = new DataBaseService();
                      database.deleteStudentFromClass(widget.email,widget.studentID,
                          widget.slass, widget.context, widget.refresh);
                    },
                    child: Container(
                        width: 35,
                        height: 35,
                        child: Icon(
                          Icons.delete,
                          color: MyColors.color1,
                          size: 30,
                        )),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}

class SingleStudentObject {
  String ParentEmail;
  String Name;
  String Class;
  String StudentIdinClass;
}
