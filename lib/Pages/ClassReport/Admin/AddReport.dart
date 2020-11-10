import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
//import 'package:progress_dialog/progress_dialog.dart';
import 'package:garderieeu/Colors.dart';
import 'package:garderieeu/Tools.dart';
import 'package:garderieeu/UserInfo.dart';
import 'package:garderieeu/db.dart';
import 'package:garderieeu/multiSelect/MultiSelectFormField.dart';
import 'package:garderieeu/widgets.dart';
import 'package:intl/intl.dart';

import 'EditClassReport.dart';

// Map<String,dynamic> AllAnswers=new Map<String,dynamic>();
Map<String, dynamic> ReportData = new Map<String, dynamic>();
List<QuestionAndAnswers> AllAnswerss = new List<QuestionAndAnswers>();

class AddReport extends StatefulWidget {
  final Function refresh;
  final String reportTemplateId;
  // final String UserID;
  // final String AdminEmail;

  AddReport({this.reportTemplateId, this.refresh});

  @override
  _AddReportState createState() => _AddReportState();
  DataBaseService dataBaseService = new DataBaseService();
}

class _AddReportState extends State<AddReport> {
  List<Items> items = new List<Items>();
  List<TextEditingDynamic> forTextQuestion = new List<TextEditingDynamic>();

  getInfo() async {
    List<Items> items2 = new List<Items>();

    await widget.dataBaseService
        .GetClassReportTemplateQuestions(context)
        .then((value) {
//      print("--------------------lenght="+value.documents.length.toString());
      for (int i = 0; i < value.documents.length; i++) {
//        print("--------------------text="+value.documents[i].data["text"]);
        Items item = new Items();
        item.question = value.documents[i].data["Question"];
        item.type = value.documents[i].data["Type"];
        if (item.type == "choices") {
          ChoicesHere choicesHere = new ChoicesHere();
          choicesHere.questionAndAnswers = new QuestionAndAnswers();
          choicesHere.MultiChoice = value.documents[i].data["MultipleChoice"];
          for (int j = 0; j < value.documents[i].data["choicesCount"]; j++) {
//            choicesHere.ChoicesMap.
            choicesHere.choices.add(value.documents[i].data["TheChoices"][j]);
          }
          item.choicesHere = choicesHere;
          items2.add(item);
        } else {
          TextEditingDynamic textEditingDynamic = new TextEditingDynamic();
          textEditingDynamic.questionAndAnswers = new QuestionAndAnswers();
          textEditingDynamic.textEditingController =
              new TextEditingController();
          textEditingDynamic.Question = value.documents[i].data["Question"];
          forTextQuestion.add(textEditingDynamic);
          item.textEditingDynamic = textEditingDynamic;
          items2.insert(0, item);
        }
      }
      setState(() {
        items = items2;
      });
    });
  }

  getAnswers() async {
    if (currentStudentClass.ID != " ") {
      widget.dataBaseService
          .GetQuestionsOfReport(currentStudentClass.ID, getDateNow(), context)
          .then((value) {
        if (value.documents.length > 0) {
          print("found dataaaa");
          for (int i = 0; i < value.documents.length; i++) {
            for (int j = 0; j < items.length; j++) {
              if (items[j].question == value.documents[i].data["Question"]) {
                if (items[j].type == "text" || items[j].type == "date") {
                  setState(() {
                    items[j].AnswersText = value.documents[i].data["Answer"];
                    print(value.documents[i].data["Answer"]);
                  });
                } else if (items[j].type != "text" &&
                    items[j].type != "date" &&
                    items[j].choicesHere.MultiChoice) {
                  setState(() {
                    items[j].Answers = value.documents[i].data["Answer"];
                    print(value.documents[i].data["Answer"]);
                  });
                } else if (items[j].type != "text" &&
                    items[j].type != "date" &&
                    !items[j].choicesHere.MultiChoice) {
                  setState(() {
                    items[j].AnswersText = value.documents[i].data["Answer"];
                    print(value.documents[i].data["Answer"]);
                  });
                }
              }
            }
          }
        } else {
          print("no dataaaa");
          for (int j = 0; j < items.length; j++) {
            if (items[j].type == "text") {
              setState(() {
                items[j].AnswersText = "";
              });
            } else if (items[j].type != "text" &&
                items[j].choicesHere.MultiChoice) {
              setState(() {
                items[j].Answers = new List<dynamic>();
              });
            } else {
              setState(() {
                items[j].AnswersText = "";
              });
            }
          }
        }
      });
    }
  }

