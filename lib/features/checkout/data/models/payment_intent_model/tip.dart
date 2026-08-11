class Tip {
  final int? amount;

  Tip({this.amount});

  factory Tip.fromJson(Map<String, dynamic> json) => Tip(
        amount: json['amount'] as int?,
      );

  Map<String, dynamic> toJson() => {
        if (amount != null) 'amount': amount,
      };
}
