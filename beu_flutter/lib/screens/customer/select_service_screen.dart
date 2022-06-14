import 'dart:convert';
import 'package:fuzzy/fuzzy.dart';
import 'package:beu_flutter/api/api_service.dart';
import 'package:beu_flutter/models/all_service.dart';
import 'package:beu_flutter/screens/customer/customer_notifications_screen.dart';
import 'package:beu_flutter/screens/customer/service_list_screen.dart';
import 'package:beu_flutter/utils/colours.dart';
import 'package:beu_flutter/utils/strings.dart';
import 'package:beu_flutter/widgets/searchField.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SelectServiceScreen extends StatefulWidget {
  String userId;
  SelectServiceScreen({this.userId});
  @override
  _SelectServiceScreenState createState() => _SelectServiceScreenState();
}

class _SelectServiceScreenState extends State<SelectServiceScreen> {
  List<Data> service;
  List<Data> _searchResultService = new List<Data>();
  bool isSearching = false;
  @override
  initState() {
    super.initState();
  }

  Widget _bodyWidget() {
    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.only(top: 44, left: 32, right: 32),
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
      child: SingleChildScrollView(
        child: Column(children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Icon(
                    Icons.keyboard_backspace,
                    color: Colors.white,
                    size: 30,
                  )),
              GestureDetector(
                  onTap: onNavigateNotifications,
                  child: Icon(
                    Icons.notifications_none,
                    color: Colors.white,
                    size: 24,
                  )),
            ],
          ),
          SizedBox(
            height: 16,
          ),
          Text(
            Strings.select_service,
            style: TextStyle(
                fontSize: 32,
                color: Colors.white,
                fontFamily: 'Poppins-ExtraBold',
                letterSpacing: 0.4),
          ),
          SizedBox(
            height: 12,
          ),
          Container(
            padding: EdgeInsets.all(8),
            child: SearchField(
              regularText: Strings.search,
              inputType: TextInputType.text,
              onchange: onSearchFunctionCall,
            ),
          ),
          SizedBox(
            height: 36,
          ),
          isSearching
              ? _searchResultService == null
                  ? Text("No Search Result")
                  : ServiceGridView(_searchResultService)
              : FutureBuilder<AllService>(
                  future: _getService(),
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      return Text(snapshot.error);
                    }
                    if (snapshot.hasData) {
                      service = snapshot.data.data;
                      return ServiceGridView(service);
                    }
                    return Container(
                      margin: EdgeInsets.all(8),
                      alignment: Alignment.topCenter,
                      child: CircularProgressIndicator(
                        strokeWidth: 5,
                        backgroundColor: Colors.white,
                      ),
                    );
                  }),
        ]),
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

  void onNavigate(Data data) {
    Navigator.of(context).push(new PageRouteBuilder(
      maintainState: true,
      opaque: true,
      pageBuilder: (context, _, __) =>
          new ServiceListScreen(userId: widget.userId, data: data),
    ));
  }

  void onNavigateNotifications() {
    Navigator.of(context).push(new PageRouteBuilder(
      maintainState: true,
      opaque: true,
      pageBuilder: (context, _, __) => CustomerNotificationsScreen(),
    ));
  }

  Future<AllService> _getService() async {
    final response = await ApiService().getHierarchicalServices();
    if (response != null) {
      final json = jsonDecode(response.toString());
      print("JSON Data");
      print(json['data']);
      if (json['data'] != null) {
        return Future.value(AllService.fromJson(json));
      } else {
        return Future.error(json['message']);
      }
    } else {
      return Future.error("Something went Wrong !!");
    }
  }

  Widget ServiceGridView(List<Data> data) {
    return Container(
      height: MediaQuery.of(context).size.height,
      child: GridView.builder(
          itemCount: data.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              childAspectRatio: MediaQuery.of(context).size.width /
                  MediaQuery.of(context).size.height *
                  1.2,
              mainAxisSpacing: 3),
          itemBuilder: (context, index) {
            return Container(
              height: 100,
              child: Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
                GestureDetector(
                    onTap: () {
                      onNavigate(data[index]);
                    },
                    child: CircleAvatar(
                      backgroundColor: Colors.white,
                      radius: 40,
                      child: Image.network(
                        data[index].serviceImage,
                        height: 40,
                        width: 40,
                      ),
                    )),
                SizedBox(
                  height: 10,
                ),
                Text(
                  data[index].serviceName,
                  style: TextStyle(
                      color: Colors.black,
                      fontFamily: "Poppins-Bold",
                      fontSize: 12),
                  textAlign: TextAlign.center,
                )
              ]),
            );
          }),
    );
  }

  onSearchFunctionCall(String value) {
    print(value);
    List<String> values = new List<String>();
    _searchResultService.clear();
    if (value.length != 0) {
      service.asMap().forEach((index, value) {
        values.add(index.toString() + "-" + value.serviceName);
      });
      final fuse = Fuzzy(
        values,
        options: FuzzyOptions(
          findAllMatches: true,
          tokenize: true,
          threshold: 0.5,
        ),
      );

      final result = fuse.search(value);
      result.forEach((r) {
        int index = int.parse(r.item.toString().split('-')[0]);
        _searchResultService.add(service[index]);
      });

      setState(() {
        isSearching = true;
      });
    } else {
      setState(() {
        isSearching = false;
      });
    }
  }
}
