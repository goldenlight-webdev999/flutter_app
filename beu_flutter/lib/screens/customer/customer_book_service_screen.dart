import 'dart:convert';
import 'package:beu_flutter/api/api_service.dart';
import 'package:beu_flutter/models/vendor_price_list.dart';
import 'package:beu_flutter/screens/customer/customer_payment_details_screen.dart';
import 'package:beu_flutter/screens/customer/customer_service_schedular_screen.dart';
import 'package:beu_flutter/utils/colours.dart';
import 'package:beu_flutter/utils/common_utils.dart';
import 'package:beu_flutter/utils/strings.dart';
import 'package:beu_flutter/utils/validations.dart';
import 'package:beu_flutter/widgets/regularButton.dart';
import 'package:beu_flutter/widgets/regularTextField.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class BookServiceScreen extends StatefulWidget {
  String userid, vendorid, day, month, year, slotId;
  Services innercategory;
  BookServiceScreen(
      {this.userid,
      this.vendorid,
      this.day,
      this.month,
      this.year,
      this.slotId,
      this.innercategory});
  @override
  _BookServiceScreenState createState() => _BookServiceScreenState();
}

class _BookServiceScreenState extends State<BookServiceScreen> {
  TextEditingController _nameController, _phoneController, _addressController;
  String _name, _phone, _address;
  final GlobalKey<FormState> _bookingForm = GlobalKey<FormState>();

  bool _isLoading = false;
  bool _autoValidate = false;

  @override
  initState() {
    print(widget.userid);
    print(widget.vendorid);
    print(widget.day);
    print(widget.month);
    print(widget.year);
    print(widget.slotId);
    print(widget.innercategory.innercategory.image);

    super.initState();
  }

  Widget _bodyWidget() {
    return Container(
      padding: EdgeInsets.only(top: 42, left: 24, right: 24),
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
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
                Spacer(),
                GestureDetector(
                    child: Icon(
                  Icons.search,
                  color: Colors.white,
                  size: 24,
                )),
                GestureDetector(
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
            Container(
              child: Stack(
                children: <Widget>[
                  Container(
                    width: double.infinity,
                    height: 280,
                  ),
                  Container(
                    width: double.infinity,
                    height: 220,
                    margin: EdgeInsets.only(
                      top: 8,
                    ),
                    decoration: BoxDecoration(
                      shape: BoxShape.rectangle,
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: ClipRRect(
                        borderRadius: BorderRadius.circular(18),
                        child: Image.network(
                          widget.innercategory.innercategory.image,
                          fit: BoxFit.cover,
                        )),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 2,
                    left: 2,
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(18)),
                      margin: EdgeInsets.only(left: 20, right: 20),
                      padding: EdgeInsets.all(12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            widget.innercategory.innercategory.categoryName,
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 20,
                                fontFamily: 'Poppins-Bold'),
                          ),
                          SizedBox(
                            height: 4,
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
            SizedBox(
              height: 14,
            ),
            Form(
              key: _bookingForm,
              autovalidateMode: _autoValidate?AutovalidateMode.always:AutovalidateMode.disabled,
              child: Column(
                children: <Widget>[
                  Text(
                    "Fill in your details*",
                    maxLines: 3,
                    style: TextStyle(
                      color: Colors.black,
                      fontFamily: "Poppins-Bold",
                      fontSize: 18,
                    ),
                  ),
                  SizedBox(
                    height: 12,
                  ),
                  RegularTextField(
                    regularText: "Name",
                    regularTextColor: Colors.black,
                    textColor: Colors.black,
                    obsecureText: false,
                    controller: _nameController,
                    inputType: TextInputType.text,
                    validator: Validations().validateName,
                    value: (String val) {
                      _name = val;
                    },
                    underLineColorDefault: Colors.black,
                    underLineColorSelected: Colors.black,
                  ),
                  SizedBox(
                    height: 12,
                  ),
                  RegularTextField(
                    regularText: Strings.mobile,
                    regularTextColor: Colors.black,
                    textColor: Colors.black,
                    obsecureText: false,
                    controller: _phoneController,
                    inputType: TextInputType.number,
                    validator: Validations().validateMobile,
                    value: (String val) {
                      _phone = val;
                    },
                    underLineColorDefault: Colors.black,
                    underLineColorSelected: Colors.black,
                  ),
                  SizedBox(
                    height: 12,
                  ),
                  RegularTextField(
                    regularText: Strings.address,
                    regularTextColor: Colors.black,
                    textColor: Colors.black,
                    obsecureText: false,
                    controller: _addressController,
                    validator: Validations().validateAddress,
                    inputType: TextInputType.text,
                    value: (String val) {
                      _address = val;
                    },
                    underLineColorDefault: Colors.black,
                    underLineColorSelected: Colors.black,
                  ),
                  _isLoading
                      ? Center(child: CircularProgressIndicator())
                      : GestureDetector(
                          onTap: () {
                            _submit();
                          },
                          child: RegularButton(
                            regularText: Strings.bookService,
                          ),
                        )
                ],
              ),
            )
          ],
        ),
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

  void onNavigate() {
    Navigator.of(context).pushReplacement(new PageRouteBuilder(
      maintainState: true,
      opaque: true,
      pageBuilder: (context, _, __) => new ServiceSchedularScreen(),
    ));
  }

  void onNavigatePayment(var bookingId) {
    Navigator.of(context).pushReplacement(new PageRouteBuilder(
        maintainState: true,
        opaque: true,
        pageBuilder: (context, _, __) => new PaymentDetailsScreen(
              category: widget.innercategory,
              name: _name,
              phone: _phone,
              address: _address,
              bookingId: bookingId,
              userid: widget.userid,
            )));
  }

  _submit() async {
    if (_bookingForm.currentState.validate()) {
      _bookingForm.currentState.save();

      setState(() {
        _isLoading = true;
      });
      final response = await ApiService().createBooking(
          widget.userid,
          widget.vendorid,
          widget.day,
          widget.month,
          widget.year,
          widget.slotId,
          widget.innercategory.innercategory.id,
          _name,
          _phone,
          _address);
      if (response != null) {
        final json = jsonDecode(response.toString());
        print(json.toString());
        if (json['errorcode'] != null && json['errorcode'] == 0) {
          setState(() {
            _isLoading = false;
          });
          onNavigatePayment(json['data']['bookingid']);
        } else {
          setState(() {
            _isLoading = false;
          });
          CommonUtils().showMessage(context, json["message"], () {
            Navigator.pop(context);
          });
        }
      } else {
        setState(() {
          _isLoading = false;
        });
        CommonUtils().showMessage(context, "Something went Wrong", () {
          Navigator.pop(context);
        });
      }
    } else {
      setState(() {
        _autoValidate = true;
      });
    }
  }
}
