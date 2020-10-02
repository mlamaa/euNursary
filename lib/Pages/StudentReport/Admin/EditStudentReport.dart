import 'package:flutter/cupertino.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:garderieeu/Pages/StudentReport/Admin/Create/MultiChoice.dart';
import 'package:garderieeu/Pages/StudentReport/Admin/Create/SingleChoice.dart';
import 'package:garderieeu/Pages/StudentReport/Admin/Create/TextQuestion.dart';
import 'package:garderieeu/Pages/StudentReport/Admin/Create/DateQuestion.dart';
import 'package:garderieeu/Tools.dart';
//import 'package:progress_dialog/progress_dialog.dart';
import 'package:multiselect_formfield/multiselect_formfield.dart';
import 'package:garderieeu/Colors.dart';
import 'package:garderieeu/db.dart';
import 'package:garderieeu/widgets.dart';
import 'package:garderieeu/UserInfo.dart';



class EditStudentReportAsAdmin extends StatefulWidget {
  // final List<ClassReportItems> listOfOldItems;
  // EditClassReportAsAdmin({this.listOfOldItems});

  @override
  _EditStudentReportAsAdminState createState() => _EditStudentReportAsAdminState();
}


class _EditStudentReportAsAdminState extends State<EditStudentReportAsAdmin> {
 DataBaseService dataBaseService=new DataBaseService();
 // TextEditingController  textEditingController=new TextEditingController();

  refreshFromCreate(){
    Navigator.pop(context);

    setState(() {

    });
  }

  refreshFromItem(){
    setState(() {

    });
  }



 bool MustPress=false;

 MustPressIsTrue(){
   setState(() {
     MustPress=true;
   });
 }


 Widget ItemsHere(){
    return Flexible(
        child: Padding(
          padding: EdgeInsets.fromLTRB(10, 5, 10, 5),

          child: ListView.builder(

              itemCount: CreatingStudentReportSomeInfo.CreatingStudentsReportItems.length,
              itemBuilder: (context, index){
//            print("---------------------"+items["text"]);
                  return Padding(
                    padding: EdgeInsets.fromLTRB(15, 0, 15, 10),
                    child: ItemView(
                      item: CreatingStudentReportSomeInfo.CreatingStudentsReportItems[index],
                      toRefresh: refreshFromItem,
                    ),
                  );


              }),
        ));
  }

  Future<void> popListOption(BuildContext context) {
    return showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          shape:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
          elevation: 16,
          child: Container(
            height: 400.0,
            width: 360.0,
            child: ListView(
              children: <Widget>[
                SizedBox(height: 20),
                Center(
                  child: Text(
                    "Question Type:",
                    style: TextStyle(
                        fontSize: 24,
                        color: MyColors.color1,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                SizedBox(height: 20),
                addLineInDialog("MultipleChoice", "MultipleChoiceQuestion", context),
                addLineInDialog("SingleChoice", "SingleChoiceQuestion", context),
                addLineInDialog("Text", "TextQuestion", context),
                addLineInDialog("Time", "DateQuestion", context),



//                 addLineInDialog(  "Name 4" ,   "" , context),
//                 addLineInDialog(  "Name 5" ,   "" , context),
//                 addLineInDialog(  "Name 6" ,   "", context),
              ],
            ),
          ),
        );
      },
    );
  }

