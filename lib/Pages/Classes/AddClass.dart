import 'package:flutter/material.dart';
import 'package:garderieeu/Tools.dart';
import 'package:garderieeu/Colors.dart';
import 'package:garderieeu/db.dart';
import 'package:garderieeu/helpers/HelperContext.dart';
import 'package:garderieeu/widgets.dart';

class AddClass extends StatefulWidget {
  final Function refresh;
  AddClass({this.refresh});
  @override
  _AddClassState createState() => _AddClassState();
}

class _AddClassState extends State<AddClass> {
  bool isAdding = false;

  DataBaseService dataBaseService = new DataBaseService();
  Map<String, String> ThisClassMap = new Map<String, String>();

  TextEditingController ClassNameController = new TextEditingController();
  TextEditingController ClassDateController = new TextEditingController();

  AddClass() async {
    print("Adding classss");
    ThisClassMap["ClassDate"] = ClassDateController.text;
    ThisClassMap["ClassName"] = ClassNameController.text;
    await dataBaseService.AddClassToDataBase(ThisClassMap, context)
        .then((value) {
      Future.delayed(const Duration(milliseconds: 500), () {
        widget.refresh();
        print("refresh");
        Navigator.pop(context);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    TextStyle myTextStyle = TextStyle(
        fontSize: 20, color: MyColors.color1, fontWeight: FontWeight.bold);
    return Scaffold(
      backgroundColor: MyColors.color4,
      appBar: myAppBar(),
      body: Builder(builder: (BuildContext context) {
        return (isAdding
            ? Center(
                child: CircularProgressIndicator(),
              )
            : Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      height: 50,
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          "Class Name:",
                          style: myTextStyle,
                        ),
                        Container(
                          width: 30,
                        ),
                        Tools.MyInputText("Class Name", ClassNameController)
                      ],
                    ),
                    Container(
                      height: 10,
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          "Class Year:  ",
                          style: myTextStyle,
                        ),
                        Container(
                          width: 30,
                        ),
                        Tools.MyInputText("Class Date", ClassDateController)
                      ],
                    ),
                    Container(
                      height: 15,
                    ),
                    InkWell(
                      onTap: () {
                        if (ClassDateController.text.length > 2 &&
                            ClassNameController.text.length > 2) {
                          setState(() {
                            isAdding = true;
                          });
                          AddClass();
                        } else {
                          HelperContext.showMessage(context,
                              "Class Name and year must be more than 2 letters");
                        }
                      },
                      child: Tools.MyButton("Add Class"),
                    )
                  ],
                ),
              ));
      }),
    );
  }
}