  Widget itemsHere() {
    return Container(
        height: 400,
        child: Padding(
          padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
          child: ListView.builder(
              itemCount: items.length,
              itemBuilder: (context, index) {
                if (items[index].type == "choices") {
                  if (items[index].choicesHere.MultiChoice) {
                    print(items[index].Answers.toString() + "oooooooooooooooo");
                    return Padding(
                      padding: EdgeInsets.fromLTRB(15, 0, 15, 10),
                      child: ItemView(
                        savedAnswer: items[index].Answers,
                        question: items[index].question,
                        multipleChoice: items[index].choicesHere.MultiChoice,
                        type: items[index].type,
                        choices: items[index].choicesHere.choices,
                      ),
                    );
                  } else if (!items[index].choicesHere.MultiChoice) {
                    print(items[index].AnswersText.toString() +
                        "oooooooooooooooo");
                    return Padding(
                      padding: EdgeInsets.fromLTRB(15, 0, 15, 10),
                      child: ItemView(
                        savedAnswerText: items[index].AnswersText,
                        question: items[index].question,
                        multipleChoice: items[index].choicesHere.MultiChoice,
                        type: items[index].type,
                        choices: items[index].choicesHere.choices,
                      ),
                    );
                  }
                } else {
                  print(
                      items[index].AnswersText.toString() + "oooooooooooooooo");

                  return Padding(
                    padding: EdgeInsets.fromLTRB(15, 0, 15, 10),
                    child: ItemView(
                      savedAnswerText: items[index].AnswersText,
                      question: items[index].question,
                      type: items[index].type,
                      textEditingDynamic: items[index].textEditingDynamic,
                    ),
                  );
                }
                return Padding(
                  padding: EdgeInsets.fromLTRB(1, 0, 1, 1),
                  child: Container(),
                );
                ;
              }),
        ));
  }

  Classes currentStudentClass = new Classes(" ", " ");
  List<Classes> classesList = new List<Classes>();
  getClasses() async {
    await widget.dataBaseService.GetClasses(context).then((values) {
      for (int i = 0; i < values.documents.length; i++) {
        Classes classes = new Classes(" ", " ");
        classes.ID = values.documents[i].documentID;
        classes.name = values.documents[i].data["ClassName"];

        setState(() {
          classesList.add(classes);
        });
      }
    });
  }

  @override
  void initState() {
    getInfo();
    getClasses();
    super.initState();
    // AllAnswers[" "]=" ";
    ReportData[" "] = " ";
    ReportData["ReportSenderType"] = "admin";
    ReportData["ReportSenderID"] = UserCurrentInfo.currentUserId;
    ReportData["ReportSenderEmail"] = UserCurrentInfo.email;
    ReportData["Date"] = FieldValue.serverTimestamp();
  }

  Future<bool> getTextAnswers() async {
    print("i am at get text answer ");
    for (int i = 0; i < forTextQuestion.length; i++) {
      print("i am at First for loop" + forTextQuestion.length.toString());
      QuestionAndAnswers questionsAndAnswersHere = new QuestionAndAnswers();
      questionsAndAnswersHere.question = forTextQuestion[i].Question;
      questionsAndAnswersHere.answer =
          forTextQuestion[i].textEditingController.text;

      print("i am at First for loop");

      // ForTextQuestion[i].questionAndAnswers=ForTextQuestion[i].textEditingController.text;
      // print(AllAnswers.toString()+"==============================");
      for (int j = 0; j < AllAnswerss.length; j++) {
        print("i am at Second for loop");

        if (AllAnswerss[j].question == questionsAndAnswersHere.question) {
          print("i am at if");

          AllAnswerss.removeAt(j);
        }
      }
      AllAnswerss.add(questionsAndAnswersHere);
    }
    return true;
  }

