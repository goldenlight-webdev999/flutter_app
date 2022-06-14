import 'package:beu_flutter/utils/strings.dart';

class Validations {
  String password;
  String validateExpMonth(String value) {
    Pattern pattern = r'^(0?[1-9]|1[012])$';
    RegExp regex = new RegExp(pattern);
    if (value.isEmpty)
      return Strings.expEmpty;
    else if (!regex.hasMatch(value))
      return Strings.expMonthValid;
    else
      return null;
  }

  String validateExpYear(String value) {
    Pattern pattern = r'^(20[0-9][0-9])$';
    RegExp regex = new RegExp(pattern);
    if (value.isEmpty)
      return Strings.expEmpty;
    else if (!regex.hasMatch(value))
      return Strings.expYearValid;
    else
      return null;
  }

  String validateName(String value) {
    if (value.isEmpty)
      return Strings.nameEmpty;
    else if (value.length < 3)
      return Strings.nameValidation;
    else
      return null;
  }

  String validateCommon(String value) {
    if (value.isEmpty)
      return "Please enter the details";
    else
      return null;
  }

  String validateCompanyName(String value) {
    if (value.isEmpty)
      return Strings.companyNameEmpty;
    else if (value.length < 3)
      return Strings.companyNameValidation;
    else
      return null;
  }

  String validateAddress(String value) {
    if (value.isEmpty)
      return Strings.addressEmpty;
    else
      return null;
  }

  String validateMobile(String value) {
    if (value.length != 10)
      return 'Mobile number must be of 10 digit!';
    else
      return null;
  }

  String validateEmail(String value) {
    Pattern pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = new RegExp(pattern);
    if (value.isEmpty)
      return Strings.emailEmpty;
    else if (!regex.hasMatch(value))
      return Strings.emailValid;
    else
      return null;
  }

  String validatePassword(String value) {
    password = value;
    print(password);
    if (value.isEmpty)
      return Strings.passEmpty;
    else if (value.length < 6)
      return Strings.passvalid;
    else {
      return null;
    }
  }

  String validateConfirmPassword(String value) {
    print(password);
    if (value.isEmpty)
      return Strings.cfPassEmpty;
    else if (value.length < 6)
      return Strings.passvalid;
    else
      return null;
  }

  String validateCard(String value) {
    Pattern pattern =
        r'^(?:4[0-9]{12}(?:[0-9]{3})?|[25][1-7][0-9]{14}|6(?:011|5[0-9][0-9])[0-9]{12}|3[47][0-9]{13}|3(?:0[0-5]|[68][0-9])[0-9]{11}|(?:2131|1800|35\d{3})\d{11})$';
    RegExp regex = new RegExp(pattern);
    if (value.isEmpty)
      return Strings.cardEmpty;
    else if (!regex.hasMatch(value))
      return Strings.cardValid;
    else
      return null;
  }

  String validateExpDate(String value) {
    Pattern pattern =
        r'^(0[1-9]|1[0-2]|[1-9])\/(1[4-9]|[2-9][0-9]|20[1-9][1-9])$';
    RegExp regex = new RegExp(pattern);
    if (value.isEmpty)
      return Strings.expEmpty;
    else if (!regex.hasMatch(value))
      return Strings.expValid;
    else
      return null;
  }

  String validateCvv(String value) {
    Pattern pattern = r'^[0-9]{3}$';
    RegExp regex = new RegExp(pattern);
    if (value.isEmpty)
      return Strings.cvvEmpty;
    else if (!regex.hasMatch(value))
      return Strings.cvvValid;
    else
      return null;
  }

  String validateOtp(String value) {
    if (value.isEmpty)
      return "OTP cannot be empty";
    else if (value.length < 4)
      return "OTP should not be less than 4 character";
    else if (value.length > 4)
      return "OTP should not be more than 4 character";
    else {
      return null;
    }
  }
}
