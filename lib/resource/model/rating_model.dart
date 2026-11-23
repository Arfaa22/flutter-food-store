import 'package:flutter_application_1/resource/model/customer_model.dart';

class RatingModel {
  final int? id;
  final int? rating;
  final String? review;
  final CustomerModel? customer;

  RatingModel({this.id, this.rating, this.review, this.customer});

  factory RatingModel.fromMap(Map<String, dynamic> map) {
    return RatingModel(
      id: map['id'],
      rating: map['rating'],
      review: map['review'],
      customer: map['customer'] != null
          ? CustomerModel.fromMap(map['customer'])
          : null,
    );
  }
}
