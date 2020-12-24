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
Widget widgetsList;

List<dynamic> list = new List();
  getInfo() async {
    List<Items> items2 = new List<Items>();

    await widget.dataBaseService
        .GetReportTemplateQuestions(context,'Class')
        .then((value) {
      print("--------------------lenght=" + value.documents.length.toString());
      //print("--------------------documents="+value.documents[0].documentID);
      for (int i = 0; i < value.documents.length; i++) {
        try {
          Items item = new Items();
          item.question = value.documents[i].data["Question"];
          item.type = value.documents[i].data["Type"];
          if (item.type == "choices") {
            ChoicesHere choicesHere = new ChoicesHere();
            choicesHere.questionAndAnswers = new QuestionAndAnswers();
            choicesHere.MultiChoice = value.documents[i].data["MultipleChoice"];
            List<String> TheChoices =
                List.from(value.documents[i].data["TheChoices"]);
            choicesHere.choices.addAll(TheChoices);
            item.choicesHere = choicesHere;
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
        } catch (Ex) {}
      }
      setState(() {
        items = items2;
      });
    });
  }
  //
  // getAnswersData()async{
  //     var db =await DataBaseService()
  //         .GetQuestionsOfReport(currentStudentClass.ID, getDateNow(), context);
  //     setState(() {
  //       list = db;
  //     });
  // }

  Future<void> getAnswers() async {
    for (var item in items) {
      if (item.type == "text" || item.type == "date") {
        setState(() {
          item.AnswersText = null;
        });
      } else if (item.type != "text" &&
          item.type != "date" &&
          item.choicesHere.MultiChoice) {
        setState(() {
          item.Answers = new List<dynamic>();
        });
      } else if(
      item.type != "text" &&
          item.type != "date" &&
          !item.choicesHere.MultiChoice
      ) {
        setState(() {
          item.AnswersText = null;
        });
      }
    }
    print('building answerss.....');
    if (currentStudentClass.ID != " ") {
      var db = await DataBaseService()
          .GetQuestionsOfReport(currentStudentClass.ID, getDateNow(), context,'Class');
setState(() {
  list = db;
});
      print('answersss:' + list.toString());
        if (list != []) {
          for (var listItem in list) {
            for (var item in items) {
              if (item.question == listItem.data["Question"]) {
                if (item.type == "text" || item.type == "date") {
                  setState(() {
                    item.AnswersText = listItem.data["Answer"];
                    print(listItem.data["Answer"]);
                  });
                } else if (item.type != "text" &&
                    item.type != "date" &&
                    item.choicesHere.MultiChoice) {
                  setState(() {
                    item.Answers = listItem.data["Answer"];
                    print(listItem.data["Answer"]);
                  });
                } else if (item.type != "text" &&
                    item.type != "date" &&
                    !item.choicesHere.MultiChoice) {
                  setState(() {
                    item.AnswersText = listItem.data["Answer"];
                    print(listItem.data["Answer"]);
                  });
                }
              }
            }
          }
        }
    }
  }

  Widget itemsHere() {
    print('building items.....');
    print('items in itemsHere: ' + items.toString());
    print('answers in iremsHere:  ' + list.toString());
    return Container(
        height: 500,
        child: Padding(
          padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
          child: ListView.builder(
              itemCount: items.length,
              itemBuilder: (context, index) {
                if (items[index].type == "choices") {
                  if (items[index].choicesHere.MultiChoice) {
                    return Padding(
                      padding: EdgeInsets.fromLTRB(15, 0, 15, 10),
                      child: ItemView(
                        savedAnswer: items[index].Answers,
                        question: items[index].question,
                        multipleChoice: items[index].choicesHere.MultiChoice,
                        type: items[index].type,
                        choices: items[index].choicesHere.choices,
                        itemTag: items[index],
                      ),
                    );
                  } else if (!items[index].choicesHere.MultiChoice) {
                    print('itemsHere selected item: ' + items[index].AnswersText.toString());
                    return Padding(
                      padding: EdgeInsets.fromLTRB(15, 0, 15, 10),
                      child: ItemView(
                        savedAnswerText: items[index].AnswersText,
                        question: items[index].question,
                        multipleChoice: items[index].choicesHere.MultiChoice,
                        type: items[index].type,
                        choices: items[index].choicesHere.choices,
                        itemTag: items[index],
                      ),
                    );
                  }
                } else {

                  return Padding(
                    padding: EdgeInsets.fromLTRB(15, 0, 15, 10),
                    child: ItemView(
                      savedAnswerText: items[index].AnswersText,
                      question: items[index].question,
                      type: items[index].type,
                      textEditingDynamic: items[index].textEditingDynamic,
                      itemTag: items[index],

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
    print('hereee');
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
    for (int i = 0; i < forTextQuestion.length; i++) {
      QuestionAndAnswers questionsAndAnswersHere = new QuestionAndAnswers();
      questionsAndAnswersHere.question = forTextQuestion[i].Question;
      questionsAndAnswersHere.answer =
          forTextQuestion[i].textEditingController.text;


      for (int j = 0; j < AllAnswerss.length; j++) {


        if (AllAnswerss[j].question == questionsAndAnswersHere.question) {


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
    var answers = await getTextAnswers();
      if (answers == true) {
        await widget.dataBaseService.sendReport(ReportData, AllAnswerss,
            currentStudentClass.ID, getDateNow(), context,'Class');

          widget.refresh(getDateNow());
          print("refresh");
          Navigator.pop(context);

        // Future.delayed(const Duration(seconds: 2), () {
        //
        // });

      }

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
                              "Selectionnez:",
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
                                    onChanged: (Classes s) async{
                                      setState(() {
                                        currentStudentClass = s;
                                        getAnswers();
                                      });
                                      // // print('before answer');
                                      //



                                      // // print('after answer');
                                      // setState(() {
                                      //   widgetsList = itemsHere();
                                      // });
                                    },
                                    selectedItem: currentStudentClass),
                              ),
                            ),
                          ],
                        ),
                        Container(
                          height: 10,
                        ),
                        (currentStudentClass.ID.trim() ?? '') != ''  ? itemsHere() : Container(),
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
                                width: 250,
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

class ItemView extends StatefulWidget {
  final bool multipleChoice;
  final String question;
  final String savedAnswerText;
  final String type;
  final Items itemTag;
  final TextEditingDynamic textEditingDynamic;
  final List<String> choices;
  final List<dynamic> savedAnswer;

  TextEditingDynamic controller = new TextEditingDynamic();

  ItemView({this.textEditingDynamic,
    this.multipleChoice,
    this.choices,
    this.type,
    this.question,
    this.savedAnswer,
    this.savedAnswerText,
    this.itemTag});

  @override
  _ItemViewState createState() => _ItemViewState();
}

class _ItemViewState extends State<ItemView> {


  @override
  Widget build(BuildContext context) {

    List _MyAnswers = [];
    Widget oldChoiceWidget = new Container();

    if (widget.type == "choices") {
      if (widget.multipleChoice) {
        print(widget.savedAnswer.toString());

        if (widget.savedAnswer != null) {
          if (widget.savedAnswer.length > 0) {
            String text = "Reponses: ";
            for (int i = 0; i < widget.savedAnswer.length; i++) {
              text = text + widget.savedAnswer[i].toString() + ", ";
            }
            oldChoiceWidget = new Text(text);
            // choices.addAll(savedAnswer.map((e) => e.toString()));

          }
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.question,
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
                  return widget.question;
                } else {
                  return " ";
                }
              },
              initialValue: widget.savedAnswer,
              dataSource: [
                for (int i = 0; i < widget.choices.length; i++)
                  {
                    "display": widget.choices[i],
                    "value": widget.choices[i]
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
                questionsAndAnswersHere.question = widget.question;
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
        print('in itemView selected: ' + widget.savedAnswerText.toString());
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              widget.question,
              style: TextStyle(color: MyColors.color1, fontSize: 25),
            ),
            Container(
              height: 10,
            ),
            Center(
                child: SingleDrop(
                    choices: widget.choices,
                    Question: widget.question,
                    savedText:
                        widget.savedAnswerText == null ? null: widget.savedAnswerText))
          ],
        );
      }
    } else {
      print('in texttt : ' + widget.savedAnswerText.toString());
      widget.controller.textEditingController.text = widget.savedAnswerText;
      print('controller in texttt: ' + widget.controller.textEditingController.text);
      if (widget.type == "date") {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              widget.question,
              style: TextStyle(color: MyColors.color1, fontSize: 25),
            ),
            Container(
              height: 10,
            ),
            DateRow(
              onChanged: (value){
                widget.textEditingDynamic.textEditingController.text =
                    value;
              },
                textEditingController:
                    widget.controller.textEditingController),

          ],
        );
      } else {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              widget.question,
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
                  controller: widget.controller.textEditingController,
                  style: TextStyle(color: MyColors.color1, fontSize: 16),
                  decoration: InputDecoration(
                      hintText: " Reponse ...",
                      hintStyle: TextStyle(
                        color: MyColors.color1,
                        fontSize: 16,
                      ),
                      border: InputBorder.none),
                  onChanged: (value){

                      widget.textEditingDynamic.textEditingController.text =
                      value;

                  },
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
   TextEditingController textEditingController;
   Function onChanged;
  DateRow({this.textEditingController, this.onChanged});

  @override
  _DateRowState createState() => _DateRowState();
}

class _DateRowState extends State<DateRow> {
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
  void initState() {

    super.initState();
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
                onChanged: widget.onChanged,
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
  final String savedText;
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
      print("single drop is not null -----------------------------------");
      setState(() {
        widget.CurrentChoice = widget.savedText;
      });

    }
    //if(AllAnswerss?.firstWhere((element) => element.question == widget.Question,orElse: ()=>null) == null)

    super.initState();
  }

  @override
  void didUpdateWidget(covariant SingleDrop oldWidget) {

    if(oldWidget.savedText != widget.savedText){
setState(() {
  widget.CurrentChoice = widget.savedText;
});


    }
    // if(AllAnswerss?.firstWhere((element) => element.question == widget.Question,orElse: ()=>null) == null)
    // TODO: implement didUpdateWidget
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    print('this the current choice :' + widget.CurrentChoice.toString() + ' here');
    return DropdownSearch<String>(
      //hint: Text("Sélectionnez élément"),
      // value: _answer ?? CurrentChoice,
      label:"Sélectionnez élément" ,
      selectedItem: _answer ?? widget.CurrentChoice,
      showClearButton: true,
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

      items: widget.choices,
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
  bool MultiChoice;
  QuestionAndAnswers questionAndAnswers;

}

class Classes {
  String ID;
  String name;

  Classes(this.ID, this.name);
}