  String getDateNow() {
    String Datehere = " ";
    DateTime datetime = DateTime.now();
    var formatter = new DateFormat("yyyy.MM.dd");
    Datehere = formatter.format(datetime);
    return Datehere;
  }

  submit() async {
    await getTextAnswers().then((value) {
      if (value == true) {
        widget.dataBaseService.sendClassReport(ReportData, AllAnswerss,
            currentStudentClass.ID, getDateNow(), context);
        Future.delayed(const Duration(milliseconds: 500), () {
          widget.refresh(getDateNow());
          print("refresh");
          Navigator.pop(context);
        });
        // Future.delayed(const Duration(seconds: 2), () {
        //
        // });

      }
    });
  }

  @override
  Widget build(BuildContext context) {
    TextStyle myTextStyle = TextStyle(
        fontSize: 20, color: MyColors.color1, fontWeight: FontWeight.bold);

    return Scaffold(
      backgroundColor: MyColors.color4,
      appBar: myAppBar(),
      body: items.length > 0
          ? GestureDetector(
              onTap: () {
                FocusScope.of(context).requestFocus(new FocusNode());
              },
              child: Stack(
                children: <Widget>[
                  SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: InkWell(
                            onTap: () {
                              Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          new EditClassReportAsAdmin()));
                            },
                            child: Container(
                              height: 30,
                              decoration: BoxDecoration(
                                borderRadius: Tools.myBorderRadius2,
                                color: MyColors.color1,
                              ),
                              child: Center(
                                  child: Text(
                                "Modifier le modèle de rapport de classe",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 20),
                              )),
                            ),
                          ),
                        ),
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
                        Container(
                          height: 10,
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              "Enfant:",
                              style: myTextStyle,
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
                                child: DropdownSearch<Classes>(
                                    mode: Mode.DIALOG,
                                    showSearchBox: true,
                                    // showSelectedItem: true,
                                    itemAsString: (Classes s) => s.name,
                                    onFind: (String filter) async {
                                      if (filter.length != 0) {
                                        List<Classes> classesCurrentList =
                                            new List<Classes>();
                                        for (int i = 0;
                                            i < classesList.length;
                                            i++) {
                                          if (classesList[i]
                                              .name
                                              .contains(filter)) {
                                            classesCurrentList
                                                .add(classesList[i]);
                                          }
                                        }
                                        return classesCurrentList;
                                      } else {
                                        return classesList;
                                      }
                                    },
                                    label: "class",
                                    hint: "Nom du class",
                                    // popupItemDisabled: (String s) => s.startsWith('I'),
                                    onChanged: (Classes s) {
                                      setState(() {
                                        currentStudentClass = s;
                                        getAnswers();
                                      });
                                    },
                                    selectedItem: currentStudentClass),
                              ),
                            ),
                          ],
                        ),
                        Container(
                          height: 10, 
                        ),
                        if((currentStudentClass.ID.trim() ?? '') != '') itemsHere(),
                        Container(
                          height: 20,
                        ),
                        if((currentStudentClass.ID.trim() ?? '') != '') Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            InkWell(
                              onTap: () {
                                if (currentStudentClass.ID != " ") {
                                  ReportData["ClassName"] =
                                      currentStudentClass.name;
                                  ReportData["ClassId"] =
                                      currentStudentClass.ID;
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
                                width: 150,
                                height: 45,
                                child: Center(
                                  child: Text(
                                    "Sauvgarder",
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 30),
                                  ),
                                ),
                              ),
                            ), 
                          ],
                        ),
                        Container(
                          height: 10,
                        )
                      ],
                    ),
                  ),
                ],
              ),
            )
          : Center(
              child: CircularProgressIndicator(),
            ),
    );
  }
}

