import 'package:flutter/material.dart';

import '../../Colors.dart';
import '../../Tools.dart';
import '../../db.dart';
import '../../helpers/HelperContext.dart';
import '../../multiSelect/MultiSelectFormField.dart';
import '../../widgets.dart';

class AddTeacher extends StatefulWidget {
  final Function refresh;
  AddTeacher({this.refresh});
  @override
  _AddTeacherState createState() => _AddTeacherState();
}

class _AddTeacherState extends State<AddTeacher> {
  bool isAdding = false;
  DataBaseService dataBaseService = new DataBaseService();
  Map<String, dynamic> thisClassMap = new Map<String, dynamic>();

  TextEditingController nameController = new TextEditingController();
  TextEditingController emailDateController = new TextEditingController();
  TextEditingController passDateController = new TextEditingController();
  List _myAnswers = [];
  final List<String> choicesDisplay = new List<String>();
  final List<String> choicesValue = new List<String>();

  getClasses() async {
    await dataBaseService.GetClasses(context).then((values) {
      for (int i = 0; i < values.documents.length; i++) {
        String display;
        String value;

        value = values.documents[i].documentID;
        display = values.documents[i].data["ClassName"];

        setState(() {
          choicesValue.add(value);
          choicesDisplay.add(display);
        });
      }
    });
  }

  addTeacher() async {
    print("Adding Teacher");
    thisClassMap["name"] = nameController.text;
    thisClassMap["password"] = passDateController.text;
    thisClassMap["Classes"] = _myAnswers;

    final email = emailDateController.text.contains('@')
        ? emailDateController.text
        : emailDateController.text + '@app.com';
    await dataBaseService
        .authenticateTeacher(
            thisClassMap, email, passDateController.text, context)
        .then((value) {
      Future.delayed(const Duration(milliseconds: 500), () {
        widget.refresh();
        print("refresh");
        Navigator.pop(context);
      });
    });
  }

  @override
  void initState() {
    getClasses();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    TextStyle myTextStyle = TextStyle(
        fontSize: 20, color: MyColors.color1, fontWeight: FontWeight.bold);
    return Scaffold(
        backgroundColor: MyColors.color4,
        appBar: myAppBar(),
        body: Builder(
          builder: (BuildContext context) {
            return isAdding
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          SizedBox(
                            height: 30,
                          ),
                          Text(
                            "Teacher Info",
                            style: myTextStyle,
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text(
                                "Name :",
                                style: myTextStyle,
                              ),
                              Container(
                                width: 5,
                              ),
                              Tools.MyInputText("Name", nameController,
                                  width: 230)
                            ],
                          ),
                          Container(
                            height: 10,
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text(
                                "Email/Phone :",
                                style: myTextStyle,
                              ),
                              Container(
                                width: 5,
                              ),
                              Tools.MyInputText(
                                  "Email/Phone", emailDateController,
                                  width: 230)
                            ],
                          ),
                          Container(
                            height: 10,
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text(
                                "Password :",
                                style: myTextStyle,
                              ),
                              Container(
                                width: 5,
                              ),
                              Tools.MyInputText("Password", passDateController,
                                  width: 230)
                            ],
                          ),
                          Container(
                            height: 10,
                          ),
                          MultiSelectFormField(
//          autovalidate: false,
                            titleText: ' ',
                            validator: (value) {
                              if (value == null || value.length == 0) {
                                return "Classes";
                              } else {
                                return " ";
                              }
                            },
                            dataSource: [
                              for (int i = 0; i < choicesDisplay.length; i++)
                                {
                                  "display": choicesDisplay[i],
                                  "value": choicesValue[i],
                                },
                            ],
                            textField: 'display',
                            valueField: 'value',
                            okButtonLabel: 'OK',
                            cancelButtonLabel: 'CANCEL',
                            // required: true,
                            hintText: 'Please choose one or more class',
                            onSaved: (value) {
                              if (value == null) return;
                              _myAnswers = value;
                            },
                          ),
                          Container(
                            height: 15,
                          ),
                          InkWell(
                              onTap: () {
                                // if (emailDateController.text.length <= 4) {

                                //   HelperContext.showMessage(
                                //       context, "Too Short Email");
                                // } else if (!EmailValidator.validate(
                                //     emailDateController.text)) {
                                //   HelperContext.showMessage(
                                //       context, "Email must be valid");
                                // }
                                if (nameController.text.length <= 4)
                                  HelperContext.showMessage(
                                      context, "To Short Name");
                                else if (passDateController.text.length < 6)
                                  HelperContext.showMessage(
                                      context, "To Short password");
                                else {
                                  setState(() {
                                    isAdding = true;
                                  });
                                  addTeacher();
                                }
                              },
                              child: Tools.MyButton("Add Teacher")),
                          Container(
                            height: 100,
                          )
                        ],
                      ),
                    ),
                  );
          },
        ));
  }
}