  void goToCreateReport(String tag, BuildContext context) {
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      switch (tag) {
        case "MultipleChoiceQuestion":
          return AddMultiChoice(refreshToAdd: refreshFromCreate,ChangeColor: MustPressIsTrue,);

        case "SingleChoiceQuestion":
          return new AddSingleChoice(refreshToAdd: refreshFromCreate,ChangeColor: MustPressIsTrue,);

        case "TextQuestion":
          return new AddTextQuestion(refreshToAdd: refreshFromCreate,ChangeColor: MustPressIsTrue,);
        case "DateQuestion":
          return new AddDateQuestion(refreshToAdd: refreshFromCreate,ChangeColor: MustPressIsTrue,);


      }

      return new EditStudentReportAsAdmin();
    }));
  }

  Widget addLineInDialog(String displayText, String tag, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: InkWell(
        onTap: () {
          goToCreateReport(tag, context);
        },
        child: Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                  new Text(displayText),
              ],
            ),
            SizedBox(height: 12),
            Container(height: 2, color: MyColors.color1),
            SizedBox(height: 12),
          ],
        ),
      ),
    );
  }

 getOldItems()async{
    await dataBaseService.GetStudentReportTemplateQuestions(context).then((value) {

      for(int i=0;i<value.documents.length;i++){
        StudentReportItems classReportItems = new StudentReportItems();
        classReportItems.isAdded=true;
        print(value.documents[i].data["Type"]);
        if(value.documents[i].data["Type"]=="text"||value.documents[i].data["Type"]=="date"){
          classReportItems.Type=value.documents[i].data["Type"];
          classReportItems.Question=value.documents[i].data["Question"];
        }else{
          classReportItems.Type=value.documents[i].data["Type"];
          classReportItems.Question=value.documents[i].data["Question"];
          classReportItems.choicesCount=value.documents[i].data["choicesCount"];
          classReportItems.TheChoices=value.documents[i].data["TheChoices"];
          classReportItems.MultipleChoice=value.documents[i].data["MultipleChoice"];
        }
        bool mustadd=true;
          if(CreatingStudentReportSomeInfo.CreatingStudentsReportItems.length>0){
            for(int j=0;j<CreatingStudentReportSomeInfo.CreatingStudentsReportItems.length;j++)
            {
              print(CreatingStudentReportSomeInfo.CreatingStudentsReportItems==null);
              if(CreatingStudentReportSomeInfo.CreatingStudentsReportItems[j].Question==classReportItems.Question)
              {
                mustadd=false;
              }
              if(j==CreatingStudentReportSomeInfo.CreatingStudentsReportItems.length-1&&mustadd){
                setState(() {
                  CreatingStudentReportSomeInfo.CreatingStudentsReportItems.add(classReportItems);
                });
              }
            }

          }else{
            CreatingStudentReportSomeInfo.CreatingStudentsReportItems.add(classReportItems);
          }

      }
      print("++++++++++++ must return");
    });
  }



  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // CreatingReportSomeInfo.CreatingReportItems=new List<ClassReportItems>();
    getOldItems();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(" "),
      floatingActionButton: FloatingActionButton(
        onPressed: () => popListOption(
            context), //  popAddElement( context , "Choisir l'element"),
        child: Icon(Icons.add),
        backgroundColor: MyColors.color1,
      ),
      body: Builder(
        builder: (BuildContext context){
          return Stack(
            children: <Widget>[
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  // Padding(
                  //   padding: const EdgeInsets.all(8.0),
                  //   child: Container(
                  //     width: 350,
                  //     height: 50,
                  //     child: Row(
                  //       children: [
                  //         Text("report name:  ",style: TextStyle(fontSize: 17,color: MyColors.color1),),
                  //         Container(
                  //           decoration: BoxDecoration(
                  //             color: MyColors.color1,
                  //             borderRadius: Tools.myBorderRadius2
                  //           ),
                  //           width: 150,
                  //           child: TextField(
                  //             controller: textEditingController,
                  //             style: TextStyle(color: Colors.white, fontSize: 16),
                  //             decoration: InputDecoration(
                  //
                  //                 hintText: " name ...",
                  //                 hintStyle: TextStyle(
                  //                   color: Colors.white,
                  //                   fontSize: 16,
                  //                 ),
                  //                 border: InputBorder.none
                  //             ),
                  //           ),
                  //         ),
                  //       ],
                  //     ),
                  //   ),
                  // ),
                  ItemsHere(),
                  Center(
                    child: InkWell(
                      onTap: (){
                        if(CreatingStudentReportSomeInfo.CreatingStudentsReportItems.length>0){
                          print("will add");
                          dataBaseService.SendNewStudentReportTempplate(CreatingStudentReportSomeInfo.CreatingStudentsReportItems,context);
                          CreatingStudentReportSomeInfo.CreatingStudentsReportItems=new List<StudentReportItems>();
                          Navigator.pop(context);
                        }else{

                          final snackBar = SnackBar(
                            content: Container(
                              height: 30.0,
                              child: Center(
                                  child: Text(
                                    "Report must not be empty",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold),
                                    textAlign: TextAlign.center,
                                  )),
                            ),
                            duration: Duration(seconds: 2),
                            backgroundColor:MyColors.color3,
                          );
                          Scaffold.of(context).showSnackBar(snackBar);
                        }
                      },
                      child: Container(
                        width: 200,
                        height: 40,
                        decoration: BoxDecoration(
                            borderRadius: Tools.myBorderRadius2,
                            color:MustPress?MyColors.color3: MyColors.color1
                        ),
                        child: Center(child: Text("Edit Report",style: TextStyle(fontSize: 18,color: Colors.white),)),
                      ),
                    ),
                  ),
                  Container(
                    height: 10,
                  )
                ],
              ),
            ],
          );
        }
      )
    );
  }
}


