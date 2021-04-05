// To parse this JSON data, do
//
//     final myWalletHis = myWalletHisFromMap(jsonString);

import 'dart:convert';

List<MyWalletHis> myWalletHisFromMap(String str) => List<MyWalletHis>.from(json.decode(str).map((x) => MyWalletHis.fromMap(x)));

String myWalletHisToMap(List<MyWalletHis> data) => json.encode(List<dynamic>.from(data.map((x) => x.toMap())));

class MyWalletHis {
    MyWalletHis({
        this.id,
        this.userid,
        this.name,
        this.details,
        this.amount,
        this.walletBalance,
        this.status,
        this.date,
    });

    String id;
    String userid;
    String name;
    String details;
    String amount;
    String walletBalance;
    String status;
    DateTime date;

    factory MyWalletHis.fromMap(Map<String, dynamic> json) => MyWalletHis(
        id: json["id"],
        userid: json["userid"],
        name: json["name"],
        details: json["details"],
        amount: json["amount"],
        walletBalance: json["wallet_balance"],
        status: json["status"],
        date: DateTime.parse(json["date"]),
    );

    Map<String, dynamic> toMap() => {
        "id": id,
        "userid": userid,
        "name": name,
        "details": details,
        "amount": amount,
        "wallet_balance": walletBalance,
        "status": status,
        "date": date.toIso8601String(),
    };
}
