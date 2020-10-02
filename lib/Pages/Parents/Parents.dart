import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:garderieeu/Tools.dart';
import 'package:garderieeu/Colors.dart';
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

  List<SingleParentObject> ListOfParents = new List<SingleParentObject>();
  DataBaseService dataBaseService = new DataBaseService();

  GetParetns() async{
    setState(() {
      ListOfParents = new List<SingleParentObject>();

    });
    await dataBaseService.GetParents(context).then((value) {
      for(int i=0;i<value.documents.length;i++){
        SingleParentObject singleClassObject=new SingleParentObject();
        singleClassObject.Email=value.documents[i].documentID;
        singleClassObject.Name=value.documents[i].data["name"];
        setState(() {
          ListOfParents.add(singleClassObject);
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

            children: List.generate(ListOfParents.length, (index) {
              return SingleParent(
                refresh: GetParetns,
                context: context,
                Email: ListOfParents[index].Email,
                Name: ListOfParents[index].Name,
              );
            })

        ),
      ),

    );
  }




  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    GetParetns();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColors.color4,
      appBar: MyAppBar(" "),
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
                    child: Text("Add Parent",style: TextStyle(color: Colors.white,fontSize: 20),)
                ),
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
  final String Name;
  final String Email;
  final BuildContext context;
  SingleParent({this.Name,this.Email,this.context,this.refresh});

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
              Text(widget.Name,style: TextStyle(fontSize:25,color:MyColors.color1,fontWeight: FontWeight.bold),),
              Container(height: 10,),
              Text(widget.Email.split("@")[0],style: TextStyle(fontSize:20,color: MyColors.color1),),
              Container(height: 10,),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  InkWell(
                    onTap: (){

                      Navigator.push(context, MaterialPageRoute(builder: (context)=>
                      new EditParent(ParentEmail: widget.Email,ParentName: widget.Name,refresh: widget.refresh,)));

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
                    database.DeleteParent(widget.Email, widget.context,widget.refresh);
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
  String Email;
  String Name;

}

