import 'package:material_ui/material_ui.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_application_1/bloc/slider/order_cubit.dart';
import 'package:flutter_application_1/bloc/slider/review_product_cubit.dart';

class DetailOrderPage extends StatefulWidget {
  const DetailOrderPage({super.key});

  @override
  State<DetailOrderPage> createState() => _DetailOrderPageState();
}

class _DetailOrderPageState extends State<DetailOrderPage> {
  final _formKey = GlobalKey<FormState>();
  final _reviewController = TextEditingController();
  double _rating = 5.0;

  @override
  void dispose() {
    _reviewController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ReviewProductCubit, ReviewProductState>(
      listener: _reviewProductListener,
      child: BlocBuilder<OrderCubit, OrderState>(
        builder: (context, state) {
          return Scaffold(
            appBar: _buildAppBar(context),
            body: _buildBody(state),
            floatingActionButton: _buildFloatingActionButton(),
          );
        },
      ),
    );
  }

  void _reviewProductListener(BuildContext context, ReviewProductState state) {
    state.maybeWhen(
      errorReviewProduct: (message) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(message), backgroundColor: Colors.red),
        );
      },
      successReviewProduct: () {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Terima kasih telah memberikan ulasan'),
            backgroundColor: Colors.green,
          ),
        );
      },
      orElse: () {},
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(title: const Text('Detail Order'));
  }

  Widget _buildBody(OrderState state) {
    return state.maybeWhen(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (message) => Center(child: Text(message)),
      detail: (detailOrder) {
        final List<dynamic> items = detailOrder is Map
            ? (detailOrder['transaction_details'] ??
                  detailOrder['details'] ??
                  [])
            : (detailOrder?.transactionDetails ?? []);

        if (items.isEmpty) {
          return const Center(child: Text('Detail Order kosong'));
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: items.length,
          itemBuilder: (context, index) {
            final item = items[index];
            final String productName = item is Map
                ? (item['product']?['name'] ?? 'Produk')
                : (item.product?.name ?? 'Produk');

            return Card(
              margin: const EdgeInsets.only(bottom: 12),
              child: ListTile(
                title: Text(productName),
                trailing: ElevatedButton(
                  onPressed: () {
                    _reviewController.clear();
                    setState(() => _rating = 5.0);
                    showDialog(
                      context: context,
                      builder: (context) => _buildReviewDialog(item),
                    );
                  },
                  child: const Text('Beri Ulasan'),
                ),
              ),
            );
          },
        );
      },
      orElse: () => const Center(child: Text('Detail Order')),
    );
  }

  Widget? _buildFloatingActionButton() {
    return null;
  }

  Widget _buildReviewDialog(dynamic item) {
    final int transactionDetailId = item is Map
        ? (item['id'] ?? 0)
        : (item.id ?? 0);
    final int productId = item is Map
        ? (item['product_id'] ?? item['product']?['id'] ?? 0)
        : (item.product?.id ?? 0);

    return AlertDialog(
      title: const Text('Beri Ulasan'),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Beri rating untuk produk ini:'),
            const SizedBox(height: 8),
            RatingBar.builder(
              initialRating: _rating,
              minRating: 1,
              maxRating: 5,
              direction: Axis.horizontal,
              allowHalfRating: false,
              itemCount: 5,
              itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
              itemBuilder: (context, _) =>
                  const Icon(Icons.star, color: Colors.amber),
              onRatingUpdate: (rating) => setState(() => _rating = rating),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _reviewController,
              maxLines: 3,
              decoration: const InputDecoration(
                hintText: 'Tulis ulasan Anda...',
                border: OutlineInputBorder(),
              ),
              validator: (value) => value == null || value.trim().isEmpty
                  ? 'Ulasan tidak boleh kosong'
                  : null,
            ),
          ],
        ),
      ),
      actions: [
        TextButton(onPressed: () => context.pop(), child: const Text('Batal')),
        FilledButton(
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              context.read<ReviewProductCubit>().reviewProduct(
                transactionDetailId,
                productId,
                _rating.toInt(),
                _reviewController.text,
              );
              context.pop();
            }
          },
          child: const Text('Kirim', style: TextStyle(color: Colors.white)),
        ),
      ],
    );
  }
}
