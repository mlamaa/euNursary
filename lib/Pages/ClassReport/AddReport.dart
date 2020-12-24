import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:garderieeu/multiSelect/MultiSelectFormField.dart';
import 'package:intl/intl.dart';

import '../../Colors.dart';
import '../../Tools.dart';
import '../../UserInfo.dart';
import '../../db.dart';
import '../../widgets.dart';

Map<String, dynamic> ReportData = new Map<String, dynamic>();
Map<String, Properties> reportGlobalList = new Map();

List<QuestionAndAnswers> AllAnswerss = new List<QuestionAndAnswers>();

class AddReportForAll extends StatefulWidget {
  Function refresh;
  final List<String> teacherClasses;
  final bool fromTeacher;
  final String reportType;

  AddReportForAll(
      {this.refresh, this.fromTeacher, this.teacherClasses, this.reportType});

  @override
  _AddReportForAllState createState() => _AddReportForAllState();
  DataBaseService dataBaseService = new DataBaseService();
}

class _AddReportForAllState extends State<AddReportForAll> {
  List<Properties> propertiesList = new List();

  List<dynamic> answersList = new List();
  bool loadingAnswers = true;

  Studetns CurrentStudent = new Studetns(" ", " ", " ");
  List<Studetns> studetnsList = new List<Studetns>();

  getStudetns() async {
    await widget.dataBaseService.GetStudents(context).then((values) {
      for (int i = 0; i < values.documents.length; i++) {
        Studetns studetns = new Studetns(" ", " ", " ");
        studetns.ParentEmail = values.documents[i].data["parentEmail"];
        studetns.name = values.documents[i].data["name"];
        studetns.ID = values.documents[i].documentID;

        setState(() {
          studetnsList.add(studetns);
        });
      }
    });
  }

  Classes currentStudentClass = new Classes(" ", " ");
  List<Classes> classesList = new List<Classes>();

  getClasses() async {
    await widget.dataBaseService.GetClasses(context).then((values) {
      for (int i = 0; i < values.documents.length; i++) {
        setState(() {
          classesList.add(new Classes(values.documents[i].documentID,
              values.documents[i].data["ClassName"]));
        });
      }
    });
  }

  getWidgetsInfo() async {
    var info = await widget.dataBaseService
        .GetReportTemplateQuestions(context, widget.reportType)
        .then((value) {
      for (var doc in value.documents) {
        setState(() {
          propertiesList
              .add(new Properties(doc, doc.documentID, reportGlobalList));
        });
      }
    });
  }

  String getDateNow() {
    String Datehere = " ";
    DateTime datetime = DateTime.now();
    var formatter = new DateFormat("yyyy.MM.dd");
    Datehere = formatter.format(datetime);
    return Datehere;
  }

  Future<void> getAnswers(String classID) async {
    setState(() {
      loadingAnswers = true;
    });
    for(var item in propertiesList){
      setState(() {
        item.controller.text = '';
      });
    }
    if (classID != " ") {
      var db = await DataBaseService().GetQuestionsOfReport(
         classID, getDateNow(), context, widget.reportType);
      setState(() {
        answersList = db;
      });
    }

    for (var answer in answersList) {
      for (var item in propertiesList) {
        if (answer['Question'] == item.Question) {
          if (item.MultipleChoice) {
            item.answersList.addAll(answer['Answer']);
          } else {
            setState(() {
              item.controller.text = answer['Answer'];
              print('saving answers :       ' + item.controller.text);
            });
          }
        }
      }
    }
    setState(() {
      loadingAnswers = false;
    });
  }

  submit() async {
    showLoadingDialog(context);
    await widget.dataBaseService.sendReport(ReportData, reportGlobalList,
        currentStudentClass.ID, getDateNow(), context, widget.reportType);

    widget.refresh(getDateNow());
    print("refresh");
    Navigator.pop(context);
    Navigator.pop(context);
  }

  getUserType(String email) async {
    await widget.dataBaseService
        .getUserType(email, context)
        .then((value) async {
      UserCurrentInfo.currentUserType = value.data["type"];
      if (UserCurrentInfo.email != null &&
          UserCurrentInfo.currentUserType != null)
        await widget.dataBaseService.saveTooken(
            UserCurrentInfo.email, UserCurrentInfo.currentUserType, context);
      // print(UserCurrentInfo.Type+"a");
    });
  }



