
  import 'package:flutter/cupertino.dart';
  import 'package:flutter/material.dart';
  import 'package:garderieeu/Tools.dart';
  import 'package:garderieeu/Colors.dart';
  import 'package:garderieeu/db.dart';
  import 'package:garderieeu/widgets.dart';

  class ClassStudents extends StatefulWidget {

    final String ClassId;
    ClassStudents({this.ClassId});

  @override
  _ClassStudentsState createState() => _ClassStudentsState();
  }

  class _ClassStudentsState extends State<ClassStudents> {

  List<SingleStudentObject> ListOfStudents = new List<SingleStudentObject>();
  DataBaseService dataBaseService = new DataBaseService();

  GetStudents() async{
  await dataBaseService.GetClassStudents(widget.ClassId,context).then((value) {
  for(int i=0;i<value.documents.length;i++){
  SingleStudentObject singleStudentObject=new SingleStudentObject();
  singleStudentObject.ParentEmail=value.documents[i].data["parentEmail"];
  singleStudentObject.Name=value.documents[i].data["name"];
  singleStudentObject.StudentIdinClass=value.documents[i].documentID;
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
    refresh: GetStudents,
    context: context,
  Class: ListOfStudents[index].Class,
  Email: ListOfStudents[index].ParentEmail,
  Name: ListOfStudents[index].Name,
      StudentID:ListOfStudents[index].StudentIdinClass
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
  GetStudents();
  }

  @override
  Widget build(BuildContext context) {
  return Scaffold(
    backgroundColor: MyColors.color4,
  appBar: MyAppBar(" "),
  body: Column(
  children: <Widget>[
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

  final String Name;
  final String Email;
  final String Class;
  final String StudentID;
  final Function refresh;
  final BuildContext context;
  SingleParent({this.Name,this.Email,this.Class,this.StudentID,this.context,this.refresh});

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
  Text(widget.Name,style: TextStyle(fontSize:25,color:MyColors.color1,fontWeight: FontWeight.bold),),
  Container(height: 10,),
  Padding(
  padding: const EdgeInsets.all(4.0),
  child: Text("Parent Email: "+widget.Email,style: TextStyle(fontSize:20,color: MyColors.color1,),),
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
  // InkWell(
  //   onTap: (){
  //
  //     Navigator.push(context, MaterialPageRoute(builder: (context)=>
  //     new UpdateClass(date: widget.Year,name: widget.ClassName,Id:widget.ID,)));
  //
  //   },
  //   child: Container(
  //       width: 35,
  //       height: 35,
  //       child: Icon(Icons.edit,color: MyColors.color1,size: 30,)),
  // ),
  // Container(width: 20,),
  InkWell(
  onTap: (){
    DataBaseService database=new DataBaseService();
    database.DeleteStudentFromClass(widget.StudentID,widget.Class,widget.context,widget.refresh);
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
  String ParentEmail;
  String Name;
  String Class;
  String StudentIdinClass;
  }

