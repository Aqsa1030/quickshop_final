import 'package:flutter/material.dart';
import 'package:quickshop_final/navigation/app_router.dart';

class CustomBottomNavigationBar extends StatelessWidget {
  final int currentIndex;

  const CustomBottomNavigationBar({
    super.key,
    required this.currentIndex,
  });

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: (index) {
        switch (index) {
          case 0:
            Navigator.pushNamedAndRemoveUntil(
              context,
              AppRouter.home,
                  (route) => false,
            );
            break;
          case 1:
            Navigator.pushNamed(
              context,
              AppRouter.categories,
            );
            break;
          case 2:
            Navigator.pushNamed(
              context,
              AppRouter.cart,
            );
            break;
          case 3:
            Navigator.pushNamed(
              context,
              AppRouter.profile,
            );
            break;
        }
      },
      type: BottomNavigationBarType.fixed,
      selectedItemColor: Theme.of(context).primaryColor,
      unselectedItemColor: Colors.grey,
      selectedFontSize: 12,
      unselectedFontSize: 12,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      elevation: 8,
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home_outlined),
          activeIcon: Icon(Icons.home),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.category_outlined),
          activeIcon: Icon(Icons.category),
          label: 'Categories',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.shopping_cart_outlined),
          activeIcon: Icon(Icons.shopping_cart),
          label: 'Cart',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person_outlined),
          activeIcon: Icon(Icons.person),
          label: 'Profile',
        ),
      ],
    );
  }
}