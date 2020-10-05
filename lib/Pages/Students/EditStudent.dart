import 'package:flutter/material.dart';
import 'package:garderieeu/Tools.dart';
import 'package:garderieeu/Colors.dart';
import 'package:garderieeu/db.dart';
import 'package:garderieeu/widgets.dart';
import 'package:dropdown_search/dropdown_search.dart';


class EditStudent extends StatefulWidget {
  final String StudentId;
  final Function refresh;

  EditStudent({this.StudentId,this.refresh});

  @override
  _EditStudentState createState() => _EditStudentState();
}

class _EditStudentState extends State<EditStudent> {
  bool isAdding=false;

  DataBaseService dataBaseService = new DataBaseService();
  Map<String,String> ThisClassMap=new Map<String,String>();

  TextEditingController StudentNameeController=new TextEditingController();

  Parents CurrentParent=new Parents(" ", " ");
  Classes CurrentStudentClass=new Classes(" ", " ");
  List<Classes> classesList= new List<Classes>();



  GetOldData(){
    print(widget.StudentId);
    dataBaseService.GetSingleStudent(widget.StudentId,context).then((value){
      StudentNameeController.text=value.data["name"];
      CurrentParent.Email=value.data["parentEmail"];
      dataBaseService.GetSingleClass(value.data["class"],context).then((value2) {
        if(value2!=null){
          Classes OldClass=new Classes(value2.documentID, value2.data["ClassName"]);
          setState(() {
            CurrentStudentClass=OldClass;

          });
        }

      });

    });

  }



  EditStudentFunction() async{
    print("Adding student");
    ThisClassMap["name"]=StudentNameeController.text;
    ThisClassMap["parentEmail"]=CurrentParent.Email;
    ThisClassMap["class"]=CurrentStudentClass.ID;
    // ThisClassMap["parentEmail"]=ParentEmailController.text;
    await dataBaseService.EdittStudentTODataBase(ThisClassMap,CurrentStudentClass.ID,CurrentParent.Email,widget.StudentId,context).then((value) {
      Future.delayed(const Duration(milliseconds: 500), () {
        widget.refresh();
        print("refresh");
        Navigator.pop(context);
      });
    });
  }

  getClasses() async{
    await dataBaseService.GetClasses(context).then((values) {
      for(int i=0;i<values.documents.length;i++){
        Classes classes=new Classes(" "," ");
        classes.ID=values.documents[i].documentID;
        classes.name=values.documents[i].data["ClassName"];

        setState(() {
          classesList.add(classes);
        });
      }

    });
  }



  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getClasses();
    GetOldData();
  }

  @override
  Widget build(BuildContext context) {
    TextStyle myTextStyle=TextStyle(fontSize: 20,color: MyColors.color1,fontWeight: FontWeight.bold);
    return Scaffold(
      backgroundColor: MyColors.color4,
      appBar: myAppBar(),
      body:
      Builder(
        builder: (BuildContext context){
          return
            isAdding? Center(
              child: CircularProgressIndicator(),
            ):Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text("Student Name:",style:myTextStyle ,),
                      Container(width: 10,),
                      Tools.MyInputText("Student Name", StudentNameeController),
                    ],
                  ),
                  Container(height: 15,),

                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text("Student Class:",style:myTextStyle,),
                      Container(width: 10,),
                      Container(
                        width: 200,
                        height: 50,
                        decoration: BoxDecoration(
                          borderRadius: Tools.myBorderRadius2,
                          // color: MyColors.color1
                        ),
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(2, 0, 0, 0),
                          child:
                          DropdownSearch<Classes>(
                              mode: Mode.DIALOG,
                              showSearchBox: true,
                              // showSelectedItem: true,
                              itemAsString:(Classes s) =>s.name,
                              onFind: (String filter) async{
                                if(filter.length!=0){
                                  List<Classes> classesCurrentList=new List<Classes>();
                                  for(int i=0;i<classesList.length;i++){
                                    if(classesList[i].name.contains(filter))
                                    {
                                      classesCurrentList.add(classesList[i]);
                                    }
                                  }
                                  return classesCurrentList;
                                }else{
                                  return classesList;
                                }

                              },
                              label: "class",
                              hint: "Parent Name",
                              // popupItemDisabled: (String s) => s.startsWith('I'),
                              onChanged: (Classes s)=> CurrentStudentClass=s,
                              selectedItem: CurrentStudentClass),

                        ),
                      ),
                    ],
                  ),
                  Container(height: 15,),
                  InkWell(
                    onTap: (){
                      print(CurrentParent.name+CurrentParent.Email);
                      if(StudentNameeController.text.length>4&&CurrentParent.Email!=" "&&CurrentStudentClass.ID!=" "){
                        setState(() {
                          isAdding=true;
                        });
                        EditStudentFunction();
                      }
                      else{
                        final snackBar = SnackBar(content: Text("Student Name must be more than 2 letters, parent and class must be empty"));
                        Scaffold.of(context).showSnackBar(snackBar);
                      }
                    },
                    child: Container(
                      width: 350,
                      height: 40,
                      decoration: BoxDecoration(borderRadius: Tools.myBorderRadius2,
                          color: MyColors.color1
                      ),
                      child: Center(
                        child: Text("Edit Student",style: TextStyle(fontSize: 18,color: Colors.white),),
                      ),
                    ),
                  )
                ],),
            );
        },
      )
    );
  }
}


class Parents{
  String Email;
  String name;
  // List<String> Childs=new List<String>();
  Parents(this.Email, this.name);
}

class Classes{
  String ID;
  String name;

  Classes(this.ID, this.name);
}