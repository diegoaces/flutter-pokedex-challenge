import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:poke_app/app_router.dart';
import 'package:poke_app/core/app_routes.dart';

class CustomBottomNavigation extends ConsumerWidget {
  const CustomBottomNavigation({super.key});

  int _getCurrentIndex(String currentRoute) {
    switch (currentRoute) {
      case AppRoutes.pokedex:
        return 0;
      case AppRoutes.regiones:
        return 1;
      case AppRoutes.favoritos:
        return 2;
      case AppRoutes.profile:
        return 3;
      default:
        return 0;
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(appRouterProvider);
    final currentRoute = router.routerDelegate.currentConfiguration.fullPath;
    final currentIndex = _getCurrentIndex(currentRoute);

    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(25),
            blurRadius: 2,
            spreadRadius: 0,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
        child: BottomNavigationBar(
          elevation: 0,
          currentIndex: currentIndex,
          type: BottomNavigationBarType.fixed,
          backgroundColor: const Color(0xFFFAFAFA),
          selectedItemColor: Colors.blue,
          unselectedItemColor: Colors.black,
          selectedFontSize: 13,
          unselectedFontSize: 13,
          selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold),
          unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.normal),
          onTap: (index) {
            switch (index) {
              case 0:
                router.go(AppRoutes.pokedex);
                break;
              case 1:
                router.go(AppRoutes.regiones);
                break;
              case 2:
                router.go(AppRoutes.favoritos);
                break;
              case 3:
                router.go(AppRoutes.profile);
                break;
            }
          },
          items: [
            BottomNavigationBarItem(
              icon: SvgPicture.asset(
                'assets/svg/home.svg',
                width: 24,
                height: 24,
                colorFilter: currentIndex == 0
                    ? const ColorFilter.mode(Colors.blue, BlendMode.srcIn)
                    : null,
              ),
              label: 'Pokedex',
            ),
            BottomNavigationBarItem(
              icon: SvgPicture.asset(
                'assets/svg/globe.svg',
                width: 24,
                height: 24,
                colorFilter: currentIndex == 1
                    ? const ColorFilter.mode(Colors.blue, BlendMode.srcIn)
                    : null,
              ),
              label: 'Regiones',
            ),
            BottomNavigationBarItem(
              icon: SvgPicture.asset(
                'assets/svg/heart.svg',
                width: 24,
                height: 24,
                colorFilter: currentIndex == 2
                    ? const ColorFilter.mode(Colors.blue, BlendMode.srcIn)
                    : null,
              ),
              label: 'Favoritos',
            ),
            BottomNavigationBarItem(
              icon: SvgPicture.asset(
                'assets/svg/user.svg',
                width: 24,
                height: 24,
                colorFilter: currentIndex == 3
                    ? const ColorFilter.mode(Colors.blue, BlendMode.srcIn)
                    : null,
              ),
              label: 'Perfil',
            ),
          ],
        ),
      ),
    );
  }
}
