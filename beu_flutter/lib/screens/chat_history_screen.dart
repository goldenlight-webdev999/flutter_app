import 'dart:convert';

import 'package:beu_flutter/api/api_service.dart';
import 'package:beu_flutter/models/user.dart';
import 'package:beu_flutter/screens/chat_screen.dart';
import 'package:beu_flutter/utils/colours.dart';
import 'package:beu_flutter/utils/common_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:socket_io_client/socket_io_client.dart';

class ChatHistoryScreen extends StatefulWidget {
  @override
  _ChatHistoryScreenState createState() => _ChatHistoryScreenState();
}

class _ChatHistoryScreenState extends State<ChatHistoryScreen> {
  final ScrollController _scrollController = ScrollController();
  int i;
  List<int> _list = List.generate(20, (i) => i);
  List<bool> _selected = List.generate(20, (i) => false);
  List<chatUser> users;
  bool _isLoading = false;
  SharedPreferences prefs;
  String userid;
  Socket socket;

  @override
  initState() {
    super.initState();
    print('initState');
    _getSharedPrefs();
    socket = io('http://3.130.157.207:3033', <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': false,
    });
    socket.connect();
    socket.on('connect', (_) {
      print('connect');
      socket.emitWithAck(
          'newuser', '{"apikey":"5ee9e0ee5561ed74d4818643","userid":"$userid"}',
          ack: (data) {
        print('ack $data');
        if (data != null) {
          print('from server $data');
        } else {
          print("Null");
        }
      });
    });

    socket.on('getusers', (data) {
      print('getusers');
      print('Data: $data');
    });

    socket.on('disconnect', (_) {
      print('disconnect');
    });
  }

  void dispose() {
    print('dispose');
    socket.disconnect();
    super.dispose();
  }

  Future<Null> _getSharedPrefs() async {
    print("_getSharedPrefs");
    prefs = await SharedPreferences.getInstance();
    setState(() {
      userid = prefs.getString("userid");
    });

    _getAllChatUsers();
  }

  void _getAllChatUsers() async {
    print("_getAllChatUsers");
    setState(() {
      _isLoading = true;
    });
    print(userid);
    final response =
        await ApiService().getAllChatUsers(userid, "5ee9e0ee5561ed74d4818643");
    if (response != null) {
      final json = jsonDecode(response.toString());
      print("JSON Data");
      print(json);
      if (json['data'] != null && json['data'].length > 0) {
        var userList = json['data'][0]['users'] as List;
        setState(() {
          users = userList
              .map<chatUser>((json) => chatUser.fromJson(json['user']))
              .toList();
        });
        users = users.reversed.toList();
      } else {
        CommonUtils().showMessage(context, json["message"], () {
          Navigator.pop(context);
        });
      }
    } else {
      CommonUtils().showMessage(context, "Something went wrong!", () {
        Navigator.pop(context);
      });
    }
    setState(() {
      _isLoading = false;
    });
  }

  Widget _bodyWidget() {
    return Container(
      width: double.infinity,
      height: double.infinity,
      padding: EdgeInsets.only(top: 4, left: 32, right: 32),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          tileMode: TileMode.mirror,
          end: Alignment.bottomCenter,
          colors: [
            Colours.welcome_bg,
            Colours.wel_bg_gd4,
            Colours.wel_bg_gd5,
            Colours.wel_bg_gd6,
            Colours.welcome_bg_gd2
          ],
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            "Chats",
            style: TextStyle(
                fontSize: 32,
                color: Colors.white,
                fontFamily: 'Poppins-ExtraBold',
                letterSpacing: 0.4),
          ),
          _isLoading
              ? Center(
                  child:
                      CircularProgressIndicator(backgroundColor: Colors.white),
                )
              : _buildChatList(),
          SizedBox(
            height: 12,
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: _bodyWidget(),
      resizeToAvoidBottomInset: false,
    );
  }

  Widget _buildChatList() {
    return users != null && users.length > 0
        ? Expanded(
            child: Container(
              height: MediaQuery.of(context).size.height,
              width: double.infinity,
              child: Scrollbar(
                controller: _scrollController,
                child: ListView.builder(
                    controller: _scrollController,
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    itemCount: users.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            GestureDetector(
                              onTap: () {
                                onNavigate(users[index]);
                              },
                              child: Container(
                                alignment: Alignment.centerLeft,
                                padding: EdgeInsets.only(bottom: 8),
                                child: Row(
                                  children: <Widget>[
                                    Flexible(
                                      flex: 2,
                                      child: Container(
                                        width: 60,
                                        height: 60,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                        ),
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(30),
                                          child: users[index].profilepic == null
                                              ? Image.asset(
                                                  "assets/images/man.png",
                                                  height: 60,
                                                  width: 60,
                                                  fit: BoxFit.cover,
                                                )
                                              : Image.network(
                                                  users[index].profilepic,
                                                  height: 60,
                                                  width: 60,
                                                  fit: BoxFit.cover,
                                                ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 12,
                                    ),
                                    Flexible(
                                      flex: 4,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Text(
                                            users[index].firstname +
                                                    " " +
                                                    users[index].lastname ??
                                                " ",
                                            style: TextStyle(
                                                fontSize: 14,
                                                fontFamily: 'Poppins-Light',
                                                fontWeight: FontWeight.bold,
                                                color: Colors.white),
                                          ),
                                          Text(
                                            new DateFormat("MMM-dd hh:mm")
                                                .format(DateTime.tryParse(
                                                    users[index].updatedTs)),
                                            style: TextStyle(
                                                fontSize: 10,
                                                letterSpacing: 2,
                                                fontFamily: 'Poppins-Light',
                                                color: Colors.white),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Spacer(),
                                    Flexible(
                                      flex: 2,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                        children: <Widget>[
                                          // Text(
                                          //   "",
                                          //   style: TextStyle(
                                          //       fontSize: 10,
                                          //       fontFamily: 'Poppins-Light',
                                          //       color: Colors.white),
                                          // ),
                                          // Container(
                                          //   decoration: BoxDecoration(
                                          //       shape: BoxShape.circle,
                                          //       color: Colors.white),
                                          //   padding: EdgeInsets.all(6),
                                          //   child: Text(
                                          //     "3",
                                          //     style: TextStyle(
                                          //         fontSize: 8,
                                          //         fontFamily: 'Poppins-Light',
                                          //         color: Colors.blue,
                                          //         fontWeight: FontWeight.bold),
                                          //   ),
                                          // ),
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                            Divider(
                              color: Colors.white,
                            )
                          ]);
                    }),
              ),
            ),
          )
        : Text("No Data");
  }

  void onNavigate(chatUser user) {
    Navigator.of(context).push(new PageRouteBuilder(
      maintainState: true,
      opaque: true,
      pageBuilder: (context, _, __) => new ChatScreen(
        user: user,
        myUserId: userid,
      ),
    ));
  }
}
