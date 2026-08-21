import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'providers/auth_provider.dart';
import 'screens/landing_page.dart'; // Handles the connection
import 'screens/login_screen.dart';
import 'screens/viewer_dash.dart';
import 'screens/host_dash.dart';
import 'screens/admin_dash.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AuthProvider(),
      child: MaterialApp(
        title: 'AI Scheduling - Demo',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
          useMaterial3: true,
        ),
        // Named routes used after login / from the landing page's CTA.
        routes: {
          '/login': (_) => const LoginScreen(),
          '/viewer-dashboard': (_) => const ViewerDashboard(),
          '/host-dashboard': (_) => const HostDashboard(),
          '/admin-dashboard': (_) => const AdminDashboard(),
        },
        // Landing page is the very first thing users see. Its "Get
        // Started" / "Sign In" CTA pushes '/login'; LoginScreen then
        // routes on to the right dashboard after auth succeeds.
        home: const LandingPage(),
      ),
    );
  }
}
