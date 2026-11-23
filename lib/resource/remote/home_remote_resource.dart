import 'package:dio/dio.dart';
import 'package:either_dart/either.dart';
import 'package:flutter_application_1/resource/model/category_model.dart';
import 'package:flutter_application_1/resource/model/paging_model.dart';
import 'package:flutter_application_1/resource/model/product_model.dart';
import 'package:flutter_application_1/resource/model/slider_model.dart';

class HomeRemoteResource {
  final Dio _dio;

  HomeRemoteResource(this._dio);

  Future<Either<String, List<SliderModel>>> fetchSliders() async {
    try {
      final response = await _dio.get('/sliders');
      if (response.statusCode == 200) {
        final List data = response.data['data'];
        final sliders = data.map((e) => SliderModel.fromMap(e)).toList();
        return Right(sliders);
      } else {
        return Left(response.data['message'] ?? 'Gagal memuat slider');
      }
    } on DioException catch (e) {
      return Left(
        e.response?.data['message'] ?? e.message ?? 'Terjadi kesalahan',
      );
    } catch (e) {
      return Left(e.toString());
    }
  }

  Future<Either<String, List<CategoryModel>>> fetchCategories() async {
    try {
      final response = await _dio.get('/categories');
      if (response.statusCode == 200) {
        final List data = response.data['data'];
        final categories = data.map((e) => CategoryModel.fromMap(e)).toList();
        return Right(categories);
      } else {
        return Left(response.data['message'] ?? 'Gagal memuat kategori');
      }
    } on DioException catch (e) {
      return Left(
        e.response?.data['message'] ?? e.message ?? 'Terjadi kesalahan',
      );
    } catch (e) {
      return Left(e.toString());
    }
  }

  Future<Either<String, CategoryModel>> fetchCategoryBySlug(String slug) async {
    try {
      final response = await _dio.get('/categories/$slug');
      if (response.statusCode == 200) {
        final category = CategoryModel.fromMap(response.data['data']);
        return Right(category);
      } else {
        return Left(response.data['message'] ?? 'Gagal memuat detail kategori');
      }
    } on DioException catch (e) {
      return Left(
        e.response?.data['message'] ?? e.message ?? 'Terjadi kesalahan',
      );
    } catch (e) {
      return Left(e.toString());
    }
  }

  Future<Either<String, List<ProductModel>>> fetchProductsPopuler() async {
    try {
      final response = await _dio.get('/products-populer');
      if (response.statusCode == 200) {
        final List data = response.data['data'];
        final products = data.map((e) => ProductModel.fromMap(e)).toList();
        return Right(products);
      } else {
        return Left(response.data['message'] ?? 'Gagal memuat produk populer');
      }
    } on DioException catch (e) {
      return Left(
        e.response?.data['message'] ?? e.message ?? 'Terjadi kesalahan',
      );
    } catch (e) {
      return Left(e.toString());
    }
  }

  Future<Either<String, PagingModel>> fetchProducts({
    required int page,
    String query = '',
  }) async {
    try {
      final response = await _dio.get(
        '/products',
        queryParameters: {'page': page, if (query.isNotEmpty) 'q': query},
      );
      if (response.statusCode == 200) {
        final paging = PagingModel.fromMap(
          response.data['data'],
          (map) => ProductModel.fromMap(map),
        );
        return Right(paging);
      } else {
        return Left(response.data['message'] ?? 'Gagal memuat produk');
      }
    } on DioException catch (e) {
      return Left(
        e.response?.data['message'] ?? e.message ?? 'Terjadi kesalahan',
      );
    } catch (e) {
      return Left(e.toString());
    }
  }

  Future<Either<String, ProductModel>> detailProduct(String slug) async {
    try {
      final response = await _dio.get('/products/$slug');
      if (response.statusCode == 200) {
        final product = ProductModel.fromMap(response.data['data']);
        return Right(product);
      } else {
        return Left(response.data['message'] ?? 'Gagal memuat detail produk');
      }
    } on DioException catch (e) {
      return Left(
        e.response?.data['message'] ?? e.message ?? 'Terjadi kesalahan',
      );
    } catch (e) {
      return Left(e.toString());
    }
  }
}
