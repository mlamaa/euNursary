import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:garderieeu/Colors.dart';
import 'package:garderieeu/Tools.dart';
import 'package:garderieeu/widgets.dart';
import 'package:garderieeu/Pages/ClassReport/Admin/EditClassReport.dart';
import 'package:garderieeu/db.dart';

class AddMultiChoice extends StatefulWidget {
  final Function refreshToAdd;
  final Function ChangeColor;

  AddMultiChoice({this.refreshToAdd, this.ChangeColor});

  @override
  _AddMultiChoiceState createState() => _AddMultiChoiceState();
}

class _AddMultiChoiceState extends State<AddMultiChoice> {
  List<String> itemsList;
  void deleteVal(int index) {
    setState(() {
      itemsList.removeAt(index);
    });
  }

  Widget createTheList() {
    if (itemsList == null || itemsList == null) itemsList = new List();

    return Expanded(
      child: ListView.separated(
        itemCount: itemsList.length,
        separatorBuilder: (context, index) => Divider(
          color: Colors.black,
        ),
        itemBuilder: (context, index) {
          final item = itemsList[index];

          return ListTile(
            //   leading: FlutterLogo(size: 30.0),
            title: Text(item),
            //   subtitle: Text(item.lastName),
            trailing: new Column(
              children: <Widget>[
                new Container(
                  child: new IconButton(
                    icon: new Icon(Icons.delete),
                    onPressed: () => deleteVal(index),
                  ),
                )
              ],
            ), //Icon(Icons.delete),// Icon(Icons.more_vert)
          );
        },
      ),
    );
  }

  final myController = TextEditingController();
  void addVal() {
    if (itemsList == null || itemsList.length == 0) itemsList = new List();
    if (myController.text == "" || itemsList.contains(myController.text))
      return;
    String val = myController.text;
    setState(() {
      itemsList.add(val);
    });
  }

  TextEditingController QuestiontextEditingController =
      new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: myAppBar(),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(height: 1.0),
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
              child: Text(
                "Enter The Question:",
                style: TextStyle(fontSize: 20, color: MyColors.color1),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(8, 10, 8, 8),
              child: TextField(
                controller: QuestiontextEditingController,
                style: TextStyle(color: MyColors.color1, fontSize: 16),
                decoration: InputDecoration(
                    hintText: " Question ...",
                    hintStyle: TextStyle(
                      color: MyColors.color1,
                      fontSize: 16,
                    ),
                    border: InputBorder.none),
              ),
            ),
            SizedBox(height: 5.0),
            Align(
              alignment: Alignment.centerLeft,
              child: Container(
                // color: Colors.red,
                child: Text("Value(s) : ",
                    style: TextStyle(fontSize: 20, color: MyColors.color1)),
              ),
            ),
            SizedBox(height: 5.0),
            TextField(
              controller: myController,
              decoration: InputDecoration(
                hintText: "Choice Value",
                suffixIcon: IconButton(
                  onPressed: () {
                    // This is not working. Exception - invalid text selection: TextSelection(baseOffset: 2, extentOffset: 2, affinity: TextAffinity.upstream, isDirectional: false)
                    //searchTextController.clear();
                    addVal();
                    String CurrentQuestion = QuestiontextEditingController.text;
                    widget.ChangeColor();

                    myController.clear();
                    QuestiontextEditingController.text = CurrentQuestion;
                  },
                  icon: Icon(Icons.add),
                ),
              ),
            ),
            createTheList(),
            SizedBox(height: 15.0),
            Material(
              elevation: 5.0,
              //borderRadius: BorderRadius.circular(30.0),
              color: MyColors.color1,
              child: MaterialButton(
                minWidth: MediaQuery.of(context).size.width,
                padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                onPressed: () {
                  // print(itemsList.length);
                  if (QuestiontextEditingController.text.length > 0 &&
                      itemsList.length > 0) {
                    ClassReportItems item = new ClassReportItems();
                    item.Question = QuestiontextEditingController.text;
                    item.Type = "choices";
                    item.isAdded = false;

                    item.MultipleChoice = true;
                    item.choicesCount = itemsList.length;
                    item.TheChoices = itemsList;
                    CreatingReportSomeInfo.CreatingReportItems.add(item);
                    widget.refreshToAdd();
                    Navigator.pop(context);
                  }
                },
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
