import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_application_1/resource/model/product_model.dart';
import 'package:flutter_application_1/resource/remote/home_remote_resource.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'product_populer_state.dart';
part 'product_populer_cubit.freezed.dart';

class ProductPopulerCubit extends Cubit<ProductPopulerState> {
  final HomeRemoteResource homeRemoteResource;
  ProductPopulerCubit(this.homeRemoteResource)
    : super(ProductPopulerState.initial());

  Future<void> fetchProductPopuler() async {
    emit(ProductPopulerState.loading());
    final result = await homeRemoteResource.fetchProductsPopuler();
    result.fold(
      (error) => emit(ProductPopulerState.error(error)),
      (products) => emit(ProductPopulerState.loadedProductPopuler(products)),
    );
  }
}