  @override
  void initState() {
    getClasses();
    if (widget.reportType == 'Student') getStudetns();
    getWidgetsInfo();
    super.initState();
    ReportData[" "] = " ";
    ReportData["ReportSenderType"] = "admin";
    ReportData["ReportSenderID"] = UserCurrentInfo.currentUserId;
    ReportData["ReportSenderEmail"] = UserCurrentInfo.email;
    ReportData["Date"] = FieldValue.serverTimestamp();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColors.color4,
      appBar: myAppBar(),
      body: Container(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                child: Text(
                  "Vos rapports",
                  style: TextStyle(
                      fontSize: 40,
                      color: MyColors.color1,
                      fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Selectionnez:",
                    style: TextStyle(
                        fontSize: 20,
                        color: MyColors.color1,
                        fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
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
                      child: DropdownSearch<Classes>(
                          mode: Mode.DIALOG,
                          showSearchBox: true,
                          // showSelectedItem: true,
                          itemAsString: (Classes s) => s.name,
                          onFind: UserCurrentInfo.currentUserType == 'admin'
                              ? (String filter) async {
                                  if (filter.length != 0) {
                                    List<Classes> classesCurrentList =
                                        new List<Classes>();
                                    for (int i = 0;
                                        i < classesList.length;
                                        i++) {
                                      if (classesList[i]
                                          .name
                                          .contains(filter)) {
                                        classesCurrentList.add(classesList[i]);
                                      }
                                    }
                                    return classesCurrentList;
                                  } else {
                                    return classesList;
                                  }
                                }
                              : (String filter) async {
                                  return classesList
                                      .where((element) =>
                                          (widget.fromTeacher &&
                                              (widget?.teacherClasses
                                                      ?.contains(element.ID) ??
                                                  false)) &&
                                          ((filter?.trim() ?? '') == '' ||
                                              element.name.contains(filter)))
                                      .toList();
                                },
                          label: "class",
                          hint: "Nom du class",
                          // popupItemDisabled: (String s) => s.startsWith('I'),
                          onChanged: (Classes s) async {

                            setState(() {
                              currentStudentClass = s;
                              print('class ID: ' + currentStudentClass.ID);
                              getAnswers(currentStudentClass.ID);
                            });

                          },
                          selectedItem: currentStudentClass),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 10,
              ),
              widget.reportType == 'Student'
                  ? Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          "Student Name:",
                          style: TextStyle(
                              fontSize: 20,
                              color: MyColors.color1,
                              fontWeight: FontWeight.bold),
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
                            child: DropdownSearch<Studetns>(
                                mode: Mode.DIALOG,
                                showSearchBox: true,
                                // showSelectedItem: true,
                                itemAsString: (Studetns s) => s.name,
                                onFind: (String filter) async {
                                  if (filter.length != 0) {
                                    List<Studetns> studentsCurrentList =
                                        new List<Studetns>();
                                    for (int i = 0;
                                        i < studetnsList.length;
                                        i++) {
                                      if (studetnsList[i]
                                          .name
                                          .contains(filter)) {
                                        studentsCurrentList
                                            .add(studetnsList[i]);
                                      }
                                    }
                                    return studentsCurrentList;
                                  } else {
                                    return studetnsList;
                                  }
                                },
                                label: "Student name",
                                hint: "Student Name",
                                // popupItemDisabled: (String s) => s.startsWith('I'),
                                onChanged: (Studetns s) async {
                                  setState(() {
                                    CurrentStudent = s;
                                    getAnswers(CurrentStudent.ID);
                                  });


                                },
                                selectedItem: CurrentStudent),
                          ),
                        ),
                      ],
                    )
                  : Container(),
              SizedBox(
                height: 10,
              ),
              (currentStudentClass.ID.trim() ?? '') != ''
                  ? (loadingAnswers
                      ? Container(
                          height: MediaQuery.of(context).size.height * 0.62,
                          child: Center(child: CircularProgressIndicator()))
                      : getReportComponenetsList())
                  : Container(),
              SizedBox(
                height: 20,
              ),
              if ((currentStudentClass.ID.trim() ?? '') != '')
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    InkWell(
                      onTap: () {
                        if (currentStudentClass.ID != " ") {
                          ReportData["ClassName"] = currentStudentClass.name;
                          ReportData["ClassId"] = currentStudentClass.ID;
                          if (widget.reportType == 'Student') {
                            ReportData["StudentName"] = CurrentStudent.name;
                            ReportData["StudentParentEmail"] =
                                CurrentStudent.ParentEmail;
                          }
                          submit();
                        }
//                        List<QuestionAndAnswers> questionAndanswers=new List<QuestionAndAnswers>();
                      },
                      child: Container(
                        decoration: new BoxDecoration(
                          color: MyColors.color1,
                          borderRadius: new BorderRadius.only(
                            topLeft: const Radius.circular(5.0),
                            topRight: const Radius.circular(5.0),
                            bottomLeft: const Radius.circular(5.0),
                            bottomRight: const Radius.circular(5.0),
                          ),
                        ),
                        width: 250,
                        height: 45,
                        child: Center(
                          child: Text(
                            "Sauvgarder",
                            style: TextStyle(color: Colors.white, fontSize: 30),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }

  static Future<void> showLoadingDialog(BuildContext context) async {
    return showDialog<void>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return new WillPopScope(
              onWillPop: () async => false,
              child: SimpleDialog(
                  //key: key,
                  backgroundColor: MyColors.color4,
                  children: <Widget>[
                    Center(
                      child: Column(children: [
                        CircularProgressIndicator(
                          backgroundColor: MyColors.color1,
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          "Saving, Please Wait...",
                          style: TextStyle(color: MyColors.color1),
                        )
                      ]),
                    )
                  ]));
        });
  }

  Widget getReportComponenetsList() {
    print('properties --------> ' + propertiesList.toString());
    return Container(
      height: MediaQuery.of(context).size.height * 0.62,
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(children: [
            for (int i = 0; i < propertiesList.length; i++)
              reportComponent(propertiesList[i])
          ]),
        ),
      ),
    );
  }

  Widget reportComponent(Properties properties) {
    switch (properties.Type) {
      case 'choices':
        return properties.MultipleChoice
            ? MultiSelectComponent(properties)
            : SingleSelectComponent(properties);
        break;
      case 'text':
        return TextFieldComponent(properties);
        break;
      case 'date':
        return TimeComponent(properties);
        break;
    }
  }
}

