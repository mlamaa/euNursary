import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:garderieeu/Tools.dart';
import 'package:garderieeu/Colors.dart';
import 'package:garderieeu/db.dart';
import 'package:garderieeu/widgets.dart';
import 'EditStudentReport.dart';
import 'AddReport.dart';
import 'AdminStudentReportTemplates.dart';
import 'SingleReport.dart';
import 'package:intl/intl.dart';

class AdminClassReportTemplates extends StatefulWidget {
  final Function refresh;
  AdminClassReportTemplates({this.refresh});

  @override
  _AdminClassReportTemplatesState createState() => _AdminClassReportTemplatesState();
}

class _AdminClassReportTemplatesState extends State<AdminClassReportTemplates> {
  List<SingleReportTemplate> ListOfReports = new List<SingleReportTemplate>();
  DataBaseService dataBaseService = new DataBaseService();

  GetReports() async{
    await dataBaseService.GetStudentReportsTemplates(context).then((value) {
        SingleReportTemplate singleReport=new SingleReportTemplate();
        singleReport.ReportTemplateID=value.documentID;
        singleReport.ReportTemplateMaker=value.data["ReportTemplateMaker"];
        singleReport.Date=value.data["Date"];
        // singleReport.Reportname=value.data["ReportName"];

        setState(() {
          ListOfReports.add(singleReport);
          print("===="+singleReport.ReportTemplateID);
        });


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
              return SingleReportTemplateWidget(
                refresh: widget.refresh,
                ReportTemplateMaker: ListOfReports[index].ReportTemplateMaker,
                Date: ListOfReports[index].Date,
                ReportTemplateID: ListOfReports[index].ReportTemplateID,
                // Reportname: ListOfReports[index].Reportname,

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
    GetReports();
  }




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColors.color4,
      appBar: MyAppBar("title"),
      body: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: InkWell(
              onTap: (){
                Navigator.push(context, MaterialPageRoute(builder: (context)=>new EditStudentReportAsAdmin()));
              },
              child: Container(
                height: 30,
                decoration: BoxDecoration(
                  borderRadius: Tools.myBorderRadius2,
                  color: MyColors.color1,
                ),
                child: Center(
                    child: Text("Edit Student Report Template",style: TextStyle(color: Colors.white,fontSize: 20),)
                ),
              ),
            ),
          ),

          ItemsHere(),

        ],
      ),
    );
  }
}


class SingleReportTemplateWidget extends StatefulWidget {
  final    String ReportTemplateID;
  // final    String Reportname;
  final    String ReportTemplateMaker;
  final    Timestamp Date;
  final Function refresh;
  SingleReportTemplateWidget({this.ReportTemplateMaker,this.ReportTemplateID,this.Date,this.refresh });

  @override
  _SingleReportTemplateWidgetState createState() => _SingleReportTemplateWidgetState();
}

class _SingleReportTemplateWidgetState extends State<SingleReportTemplateWidget> {
  @override
  Widget build(BuildContext context) {
    DateTime datetime;
    if(widget.Date!=null){
      datetime=widget.Date.toDate();
    }

    var formatter =new DateFormat.yMd().add_jm();
    String Datehere=formatter.format(datetime);

    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 0, 0, 10),
      child: InkWell(
        onTap: (){
          Navigator.push(context, MaterialPageRoute(builder: (context)=>
          new AddReport(
            refresh: widget.refresh,
            ReportTemplateId: widget.ReportTemplateID,
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
                Container(height: 10,),
                // Text("Report Name:   "+widget.Reportname,style: TextStyle(fontSize:25,color: Colors.white,fontWeight: FontWeight.bold),),
                // Container(height: 10,),
                Text("Date modified: "+Datehere,style: TextStyle(fontSize:20,color: MyColors.color1),),
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



class SingleReportTemplate{
  String ReportTemplateID;
  // String Reportname;
  String ReportTemplateMaker;
  Timestamp Date;

}
// class SingleQuestion{
//   String Question;
//   List<String> Answer=new List<String>();
// }
