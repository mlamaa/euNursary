import 'package:flutter/material.dart';

import '../../Colors.dart';
import '../../Tools.dart';
import '../../db.dart';
import '../../widgets.dart';

class EditParent extends StatefulWidget {
  final Function refresh;
  final String parentName;
  final String parentEmail;
  final String parentPassword;
  EditParent({this.parentName,this.parentPassword,this.parentEmail,this.refresh});

  @override
  _EditParentState createState() => _EditParentState();
}

class _EditParentState extends State<EditParent> {

  bool isAdding=false;
  DataBaseService dataBaseService = new DataBaseService();
  Map<String,dynamic> thisClassMap=new Map<String,dynamic>();

  TextEditingController nameController=new TextEditingController();
  String _password;



  AddParentFunction() async{
    print("Adding Parent");
    thisClassMap["name"]=nameController.text;
    thisClassMap["password"]=_password;
    await dataBaseService.EditParentToDataBase(thisClassMap,widget.parentEmail,context).then((value) {
      Future.delayed(const Duration(milliseconds: 500), () {
        widget.refresh();
        print("refresh");
        Navigator.pop(context);
      });
    });
  }






  @override
  void initState() {
    super.initState();
    _password = widget.parentPassword;
    setState(() {
      nameController.text=widget.parentName;
      

    });
  }

  bool isNumeric(String s) {
    if(s == null) {
      return false;
    }
    return double.parse(s, (e) => null) != null;
  }

  @override
  Widget build(BuildContext context) {
    TextStyle myTextStyle=TextStyle(fontSize: 20,color: MyColors.color1,fontWeight: FontWeight.bold);
    return Scaffold(
      backgroundColor: MyColors.color4,
      appBar: myAppBar(),
      body:
      Builder(
        builder: (BuildContext context){
          return isAdding? Center(
          child: CircularProgressIndicator(),
          ):Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
          Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
          Text("Parent Name: ",style:myTextStyle ,),
          Container(width: 5,),
          Tools.MyInputText("Parent Name", nameController)
          ],
          ),

          Container(height: 15,),
          InkWell(
          onTap: (){
          if(nameController.text.length>4){
          setState(() {
          isAdding=true;
          });
          AddParentFunction();


          }
          else{
          final snackBar = SnackBar(content: Text("Parent Full Name must be more than 4 letters"));
          Scaffold.of(context).showSnackBar(snackBar);
          }
          },
          child: Tools.MyButton("Edit Parent")
          )
          ],),
          );
        },
      )

    );
  }
}
