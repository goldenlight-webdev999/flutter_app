import 'package:beu_flutter/models/all_service.dart';
import 'package:beu_flutter/screens/customer/customer_notifications_screen.dart';
import 'package:beu_flutter/screens/customer/select_service_screen.dart';
import 'package:beu_flutter/screens/customer/service_vendors.dart';
import 'package:beu_flutter/utils/colours.dart';
import 'package:beu_flutter/utils/strings.dart';
import 'package:beu_flutter/widgets/searchField.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fuzzy/fuzzy.dart';

class ServiceListScreen extends StatefulWidget {
  String userId;
  Data data;
  ServiceListScreen({this.userId, this.data});
  @override
  _ServiceListScreenState createState() => _ServiceListScreenState();
}

class _ServiceListScreenState extends State<ServiceListScreen> {
  final ScrollController _scrollController = ScrollController();
  TextEditingController searchController = TextEditingController();
  List<Subcategory> _subCategorySearchList = new List<Subcategory>();
  List<Innercategory> _innerCategorySearchList = new List<Innercategory>();
  String _searchText;
  bool isSearch = false;
  @override
  initState() {
    super.initState();
  }

  Widget _bodyWidget() {
    return Container(
      width: double.infinity,
      height: double.infinity,
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
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
            widget.data.serviceName,
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
            height: 12,
          ),
          if (widget.data.subcategory.length == 1) ...[
            //_buildInnerList(widget.data.subcategory[0].innercategory)
            if (!isSearch)
              _buildInnerList(widget.data.subcategory[0].innercategory)
            else
              _buildInnerList(_innerCategorySearchList)
          ],
          if (widget.data.subcategory.length != 1) ...[
            if (!isSearch)
              _buildServiceList(widget.data.subcategory)
            else
              _buildServiceList(_subCategorySearchList)
          ],
          SizedBox(
            height: 24,
          )
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

  Widget _buildInnerList(List<Innercategory> data) {
    return Expanded(
      child: Container(
        height: MediaQuery.of(context).size.height,
        width: double.infinity,
        child: Scrollbar(
          controller: _scrollController,
          child: ListView.builder(
              controller: _scrollController,
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              itemCount: data.length,
              itemBuilder: (BuildContext context, int index) {
                return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      GestureDetector(
                        onTap: () {
                          onNavigate(data[index], widget.userId);
                        },
                        child: Container(
                          decoration: BoxDecoration(
                              shape: BoxShape.rectangle,
                              borderRadius: BorderRadius.circular(24),
                              color: Colors.white),
                          alignment: Alignment.centerLeft,
                          padding: EdgeInsets.only(
                              left: 16, right: 16, top: 8, bottom: 8),
                          child: Text(
                            data[index].categoryName,
                            style: TextStyle(
                                fontSize: 16,
                                fontFamily: 'Poppins-Bold',
                                color: Colors.black45),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 14,
                      )
                    ]);
              }),
        ),
      ),
    );
  }

  Widget _buildServiceList(List<Subcategory> data) {
    return Expanded(
      child: Container(
        height: MediaQuery.of(context).size.height,
        width: double.infinity,
        child: Scrollbar(
          controller: _scrollController,
          child: ListView.builder(
              controller: _scrollController,
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              itemCount: data.length,
              itemBuilder: (BuildContext context, int index) {
                return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      GestureDetector(
                        onTap: () {
                          // * if there's only one inner category, navigate to it
                          if (data[index].innercategory.length == 1) {
                            onNavigate(
                              data[index].innercategory[0],
                              widget.userId,
                            );
                          } else {
                            _selectedServiceAlert(context, data[index]);
                          }
                        },
                        child: Container(
                          decoration: BoxDecoration(
                              shape: BoxShape.rectangle,
                              borderRadius: BorderRadius.circular(24),
                              color: Colors.white),
                          alignment: Alignment.centerLeft,
                          padding: EdgeInsets.only(
                              left: 16, right: 16, top: 8, bottom: 8),
                          child: Text(
                            data[index].categoryName,
                            style: TextStyle(
                                fontSize: 16,
                                fontFamily: 'Poppins-Bold',
                                color: Colors.black45),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 14,
                      )
                    ]);
              }),
        ),
      ),
    );
  }

  void onNavigateNotifications() {
    Navigator.of(context).push(new PageRouteBuilder(
      maintainState: true,
      opaque: true,
      pageBuilder: (context, _, __) => CustomerNotificationsScreen(),
    ));
  }

  _selectedServiceAlert(BuildContext context, Subcategory data) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
            backgroundColor: Colors.transparent,
            contentPadding: EdgeInsets.all(0),
            content: new Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height * 0.40,
                padding:
                    EdgeInsets.only(top: 12, left: 18, right: 18, bottom: 12),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(14),
                    color: Colours.welcome_bg),
                child: new Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Flexible(
                          child: RichText(
                            overflow: TextOverflow.ellipsis,
                            strutStyle: StrutStyle(fontSize: 12.0),
                            text: TextSpan(
                                style: new TextStyle(
                                    fontFamily: "Poppins-ExtraBold",
                                    color: Colors.white,
                                    fontSize: 18),
                                text: data.categoryName),
                          ),
                        ),
                        GestureDetector(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: Icon(
                              Icons.keyboard_arrow_up,
                              color: Colors.white,
                              size: 20,
                            )),
                      ],
                    ),
                    SizedBox(
                      height: 12,
                    ),
                    Flexible(
                        child: ListView.builder(
                            scrollDirection: Axis.vertical,
                            padding: const EdgeInsets.all(8),
                            itemCount: data.innercategory.length,
                            itemBuilder: (BuildContext context, int index) {
                              return Scrollbar(
                                  child: Column(children: <Widget>[
                                GestureDetector(
                                  onTap: () {
                                    onNavigate(data.innercategory[index],
                                        widget.userId);
                                  },
                                  child: Text(
                                    data.innercategory[index].categoryName,
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontFamily: 'Poppins-Light',
                                        color: Colors.white),
                                  ),
                                ),
                                Divider(
                                  color: Colors.white,
                                )
                              ]));
                            })),
                  ],
                )));
      },
    );
  }

  void onNavigate(Innercategory data, String userid) {
    Navigator.of(context).push(new PageRouteBuilder(
      maintainState: true,
      opaque: true,
      pageBuilder: (context, _, __) =>
          new ServiceVendorScreen(data: data, userid: userid),
    ));
  }

  void onNavigateSelectService() {
    Navigator.of(context).pushReplacement(new PageRouteBuilder(
      maintainState: true,
      opaque: true,
      pageBuilder: (context, _, __) => new SelectServiceScreen(),
    ));
  }

  onSearchFunctionCall(String value) {
    print(value);
    List<String> values = new List<String>();
    _innerCategorySearchList.clear();
    _subCategorySearchList.clear();
    if (value.length != 0) {
      if (widget.data.subcategory.length == 1) {
        widget.data.subcategory[0].innercategory
            .asMap()
            .forEach((index, value) {
          values.add(index.toString() + "-" + value.categoryName);
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
          print(r.item);

          _innerCategorySearchList
              .add(widget.data.subcategory[0].innercategory[index]);
        });

        setState(() {
          isSearch = true;
        });
      } else {
        widget.data.subcategory.asMap().forEach((index, value) {
          values.add(index.toString() + "-" + value.categoryName);
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
          print(r.item);

          _subCategorySearchList.add(widget.data.subcategory[index]);
        });

        setState(() {
          isSearch = true;
        });
      }
    } else {
      setState(() {
        isSearch = false;
      });
    }
  }
}