class ItemView extends StatefulWidget {
  final Function ChangeColor;

  final StudentReportItems item;
  final Function toRefresh;
  ItemView({this.item,this.toRefresh,this.ChangeColor});

  @override
  _ItemViewState createState() => _ItemViewState();
}

class _ItemViewState extends State<ItemView> {
  @override
  Widget build(BuildContext context) {
    Widget Choices=Container();
    if(widget.item.Type=="choices"){
      ScrollController _controllerTwo = ScrollController();
      setState(() {
        Choices= Scrollbar(
          isAlwaysShown: true,
          controller: _controllerTwo,
          child: SingleChildScrollView(
            controller: _controllerTwo,
            child: Column(
              children:List.generate(widget.item.TheChoices.length, (index) {
                return Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Text(
                    "Choice "+(index+1).toString()+" :"+widget.item.TheChoices[index],
                    style: TextStyle(fontSize: 18,color: Colors.white),
                  ),
                );
              }),
            ),
          ),
        );
      });
    }

    if(widget.item.Type=="text"){
      return Container(
        width: 350,
        // height: 50,
        decoration: BoxDecoration(
          borderRadius: Tools.myBorderRadius,
            color: widget.item.isAdded? MyColors.color1:MyColors.color3
        ),
        child: Padding(
          padding: const EdgeInsets.all(4.0),
          child: Column(
            children: [
              Text("Type: "+widget.item.Type,style:TextStyle(fontSize: 18,color: Colors.white) ,),
              Container(height: 10,),
              Text("Question:  "+widget.item.Question,style:TextStyle(fontSize: 18,color: Colors.white) ,),
              Container(height: 5,),
              InkWell(
                  onTap: (){
                    CreatingStudentReportSomeInfo.CreatingStudentsReportItems.remove(widget.item);
                    widget.toRefresh();
                    widget.ChangeColor();

                  },
                  child: Icon(Icons.delete,size: 30,color: Colors.white,))
            ],
          )
        ),
      );
    }else if(widget.item.Type=="date"){
      return Container(
        width: 350,
        // height: 50,
        decoration: BoxDecoration(
            borderRadius: Tools.myBorderRadius,
            color: widget.item.isAdded? MyColors.color1:MyColors.color3
        ),
        child: Padding(
            padding: const EdgeInsets.all(4.0),
            child: Column(
              children: [
                Text("Type: "+widget.item.Type,style:TextStyle(fontSize: 18,color: Colors.white) ,),
                Container(height: 10,),
                Text("Question:  "+widget.item.Question,style:TextStyle(fontSize: 18,color: Colors.white) ,),
                Container(height: 5,),
                InkWell(
                    onTap: (){
                      CreatingStudentReportSomeInfo.CreatingStudentsReportItems.remove(widget.item);
                      widget.toRefresh();
                      widget.ChangeColor();

                    },
                    child: Icon(Icons.delete,size: 30,color: Colors.white,))
              ],
            )
        ),
      );
    }else if(widget.item.Type=="choices"){
        return Container(
          width: 350,
          // height: 50,
          decoration: BoxDecoration(
              borderRadius: Tools.myBorderRadius,
              color: widget.item.isAdded? MyColors.color1:MyColors.color3
          ),
          child: Padding(
              padding: const EdgeInsets.all(4.0),
              child: Column(
                children: [
                  Text("Type: "+widget.item.Type+"  MultipleChoice: "+(widget.item.MultipleChoice?"yes":"no"),style:TextStyle(fontSize: 18,color: Colors.white) ,),
                  Container(height: 10,),
                  Text("Question:  "+widget.item.Question,style:TextStyle(fontSize: 18,color: Colors.white) ,),
                  Container(height: 5,),
                  Text("Choices:",style:TextStyle(fontSize: 18,color: Colors.white) ,),
                  Container(height: 5,),
                  Container(
                    width: 300,
                      height:60,
                      child: Choices),
                  Container(height: 5,),
                  InkWell(
                      onTap: (){
                        CreatingStudentReportSomeInfo.CreatingStudentsReportItems.remove(widget.item);
                        widget.toRefresh();
                        widget.ChangeColor();

                      },
                      child: Icon(Icons.delete,size: 30,color: Colors.white,))
                ],
              )
          ),
        );


    }

  }
}




