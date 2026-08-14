import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'providers/auth_provider.dart';
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
        // Named routes used by LoginScreen after "login"
        routes: {
          '/login': (_) => const LoginScreen(),
          '/viewer-dashboard': (_) => const ViewerDashboard(),
          '/host-dashboard': (_) => const HostDashboard(),
          '/admin-dashboard': (_) => const AdminDashboard(),
        },
        // Start at login; the LoginScreen routes to the appropriate dashboard.
        home: const LoginScreen(),
      ),
    );
  }
}
