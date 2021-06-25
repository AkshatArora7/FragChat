import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fragchat/helper/constants.dart';
import 'package:fragchat/helper/helperfunction.dart';
import 'package:fragchat/screens/chat.dart';
import 'package:fragchat/services/database.dart';
import 'package:fragchat/widgets/widget.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

String _myName;

class _SearchScreenState extends State<SearchScreen> {
  DatabaseMethods databaseMethods = new DatabaseMethods();

  TextEditingController searchTextEditingController =
      new TextEditingController();
  QuerySnapshot searchSnapshot;

  Widget searchList() {
    return searchSnapshot != null
        ? ListView.builder(
        itemCount: searchSnapshot.documents.length,
        shrinkWrap: true,
        itemBuilder: (context, index) {
          return searchTile(
            userName: searchSnapshot.documents[index].data["name"],
            userEmail: searchSnapshot.documents[index].data["email"],
          );
        })
        : Container();
  }

   initiateSearch() {
    databaseMethods
        .getUserByUsername(searchTextEditingController.text)
        .then((val) {
      setState(() {
        searchSnapshot = val;
      });
    });
  }

  createChatRoomAndStartConversation({String userName}){

    if(userName != Constants.myName){
      String chatRoomId = getChatRoomId(userName, Constants.myName);

      List<String> users = [userName, Constants.myName];
      Map<String, dynamic> chatRoomMap={
        "users" : users,
        "chatroomId": chatRoomId,
      };

      DatabaseMethods().createChatRoom(chatRoomId, chatRoomMap);
      Navigator.push(context, MaterialPageRoute(builder: (context)=>ConversationScreen(userName, chatRoomId)));
    }
  }

  Widget searchTile({String userName ,String userEmail})
  {
    return Container(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16),
        child: Row(
          children: <Widget>[
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  userName,
                  style: mediumTextStyle(),
                ),
                SizedBox(height: 10.0,),
                Text(
                  userEmail,
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 12.0
                  ),
                )
              ],
            ),
            Spacer(),
            InkWell(
              onTap: (){
                createChatRoomAndStartConversation(userName: userName);
              },
              child: Container(
                decoration: BoxDecoration(
                    color: Colors.deepOrange,
                    borderRadius: BorderRadius.circular(30.0)),
                padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
                child: Text("Message", style: mediumTextStyle(),),
              ),
            )
          ],
        ),
      ),
    );
  }


  getChatRoomId(String a, String b){
    if(a.substring(0,1).codeUnitAt(0)>b.substring(0,1).codeUnitAt(0)){
      return "$b\_$a";
    }else{
      return "$a\_$b";
    }
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarMain(context, Text("FragChat")),
      body: Container(
        child: Column(
          children: <Widget>[
            Container(
              color: Color(0x54FFFFFF),
              padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: TextField(
                      controller: searchTextEditingController,
                      style: TextStyle(
                        color: Colors.white,
                      ),
                      decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: "search username....",
                          hintStyle: TextStyle(
                            color: Colors.white54,
                          )),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      initiateSearch();
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
                      child: Image.asset("assets/images/search.png"),
                    ),
                  )
                ],
              ),
            ),
            searchList(),
          ],
        ),
      ),
    );
  }
}

