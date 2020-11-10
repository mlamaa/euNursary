import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:garderieeu/Colors.dart';
import 'package:garderieeu/Tools.dart';
import 'package:garderieeu/db.dart';
import 'package:garderieeu/widgets.dart';

import 'AddStudent.dart';
import 'EditStudent.dart';

class Students extends StatefulWidget {
  @override
  _StudentsState createState() => _StudentsState();
}

class _StudentsState extends State<Students> {

  List<SingleStudentObject> ListOfStudents = new List<SingleStudentObject>();
  DataBaseService dataBaseService = new DataBaseService();

  GetParetns() async{
    setState(() {
      ListOfStudents = new List<SingleStudentObject>();

    });
    await dataBaseService.GetStudents(context).then((value) {
      for(int i=0;i<value.documents.length;i++){
        SingleStudentObject singleStudentObject=new SingleStudentObject();
        singleStudentObject.StudentID=value.documents[i].documentID;
        singleStudentObject.ParentEmail=value.documents[i].data["parentEmail"];
        singleStudentObject.Name=value.documents[i].data["name"];
        singleStudentObject.Class=value.documents[i].data["class"];
        setState(() {
          ListOfStudents.add(singleStudentObject);
        });
      }

    });
  }


  Widget ItemsHere(){
    return Flexible(
      child: Padding(
        padding: EdgeInsets.fromLTRB(15, 15, 15, 5),
        child: ListView(
          // crossAxisCount: 1,
          // crossAxisSpacing: 30,
          // mainAxisSpacing:20,

            children: List.generate(ListOfStudents.length, (index) {
              return SingleParent(
                refresh: GetParetns,
                context: context,
                studentId:ListOfStudents[index].StudentID,
                classID: ListOfStudents[index].Class,
                parentEmail: ListOfStudents[index].ParentEmail,
                name: ListOfStudents[index].Name,
              );
            })

        ),
      ),

    );
  }


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    GetParetns();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColors.color4,
      appBar: myAppBar(),
      body: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: InkWell(
              onTap: (){
                Navigator.push(context, MaterialPageRoute(builder: (context)=>new AddStudent(refresh: GetParetns,)));
              },
              child: Container(
                height: 30,
                decoration: BoxDecoration(
                  borderRadius: Tools.myBorderRadius2,
                  color: MyColors.color1,
                ),
                child: Center(
                    child: Text(
                  "Ajouter un enfant",
                  style: TextStyle(color: Colors.white, fontSize: 20),
                )),
              ),
            ),
          ),
          ItemsHere(),
          // Flexible(
          //   child: Padding(
          //     padding: const EdgeInsets.all(8.0),
          //     child: ItemsHere(),
          //   ),
          // )
        ],
      ),

    );
  }
}


class SingleParent extends StatefulWidget {
  final Function refresh;
  final String name;
  final String parentEmail;
  final String studentId;
  final String classID;
  final BuildContext context;
  SingleParent({this.name,this.parentEmail,this.classID,this.studentId,this.context,this.refresh});

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
            borderRadius: Tools.myBorderRadius2,
            color: Colors.white
        ),

        child: Center(
          child: Column(
            children: <Widget>[
              Container(height: 10,),
              Text(widget.name,style: TextStyle(fontSize:25,color: MyColors.color1,fontWeight: FontWeight.bold),),
              Container(height: 10,),
              Padding(
                padding: const EdgeInsets.all(4.0),
                child: Text(
                  "Téléphone des parents: " + widget.parentEmail.split("@")[0],
                  style: TextStyle(fontSize: 20, color: MyColors.color1),),
              ),
              Container(height: 10,),
              // Padding(
              //   padding: const EdgeInsets.all(4.0),
              //   child: Text("class:   "+widget.Class,style: TextStyle(fontSize:20,color: Colors.white),),
              // ),
              // Container(height: 10,),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  InkWell(
                    onTap: (){

                      Navigator.push(context, MaterialPageRoute(builder: (context)=>
                      new EditStudent(StudentId: widget.studentId,refresh: widget.refresh,)));

                    },
                    child: Container(
                        width: 35,
                        height: 35,
                        child: Icon(Icons.edit,color: MyColors.color1,size: 30,)),
                  ),
                  Container(width: 20,),
                  InkWell(
                    onTap: (){
                      DataBaseService database=new DataBaseService();
                      database.deleteStudent(widget.parentEmail,widget.classID,widget.studentId, widget.context,widget.refresh);
                    },
                    child: Container(
                        width: 35,
                        height: 35,
                        child: Icon(Icons.delete,color: MyColors.color1,size: 30,)),
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

class SingleStudentObject{
  String StudentID;
  String ParentEmail;
  String Name;
  String Class;

}

