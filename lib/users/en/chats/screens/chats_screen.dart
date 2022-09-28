import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:users_app/users/en/chats/screens/search_screen.dart';
import '../../app_localization/app_localization.dart';
import '../../global/global.dart';
import 'chat_screen.dart';

class ChatsScreen extends StatefulWidget {
  const ChatsScreen({Key? key}) : super(key: key);

  @override
  State<ChatsScreen> createState() => _ChatsScreenState();
}

class _ChatsScreenState extends State<ChatsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:
      StreamBuilder(
          stream: FirebaseFirestore.instance.collection('users').doc(fAuthUser.currentUser!.uid).collection('messages').snapshots(),
          builder: (context,AsyncSnapshot snapshot){
            if(snapshot.hasData){
              if(snapshot.data.docs.length < 1){
                return Center(
                  child: Text(AppLocalization().noChatsAvailable),
                );
              }
              return ListView.builder(
                  itemCount: snapshot.data.docs.length,
                  itemBuilder: (context,index){
                    var friendId = snapshot.data.docs[index].id;
                    var lastMsg = snapshot.data.docs[index]['last_msg'];
                    return FutureBuilder(
                      future: FirebaseFirestore.instance.collection('users').doc(friendId).get(),
                      builder: (context,AsyncSnapshot asyncSnapshot){
                        if(asyncSnapshot.hasData){
                          var friend = asyncSnapshot.data;
                          return ListTile(
                            title: Text(friend['name'], style: TextStyle(color: Colors.black, fontSize: 17),),
                            subtitle: Container(
                              child: Text("$lastMsg",style: TextStyle(color: Colors.grey, fontSize: 12),overflow: TextOverflow.ellipsis,),
                            ),
                            onTap: (){
                              Navigator.push(context, MaterialPageRoute(builder: (context)=>ChatScreen(
                                  currentUser: fAuthUser.currentUser!.uid,
                                  friendId: friend['id'],
                                  friendName: friend['name'])));
                            },
                          );
                        }
                        return LinearProgressIndicator();
                      },

                    );
                  });
            }
            return Center(child: CircularProgressIndicator(),);
          }),

      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.indigo,
        child: Icon(Icons.search),
        onPressed: (){
          Navigator.push(context, MaterialPageRoute(builder: (context)=>SearchScreen(fAuthUser.currentUser!.uid)));
        },
      ),
    );
  }
}
