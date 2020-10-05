import 'package:flutter/material.dart';
import 'package:garderieeu/Tools.dart';
import 'package:garderieeu/Colors.dart';
import 'package:garderieeu/db.dart';
import 'package:garderieeu/widgets.dart';
import 'package:email_validator/email_validator.dart';
import 'package:multiselect_formfield/multiselect_formfield.dart';

class EditTeacher extends StatefulWidget {
  final String TeacherEmail;
  final Function refresh;
  EditTeacher({this.TeacherEmail,this.refresh});

  @override
  _EditTeacherState createState() => _EditTeacherState();
}

class _EditTeacherState extends State<EditTeacher> {

  bool isAdding=false;
  DataBaseService dataBaseService = new DataBaseService();
  Map<String,dynamic> thisClassMap=new Map<String,dynamic>();
  String _password;
  TextEditingController nameController=new TextEditingController();
  List _MyAnswers= [];
  final List<String> choicesDisplay=new List<String>();
  final List<String> choicesValue=new List<String>();


  getClasses() async{
    await dataBaseService.GetClasses(context).then((values) {
      for(int i=0;i<values.documents.length;i++){
        String display;
        String value;

        value=values.documents[i].documentID;
        display=values.documents[i].data["ClassName"];

        setState(() {
          choicesValue.add(value);
          choicesDisplay.add(display);
        });
      }

    });
  }


  GetOldData(){
    dataBaseService.getSingleTeacher(widget.TeacherEmail,context).then((value){
      _password = value.data["password"];
      setState(() {
        nameController.text=value.data["name"];

      });
    });

  }


  addClass() async{
    print("Adding Teacher");
    thisClassMap["name"]=nameController.text;
    thisClassMap["password"] = _password;
    thisClassMap["Classes"] = _MyAnswers;

    await dataBaseService.editTeacherToDataBase(thisClassMap,widget.TeacherEmail,context).then((value) {
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
    getClasses();
    GetOldData();

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
          return isAdding? Container(
              child: CircularProgressIndicator(),
            ):Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Container(height: 50,),

                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[

                      Text("Teacher Name:",style:myTextStyle ,),
                      Container(width: 5,),
                      Tools.MyInputText("Teacher Name", nameController)
                    ],
                  ),
                  Container(height: 10,),
                  MultiSelectFormField(
//          autovalidate: false,
                    titleText: ' ',
                    validator: (value) {
                      if (value == null || value.length == 0) {
                        return "Classes";
                      }
                      else{
                        return " ";
                      }
                    },
                    dataSource:  [
                      for(int i=0;i<choicesDisplay.length;i++)
                        {
                          "display": choicesDisplay[i],
                          "value": choicesValue[i],
                        },

                    ],
                    textField: 'display',
                    valueField: 'value',
                    okButtonLabel: 'OK',
                    cancelButtonLabel: 'CANCEL',
                    // required: true,
                    hintText: 'Please choose one or more class',
                    onSaved: (value) {
                      if (value == null) return;
                      _MyAnswers = value;
                    },
                  ),

                  Container(height: 15,),
                  InkWell(
                      onTap: (){
                        if(nameController.text.length>4){

                          setState(() {
                            isAdding=true;
                          });
                          addClass();


                        }
                        else{
                          final snackBar = SnackBar(content: Text("Teacher Full Name must be more than 4 letters"));
                          Scaffold.of(context).showSnackBar(snackBar);
                        }
                      },
                      child: Tools.MyButton("Edit Teacher")
                  )
                ],),
            );
        },
      )
    );
  }
}
