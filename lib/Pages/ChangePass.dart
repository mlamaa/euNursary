import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:garderieeu/Colors.dart';
import 'package:garderieeu/Tools.dart';
import 'package:garderieeu/db.dart';
import 'package:garderieeu/helpers/HelperContext.dart';
import 'package:garderieeu/widgets.dart';

class ChangePass extends StatefulWidget {
  @override
  _ChangePassState createState() => _ChangePassState();
}

class _ChangePassState extends State<ChangePass> {
  DataBaseService dataBaseService = new DataBaseService();
  TextEditingController pass1Controller = new TextEditingController();
  TextEditingController pass2Controller = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: MyColors.color4,
        appBar: myAppBar(),
        body: Builder(
          builder: (BuildContext context) {
            return Column(
              children: [
                Container(
                  height: 30,
                ),
                Tools.MyInputText("MDP", pass1Controller),
                Container(
                  height: 15,
                ),
                Tools.MyInputText("Confirm MDP", pass2Controller),
                Container(
                  height: 20,
                ),
                InkWell(
                  onTap: () {
                    if (pass2Controller.text == pass1Controller.text &&
                        pass2Controller.text.length > 5) {
                      dataBaseService.ChangePassword(pass2Controller.text)
                          .then((value) {
                        Navigator.pop(context);
                      });
                    } else {
                      HelperContext.showMessage(context,
                          "Les mots de passe doivent être identiques et contenir plus de 5 lettres");
                    }
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Tools.MyButton("Changer le MDP"),
                  ),
                ),
              ],
            );
          },
        ));
  }
}
