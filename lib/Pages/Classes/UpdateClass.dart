import 'package:flutter/material.dart';
import 'package:garderieeu/Tools.dart';
import 'package:garderieeu/Colors.dart';
import 'package:garderieeu/db.dart';
import 'package:garderieeu/widgets.dart';


class UpdateClass extends StatefulWidget {
  final String Id;
  final String name;
  final String date;
  final Function refresh;

  UpdateClass({this.date,this.name,this.Id,this.refresh});

  @override
  _UpdateClassState createState() => _UpdateClassState();
}

class _UpdateClassState extends State<UpdateClass> {
  DataBaseService dataBaseService = new DataBaseService();
  Map<String,String> ThisClassMap=new Map<String,String>();

  TextEditingController ClassNameController=new TextEditingController();
  TextEditingController ClassDateController=new TextEditingController();

  AddClass() async{
    print("Adding classss");
    ThisClassMap["ClassDate"]=ClassDateController.text;
    ThisClassMap["ClassName"]=ClassNameController.text;
    await dataBaseService.EditClassToDataBase(ThisClassMap,widget.Id,context).then((value) {
      Future.delayed(const Duration(milliseconds: 500), () {
        widget.refresh();
        print("refresh");
        Navigator.pop(context);
      });
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    ClassDateController.text=widget.date;
    ClassNameController.text=widget.name;
  }

  @override
  Widget build(BuildContext context) {
    TextStyle myTextStyle=TextStyle(fontSize: 20,color: MyColors.color1,fontWeight: FontWeight.bold);
    return Scaffold(
      backgroundColor: MyColors.color4,
      appBar: MyAppBar("title"),
      body: Builder(builder: (BuildContext context){
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Container(height: 50,),

              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text("Class Name:",style:myTextStyle ,),
                  Container(width: 30,),
                  Tools.MyInputText("Class Name", ClassNameController)
                ],
              ),
              Container(height: 10,),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text("Class Year:  ",style:myTextStyle ,),
                  Container(width: 30,),
                  Tools.MyInputText("Class Year", ClassDateController)

                ],
              ),
              Container(height: 15,),
              InkWell(
                  onTap: (){
                    if(ClassDateController.text.length>2&&ClassNameController.text.length>2){
                      AddClass();
                    }
                    else{
                      final snackBar = SnackBar(content: Text("Class Name and year must be more than 2 letters"));
                      Scaffold.of(context).showSnackBar(snackBar);
                    }
                  },
                  child: Tools.MyButton("Edit Class")
              )
            ],),
        );
      })
    );
  }
}
