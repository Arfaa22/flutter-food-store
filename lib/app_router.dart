import 'package:material_ui/material_ui.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_application_1/bloc/auth/auth_bloc.dart';
import 'package:flutter_application_1/bloc/Cart/cart_bloc.dart';
import 'package:flutter_application_1/bloc/category/category_cubit.dart';
import 'package:flutter_application_1/bloc/slider/order_cubit.dart';
import 'package:flutter_application_1/bloc/Product/product_cubit.dart';
import 'package:flutter_application_1/bloc/profile/profile_bloc.dart';
import 'package:flutter_application_1/bloc/slider/review_product_cubit.dart';
import 'package:flutter_application_1/page/auth/login_page.dart';
import 'package:flutter_application_1/page/auth/register_page.dart';
import 'package:flutter_application_1/page/dashboard/cart_page.dart';
import 'package:flutter_application_1/page/dashboard/dashboard_page.dart';
import 'package:flutter_application_1/page/dashboard/home_page.dart';
import 'package:flutter_application_1/page/dashboard/order_page.dart';
import 'package:flutter_application_1/page/dashboard/profile_page.dart';
import 'package:flutter_application_1/page/midtrans/midtrans_payment_page.dart';
import 'package:flutter_application_1/resource/model/category_model.dart';
import 'package:flutter_application_1/resource/remote/home_remote_resource.dart';
import 'package:flutter_application_1/resource/remote/order_resource_remote.dart';
import 'package:go_router/go_router.dart';

class AppRouter {
  final AuthBloc authBloc;
  final OrderRemoteResource orderRemoteResource;
  final HomeRemoteResource homeRemoteResource;

  AppRouter({
    required this.authBloc,
    required this.orderRemoteResource,
    required this.homeRemoteResource,
  });

  late final GoRouter router = GoRouter(
    refreshListenable: GoRouterRefreshStream(authBloc.stream),
    initialLocation: '/dashboard/home',
    redirect: (context, state) {
      final authState = authBloc.state;
      final isLoggedIn = authState is Authenticated;

      final protectedRoutes = [
        '/dashboard/orders',
        '/dashboard/profile',
        '/dashboard/cart',
        '/orders',
        '/checkout',
      ];

      final isProtected = protectedRoutes.any(
        (route) => state.matchedLocation.startsWith(route),
      );

      if (!isLoggedIn && isProtected) return '/login';

      if (isLoggedIn && state.matchedLocation == '/login') {
        return '/dashboard/home';
      }

      return null;
    },
    routes: [
      ShellRoute(
        builder: (_, _, child) => DashboardPage(child: child),
        routes: [
          GoRoute(
            path: '/dashboard/home',
            builder: (_, _) {
              return HomePage();
            },
          ),
          GoRoute(
            path: '/dashboard/orders',
            builder: (context, state) {
              context.read<OrderCubit>().fetchOrders(isRefresh: true);
              return OrderPage();
            },
          ),
          GoRoute(
            path: '/dashboard/cart',
            builder: (context, state) {
              context.read<CartBloc>().add(const CartEvent.fetchCart());
              return CartPage();
            },
          ),
          GoRoute(
            path: '/dashboard/profile',
            builder: (context, state) {
              context.read<ProfileBloc>().add(const ProfileEvent.loadProfile());
              return ProfilePage();
            },
          ),
        ],
      ),
      GoRoute(path: '/login', builder: (_, _) => LoginPage()),
      GoRoute(path: '/register', builder: (_, _) => RegisterPage()),
      GoRoute(
        path: '/orderDetail/:snapToken',
        builder: (context, state) {
          final snapToken = state.pathParameters['snapToken'] ?? '';
          return MultiBlocProvider(
            providers: [
              BlocProvider(
                create: (context) =>
                    OrderCubit(orderRemoteResource)..detailOrder(snapToken),
              ),
              BlocProvider(
                create: (context) => ReviewProductCubit(orderRemoteResource),
              ),
            ],
            child: AboutDialog(),
          );
        },
      ),
      GoRoute(
        path: '/midtransPayment/:snapToken',
        builder: (context, state) {
          return MidtransPaymentPage(
            snapToken: state.pathParameters['snapToken'] ?? '',
          );
        },
      ),
      GoRoute(
        path: '/allProducts',
        builder: (context, state) => BlocProvider(
          create: (context) =>
              ProductCubit(homeRemoteResource)..fetchProduct(isRefresh: true),
          child: AboutDialog(),
        ),
      ),
      GoRoute(
        path: '/detailProduct/:slug',
        builder: (context, state) {
          return BlocProvider(
            create: (context) =>
                ProductCubit(homeRemoteResource)
                  ..detailProduct(state.pathParameters['slug'] ?? ''),
            child: AboutDialog(),
          );
        },
      ),
      GoRoute(
        path: '/productByCategory',
        builder: (context, state) {
          final category = state.extra as CategoryModel;
          return BlocProvider(
            create: (context) =>
                CategoryCubit(homeRemoteResource)
                  ..fetchCategoryBySlug(category.slug ?? ''),
            child: AboutDialog(),
          );
        },
      ),
    ],
  );
}

class OrderDetailPage {}

class GoRouterRefreshStream extends ChangeNotifier {
  GoRouterRefreshStream(Stream stream) {
    stream.listen((_) {
      notifyListeners();
    });
  }
}