class ItemView extends StatelessWidget {
  final bool multipleChoice;
  final String question;
  final String savedAnswerText;
  final String type;
  final TextEditingDynamic textEditingDynamic;
  final List<String> choices;
  final List<dynamic> savedAnswer;

  ItemView(
      {this.textEditingDynamic,
      this.multipleChoice,
      this.choices,
      this.type,
      this.question,
      this.savedAnswer,
      this.savedAnswerText});
  @override
  Widget build(BuildContext context) {
    List _MyAnswers = [];
    Widget oldChoiceWidget = new Container();

    if (type == "choices") {
      if (multipleChoice) {
        print(savedAnswer.toString());
 
        if (savedAnswer != null) {
          if (savedAnswer.length > 0) {
            String text = "Reponses: ";
            for (int i = 0; i < savedAnswer.length; i++) {
              text = text + savedAnswer[i].toString() + ", ";
            }
            oldChoiceWidget = new Text(text);
            // choices.addAll(savedAnswer.map((e) => e.toString()));
            
          }
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              question,
              style: TextStyle(color: MyColors.color1, fontSize: 25),
            ),
            Container(
              height: 5,
            ),
            oldChoiceWidget,
            Container(
              height: 5,
            ),
            
            MultiSelectFormField(
//          autovalidate: false,
              titleText: ' ',
              validator: (value) {
                if (value == null || value.length == 0) {
                  return question;
                } else {
                  return " ";
                }
              },
              initialValue: savedAnswer, 
              dataSource: [
                for (int i = 0; i < choices.length; i++)
                  {
                    "display": choices[i],
                    "value": choices[i]
                  }
              ],

              textField: 'display',
              valueField: 'value',
              okButtonLabel: 'OK',
              cancelButtonLabel: 'ANNULER',
              hintText: 'Veuillez en choisir un ou plusieurs valeurs',
              onSaved: (value) {
                if (value == null) return;
                _MyAnswers = value;

                QuestionAndAnswers questionsAndAnswersHere =
                new QuestionAndAnswers();
                questionsAndAnswersHere.question = question;
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
          ],
        );
      } else {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              question,
              style: TextStyle(color: MyColors.color1, fontSize: 25),
            ),
            Container(
              height: 10,
            ),
            Center(
                child: SingleDrop(
                    choices: choices,
                    Question: question,
                    savedText:
                        savedAnswerText == null ? choices[0] : savedAnswerText))
          ],
        );
      }
    } else {
      if (savedAnswerText != null) {
        textEditingDynamic.textEditingController.text = savedAnswerText;
      }
      if (type == "date") {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              question,
              style: TextStyle(color: MyColors.color1, fontSize: 25),
            ),
            Container(
              height: 10,
            ),
            DateRow(
                textEditingController:
                    textEditingDynamic.textEditingController),
          ],
        );
      } else {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              question,
              style: TextStyle(color: MyColors.color1, fontSize: 25),
            ),
            Container(
              height: 10,
            ),
            Container(
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(15, 0, 0, 0),
                child: TextField(
                  maxLines: 3,
                  controller: textEditingDynamic.textEditingController,
                  style: TextStyle(color: MyColors.color1, fontSize: 16),
                  decoration: InputDecoration(
                      hintText: " Reponse ...",
                      hintStyle: TextStyle(
                        color: MyColors.color1,
                        fontSize: 16,
                      ),
                      border: InputBorder.none),
                ),
              ),
            ),
          ],
        );
      }
    }
  }
}

class DateRow extends StatefulWidget {
  final TextEditingController textEditingController;
  DateRow({this.textEditingController});

  @override
  _DateRowState createState() => _DateRowState();
}

