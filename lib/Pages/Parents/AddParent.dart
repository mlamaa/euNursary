import 'package:flutter/material.dart';
import 'package:garderieeu/Tools.dart';
import 'package:garderieeu/Colors.dart';
import 'package:garderieeu/db.dart';
import 'package:garderieeu/widgets.dart';
import 'package:email_validator/email_validator.dart';
import 'package:multiselect_formfield/multiselect_formfield.dart';

class AddParent extends StatefulWidget {
  final Function refresh;
  AddParent({this.refresh});
  @override
  _AddParentState createState() => _AddParentState();
}

class _AddParentState extends State<AddParent> {

  bool isAdding=false;
  DataBaseService dataBaseService = new DataBaseService();
  Map<String,dynamic> ThisClassMap=new Map<String,dynamic>();

  TextEditingController NameController=new TextEditingController();
  TextEditingController EmailDateController=new TextEditingController();
  TextEditingController PassDateController=new TextEditingController();




  AddParentFunction(BuildContext context2) async{
    print("Adding Parent");
    ThisClassMap["name"]=NameController.text;
    await dataBaseService.AuthenticateParent(ThisClassMap,EmailDateController.text+"@app.com",PassDateController.text,context2).then((value) {
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
      body:Builder(
        builder: (BuildContext context){
          return
            isAdding? Center(
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
                  Container(height: 10,),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text("Parent Phone:",style:myTextStyle ,),
                      Container(width: 5,),
                      Tools.MyInputText("Parent Phone Number", EmailDateController)
                    ],
                  ),
                  Container(height: 10,),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text("Parent Pass:  ",style:myTextStyle ,),
                      Container(width: 5,),
                      Tools.MyInputText("Parent Pass", PassDateController)
                    ],
                  ),
                  Container(height: 15,),
                  InkWell(
                      onTap: (){
                        if(EmailDateController.text.length>4&&NameController.text.length>4&&PassDateController.text.length>5){
                          if(EmailDateController.text.length==8&&isNumeric(EmailDateController.text)){
                            setState(() {
                              isAdding=true;
                            });
                            AddParentFunction(context);
                          }
                          else{
                            final snackBar = SnackBar(content: Text("Phone Number Must be 8 numbers"));
                            Scaffold.of(context).showSnackBar(snackBar);
                          }
                        }
                        else{
                          final snackBar = SnackBar(content: Text("Parent Full Name must be more than 4 letters,Pass more than 5 letters"));
                          Scaffold.of(context).showSnackBar(snackBar);
                        }
                      },
                      child: Tools.MyButton("Add Parent")
                  )
                ],),
            );
        },
      )
    );
  }
}