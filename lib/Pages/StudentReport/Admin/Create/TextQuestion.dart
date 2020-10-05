import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:garderieeu/Colors.dart';
import 'package:garderieeu/Tools.dart';
import 'package:garderieeu/widgets.dart';
import 'package:garderieeu/Pages/ClassReport/Admin/EditClassReport.dart';
import 'package:garderieeu/db.dart';

class AddTextQuestion extends StatefulWidget {
  final Function refreshToAdd;
  final Function ChangeColor;

  AddTextQuestion({this.refreshToAdd,this.ChangeColor});

  @override
  _AddTextQuestionState createState() => _AddTextQuestionState();
}

class _AddTextQuestionState extends State<AddTextQuestion> {
  TextEditingController  textEditingController=new TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: myAppBar(),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text("Enter The Question:",style: TextStyle(fontSize: 20,color: MyColors.color1),),
            ),

            Padding(
              padding: const EdgeInsets.fromLTRB(8, 20, 8, 8),
              child: TextField(
                controller: textEditingController,
                style: TextStyle(color: MyColors.color1, fontSize: 16),
                decoration: InputDecoration(

                    hintText: " Question ...",
                    hintStyle: TextStyle(
                      color: MyColors.color1,
                      fontSize: 16,
                    ),
                    border: InputBorder.none
                ),
              ),
            ),
            Material(
              elevation: 5.0,
              //borderRadius: BorderRadius.circular(30.0),
              color: MyColors.color1,
              child: MaterialButton(
                minWidth: MediaQuery.of(context).size.width,
                padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                onPressed: () {
                  if(textEditingController.text.length>0){
                    StudentReportItems item =new StudentReportItems();
                    item.Question=textEditingController.text;
                    item.Type="text";
                    item.isAdded=false;
                    CreatingStudentReportSomeInfo.CreatingStudentsReportItems.add(item);
                    widget.refreshToAdd();
                    widget.ChangeColor();

                    Navigator.pop(context);
                  }
                  }
                ,
                child: Text("add question",
                    textAlign: TextAlign.center,
                    style: Tools.myTextStyle.copyWith(
                        color: Colors.white, fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
