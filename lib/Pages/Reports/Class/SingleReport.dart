import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:garderieeu/Tools.dart';
import 'package:garderieeu/Colors.dart';
import 'package:garderieeu/db.dart';
import 'package:garderieeu/widgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class SingleReport extends StatefulWidget {
 final String ReportID;
 final String ClassId;
 final Timestamp Date;
 final String ClassName;
 final String ReportSenderID;
 final String ReportSenderEmail;
 final String ReportSenderType;

 SingleReport({
 this.Date,this.ReportID,this.ClassName,this.ReportSenderType,this.ReportSenderID,this.ClassId,this.ReportSenderEmail
});

  @override
  _SingleReportState createState() => _SingleReportState();
}

class _SingleReportState extends State<SingleReport> {
  List<SingleQuestion> ListOfQuestions = new List<SingleQuestion>();
  DataBaseService dataBaseService = new DataBaseService();
bool loading;



  GetSingleQuestions() async{
    setState(() {
      loading = true;
    });
    print(widget.ReportID+dataBaseService.getDateNow());
    var list = await dataBaseService.GetQuestionsOfReport(widget.ReportID,dataBaseService.getDateNow(),context,'Class');

    //print(list.length.toString()+"aa");
    list.sort((a,b) => a["index"]>b["index"]?1:-1);
    for(var listItem in list){
      SingleQuestion singleQuestion=new SingleQuestion();
      singleQuestion.Question=listItem.data["Question"];
      singleQuestion.Answer=listItem.data["Answer"].toString();

      setState(() {
        ListOfQuestions.add(singleQuestion);
      });
    }
    setState(() {
      loading = false;
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

            children: List.generate(ListOfQuestions.length, (index) {
              return SingleQuestionWidget(
                Question: ListOfQuestions[index].Question,
                Answer: ListOfQuestions[index].Answer,
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
    GetSingleQuestions();
  }


  @override
  Widget build(BuildContext context) {
    DateTime dateHere=DateTime.now();
    String Datehere=" ";
    DateTime datetime;
    if(widget.Date!=null){
      datetime=widget.Date.toDate();
      var formatter =new DateFormat.yMd().add_jm();
      Datehere=formatter.format(datetime);
    }else{
      var formatter =new DateFormat.yMd().add_jm();
      Datehere=formatter.format(dateHere);
    }

    return Scaffold(
      appBar: myAppBar(),
      body: Column(
        children: <Widget>[
          // Padding(
          //   padding: const EdgeInsets.all(8.0),
          //   child: Container(
          //       height: 30,
          //       decoration: BoxDecoration(
          //         borderRadius: Tools.myBorderRadius2,
          //         color: MyColors.color1,
          //       ),
          //       child: Center(
          //           child: Text("bla bla",style: TextStyle(color: Colors.white,fontSize: 20),)
          //       ),
          //     ),
          //
          // ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              width: 350,
              height: 40,
              color: MyColors.color1,
              child: Center(child: Text("Class:   "+widget.ClassName,style: TextStyle(fontSize: 20,color: Colors.white),)),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              width: 350,
              height: 40,
              color: MyColors.color1,
              child: Center(
                  child: Text(
                "Enseignant:   " + widget.ReportSenderEmail,
                style: TextStyle(fontSize: 20, color: Colors.white),
              )),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              width: 350,
              height: 40,
              color: MyColors.color1,
              child: Center(child: Text("Date:   " + Datehere,
                style: TextStyle(fontSize: 20, color: Colors.white),)),
            ),
          ),

          loading? Container(height:MediaQuery.of(context).size.height*0.6,child: Center(child:CircularProgressIndicator(backgroundColor: MyColors.color1,)),) : ItemsHere(),

        ],
      ),
    );
  }
}


class SingleQuestionWidget extends StatefulWidget {
  final    String Answer;
  final    String Question;


  SingleQuestionWidget({this.Answer,this.Question });

  @override
  _SingleQuestionWidgetState createState() => _SingleQuestionWidgetState();
}

class _SingleQuestionWidgetState extends State<SingleQuestionWidget> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 0, 0, 10),
      child: Container(
        // height: 80,
        decoration: BoxDecoration(
            borderRadius: Tools.myBorderRadius2,
            color: MyColors.color4
        ),

        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Container(height: 10,),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(widget.Question,style: TextStyle(fontSize:30,color: MyColors.color1,fontWeight: FontWeight.bold),),
              ),
              Container(height: 5,),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(widget.Answer,style: TextStyle(fontSize:20,color: MyColors.color1),),
              ),
              Container(height: 10,),
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
                  // InkWell(
                  //   onTap: (){
                  //
                  //   },
                  //   child: Container(
                  //       width: 35,
                  //       height: 35,
                  //       child: Icon(Icons.delete,color: MyColors.color1,size: 30,)),
                  // ),  // InkWell(
                  //   onTap: (){
                  //
                  //   },
                  //   child: Container(
                  //       width: 35,
                  //       height: 35,
                  //       child: Icon(Icons.delete,color: MyColors.color1,size: 30,)),
                  // ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}



class SingleQuestion{
   String Question;
   String Answer;
}
