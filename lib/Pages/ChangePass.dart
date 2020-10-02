import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:garderieeu/Tools.dart';
import 'package:garderieeu/Colors.dart';
import 'package:garderieeu/db.dart';
import 'package:garderieeu/widgets.dart';


class ChangePass extends StatefulWidget {
  @override
  _ChangePassState createState() => _ChangePassState();
}

class _ChangePassState extends State<ChangePass> {
  DataBaseService dataBaseService=new DataBaseService();
  TextEditingController pass1Controller=new TextEditingController();
  TextEditingController pass2Controller=new TextEditingController();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColors.color4,
      appBar: MyAppBar("title"),
      body: Builder(
        builder: (BuildContext context){
          return Column(

            children: [
              Container(height: 30,),
              Tools.MyInputText("Password", pass1Controller),
              Container(height: 15,),
              Tools.MyInputText("Confirm Password", pass2Controller),
              Container(height: 20,),
              InkWell(
                onTap: (){
                  if(pass2Controller.text==pass1Controller.text&&pass2Controller.text.length>5){
                    dataBaseService.ChangePassword(pass2Controller.text).then((value) {
                      Navigator.pop(context);
                    });
                  }else{
                    final snackBar = SnackBar(content: Text("Passwords must be the same, and longer than 5 letters"));
                    Scaffold.of(context).showSnackBar(snackBar);
                  }
                },
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Tools.MyButton("Change Password"),
                ),
              ),

            ],
          );
        },
      )
    );
  }
}

