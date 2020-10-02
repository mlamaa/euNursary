import 'package:flutter/material.dart';
import 'package:garderieeu/Tools.dart';
import 'package:garderieeu/Colors.dart';
import 'package:garderieeu/db.dart';
import 'package:garderieeu/widgets.dart';
import 'package:email_validator/email_validator.dart';
import 'package:multiselect_formfield/multiselect_formfield.dart';

class EditParent extends StatefulWidget {
  final Function refresh;
  final String ParentName;
  final String ParentEmail;
  EditParent({this.ParentName,this.ParentEmail,this.refresh});

  @override
  _EditParentState createState() => _EditParentState();
}

class _EditParentState extends State<EditParent> {

  bool isAdding=false;
  DataBaseService dataBaseService = new DataBaseService();
  Map<String,dynamic> ThisClassMap=new Map<String,dynamic>();

  TextEditingController NameController=new TextEditingController();




  AddParentFunction() async{
    print("Adding Parent");
    ThisClassMap["name"]=NameController.text;
    await dataBaseService.EditParentToDataBase(ThisClassMap,widget.ParentEmail,context).then((value) {
      Future.delayed(const Duration(milliseconds: 500), () {
        widget.refresh();
        print("refresh");
        Navigator.pop(context);
      });
    });
  }






  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      NameController.text=widget.ParentName;

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
      appBar: MyAppBar("title"),
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
          Tools.MyInputText("Parent Name", NameController)
          ],
          ),

          Container(height: 15,),
          InkWell(
          onTap: (){
          if(NameController.text.length>4){
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
