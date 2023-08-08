import 'dart:convert';

import 'package:kliknss77/application/models/response_json.dart';


ResponseGetVoucherModel welcomeFromJson(String str) =>
    ResponseGetVoucherModel.fromJson(json.decode(str));

String welcomeToJson(ResponseGetVoucherModel data) =>
    json.encode(data.toJson());

class ResponseGetVoucherModel {
  ResponseGetVoucherModel({this.vouchers, this.commonData});

  List<Voucher>? vouchers;

  ResponseJson? commonData;

  factory ResponseGetVoucherModel.fromJson(Map<String, dynamic> json) =>
      ResponseGetVoucherModel(
        vouchers: List<Voucher>.from(
            json["vouchers"].map((x) => Voucher.fromJson(x))),
      );

  factory ResponseGetVoucherModel.errorJson(Map<String, dynamic> parsedJson) {
    return ResponseGetVoucherModel(
      commonData: ResponseJson.errorJson(parsedJson),
    );
  }

  Map<String, dynamic> toJson() => {
        "vouchers": List<dynamic>.from(vouchers!.map((x) => x.toJson())),
      };
}

class Voucher {
  Voucher({
    this.id,
    this.title,
    this.description,
    this.imageUrl,
    this.tnc,
    this.endDate,
    this.target,
    this.code,
  });

  int? id;
  String? title;
  String? description;
  String? imageUrl;
  String? tnc;
  String? endDate;
  String? target;
  String? code;

  factory Voucher.fromJson(Map<String, dynamic> json) => Voucher(
        id: json["id"] ?? 1,
        title: json["title"] ?? "",
        description: json["description"] ?? "",
        imageUrl: json["imageUrl"] ?? "",
        tnc: json["tnc"] ?? '',
        endDate: json["endDate"] ?? "",
        target: json["target"] ?? "",
        code: json["code"] ?? "",
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "description": description,
        "imageUrl": imageUrl,
        "tnc": tnc,
        "endDate": endDate,
        "target": target,
        "code": code,
      };

  @override
  String toString() {
    return '$id, $title, $description, $imageUrl, $tnc, $endDate, $target,$code';
  }
}