class MultiSelectComponent extends StatefulWidget {
  Properties properties;

  MultiSelectComponent(this.properties);

  @override
  _MultiSelectComponentState createState() => _MultiSelectComponentState();
}

class _MultiSelectComponentState extends State<MultiSelectComponent> {
  List<dynamic> _answer = new List();

  setValue() {
    setState(() {
      _answer = widget.properties.answersList;
    });
  }

  initState() {
    if (widget.properties.answersList != null) {
      setValue();
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            widget.properties.Question,
            style: TextStyle(color: MyColors.color1, fontSize: 25),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: MultiSelectFormField(
//          autovalidate: false,

            initialValue: _answer,
            titleText: ' ',
            validator: (value) {
              if (value == null || value.length == 0) {
                return widget.properties.Question;
              } else {
                return " ";
              }
            },
            /*initialValue: widget.savedAnswer,*/
            dataSource: [
              for (int i = 0; i < widget.properties.TheChoices.length; i++)
                {
                  "display": widget.properties.TheChoices[i],
                  "value": widget.properties.TheChoices[i]
                }
            ],

            textField: 'display',
            valueField: 'value',
            okButtonLabel: 'OK',
            cancelButtonLabel: 'ANNULER',
            hintText: 'Veuillez en choisir un ou plusieurs valeurs',
            onSaved: (value) {
              if (value == null) return;
              setState(() {
                _answer = value;
                widget.properties.answersList = value;
              });

              QuestionAndAnswers questionsAndAnswersHere =
                  new QuestionAndAnswers();
              questionsAndAnswersHere.question = widget.properties.Question;
              questionsAndAnswersHere.answers = value;

              // ForTextQuestion[i].questionAndAnswers=ForTextQuestion[i].textEditingController.text;
              // print(AllAnswers.toString()+"==============================");
              for (int j = 0; j < AllAnswerss.length; j++) {
                if (AllAnswerss[j].question ==
                    questionsAndAnswersHere.question) {
                  AllAnswerss.removeAt(j);
                }
              }
              AllAnswerss.add(questionsAndAnswersHere);

              // AllAnswers[question]=_MyAnswers.toString();
              //print(AllAnswers.toString()+"==============================");
              //});
            },
          ),
        ),
      ],
    );
  }
}

class SingleSelectComponent extends StatefulWidget {
  Properties properties;

  SingleSelectComponent(this.properties);

  @override
  _SingleSelectComponentState createState() => _SingleSelectComponentState();
}

class _SingleSelectComponentState extends State<SingleSelectComponent> {
  String _answer;

  setController() {
    setState(() {
      _answer = widget.properties.controller.text;
    });
  }

