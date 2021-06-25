import 'package:flutter/material.dart';
import 'package:fragchat/helper/authenticate.dart';
import 'package:fragchat/helper/constants.dart';
import 'package:fragchat/helper/helperfunction.dart';
import 'package:fragchat/screens/chat.dart';
import 'package:fragchat/screens/search.dart';
import 'package:fragchat/services/auth.dart';
import 'package:fragchat/services/database.dart';
import 'package:fragchat/widgets/widget.dart';

class ChatRoom extends StatefulWidget {
  @override
  _ChatRoomState createState() => _ChatRoomState();
}

class _ChatRoomState extends State<ChatRoom> {
  AuthMethods authMethods = new AuthMethods();
  DatabaseMethods databaseMethods = new DatabaseMethods();

  Stream chatRoomStream;

  Widget chatRoomList() {
    return StreamBuilder(
      stream: chatRoomStream,
      builder: (context, snapshot) {
        return snapshot.hasData
            ? ListView.builder(
            itemCount: snapshot.data.documents.length,
            itemBuilder: (context, index) {
              return ChatRoomTile(snapshot
                  .data.documents[index].data["chatroomId"]
                  .toString()
                  .replaceAll("_", "")
                  .replaceAll(Constants.myName, ""),
                  snapshot.data.documents[index].data["chatroomId"]

              );
            })
            : Container();
      },
    );
  }

  @override
  void initState() {
    getUserInfo();
    super.initState();
  }

  getUserInfo() async {
    Constants.myName = await HelperFunctions.getUserNameSharedPreference();
    databaseMethods.getChatRooms(Constants.myName).then((value) {
      setState(() {
        chatRoomStream = value;
      });
    });
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("FragChat"),
        actions: <Widget>[
          //Search button===========================================================
          InkWell(
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => SearchScreen()));
            },
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Icon(Icons.search),
            ),
          ),
          //Signout button=================================================
          InkWell(
            onTap: () {
              authMethods.signOut();
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => Authenticate()));
            },
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Icon(Icons.exit_to_app),
            ),
          ),
        ],
      ),
      body: chatRoomList(),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.search),
        onPressed: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => SearchScreen()));
        },
      ),
    );
  }
}

class ChatRoomTile extends StatelessWidget {
  final String userName;
  final String chatRoomId;

  ChatRoomTile(this.userName, this.chatRoomId);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(
            builder: (context) => ConversationScreen(userName, chatRoomId)));
      },
      child: Container(
        color: Colors.black45,
        padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
        child: Row(
          children: <Widget>[
            Container(
              height: 40.0,
              width: 40.0,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                  color: Colors.deepOrange,
                  borderRadius: BorderRadius.circular(40.0)),
              child: Text(
                "${userName.substring(0, 1).toUpperCase()}",
                style: mediumTextStyle(),
              ),
            ),
            SizedBox(
              width: 8.0,
            ),
            Text(
              userName,
              style: mediumTextStyle(),
            ),
          ],
        ),
      ),
    );
  }
}
