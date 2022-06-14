class CardDetails {
  String cardHolderName;
  String cardNumber;
  String expMonth;
  String expYear;
  CardDetails(
      {this.cardHolderName, this.cardNumber, this.expMonth, this.expYear});

  factory CardDetails.fromJson(Map<String, dynamic> data) => new CardDetails(
      cardHolderName: data['cardHolderName'].toString(),
      cardNumber: data['cardNumber'].toString(),
      expMonth: data['expMonth'].toString(),
      expYear: data['expYear'].toString());

  Map<String, dynamic> toJson() => {
        'cardHolderName': cardHolderName,
        'cardNumber': cardNumber,
        'expMonth': expMonth,
        'expYear': expYear,
      };
}
