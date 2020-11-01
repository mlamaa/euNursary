import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../Colors.dart';
import '../../../Tools.dart';
import '../../../db.dart';
import '../../../widgets.dart';
import 'AddReport.dart';

class AdminClassReportTemplates extends StatefulWidget {
  final Function refresh;
  AdminClassReportTemplates({this.refresh});
  @override
  _AdminClassReportTemplatesState createState() =>
      _AdminClassReportTemplatesState();
}

class _AdminClassReportTemplatesState extends State<AdminClassReportTemplates> {
  List<SingleReportTemplate> ListOfReports = new List<SingleReportTemplate>();
  DataBaseService dataBaseService = new DataBaseService();

  GetReports() async {
    await dataBaseService.GetStudentReportsTemplates(context).then((value) {
      SingleReportTemplate singleReport = new SingleReportTemplate();
      singleReport.ReportTemplateID = value.documentID;
      singleReport.ReportTemplateMaker = value.data["ReportTemplateMaker"];
      singleReport.Date = value.data["Date"];
      singleReport.Reportname = value.data["ReportName"];
      setState(() {
        ListOfReports.add(singleReport);
      });
    });
  }

  Widget ItemsHere() {
    return Flexible(
      child: Padding(
        padding: EdgeInsets.fromLTRB(15, 15, 15, 5),
        child: ListView(
            children: List.generate(ListOfReports.length, (index) {
          return SingleReportTemplateWidget(
            refresh: widget.refresh,
            reportTemplateMaker: ListOfReports[index].ReportTemplateMaker,
            date: ListOfReports[index].Date,
            reportTemplateID: ListOfReports[index].ReportTemplateID,
            // Reportname: ListOfReports[index].Reportname,
          );
        })),
      ),
    );
  }

  @override
  void initState() {
    GetReports();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColors.color4,
      appBar: myAppBar(),
      body: Column(
        children: <Widget>[
          ItemsHere(),
        ],
      ),
    );
  }
}

class SingleReportTemplateWidget extends StatefulWidget {
  final String reportTemplateID;
  final String reportTemplateMaker;
  final Timestamp date;
  final Function refresh;
  final List<String> teacherClasses;

  SingleReportTemplateWidget(
   { this.teacherClasses,
      this.reportTemplateMaker,
      this.reportTemplateID,
      this.date,
      this.refresh});

  @override
  _SingleReportTemplateWidgetState createState() =>
      _SingleReportTemplateWidgetState();
}

class _SingleReportTemplateWidgetState
    extends State<SingleReportTemplateWidget> {
  @override
  Widget build(BuildContext context) {
    DateTime datetime = widget.date.toDate();
    var formatter = new DateFormat.yMd().add_jm();
    String datehere = formatter.format(datetime);

    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 0, 0, 10),
      child: InkWell(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => new AddReport(
                    fromTeacher:true,
                    teacherClasses:widget.teacherClasses,
                        refresh: widget.refresh,
                        ReportTemplateId: widget.reportTemplateID,
                      )));
        },
        child: Container(
          alignment: Alignment.center,
          decoration: BoxDecoration(
              borderRadius: Tools.myBorderRadius2, color: Colors.white),
          child: Text(
            "Date: " + datehere,
            style: TextStyle(fontSize: 20, color: MyColors.color1),
          ),
        ),
      ),
    );
  }
}

class SingleReportTemplate {
  String ReportTemplateID;
  String Reportname;
  String ReportTemplateMaker;
  Timestamp Date;
}
// class SingleQuestion{
//   String Question;
//   List<String> Answer=new List<String>();
// }
