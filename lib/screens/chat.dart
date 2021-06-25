import 'package:flutter/material.dart';
import 'package:fragchat/helper/constants.dart';
import 'package:fragchat/helper/helperfunction.dart';
import 'package:fragchat/services/database.dart';
import 'package:fragchat/widgets/widget.dart';

class ConversationScreen extends StatefulWidget {
  final String chatUsername;
  final String chatRoomId;

  ConversationScreen(this.chatUsername, this.chatRoomId);

  @override
  _ConversationScreenState createState() => _ConversationScreenState();
}

class _ConversationScreenState extends State<ConversationScreen> {
  DatabaseMethods databaseMethods = new DatabaseMethods();
  TextEditingController messageController = new TextEditingController();

  Stream chatMessagesStream;

  Widget ChatMessageList() {
    return StreamBuilder(
        stream: chatMessagesStream,
        builder: (context, snapshot) {
          return snapshot.hasData
              ? ListView.builder(
                  itemBuilder: (context, index) {
                    return MessageTile(
                        snapshot.data.documents[index].data["message"],
                        snapshot.data.documents[index].data["sendBy"] ==
                            Constants.myName);
                  },
                  itemCount: snapshot.data.documents.length)
              : Container();
        });
  }

  sendMessage() {
    if (messageController.text.isNotEmpty) {
      Map<String, dynamic> messageMap = {
        "message": messageController.text,
        "sendBy": Constants.myName,
        "time": DateTime.now().millisecondsSinceEpoch,
      };
      databaseMethods.addConversationMessages(widget.chatRoomId, messageMap);
      messageController.text = "";
    }
  }

  @override
  void initState() {
    databaseMethods.getConversationMessages(widget.chatRoomId).then((val) {
      setState(() {
        chatMessagesStream = val;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarMain(context, Text(widget.chatUsername)),
      body: Container(
        child: Stack(
          children: <Widget>[
            ChatMessageList(),
            Container(
              alignment: Alignment.bottomCenter,
              child: Container(
                color: Color(0x54FFFFFF),
                padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: TextField(
                        controller: messageController,
                        style: TextStyle(
                          color: Colors.white,
                        ),
                        decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: "Message....",
                            hintStyle: TextStyle(
                              color: Colors.white54,
                            )),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        sendMessage();
                      },
                      borderRadius: BorderRadius.circular(40.0),
                      child: Container(
                        height: 40.0,
                        width: 40.0,
                        padding: EdgeInsets.all(10.0),
                        decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                const Color(0x36FFFFFF),
                                const Color(0x0FFFFFFF)
                              ],
                            ),
                            borderRadius: BorderRadius.circular(40.0)),
                        child: Image.asset("assets/images/send.png"),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MessageTile extends StatelessWidget {
  final String message;
  final bool isSentByMe;

  MessageTile(this.message, this.isSentByMe);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 8.0),
      padding: EdgeInsets.only(left: isSentByMe ? 0.0 : 24.0 , right: isSentByMe ? 24.0 : 0.0),
      width: MediaQuery.of(context).size.width,
      alignment: isSentByMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
        decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: isSentByMe
                  ? [const Color(0xFFFF8A65), const Color(0xFFFF7043)]
                  : [const Color(0x1AFFFFFF), const Color(0x1AFFFFFF)],
            ),
            borderRadius: isSentByMe
                ? BorderRadius.only(
                    topLeft: Radius.circular(23.0),
                    topRight: Radius.circular(23.0),
                    bottomLeft: Radius.circular(23.0),
                  )
                : BorderRadius.only(
                    topLeft: Radius.circular(23.0),
                    topRight: Radius.circular(23.0),
                    bottomRight: Radius.circular(23.0),
                  )),
        child: Text(
          message,
          style: mediumTextStyle(),
        ),
      ),
    );
  }
}
