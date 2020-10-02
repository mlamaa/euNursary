
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'Colors.dart';
import 'package:multiselect_formfield/multiselect_formfield.dart';





Widget MyAppBar(String title){

  Widget NewWidget=Container();

  return AppBar(
//    automaticallyImplyLeading: false,
    centerTitle: true,
    title:
        Container(
          width: 150,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
               Container(
//                   width: 20,
                   height: 30,
                  // child: Image.asset("assets/logos/wlogo.png")),
                child:Text("Nursery",style: TextStyle(fontSize: 25,color: Colors.white,fontStyle: FontStyle.normal,fontWeight: FontWeight.w900),) ,)
//
            ],
          ),
        ),

      actions: <Widget>[
        NewWidget,
      ],

    backgroundColor: MyColors.color1,
    elevation: 0.0,
  );
}





//
// Widget MyAppDrawer(BuildContext context){
//   return Container(
//     width: 250,
//     child: Drawer(
//
//       child: Container(
//         color: MyColors.drawer,
//         child: ListView(
//           children: <Widget>[
//
// //          SizedBox(height: 5,),
//             Container(
//               height: 100,
//               color: MyColors.color1,
//               child: Center(
//                 child: Container(
//                   width: 150,
//                   child: Padding(
//                       padding: EdgeInsets.fromLTRB(5, 0, 5, 5),
//                       child: Image.asset("assets/logos/wlogo.png")),
//                 ),
//               ),
//             ),
//             Divider(),
//
//             SizedBox(height: 5,),
//             InkWell(
//               onTap: (
//
//                   ){
//               // Navigator.push(context, MaterialPageRoute(builder: (context)=>new SomeInfoDialog()));
//               },
//               child: Padding(
//                 padding: const EdgeInsets.all(2.0),
//                 child: ListTile(
//                   leading:Icon(Icons.chat_bubble_outline,color: MyColors.color1,size: 22,),
//                   title: Text("fffffffff",style: TextStyle(color:MyColors.color1,fontSize: 18 ),),
//                 ),
//               ),
//             ),
//
//             SizedBox(height: 5,),
//             InkWell(
//               onTap: (
//
//                   ){
//               // Navigator.push(context, MaterialPageRoute(builder: (context)=>new YouthInfo()));
//               },
//               child: Padding(
//                 padding: const EdgeInsets.all(2.0),
//                 child: ListTile(
//                   leading:Icon(Icons.perm_phone_msg,color: MyColors.color1,size: 22,),
//                   title: Text("tttttt",style: TextStyle(color:MyColors.color1,fontSize: 18 ),),
//                 ),
//               ),
//             ),
//
//             SizedBox(height: 5,),
//             InkWell(
//               onTap: (
//
//                   ){
//               // Navigator.push(context, MaterialPageRoute(builder: (context)=>new AboutApp()));
//               },
//               child: Padding(
//                 padding: const EdgeInsets.all(2.0),
//                 child: ListTile(
//                   leading:Icon(Icons.touch_app,color: MyColors.color1,size: 22,),
//                   title: Text("jjjjjj",style: TextStyle(color:MyColors.color1,fontSize: 18 ),),
//                 ),
//               ),
//             ),
//
//             SizedBox(height: 5,),
//             InkWell(
//               onTap: (
//
//                   ){
//               // Navigator.push(context, MaterialPageRoute(builder: (context)=>new ContactsUs()));
//               },
//               child: Padding(
//                 padding: const EdgeInsets.all(2.0),
//                 child: ListTile(
//                   leading:Icon(Icons.event_note,color: MyColors.color1,size: 22,),
//                   title: Text("lllllllllll",style: TextStyle(color:MyColors.color1,fontSize: 18 ),),
//                 ),
//               ),
//             ),
//
//             Divider(),
//
//
//
//           ],
//         ),
//       ),
//     ),
//   );
//
//
// }


//
//
//
// _launchURL(String fbORinsta) async {
//   String url = fbORinsta;
//   if (await canLaunch(url)) {
//     await launch(url);
//   } else {
//     throw 'Could not launch $url';
//   }}

