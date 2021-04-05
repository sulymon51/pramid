// To parse this JSON data, do
//
//     final profileAcc = profileAccFromJson(jsonString);

import 'dart:convert';

List<ProfileAcc> profileAccFromJson(String str) => List<ProfileAcc>.from(json.decode(str).map((x) => ProfileAcc.fromMap(x)));

String profileAccToJson(List<ProfileAcc> data) => json.encode(List<dynamic>.from(data.map((x) => x.toMap())));

class ProfileAcc {
    String id;
    String fullname;
    String email;
    String password;
    String gender;
    String state;
    String address;
    String image;
    String phone;
    String wallet;
    String height;
    String weight;
    String medcondition;
    String othermedcondition;
    String yousmoke;
    String youpregnant;
    String status;

    ProfileAcc({
        this.id,
        this.fullname,
        this.email,
        this.password,
        this.gender,
        this.state,
        this.address,
        this.image,
        this.phone,
        this.wallet,
        this.height,
        this.weight,
        this.medcondition,
        this.othermedcondition,
        this.yousmoke,
        this.youpregnant,
        this.status,
    });

    factory ProfileAcc.fromMap(Map<String, dynamic> json) => ProfileAcc(
        id: json["id"],
        fullname: json["fullname"],
        email: json["email"],
        password: json["password"],
        gender: json["gender"],
        state: json["state"],
        address: json["address"],
        image: json["image"],
        phone: json["phone"],
        wallet: json["wallet"],
        height: json["height"],
        weight: json["weight"],
        medcondition: json["medcondition"],
        othermedcondition: json["othermedcondition"],
        yousmoke: json["yousmoke"],
        youpregnant: json["youpregnant"],
        status: json["status"],
    );

    Map<String, dynamic> toMap() => {
        "id": id,
        "fullname": fullname,
        "email": email,
        "password": password,
        "gender": gender,
        "state": state,
        "address": address,
        "image": image,
        "phone": phone,
        "wallet": wallet,
        "height": height,
        "weight": weight,
        "medcondition": medcondition,
        "othermedcondition": othermedcondition,
        "yousmoke": yousmoke,
        "youpregnant": youpregnant,
        "status": status,
    };
}
