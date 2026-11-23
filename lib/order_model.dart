import 'dart:convert';

class OrderModel {
    final bool success;
    final String message;
    final Data data;

    OrderModel({
        required this.success,
        required this.message,
        required this.data,
    });

    factory OrderModel.fromJson(String str) => OrderModel.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory OrderModel.fromMap(Map<String, dynamic> json) => OrderModel(
        success: json["success"],
        message: json["message"],
        data: Data.fromMap(json["data"]),
    );

    Map<String, dynamic> toMap() => {
        "success": success,
        "message": message,
        "data": data.toMap(),
    };
}

class Data {
    final int id;
    final int customerId;
    final String provinceName;
    final String cityName;
    final String districtName;
    final String subdistrictName;
    final int zipCode;
    final String fullAddress;
    final String invoice;
    final int weight;
    final String total;
    final String status;
    final String snapToken;
    final DateTime createdAt;
    final DateTime updatedAt;

    Data({
        required this.id,
        required this.customerId,
        required this.provinceName,
        required this.cityName,
        required this.districtName,
        required this.subdistrictName,
        required this.zipCode,
        required this.fullAddress,
        required this.invoice,
        required this.weight,
        required this.total,
        required this.status,
        required this.snapToken,
        required this.createdAt,
        required this.updatedAt,
    });

    factory Data.fromJson(String str) => Data.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory Data.fromMap(Map<String, dynamic> json) => Data(
        id: json["id"],
        customerId: json["customer_id"],
        provinceName: json["province_name"],
        cityName: json["city_name"],
        districtName: json["district_name"],
        subdistrictName: json["subdistrict_name"],
        zipCode: json["zip_code"],
        fullAddress: json["full_address"],
        invoice: json["invoice"],
        weight: json["weight"],
        total: json["total"],
        status: json["status"],
        snapToken: json["snap_token"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
    );

    Map<String, dynamic> toMap() => {
        "id": id,
        "customer_id": customerId,
        "province_name": provinceName,
        "city_name": cityName,
        "district_name": districtName,
        "subdistrict_name": subdistrictName,
        "zip_code": zipCode,
        "full_address": fullAddress,
        "invoice": invoice,
        "weight": weight,
        "total": total,
        "status": status,
        "snap_token": snapToken,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
    };
}
