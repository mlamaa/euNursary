
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:garderieeu/Colors.dart';
import 'package:garderieeu/Tools.dart';
import 'package:garderieeu/UserInfo.dart';
import 'package:garderieeu/db.dart';
import 'package:garderieeu/widgets.dart';
import 'package:intl/intl.dart';

import 'SingleReport.dart';

class ParentStudentReport extends StatefulWidget {
  @override
  _ParentStudentReportState createState() => _ParentStudentReportState();
}

class _ParentStudentReportState extends State<ParentStudentReport> {
  List<SingleReportt> ListOfReports = new List<SingleReportt>();
  DataBaseService dataBaseService = new DataBaseService();


  String CurrentClass;
  String CurrentDate;



  List<String> ListOfDates=new List<String>();
  getDates(){
    dataBaseService.getDatesOfStudentData(context).then((value) {
      for(int i=0;i<value.documents.length;i++){
        setState(() {
          ListOfDates.add(value.documents[i].documentID);
        });
      }
    });
  }
  Widget DatesList;



  GetReports(String Datee) async{
    await dataBaseService.GetStudentReports(Datee,context).then((value) {
      for(int i=0;i<value.documents.length;i++){
        SingleReportt singleReport=new SingleReportt();
        singleReport.ReportID=value.documents[i].documentID;
        singleReport.ClassId=value.documents[i].data["ClassId"];
        singleReport.Date=value.documents[i].data["Date"];
        singleReport.ClassName=value.documents[i].data["ClassName"];
        singleReport.ReportSenderID=value.documents[i].data["ReportSenderID"];
        singleReport.ReportSenderEmail=value.documents[i].data["ReportSenderEmail"];
        singleReport.ReportSenderType=value.documents[i].data["ReportSenderType"];
        singleReport.StudentParentEmaiil=value.documents[i].data["StudentParentEmail"];
        singleReport.StudentName=value.documents[i].data["StudentName"];

        setState(() {
          // print(singleReport.Date.toDate().toIso8601String()+singleReport.ClassName+singleReport.ReportSenderEmail+singleReport.ReportSenderID+singleReport.ReportSenderType+singleReport.ReportID);
          if(singleReport.StudentParentEmaiil==UserCurrentInfo.email){
            ListOfReports.add(singleReport);
          }

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

            children: List.generate(ListOfReports.length, (index) {
              return SingleReportWidget(
                StudentName: ListOfReports[index].StudentName,
                ReportId: ListOfReports[index].ReportID,
                Date: ListOfReports[index].Date,
                ClassId: ListOfReports[index].ClassId,
                ClassName: ListOfReports[index].ClassName,
                ReportSenderID: ListOfReports[index].ReportSenderID,
                ReportSenderType: ListOfReports[index].ReportSenderType,
                ReportSenderEmail: ListOfReports[index].ReportSenderEmail,
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
    // GetReports();
    GetReports(dataBaseService.getDateNow());
    getDates();
  }




  @override
  Widget build(BuildContext context) {

    DatesList=Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Text(
          "Raports de: ",
          style: TextStyle(fontSize: 18),
        ),
        Container(
          width: 10,
        ),
        Container(
          width: 200,
          height: 50,
          decoration: BoxDecoration(
            borderRadius: Tools.myBorderRadius2,
            // color: MyColors.color1
          ),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 0, 0),
            child:
            DropdownSearch<String>(
                mode: Mode.DIALOG,
                showSearchBox: true,
                // showSelectedItem: true,
                itemAsString:(String s) =>s,
                onFind: (String filter) async{
                  if(filter.length!=0){
                    List<String> datesCurrentList=new List<String>();
                    for(int i=0;i<ListOfDates.length;i++){
                      if(ListOfDates[i].contains(filter))
                      {
                        datesCurrentList.add(ListOfDates[i]);
                      }
                    }
                    return datesCurrentList;
                  }else{
                    return ListOfDates;
                  }

                },
                label: "Reports Date",
                hint: "Reports Date",
                // popupItemDisabled: (String s) => s.startsWith('I'),
                onChanged: (String s){
                  GetReports(s);
                } ,
                selectedItem: CurrentDate),

          ),
        ),
      ],
    );

    return Scaffold(
      backgroundColor: MyColors.color4,
      appBar: myAppBar(),
      body: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: DatesList,
          ),
          ItemsHere(),

        ],
      ),
    );
  }
}


class SingleReportWidget extends StatefulWidget {
  final    String ClassId;
  final    String ReportId;
  final    String ClassName;
  final    String StudentName;

  final    String ReportSenderID;
  final    String ReportSenderEmail;
  final    String ReportSenderType;
  final    Timestamp Date;

  SingleReportWidget({this.StudentName,this.ReportSenderType,this.ReportSenderID,this.ReportId,this.ClassName,this.ClassId,this.Date,this.ReportSenderEmail });

  @override
  _SingleReportWidgetState createState() => _SingleReportWidgetState();
}

class _SingleReportWidgetState extends State<SingleReportWidget> {
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


    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 0, 0, 10),
      child: InkWell(
        onTap: (){
          Navigator.push(context, MaterialPageRoute(builder: (context)=>
          new SingleReport(
            StudentName: widget.StudentName,
            Date: widget.Date,
            ReportID: widget.ReportId,
            ReportSenderType: widget.ReportSenderType,
            ReportSenderID: widget.ReportSenderID,
            ReportSenderEmail: widget.ReportSenderEmail,
            ClassId: widget.ClassId,
            ClassName: widget.ClassName,
          )
          ));
        },
        child: Container(
          // height: 80,
          decoration: BoxDecoration(
              borderRadius: Tools.myBorderRadius2,
              color: Colors.white
          ),

          child: Center(
            child: Column(
              children: <Widget>[
                // Container(height: 10,),
                // Text("sender:   "+widget.ReportSenderType,style: TextStyle(fontSize:25,color: Colors.white,fontWeight: FontWeight.bold),),
                Container(height: 10,),
                Text("Nom du class:   " + widget.ClassName,
                  style: TextStyle(fontSize: 20, color: MyColors.color1),),
                Container(height: 10,),
                Text("Student:   " + widget.StudentName,
                  style: TextStyle(fontSize: 20, color: MyColors.color1),),
                Container(height: 10,),

                Text("Date:   " + Datehere,
                  style: TextStyle(fontSize: 20, color: MyColors.color1),),
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
                    // ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}




class SingleReportt{
  String StudentName;
  String StudentParentEmaiil;
  String ReportID;
  String ClassId;
  Timestamp Date;
  String ClassName;
  String ReportSenderID;
  String ReportSenderEmail;
  String ReportSenderType;
}
// class SingleQuestion{
//   String Question;
//   List<String> Answer=new List<String>();
// }
