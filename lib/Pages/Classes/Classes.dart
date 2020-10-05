import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:garderieeu/Tools.dart';
import 'package:garderieeu/Colors.dart';
import 'package:garderieeu/db.dart';
import 'package:garderieeu/widgets.dart';
import 'AddClass.dart';
import 'UpdateClass.dart';
import 'ClassStudents.dart';

class Classes extends StatefulWidget {
  @override
  _ClassesState createState() => _ClassesState();
}

class _ClassesState extends State<Classes> {
  List<SingleClassObject> ListOfClasses = new List<SingleClassObject>();
  DataBaseService dataBaseService = new DataBaseService();

  getClasses() async {
    setState(() {
      ListOfClasses = new List<SingleClassObject>();
    });
    await dataBaseService.GetClasses(context).then((value) {
      for (int i = 0; i < value.documents.length; i++) {
        SingleClassObject singleClassObject = new SingleClassObject();
        singleClassObject.ID = value.documents[i].documentID;
        singleClassObject.Name = value.documents[i].data["ClassName"];
        singleClassObject.Date = value.documents[i].data["ClassDate"];
        setState(() {
          ListOfClasses.add(singleClassObject);
        });
      }
    });
  }

  Widget items() {
    return Flexible(
      child: Padding(
        padding: EdgeInsets.fromLTRB(15, 15, 15, 5),
        child: ListView(
            // crossAxisCount: 1,
            // crossAxisSpacing: 30,
            // mainAxisSpacing:20,

            children: List.generate(ListOfClasses.length, (index) {
          return SingleClass(
            refresh: getClasses,
            context: context,
            ClassName: ListOfClasses[index].Name,
            ID: ListOfClasses[index].ID,
            Year: ListOfClasses[index].Date,
          );
        })),
      ),
    );
  }

  @override
  void initState() {
    getClasses();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColors.color4,
      appBar: myAppBar(),
      body: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: InkWell(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            new AddClass(refresh: getClasses)));
              },
              child: Container(
                height: 30,
                decoration: BoxDecoration(
                  borderRadius: Tools.myBorderRadius2,
                  color: MyColors.color1,
                ),
                child: Center(
                    child: Text(
                  "Add Class",
                  style: TextStyle(color: Colors.white, fontSize: 20),
                )),
              ),
            ),
          ),
          items(), 
        ],
      ),
    );
  }
}

class SingleClass extends StatefulWidget {
  final Function refresh;
  final String ClassName;
  final String Year;
  final String ID;
  final BuildContext context;
  SingleClass({this.ClassName, this.Year, this.ID, this.context, this.refresh});

  @override
  _SingleClassState createState() => _SingleClassState();
}

class _SingleClassState extends State<SingleClass> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 0, 0, 10),
      child: InkWell(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => new ClassStudents(
                        ClassId: widget.ID,
                      )));
        },
        child: Container(
          // height: 80,
          decoration: BoxDecoration(
              borderRadius: Tools.myBorderRadius2, color: Colors.white),

          child: Center(
            child: Column(
              children: <Widget>[
                Container(
                  height: 10,
                ),
                Text(
                  widget.ClassName,
                  style: TextStyle(
                      fontSize: 25,
                      color: MyColors.color1,
                      fontWeight: FontWeight.bold),
                ),
                Container(
                  height: 10,
                ),
                Text(
                  widget.Year,
                  style: TextStyle(fontSize: 20, color: MyColors.color1),
                ),
                Container(
                  height: 10,
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => new UpdateClass(
                                      date: widget.Year,
                                      name: widget.ClassName,
                                      Id: widget.ID,
                                      refresh: widget.refresh,
                                    )));
                      },
                      child: Container(
                          width: 35,
                          height: 35,
                          child: Icon(
                            Icons.edit,
                            color: MyColors.color1,
                            size: 30,
                          )),
                    ),
                    Container(
                      width: 20,
                    ),
                    InkWell(
                      onTap: () {
                        DataBaseService database = new DataBaseService();
                        database.DeleteClass(
                            widget.ID, widget.context, widget.refresh);
                      },
                      child: Container(
                          width: 35,
                          height: 35,
                          child: Icon(
                            Icons.delete,
                            color: MyColors.color1,
                            size: 30,
                          )),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class SingleClassObject {
  String ID;
  String Name;
  String Date;
}
