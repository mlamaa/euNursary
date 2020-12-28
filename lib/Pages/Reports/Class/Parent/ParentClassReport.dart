import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:garderieeu/Colors.dart';
import 'package:garderieeu/Tools.dart';
import 'package:garderieeu/UserInfo.dart';
import 'package:garderieeu/db.dart';
import 'package:garderieeu/widgets.dart';
import 'package:intl/intl.dart';

import '../SingleReport.dart';

class ParentClassReport extends StatefulWidget {
  @override
  _ParentClassReportState createState() => _ParentClassReportState();
}

class _ParentClassReportState extends State<ParentClassReport> {
  List<SingleReportt> ListOfReports = new List<SingleReportt>();
  DataBaseService dataBaseService = new DataBaseService();

  String CurrentClass;

  List<String> ListOfDates = new List<String>();

  DateTime selectedDate = DateTime.now();

  Future<void> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(2020, 8),
        lastDate: DateTime.now());
    if (picked != null && picked != selectedDate)
      setState(() {
        selectedDate = picked;
        String year = picked.year.toString();
        String month = picked.month.toString();
        String day = picked.day.toString();

        if (month.length == 1) {
          month = "0" + month;
        }

        if (day.length == 1) {
          day = "0" + day;
        }
        GetAdminChildsClasses(year + "." + month + "." + day);
        // GetClasses(year + "." + month + "." + day);
      });
  }

  Widget DatesList;

  GetAdminChildsClasses(String date) async {
    await dataBaseService.GetSingleParents(UserCurrentInfo.email, context)
        .then((value) {
      GetReports(value.data["ChildsClassesId"], date);
    });
  }

  String getDateNow() {
    String Datehere = " ";
    DateTime datetime = DateTime.now();
    var formatter = new DateFormat("yyyy.MM.dd");
    Datehere = formatter.format(datetime);
    return Datehere;
  }

  GetReports(List<dynamic> ChildsClassesId, String datee) async {
    ListOfReports = new List<SingleReportt>();

    await dataBaseService.GetClassReports(datee, context).then((value) {
      for (int i = 0; i < value.documents.length; i++) {
        SingleReportt singleReport = new SingleReportt();
        singleReport.ReportID = value.documents[i].documentID;
        singleReport.ClassId = value.documents[i].data["ClassId"];
        singleReport.Date = value.documents[i].data["Date"];
        singleReport.ClassName = value.documents[i].data["ClassName"];
        singleReport.ReportSenderID = value.documents[i].data["ReportSenderID"];
        singleReport.ReportSenderEmail =
            value.documents[i].data["ReportSenderEmail"];
        singleReport.ReportSenderType =
            value.documents[i].data["ReportSenderType"];
        setState(() {
          // print(singleReport.Date.toDate().toIso8601String()+singleReport.ClassName+singleReport.ReportSenderEmail+singleReport.ReportSenderID+singleReport.ReportSenderType+singleReport.ReportID);
          if (ChildsClassesId.length > 0) {
            bool mustBeAdded = false;
            for (int j = 0; j < ChildsClassesId.length; j++) {
              if (ChildsClassesId[j] == singleReport.ClassId) {
                mustBeAdded = true;
              }
              if (mustBeAdded && j == ChildsClassesId.length - 1) {
                ListOfReports.add(singleReport);
              }
            }
          }
        });
      }
    });
    print('list of reportss  : '  +  ListOfReports.toString());
  }

  Widget ItemsHere() {
    return Flexible(
      child: Padding(
        padding: EdgeInsets.fromLTRB(15, 15, 15, 5),
        child: ListView(
            // crossAxisCount: 1,
            // crossAxisSpacing: 30,
            // mainAxisSpacing:20,
            children: List.generate(ListOfReports.length, (index) {
          return SingleReportWidget(
            ReportId: ListOfReports[index].ReportID,
            Date: ListOfReports[index].Date,
            ClassId: ListOfReports[index].ClassId,
            ClassName: ListOfReports[index].ClassName,
            ReportSenderID: ListOfReports[index].ReportSenderID,
            ReportSenderType: ListOfReports[index].ReportSenderType,
            ReportSenderEmail: ListOfReports[index].ReportSenderEmail,
          );
        })),
      ),
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    GetAdminChildsClasses(dataBaseService.getDateNow());
  }

  @override
  Widget build(BuildContext context) {
    DatesList = Row(
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
            child: RaisedButton(
              onPressed: () => _selectDate(context),
              child: Text(dataBaseService.formatDate(selectedDate)),
            ),
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
  final String ClassId;
  final String ReportId;
  final String ClassName;
  final String ReportSenderID;
  final String ReportSenderEmail;
  final String ReportSenderType;
  final Timestamp Date;

  SingleReportWidget(
      {this.ReportSenderType,
      this.ReportSenderID,
      this.ReportId,
      this.ClassName,
      this.ClassId,
      this.Date,
      this.ReportSenderEmail});

  @override
  _SingleReportWidgetState createState() => _SingleReportWidgetState();
}

class _SingleReportWidgetState extends State<SingleReportWidget> {
  @override
  Widget build(BuildContext context) {
    DateTime dateHere = DateTime.now();
    String Datehere = " ";
    DateTime datetime;
    if (widget.Date != null) {
      datetime = widget.Date.toDate();
      var formatter = new DateFormat.yMd().add_jm();
      Datehere = formatter.format(datetime);
    } else {
      var formatter = new DateFormat.yMd().add_jm();
      Datehere = formatter.format(dateHere);
    }

    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 0, 0, 10),
      child: InkWell(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => new SingleReport(
                        Date: widget.Date,
                        ReportID: widget.ReportId,
                        ReportSenderType: widget.ReportSenderType,
                        ReportSenderID: widget.ReportSenderID,
                        ReportSenderEmail: widget.ReportSenderEmail,
                        ClassId: widget.ClassId,
                        ClassName: widget.ClassName,
                      )));
        },
        child: Container(
          // height: 80,
          decoration: BoxDecoration(
              borderRadius: Tools.myBorderRadius2, color: Colors.white),

          child: Center(
            child: Column(
              children: <Widget>[
                // Container(height: 10,),
                // Text("Enseignant:   "+widget.ReportSenderType,style: TextStyle(fontSize:25,color: Colors.white,fontWeight: FontWeight.bold),),
                Container(
                  height: 10,
                ),
                Text(
                  "Nom du class:   " + widget.ClassName,
                  style: TextStyle(fontSize: 20, color: MyColors.color1),
                ),
                Container(
                  height: 10,
                ),
                Text(
                  "Date:   " + Datehere,
                  style: TextStyle(fontSize: 20, color: MyColors.color1),
                ),
                Container(
                  height: 10,
                ), 
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class SingleReportt {
  String ReportID;
  String ClassId;
  Timestamp Date;
  String ClassName;
  String ReportSenderID;
  String ReportSenderEmail;
  String ReportSenderType;
}