class _DateRowState extends State<DateRow> {
  DateTime selectedDate = DateTime.now();

  Future<void> _addDate(BuildContext context) async {
    DatePicker.showTimePicker(context, showTitleActions: true,
        // minTime: DateTime(2020, 1, 1, 20, 50),
        // maxTime: DateTime(2030, 6, 7, 05, 09),
        onChanged: (date) {
      print('change $date in time zone ' +
          date.timeZoneOffset.inHours.toString());
    }, onConfirm: (date) {
      String NewDate;
      // NewDate=date.toDate();
      var formatter = new DateFormat.Hm().add_jm();
      NewDate = formatter.format(date);
      setState(() {
        widget.textEditingController.text = widget.textEditingController.text +
            NewDate.split(" ")[0] +
            " " +
            NewDate.split(" ")[1] +
            "\n";
      });

      print('confirm $date');
    }, locale: LocaleType.en);
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Container(
            color: Colors.white,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(15, 0, 0, 0),
              child: TextField(
                maxLines: 4,
                // readOnly: true,
                controller: widget.textEditingController,
                style: TextStyle(color: MyColors.color1, fontSize: 16),
                decoration: InputDecoration(
                    hintText: "cliquez pour ajouter le temps",
                    hintStyle: TextStyle(
                      color: MyColors.color1,
                      fontSize: 16,
                    ),
                    border: InputBorder.none),
              ),
            ),
          ),
        ),
        InkWell(
          onTap: () {
            setState(() {
              _addDate(context);
            });
          },
          child: Container(
              width: 40,
              height: 100,
              child: Icon(
                Icons.access_time,
                size: 60,
                color: MyColors.color1,
              )),
        )
      ],
    );
  }
}

class SingleDrop extends StatefulWidget {
  String CurrentChoice;
  final String Question;
  String savedText;
  final List<String> choices;

  SingleDrop({this.choices, this.Question, this.savedText});

  @override
  _SingleDropState createState() => _SingleDropState();
}

class _SingleDropState extends State<SingleDrop> {
  dynamic _answer;
  @override
  void initState() { 
    if ((widget.savedText?.trim() ?? '') != '') {
      print("single drop is not null");
      widget.CurrentChoice = widget.savedText;
    }
    if(AllAnswerss?.firstWhere((element) => element.question == widget.Question,orElse: ()=>null) == null)

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // print(widget.savedText+"asdsadsadsadsad");
    return DropdownButton<String>(
      hint: Text("Sélectionnez élément"),
      value: _answer ?? widget.CurrentChoice,

      onChanged: (value) {
        print(AllAnswerss);
        if (AllAnswerss?.firstWhere((element) =>
        element.question == widget.Question, orElse: () => null) != null)
          AllAnswerss
              ?.firstWhere((element) => element.question == widget.Question,
              orElse: () => null)
              ?.answer = value;
        else
          AllAnswerss.add(QuestionAndAnswers()
            ..question = widget.Question
            ..answer = _answer);
        setState(() { 
          _answer = value;
        });
      },
      items: widget.choices.map((String textt) {
        return DropdownMenuItem<String>(
          value: textt,
          child: Text(textt),
        );
      }).toList(),
    );
  }
}

class Items {
  String question;
  String type;
  String AnswersText;
  TextEditingDynamic textEditingDynamic;
  ChoicesHere choicesHere;
  List<dynamic> Answers;
}

class TextEditingDynamic {
  TextEditingController textEditingController = new TextEditingController();
  String Question;
  QuestionAndAnswers questionAndAnswers;
}

class ChoicesHere {
  List<String> choices = new List<String>();
//  String Answers="";
//  String Question;
  bool MultiChoice;
  QuestionAndAnswers questionAndAnswers;

//  Map<String,String> ChoicesMap=new Map<String,String>();

}

class Classes {
  String ID;
  String name;

  Classes(this.ID, this.name);
}
