import 'package:flutter/material.dart';
import 'package:garderieeu/helpers/HelperContext.dart';

import '../../Colors.dart';
import '../../Tools.dart';
import '../../db.dart';
import '../../widgets.dart';

class AddParent extends StatefulWidget {
  final Function refresh;
  AddParent({this.refresh});
  @override
  _AddParentState createState() => _AddParentState();
}

class _AddParentState extends State<AddParent> {
  bool isAdding = false;
  DataBaseService dataBaseService = new DataBaseService();
  Map<String, dynamic> thisClassMap = new Map<String, dynamic>();

  TextEditingController nameController = new TextEditingController();
  TextEditingController emailDateController = new TextEditingController();
  TextEditingController passDateController = new TextEditingController();

  addParentFunction(BuildContext context2) async {
    print("Adding Parent");
    thisClassMap["name"] = nameController.text;
    thisClassMap["password"] = passDateController.text;
    // await dataBaseService.addParentToDataBase(
    //   thisClassMap,
    //   emailDateController.text+"@app.com",
    //   passDateController.text,
    //   context).then((value){
    await dataBaseService.AuthenticateParent(
            thisClassMap,
            emailDateController.text + "@app.com",
            passDateController.text,
            context2)
        .then((value) {
      Future.delayed(const Duration(milliseconds: 500), () {
        widget.refresh();
        print("refresh");
        Navigator.pop(context);
      });
    });
  }

  bool isNumeric(String s) {
    if (s == null) {
      return false;
    }
    return double.parse(s, (e) => null) != null;
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
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              "Nom: ",
                              style: myTextStyle,
                            ),
                            Container(
                              width: 5,
                            ),
                            Tools.MyInputText("Nom", nameController)
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
                              "Parent Phone:",
                              style: myTextStyle,
                            ),
                            Container(
                              width: 5,
                            ),
                            Tools.MyInputText("TelePhone", emailDateController)
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
                              "MDP:  ",
                              style: myTextStyle,
                            ),
                            Container(
                              width: 5,
                            ),
                            Tools.MyInputText("MDP", passDateController)
                          ],
                        ),
                        Container(
                          height: 15,
                        ),
                        InkWell(
                            onTap: () {
                              if (emailDateController.text.length > 4 &&
                                  nameController.text.length > 4 &&
                                  passDateController.text.length > 6) {
                                if (emailDateController.text.length == 8 &&
                                    isNumeric(emailDateController.text)) {
                                  setState(() {
                                    isAdding = true;
                                  });
                                  addParentFunction(context);
                                } else {
                                  HelperContext.showMessage(context,
                                      "Le numéro de téléphone doit être composé de 8 chiffres");
                                }
                              } else {
                                HelperContext.showMessage(context,
                                    "Le nom complet du parent doit contenir plus de 4 lettres, MDP plus de 6 lettres");
                              }
                            },
                            child: Tools.MyButton("Ajouter Parent"))
                      ],
                    ),
                  );
          },
        ));
  }
}
