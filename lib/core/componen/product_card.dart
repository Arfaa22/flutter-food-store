import 'package:material_ui/material_ui.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_application_1/bloc/Cart/cart_bloc.dart';
import 'package:flutter_application_1/core/constants/app_config.dart';
import 'package:flutter_application_1/core/utils/currency_helper.dart';
import 'package:flutter_application_1/resource/model/product_model.dart';
import 'package:go_router/go_router.dart';

class ProductCard extends StatelessWidget {
  final ProductModel product;
  final bool isPopular;

  const ProductCard({super.key, required this.product, this.isPopular = false});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.push('/detailProduct/${product.slug}'),
      child: SizedBox(
        width: isPopular ? 180 : double.infinity,
        child: Card(
          color: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(12),
                ),
                child: Image.network(
                  '${AppConfig.IMAGE_PATH}${product.image}',
                  height: 120,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      product.title ?? '',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            CurrencyHelper.formatRupiah(
                              product.price?.toDouble() ?? 0,
                            ),
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Colors.deepOrange,
                            ),
                          ),
                        ),
                        _addToCartButton(context),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _addToCartButton(BuildContext context) {
    return InkWell(
      onTap: () {
        context.read<CartBloc>().add(
          CartEvent.addCart(productId: product.id ?? 0, qty: 1),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          color: Colors.orange,
          borderRadius: BorderRadius.circular(8),
        ),
        child: const Icon(
          Icons.add_shopping_cart,
          color: Colors.white,
          size: 18,
        ),
      ),
    );
  }
}
