import 'package:flutter/material.dart';

import 'screens/login_screen.dart';
import 'screens/register_screen.dart';
import 'screens/home_screen.dart';
import 'screens/services_screen.dart';
import 'screens/service_detail_screen.dart';
import 'screens/profile_screen.dart';
import 'data/mock_data.dart';

void main() {
  runApp(const FixUpApp());
}

class FixUpApp extends StatelessWidget {
  const FixUpApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FixUp Flutter',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFFCB9E50),
        ),
        useMaterial3: true,
      ),
      home: const PreviewScreens(),
    );
  }
}

class PreviewScreens extends StatefulWidget {
  const PreviewScreens({super.key});

  @override
  State<PreviewScreens> createState() => _PreviewScreensState();
}

class _PreviewScreensState extends State<PreviewScreens> {
  int selectedIndex = 0;

  late final List<Widget> screens = [
    const LoginScreen(),
    const RegisterScreen(),
    const HomeScreen(),
    const ServicesScreen(),
    ServiceDetailScreen(service: mockServices.first),
    const ProfileScreen(),
  ];

  final List<String> labels = const [
    'Login',
    'Registro',
    'Home',
    'Servicios',
    'Detalle',
    'Perfil',
  ];

  final List<IconData> icons = const [
    Icons.login,
    Icons.person_add_alt_1,
    Icons.home_outlined,
    Icons.handyman_outlined,
    Icons.info_outline,
    Icons.person_outline,
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: screens[selectedIndex],
      bottomNavigationBar: NavigationBar(
        selectedIndex: selectedIndex,
        onDestinationSelected: (index) {
          setState(() {
            selectedIndex = index;
          });
        },
        destinations: List.generate(
          labels.length,
          (index) => NavigationDestination(
            icon: Icon(icons[index]),
            selectedIcon: Icon(icons[index], color: const Color(0xFFCB9E50)),
            label: labels[index],
          ),
        ),
      ),
    );
  }
}