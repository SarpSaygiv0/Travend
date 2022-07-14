import 'package:bubble/bubble.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:travend/models/message.dart';
import 'package:travend/pages/main.dart';

class MessagingPage extends StatefulWidget {
  const MessagingPage({Key? key}) : super(key: key);

  @override
  _MessagingPageState createState() => _MessagingPageState();
}

class _MessagingPageState extends State<MessagingPage> {
  var messageField = TextEditingController();

  @override
  Widget build(BuildContext context) {
    List<Message> messages = [
      Message(message: "Message text here", fromOtherPerson: true),
      Message(message: "Message text here", fromOtherPerson: false),
      Message(message: "Message text here", fromOtherPerson: true),
      Message(message: "Message text here", fromOtherPerson: false),
      Message(message: "Message text here", fromOtherPerson: true),
      Message(message: "Message text here", fromOtherPerson: false),
      Message(message: "Message text here", fromOtherPerson: true),
      Message(message: "Message text here", fromOtherPerson: false),
      Message(message: "Message text here", fromOtherPerson: false),
      Message(message: "Message text here", fromOtherPerson: false),
      Message(message: "Message text here", fromOtherPerson: true),
      Message(message: "Message text here", fromOtherPerson: false),
      Message(message: "Message text here", fromOtherPerson: false),
      Message(message: "Message text here", fromOtherPerson: true),
      Message(message: "LastMessage text here", fromOtherPerson: true),
    ];
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      appBar: AppBar(
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.blueAccent,),
            onPressed: () {
              FirebaseAuth.instance.signOut();
              Navigator.of(context).pushReplacement(MaterialPageRoute(
                builder: (context) => const HomePage(),
              ));
            },
          )
        ],
        elevation: 0,
        brightness: Brightness.light,
        backgroundColor: Colors.white,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.arrow_back_ios,
            size: 20,
            color: Colors.black,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Container(
          height: MediaQuery.of(context).size.height,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: <Widget>[
                      ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: messages.length,
                          itemBuilder: (BuildContext context, int index) {
                            return Padding(
                                padding: EdgeInsets.all(8),
                                child: messages[index].fromOtherPerson
                                    ? Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: <Widget>[
                                      CircleAvatar(
                                        radius: 24, // Image radius
                                        backgroundImage: NetworkImage(
                                            'https://picsum.photos/200'),
                                        backgroundColor:
                                        Colors.transparent,
                                      ),
                                      Bubble(
                                          margin:
                                          BubbleEdges.only(top: 0),
                                          nip: BubbleNip.leftTop,
                                          color: Color.fromRGBO(
                                              140, 200, 255, 1.0),
                                          child: Padding(
                                            padding: EdgeInsets.all(4),
                                            child: Text(
                                              messages[index].message,
                                              style: TextStyle(
                                                  fontSize: 12,
                                                  fontWeight:
                                                  FontWeight.w900,
                                                  color: Colors.white),
                                            ),
                                          )),
                                    ])
                                    : Row(mainAxisAlignment: MainAxisAlignment.end,
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: <Widget>[
                                      Bubble(
                                          margin:
                                          BubbleEdges.only(top: 0),
                                          nip: BubbleNip.rightTop,
                                          color: Color.fromRGBO(
                                              212, 234, 244, 1.0),
                                          child: Padding(
                                            padding: EdgeInsets.all(4),
                                            child: Text(
                                              messages[index].message,
                                              style: TextStyle(
                                                  fontSize: 12,
                                                  fontWeight:
                                                  FontWeight.w900,
                                                  color: Colors.grey),
                                            ),
                                          )),
                                      CircleAvatar(
                                        radius: 24, // Image radius
                                        backgroundImage: NetworkImage(
                                            'https://picsum.photos/200'),
                                        backgroundColor:
                                        Colors.transparent,
                                      ),
                                    ]));
                          }),
                    ],
                  ),
                ),
              ),
              Row(
                children: <Widget>[
                  Expanded(
                    child: Container(
                      child: TextField(
                        controller: messageField,
                        obscureText: false,
                        decoration: InputDecoration(
                          contentPadding:
                          const EdgeInsets.symmetric(vertical: 0, horizontal: 10),
                          enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                              borderSide: const BorderSide(color: Colors.grey)),
                          border: const OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.grey)),
                        ),
                      ),
                    ),
                  ),
                  MaterialButton(
                    minWidth: 48,
                    height: 48,
                    onPressed: () {
                      messageField.text = "";
                      setState(() => messages.add(Message(
                          message: messageField.text, fromOtherPerson: false)));
                    },
                    color: Colors.greenAccent,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50)),
                    child: const Text(">",
                      style:
                      TextStyle(fontWeight: FontWeight.w600, fontSize: 24),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
