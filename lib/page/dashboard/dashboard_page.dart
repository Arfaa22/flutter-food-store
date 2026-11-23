import 'package:material_ui/material_ui.dart';
import 'package:go_router/go_router.dart';

class DashboardPage extends StatefulWidget {
  final Widget child;
  const DashboardPage({super.key, required this.child});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  final TextEditingController _searchController = TextEditingController();
  final tabs = [
    '/dashboard/home',
    '/dashboard/order',
    '/dashboard/cart',
    '/dashboard/profile',
  ];

  int currentIndex = 0;

  final List<NavigationDestination> _appBarDestinations = const [
    NavigationDestination(
      selectedIcon: Icon(Icons.home, color: Colors.white),
      icon: Icon(Icons.home),
      label: 'Home',
    ),
    NavigationDestination(
      selectedIcon: Icon(Icons.shopping_bag, color: Colors.white),
      icon: Icon(Icons.shopping_bag),
      label: 'My Orders',
    ),
    NavigationDestination(
      selectedIcon: Icon(Icons.shopping_cart, color: Colors.white),
      icon: Icon(Icons.shopping_cart),
      label: 'Cart',
    ),
    NavigationDestination(
      selectedIcon: Icon(Icons.person, color: Colors.white),
      icon: Icon(Icons.person),
      label: 'Profile',
    ),
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final location = GoRouterState.of(context).matchedLocation;
    final matchedIndex = tabs.indexWhere((path) => location.startsWith(path));
    if (matchedIndex != -1) {
      currentIndex = matchedIndex;
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Food Store'),
        backgroundColor: Colors.deepOrange,
        foregroundColor: Colors.white,
      ),
      body: widget.child,
      bottomNavigationBar: NavigationBar(
        selectedIndex: currentIndex,
        indicatorColor: Colors.deepOrange,
        onDestinationSelected: (index) {
          setState(() {
            currentIndex = index;
          });
          context.go(tabs[index]);
        },
        destinations: _appBarDestinations,
      ),
    );
  }
}
