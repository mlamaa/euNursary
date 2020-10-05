import 'package:flutter/material.dart';
import 'package:garderieeu/Tools.dart';
import 'package:garderieeu/Colors.dart';
import 'package:garderieeu/db.dart';
import 'package:garderieeu/widgets.dart';
import 'package:email_validator/email_validator.dart';
import 'package:multiselect_formfield/multiselect_formfield.dart';

class AddTeacher extends StatefulWidget {
  final Function refresh;
  AddTeacher({this.refresh});
  @override
  _AddTeacherState createState() => _AddTeacherState();
}

class _AddTeacherState extends State<AddTeacher> {

  bool isAdding=false;
  DataBaseService dataBaseService = new DataBaseService();
  Map<String,dynamic> thisClassMap=new Map<String,dynamic>();

  TextEditingController nameController=new TextEditingController();
  TextEditingController emailDateController=new TextEditingController();
  TextEditingController passDateController=new TextEditingController();
  List _myAnswers= [];
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


  addTeacher(BuildContext context2) async{
    print("Adding Teacher");
    thisClassMap["name"]= nameController.text;
    thisClassMap["password"]= passDateController.text;
    thisClassMap["Classes"]=_myAnswers;
      // await dataBaseService
      // .addTeacherToDataBase(
      //   thisClassMap,
      //   emailDateController.text,
      //   passDateController.text,
      //   context)
      // .then((value) {
    await dataBaseService.authenticateTeacher(thisClassMap,emailDateController.text,passDateController.text,context2).then((value) {

        Future.delayed(const Duration(milliseconds: 500), () {
            widget.refresh();
            print("refresh");
            Navigator.pop(context);

          // else{
          //   print("goinggg outtt");
          //   Scaffold.of(context2).showSnackBar(SnackBar(content: Text("please use another email")));
          //   Future.delayed(const Duration(milliseconds: 2000), () {
          //     Navigator.pop(context2);
          //   });
          // }

        });

    });

  }


  @override
  void initState() { 
    getClasses();
    super.initState();
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
              child: SingleChildScrollView(
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
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text("Teacher Email: ",style:myTextStyle ,),
                        Container(width: 5,),
                        Tools.MyInputText("Teacher Email", emailDateController)
                      ],
                    ),
                    Container(height: 10,),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text("Teacher Pass: ",style:myTextStyle ,),
                        Container(width: 5,),
                        Tools.MyInputText("Teacher Pass", passDateController)
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
                        _myAnswers = value;
                      },
                    ),

                    Container(height: 15,),
                    InkWell(
                        onTap: (){
                          if(emailDateController.text.length<=4)
                            Scaffold.of(context).showSnackBar(SnackBar(content: Text("To Short Email")));
                          else if(nameController.text.length<=4)
                            Scaffold.of(context).showSnackBar(SnackBar(content: Text("To Short Name")));

                          else if(passDateController.text.length<6)
                            Scaffold.of(context).showSnackBar(SnackBar(content: Text("To Short password")));
                          else if(!EmailValidator.validate(emailDateController.text))
                            Scaffold.of(context).showSnackBar(SnackBar(content: Text("Email must be valid")));
                          else{
                            setState(() {
                              isAdding=true;
                            });
                            addTeacher(context);
                          }


                        },
                        child: Tools.MyButton("Add Teacher")
                    ),

                    Container(height: 100,)
                  ],),
              ),
            );
          },
        )
    );
  }
}
