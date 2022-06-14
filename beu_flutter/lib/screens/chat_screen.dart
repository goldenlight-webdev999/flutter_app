import 'dart:async';
import 'dart:convert';
import 'package:beu_flutter/api/api_service.dart';
import 'package:beu_flutter/models/user.dart';

import 'package:beu_flutter/screens/vendor/vendor_dashboard_screen.dart';
import 'package:beu_flutter/utils/colours.dart';
import 'package:beu_flutter/utils/common_utils.dart';
import 'package:beu_flutter/models/chathistory.dart' as chatModel;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:socket_io_client/socket_io_client.dart';

class ChatScreen extends StatefulWidget {
  chatUser user;
  String myUserId;
  ChatScreen({this.user, this.myUserId});
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final ScrollController _scrollController = new ScrollController();
  TextEditingController _nameController = new TextEditingController();

  bool isTyping = false;
  Socket socket;
  String myId, myProfilePic, message, myName, theirname, theirProfileimage;
  FocusNode myFocusNode;
  StreamController streamController = new StreamController<chatElement>();
  StreamController chatTypingCont = new StreamController<bool>();
  List<chatElement> chatting = new List<chatElement>();
  @override
  initState() {
    super.initState();
    _getChatHistory();
    socket = io('http://3.130.157.207:3033', <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': true,
    });
    socket.connect();
    socket.on('connect', (_) {
      print('connect');
      socket.emitWithAck('newuser',
          '{"apikey":"5ee9e0ee5561ed74d4818643","userid":"${widget.myUserId}"}',
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
      print('getusers Chats');
      print('Data: $data');
      var json = jsonDecode(data);
      print(json['_id']);
      myId = json['_id'];
      print(json['profilepic']);
      myProfilePic = json['profilepic'];
      myName = json['firstname'];
    });
    socket.on('usertyping', (data) {
      print('User Typing Data: $data');
      chatTypingCont.add(true);
    });
    socket.on('messagesent', (data) {
      print('My message Data: $data');
      var json = jsonDecode(data);
      chatting.add(new chatElement(
          mesage: json['message'],
          name: myName,
          profileImage: myProfilePic,
          me: true));

      chatTypingCont.add(false);
      streamController.add(new chatElement(
          me: true,
          mesage: json['message'],
          name: myName,
          profileImage: myProfilePic));
    });
    socket.on('newmessage', (data) {
      print('new message Data: $data');
      chatTypingCont.add(false);
      var json = jsonDecode(data);
      changeState(json);
      chatTypingCont.add(false);

      streamController.add(new chatElement(
          me: false,
          mesage: json['message'],
          name: json['senderfullname'],
          profileImage: json['senderprofilepic']));
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

  Widget _bodyWidget() {
    return Container(
      width: double.infinity,
      height: double.infinity,
      padding: EdgeInsets.only(top: 34, left: 22, right: 22),
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
          GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Icon(
                Icons.keyboard_backspace,
                color: Colors.white,
                size: 30,
              )),
          SizedBox(
            height: 8,
          ),
          Text(
            "Chat",
            style: TextStyle(
                fontSize: 32,
                color: Colors.white,
                fontFamily: 'Poppins-ExtraBold',
                letterSpacing: 0.4),
          ),
          _buildMyChatList(),
          SizedBox(
            height: 12,
          ),
          Container(
            child: StreamBuilder<bool>(
                stream: chatTypingCont.stream,
                builder: (context, snapshot) {
                  if (snapshot.hasData && snapshot.data) {
                    return Container(
                      margin: EdgeInsets.only(left: 16, bottom: 10),
                      child: Text(
                        "typing.....",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.w800),
                      ),
                    );
                  }
                  return SizedBox(
                    height: 1,
                  );
                }),
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Flexible(
                child: TextFormField(
                  focusNode: myFocusNode,
                  onChanged: (String val) {
                    if (chatting.length != 0) _toEnd();
                    socket.emit(
                      'typing',
                      '{"userid":"${myId}","recieverid":"${widget.user.sId}"}',
                    );

                    message = val;
                  },
                  onSaved: (String val) {
                    setState(() {
                      message = val;
                    });
                  },
                  controller: _nameController,
                  decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(22),
                        borderSide: BorderSide(color: Colours.welcome_bg)),
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(22),
                        borderSide: BorderSide(color: Colours.welcome_bg)),
                    fillColor: Colours.welcome_bg,
                    filled: true,
                    prefixIcon: Icon(
                      Icons.title,
                      color: Colors.white,
                    ),
                    suffixIcon: IconButton(
                        icon: Icon(
                          Icons.send,
                          color: Colors.white,
                          size: 35,
                        ),
                        onPressed: () {
                          print(widget.user.sId);
                          if (chatting.length != 0) _toEnd();
                          socket.emit('send',
                              '{"message":"${message}","recieverid":"${widget.user.sId}"}');
                          _nameController.clear();
                        }),
                    hintText: "Write here",
                    hintStyle: TextStyle(
                        color: Colors.white,
                        fontFamily: "Poppins-LightItalic",
                        fontSize: 14),
                  ),
                  style: TextStyle(
                      color: Colors.white,
                      fontFamily: "Poppins-LightItalic",
                      fontSize: 14),
                  textInputAction: TextInputAction.send,
                ),
              ),
            ],
          ),
          SizedBox(
            height: 12,
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: _bodyWidget(),
      resizeToAvoidBottomInset: true,
    );
  }

  void _toEnd() {
    // NEW
    _scrollController.animateTo(
      // NEW

      _scrollController.position.maxScrollExtent, // NEW
      duration: const Duration(milliseconds: 100), // NEW
      curve: Curves.easeIn, // NEW
    ); // NEW
  }

  Widget _buildMyChatList() {
    return StreamBuilder<chatElement>(
        stream: streamController.stream,
        builder: (context, snapshot) {
          if (chatting.length != 0) _toEnd();
          return Expanded(
            child: Container(
              height: MediaQuery.of(context).size.height,
              width: double.infinity,
              child: ListView.builder(
                  controller: _scrollController,
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  itemCount: chatting.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Container(
                        child: chatting[index].me
                            ? _myChat(chatting[index])
                            : theirChat(chatting[index]));
                  }),
            ),
          );
        });
  }

  Widget _myChat(chatElement data) {
    return Stack(
      children: <Widget>[
        Align(
          alignment: Alignment.centerRight,
          child: Container(
            padding: EdgeInsets.only(left: 12, right: 16, top: 6, bottom: 6),
            margin: EdgeInsets.only(right: 18, bottom: 8, left: 10, top: 2),
            decoration: BoxDecoration(
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.circular(12),
                color: Colors.white),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                Text(
                  data.mesage,
                  style: TextStyle(
                      color: Colors.black,
                      fontFamily: "Poppins-LightItalic",
                      fontSize: 14),
                ),
                Text(
                  "Sent",
                  style: TextStyle(
                      color: Colors.black,
                      fontFamily: "Poppins-LightItalic",
                      fontSize: 8),
                ),
              ],
            ),
          ),
        ),
        Positioned(
          right: 0,
          top: 0,
          child: Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(18),
              child: data.profileImage == null
                  ? Container(
                      height: 28,
                      width: 28,
                      color: Colors.black,
                      child: Image.asset(
                        "assets/images/man.png",
                        height: 28,
                        width: 28,
                        color: Colors.white,
                        fit: BoxFit.contain,
                      ),
                    )
                  : Image.network(
                      data.profileImage,
                      height: 36,
                      width: 36,
                      fit: BoxFit.cover,
                    ),
            ),
          ),
        ),
      ],
    );
  }

  Widget theirChat(chatElement data) {
    return Stack(
      children: <Widget>[
        Container(
          width: double.infinity,
        ),
        Container(
          padding: EdgeInsets.only(left: 16, right: 12, top: 6, bottom: 6),
          margin: EdgeInsets.only(left: 18, bottom: 8, right: 10, top: 2),
          decoration: BoxDecoration(
              shape: BoxShape.rectangle,
              borderRadius: BorderRadius.circular(12),
              color: Colors.white),
          child: Text(
            data.mesage,
            style: TextStyle(
                color: Colors.black,
                fontFamily: "Poppins-LightItalic",
                fontSize: 14),
          ),
        ),
        Positioned(
          left: 0,
          top: 0,
          child: Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: data.profileImage != null
                  ? Image.network(
                      data.profileImage,
                      height: 32,
                      width: 32,
                      fit: BoxFit.cover,
                    )
                  : Image.asset(
                      "assets/images/home_image.png",
                      height: 32,
                      width: 32,
                      fit: BoxFit.cover,
                    ),
            ),
          ),
        ),
      ],
    );
  }

  void onNavigate() {
    Navigator.of(context).pushReplacement(new PageRouteBuilder(
      maintainState: true,
      opaque: true,
      pageBuilder: (context, _, __) => new VendorDashboardScreen(),
    ));
  }

  void changeState(json) {
    chatting.add(new chatElement(
        me: false,
        mesage: json['message'],
        name: json['senderfullname'],
        profileImage: json['senderprofilepic']));
  }

  Future<void> _getChatHistory() async {
    final response =
        await ApiService().getChatHistory(widget.myUserId, widget.user.refuserid);
    if (response != null) {
      final json = jsonDecode(response.toString());
      print("JSON Data");
      print(json);
      if (json['data'] != null && json['data'].length > 0) {
        var userList = json['data'][0]['chathistory'] as List;
        setState(() {
          userList.forEach((f) {
            if (f['sender']['refuserid'] == widget.myUserId) {
              chatting.add(new chatElement(
                  me: true,
                  mesage: f['message'],
                  name: f['sender']['firstname'],
                  profileImage: f['sender']['profilepic']));
              streamController.add(new chatElement(
                  me: true,
                  mesage: f['message'],
                  name: f['sender']['firstname'],
                  profileImage: f['sender']['profilepic']));
            } else {
              chatting.add(new chatElement(
                  me: false,
                  mesage: f['message'],
                  name: f['sender']['firstname'],
                  profileImage: f['sender']['profilepic']));
              streamController.add(new chatElement(
                  me: false,
                  mesage: f['message'],
                  name: f['sender']['firstname'],
                  profileImage: f['sender']['profilepic']));
            }
          });
        });
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
  }
}
