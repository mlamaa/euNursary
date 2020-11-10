import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:garderieeu/Colors.dart';
import 'package:garderieeu/Tools.dart';
import 'package:garderieeu/db.dart';
import 'package:garderieeu/widgets.dart';

import 'AddParent.dart';
// import 'UpdateClass.dart';
import 'EditParent.dart';

class Parents extends StatefulWidget {
  @override
  _ParentsState createState() => _ParentsState();
}

class _ParentsState extends State<Parents> {

  List<SingleParentObject> listOfParents = new List<SingleParentObject>();
  DataBaseService dataBaseService = new DataBaseService();

  GetParetns() async{
    setState(() {
      listOfParents = new List<SingleParentObject>();

    });
    await dataBaseService.GetParents(context).then((value) {
      for(int i=0;i<value.documents.length;i++){
        SingleParentObject singleClassObject=new SingleParentObject();
        singleClassObject.email=value.documents[i].documentID;
        singleClassObject.name=value.documents[i].data["name"];
        singleClassObject.password=value.documents[i].data["password"];
        setState(() {
          listOfParents.add(singleClassObject);
        });
      }

    });
  }


  Widget ItemsHere(){
    return Flexible(
      child: Padding(
        padding: EdgeInsets.fromLTRB(15, 15, 15, 5),
        child: ListView(
            // crossAxisCount: 1,
            // crossAxisSpacing: 30,
            // mainAxisSpacing:20,

            children: List.generate(listOfParents.length, (index) {
              return SingleParent(
                refresh: GetParetns,
                context: context,
                email: listOfParents[index].email,
                password: listOfParents[index].password,
                name: listOfParents[index].name,
              );
            })

        ),
      ),

    );
  }




  @override
  void initState() {
    GetParetns();
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
              onTap: (){
                Navigator.push(context, MaterialPageRoute(builder: (context)=>new AddParent(refresh: GetParetns,)));
              },
              child: Container(
                height: 30,
                decoration: BoxDecoration(
                  borderRadius: Tools.myBorderRadius2,
                  color: MyColors.color1,
                ),
                child: Center(
                    child: Text(
                  "Ajout un Parent",
                  style: TextStyle(color: Colors.white, fontSize: 20),
                )),
              ),
            ),
          ),
          ItemsHere(),
          // Flexible(
          //   child: Padding(
          //     padding: const EdgeInsets.all(8.0),
          //     child: ItemsHere(),
          //   ),
          // )
        ],
      ),

    );
  }
}


class SingleParent extends StatefulWidget {
  final Function refresh;
  final String name;
  final String email;
  final String password;
  final BuildContext context;
  SingleParent({this.name,this.email,this.password,this.context,this.refresh});

  @override
  _SingleParentState createState() => _SingleParentState();
}

class _SingleParentState extends State<SingleParent> {

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 0, 0, 10),
      child: Container(
        // height: 80,
        decoration: BoxDecoration(
            borderRadius: Tools.myBorderRadius2,
            color: Colors.white
        ),

        child: Center(
          child: Column(
            children: <Widget>[
              Container(height: 10,),
              Text(widget?.name??'',style: TextStyle(fontSize:25,color:MyColors.color1,fontWeight: FontWeight.bold),),
              Container(height: 10,),
              Text(widget?.email?.split("@")[0]??'',style: TextStyle(fontSize:20,color: MyColors.color1),),
              Container(height: 10,),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  InkWell(
                    onTap: (){

                      Navigator.push(context, MaterialPageRoute(builder: (context)=>
                      new EditParent(parentEmail: widget.email,parentPassword: widget.password,parentName: widget.name,refresh: widget.refresh,)));

                    },
                    child: Container(
                        width: 35,
                        height: 35,
                        child: Icon(Icons.edit,color: MyColors.color1,size: 30,)),
                  ),
                  Container(width: 20,),
                  InkWell(
                    onTap: (){
                    DataBaseService database=new DataBaseService();
                    database.deleteParent(widget.email,widget.password, widget.context,widget.refresh);
                    },
                    child: Container(
                        width: 35,
                        height: 35,
                        child: Icon(Icons.delete,color: MyColors.color1,size: 30,)),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}

class SingleParentObject{
  String email;
  String name;
  String password;
}

