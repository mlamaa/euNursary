import 'package:flutter/material.dart';
import 'Colors.dart';

class Tools {
  static Color myBlue = Color(0xff01A0C7);
  // static Color myRed = Color(0xff01A0C7);

  static TextStyle myTextStyle = TextStyle(fontFamily: 'Montserrat', fontSize: 20.0);

  static BorderRadius myBorderRadius = new BorderRadius.only(
    topLeft: const Radius.circular(30.0),
    topRight: const Radius.circular(5.0),
    bottomLeft:const Radius.circular(5.0),
    bottomRight: const Radius.circular(30.0),
  );
  static BorderRadius myBorderRadius2 = new BorderRadius.only(
    topLeft: const Radius.circular(5.0),
    topRight: const Radius.circular(5.0),
    bottomLeft:const Radius.circular(5.0),
    bottomRight: const Radius.circular(5.0),
  );

  static Widget MyInputText(String Text,TextEditingController textEditingController){
    return Container(
      decoration: BoxDecoration(
        borderRadius: Tools.myBorderRadius2,
        color: Colors.white,
      ),
      width: 200,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(15, 0, 0, 0),
        child: TextField(
          controller: textEditingController,
          style: TextStyle(color: MyColors.color1, fontSize: 16),
          decoration: InputDecoration(

              hintText: Text,
              hintStyle: TextStyle(
                color: MyColors.color1,
                fontSize: 16,
              ),
              border: InputBorder.none,
          ),
        ),
      ),
    );
  }

  static Widget MyButton(String text){
    return Container(
      height: 45.0,
      // width: 200.0,
      decoration: BoxDecoration(
        borderRadius: Tools.myBorderRadius2,
        color: MyColors.color1,
      ),
      child: Center(
        child: Text(
          text,
          style: TextStyle(
            color: Colors.white,
            fontSize: 20.0,
            fontFamily: "Karla",
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

    );
  }


  static String getQuestionTypeString(String type)
  {

    switch(type)
    {
      case "RadioButtonQuestion" :
        return type;


      case "CheckBoxQuestion" :
        return type;


      case "ComboBoxQuestion" :
        return type;

      case "TextQuestion" :
        return type;

    }
    return "";
  }



  static List<String> mapListToListString(List<dynamic> x)
  {
    List<String> listString = new List();
    if(x == null || x.length == 0 ) return listString;

    for (int i = 0 ; i < x.length ; i++)
      listString.add(x[i].toString());

    return listString;
  }


  static bool mapToLocked( dynamic x)
  {
    bool locked  = false;
    if( x != null )
      locked = x;
    return locked;
  }



}