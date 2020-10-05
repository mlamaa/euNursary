import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:garderieeu/Tools.dart';
import 'package:garderieeu/Colors.dart';
import 'package:garderieeu/db.dart';
import 'package:garderieeu/widgets.dart';
import 'AddTeacher.dart';
// import 'UpdateClass.dart';
import 'EditTeacher.dart';


class Teachers extends StatefulWidget {
  @override
  _TeachersState createState() => _TeachersState();
}

class _TeachersState extends State<Teachers> {

  List<SingleTeacherObject> listOfTeachers = new List<SingleTeacherObject>();
  DataBaseService dataBaseService = new DataBaseService();

  getTeachers() async{
    setState(() {
      listOfTeachers = new List<SingleTeacherObject>();

    });
  await dataBaseService.GetTeachers(context).then((value) {
      for(int i=0;i<value.documents.length;i++){
        SingleTeacherObject singleTeacherObject=new SingleTeacherObject();
        singleTeacherObject.Email=value.documents[i].documentID;
        singleTeacherObject.Name=value.documents[i].data["name"];
        singleTeacherObject.Password=value.documents[i].data["password"];
        setState(() {
          listOfTeachers.add(singleTeacherObject);
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

            children: List.generate(listOfTeachers.length, (index) {
              return SingleTeacher(
                refresh: getTeachers,
                context: context,
                email: listOfTeachers[index].Email,
                password: listOfTeachers[index].Password,
                name: listOfTeachers[index].Name,
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
    getTeachers();
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
                Navigator.push(context, MaterialPageRoute(builder: (context)=>new AddTeacher(refresh: getTeachers,)));
              },
              child: Container(
                height: 30,
                decoration: BoxDecoration(
                  borderRadius: Tools.myBorderRadius2,
                  color: MyColors.color1,
                ),
                child: Center(
                    child: Text("Add Teacher",style: TextStyle(color: Colors.white,fontSize: 20),)
                ),
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


class SingleTeacher extends StatefulWidget {
  final Function refresh;
  final String name;
  final String email;
  final String password;
  final BuildContext context;
  SingleTeacher({this.name,this.email,this.password,this.context,this.refresh});

  @override
  _SingleTeacherState createState() => _SingleTeacherState();
}

class _SingleTeacherState extends State<SingleTeacher> {
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
              Text(widget.email,style: TextStyle(fontSize:20,color: MyColors.color1),),
              Container(height: 10,),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  InkWell(
                    onTap: (){

                      Navigator.push(context, MaterialPageRoute(builder: (context)=>
                      new EditTeacher(TeacherEmail: widget.email,refresh: widget.refresh,)));

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
                    database.deleteTeacher(widget.email,widget.password,widget.context,widget.refresh);
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

class SingleTeacherObject{
  String Email;
  String Password;
  String Name;
  // String Password;

}

