import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:garderieeu/Tools.dart';
import 'package:garderieeu/Colors.dart';
import 'package:garderieeu/UserInfo.dart';
import 'package:garderieeu/db.dart';
import 'package:garderieeu/widgets.dart'; 

class RecieveMessages extends StatefulWidget {
  @override
  _RecieveMessagesState createState() => _RecieveMessagesState();
}

class _RecieveMessagesState extends State<RecieveMessages> {
  DataBaseService dataBaseService = new DataBaseService();
  List<MessageClass> messagesList = new List<MessageClass>();

  getMessages() {
    dataBaseService.getMessages(UserCurrentInfo.email, context).then((value) {
      for (int i = 0; i < value.documents.length; i++) {
        MessageClass messageClass = new MessageClass();
        messageClass.ID = value.documents[i].documentID;
        messageClass.Message = value.documents[i].data["message"];
        messageClass.Title = value.documents[i].data["title"];
        setState(() {
          messagesList.add(messageClass);
        });
      }
    });
  }

  Widget ItemsHere() {
    return Flexible(
      child: Padding(
        padding: EdgeInsets.fromLTRB(15, 15, 15, 5),
        child: ListView(
            // crossAxisCount: 1,
            // crossAxisSpacing: 30,
            // mainAxisSpacing:20,

            children: List.generate(messagesList.length, (index) {
          return SingleMessage(
            Title: messagesList[index].Title,
            Message: messagesList[index].Message,
          );
        })),
      ),
    );
  }

  @override
  void initState() { 
    getMessages();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColors.color4,
      appBar: myAppBar(),
      body: Column(
        children: [ItemsHere()],
      ),
    );
  }
}

class SingleMessage extends StatefulWidget {
  final String Title;
  final String Message;

  SingleMessage({this.Title, this.Message});

  @override
  _SingleMessageState createState() => _SingleMessageState();
}

class _SingleMessageState extends State<SingleMessage> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 0, 0, 10),
      child: Container(
        // height: 80,
        decoration: BoxDecoration(
            borderRadius: Tools.myBorderRadius2, color: Colors.white),

        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Container(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  widget.Title,
                  style: TextStyle(
                      fontSize: 30,
                      color: MyColors.color1,
                      fontWeight: FontWeight.bold),
                ),
              ),
              Container(
                height: 5,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  widget.Message,
                  style: TextStyle(fontSize: 20, color: MyColors.color1),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class MessageClass {
  String Title;
  String Message;
  String ID;
}
