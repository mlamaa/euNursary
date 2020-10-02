import 'package:flutter/material.dart';
import 'package:garderieeu/Tools.dart';
import 'package:garderieeu/Colors.dart';
import 'package:garderieeu/db.dart';
import 'package:garderieeu/widgets.dart';
import 'package:dropdown_search/dropdown_search.dart';


class AddStudent extends StatefulWidget {
  final Function refresh;
  AddStudent({this.refresh});
  @override
  _AddStudentState createState() => _AddStudentState();
}

class _AddStudentState extends State<AddStudent> {
  bool isAdding=false;

  DataBaseService dataBaseService = new DataBaseService();
  Map<String,String> ThisClassMap=new Map<String,String>();

  TextEditingController StudentNameeController=new TextEditingController();

  Parents CurrentParent=new Parents(" ", " ");
  Classes CurrentStudentClass=new Classes(" ", " ");
  List<Parents> parentsList= new List<Parents>();
  List<Classes> classesList= new List<Classes>();

  AddStudentFunction() async{
    print("Adding student");
    ThisClassMap["name"]=StudentNameeController.text;
    ThisClassMap["parentEmail"]=CurrentParent.Email;
    ThisClassMap["class"]=CurrentStudentClass.ID;
    // ThisClassMap["parentEmail"]=ParentEmailController.text;
    await dataBaseService.AddStudentTODataBase(ThisClassMap,CurrentStudentClass.ID,CurrentParent.Email,context).then((value) {

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

  getparents() async{
    await dataBaseService.GetParents(context).then((values) {
      for(int i=0;i<values.documents.length;i++){
        Parents parents=new Parents(" "," ");
        parents.Email=values.documents[i].documentID;
        parents.name=values.documents[i].data["name"];
        // parents.Childs=values.documents[i].data["Childs"];

        setState(() {
          parentsList.add(parents);
        });
      }

    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getClasses();
    getparents();
  }

  @override
  Widget build(BuildContext context) {
    TextStyle myTextStyle=TextStyle(fontSize: 20,color: MyColors.color1,fontWeight: FontWeight.bold);
    return Scaffold(
      backgroundColor: MyColors.color4,
      appBar: MyAppBar("title"),
      body:
      Builder(
        builder: (BuildContext context){
          return   isAdding? Center(
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
                    Text("Parent Email:  ",style:myTextStyle,),
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
                        DropdownSearch<Parents>(
                            mode: Mode.DIALOG,
                            showSearchBox: true,
                            // showSelectedItem: true,
                            itemAsString:(Parents p) =>p.name+" "+p.Email,
                            onFind: (String filter) async{
                              if(filter.length!=0){
                                List<Parents> parentCurrentList=new List<Parents>();
                                for(int i=0;i<parentsList.length;i++){
                                  if(parentsList[i].name.contains(filter)||parentsList[i].Email.contains(filter))
                                  {
                                    parentCurrentList.add(parentCurrentList[i]);
                                  }
                                }
                                return parentCurrentList;
                              }else{
                                return parentsList;
                              }

                            },
                            label: "parent",
                            hint: "Parent Name",
                            // popupItemDisabled: (String s) => s.startsWith('I'),
                            onChanged: (Parents p)=> CurrentParent=p,
                            selectedItem: CurrentParent),

                      ),
                    ),
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
                    if(StudentNameeController.text.length>2&&CurrentParent.name!=" "&&CurrentStudentClass.ID!=" "){
                      setState(() {
                        isAdding=true;
                      });
                      AddStudentFunction();
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
                      child: Text("Add Student",style: TextStyle(fontSize: 18,color: Colors.white),),
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