  @override
  void initState() {
    print('in single drop ---> ' + widget.properties.controller.text);
    if (widget.properties.controller.text.isNotEmpty &&
        widget.properties.controller.text != null) setController();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              widget.properties.Question,
              style: TextStyle(color: MyColors.color1, fontSize: 25),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              child: DropdownSearch<String>(
                //
                // clearButton:
                //     Container(
                //       child: InkWell(onTap: (){
                //         //print('saved1 ${widget.properties.title}: ' + widget.properties.controller.text);
                //         setState(() {
                //           _answer = '';
                //           print('answerrrrrrrr' + _answer);
                //           widget.properties.controller.text = '';
                //         });
                //         //print('saved2 ${widget.properties.title}: ' + widget.properties.controller.text);
                //       },child: Icon(Icons.cancel_outlined),),
                //     ),

                items: widget.properties.TheChoices,
                label: "Sélectionnez élément",
                selectedItem: _answer,
                showClearButton: true,
                showSelectedItem: true,
                onChanged: (value) {
                  // if (AllAnswerss?.firstWhere(
                  //         (element) =>
                  //             element.question == widget.properties.Question,
                  //         orElse: () => null) !=
                  //     null)
                  //   AllAnswerss?.firstWhere(
                  //       (element) =>
                  //           element.question == widget.properties.Question,
                  //       orElse: () => null)?.answer = value;
                  // else
                  //   AllAnswerss.add(QuestionAndAnswers()
                  //     ..question = widget.properties.Question
                  //     ..answer = _answer);
                  setState(() {
                    _answer = value;
                    widget.properties.controller.text = value;
                  });
                },
              ),
            ),
          )
        ],
      ),
    );
  }
}

class TextFieldComponent extends StatefulWidget {
  Properties properties;

  TextFieldComponent(this.properties);

  @override
  _TextFieldComponentState createState() => _TextFieldComponentState();
}

class _TextFieldComponentState extends State<TextFieldComponent> {

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            widget.properties.Question,
            style: TextStyle(color: MyColors.color1, fontSize: 25),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextFormField(

            controller: widget.properties.controller,
            //initialValue: currentText,
            decoration: InputDecoration(
                hintText: widget.properties.Question,
                hintStyle: TextStyle(
                  color: MyColors.color1,
                  fontSize: 16,
                ),
                border: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: MyColors.color1,
                    width: 2.0,
                  ),
                )),
          ),
        ),
      ],
    );
  }
}

class TimeComponent extends StatelessWidget {
  Properties properties;

  TimeComponent(this.properties);

  DateTime selectedDate = DateTime.now();

  Future<void> _addDate(BuildContext context) async {
    DatePicker.showTimePicker(context, showTitleActions: true,
        onChanged: (date) {
      print('change $date in time zone ' +
          date.timeZoneOffset.inHours.toString());
    }, onConfirm: (date) {
      String NewDate;
      // NewDate=date.toDate();
      var formatter = new DateFormat.Hm().add_jm();
      NewDate = formatter.format(date);

      properties.controller.text = properties.controller.text +
          NewDate.split(" ")[0] +
          " " +
          NewDate.split(" ")[1] +
          "\n";

      print('confirm $date');
    }, locale: LocaleType.en);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            properties.Question,
            style: TextStyle(color: MyColors.color1, fontSize: 25),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Expanded(
              child: Padding(
                padding: EdgeInsets.fromLTRB(15, 0, 0, 0),
                child: TextFormField(
                  maxLines: 4,
                  controller: properties.controller,
                  style: TextStyle(color: MyColors.color1, fontSize: 16),
                  decoration: InputDecoration(
                    hintText: "cliquez pour ajouter le temps",
                    hintStyle: TextStyle(
                      color: MyColors.color1,
                      fontSize: 16,
                    ),
                    border: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: MyColors.color1,
                        width: 2.0,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: InkWell(
                onTap: () {
                  _addDate(context);
                },
                child: Container(
                    width: 40,
                    height: 100,
                    child: Icon(
                      Icons.access_time,
                      size: 60,
                      color: MyColors.color1,
                    )),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class Properties {
  String ID;
  bool MultipleChoice;
  String Question;
  List<String> TheChoices;
  String Type;
  int choicesCount;
  List<dynamic> answersList;
  TextEditingController controller = new TextEditingController();

  Properties(var properties, String widgetID,
      Map<String, Properties> controllersList) {
    this.MultipleChoice = properties['MultipleChoice'];
    this.Question = properties['Question'];
    // List<dynamic> Hi;
    // Hi.cast<String>().t
    if (properties['TheChoices'] != null)
      this.TheChoices = properties['TheChoices'].cast<String>().toList();
    this.Type = properties['Type'];
    this.choicesCount = properties['choicesCount'];
    this.ID = widgetID;
    controllersList[widgetID] = this;
    // if (answer != null) {
    //   this.controller.text = answer;
    // }
  }
}

class ChoicesHere {
  List<String> choices = new List<String>();
  bool MultiChoice;
  QuestionAndAnswers questionAndAnswers;
}

class Classes {
  String ID;
  String name;

  Classes(this.ID, this.name);
}

class Studetns {
  String ParentEmail;
  String ID;
  String name;

  Studetns(this.ParentEmail, this.name, this.ID);
}
