import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/auth_provider.dart';

class AdminDashboard extends StatelessWidget {
  const AdminDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final name = auth.currentUser?.name ?? 'Admin';

    return Scaffold(
      appBar: AppBar(
        title: Text('Admin Dashboard — $name'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout_outlined),
            onPressed: () {
              context.read<AuthProvider>().logout();
              Navigator.of(context).pushReplacementNamed('/login');
            },
          ),
        ],
      ),
      body: Center(
        child: Text(
          'Admin dashboard (user & system management).',
          style: Theme.of(context).textTheme.bodyLarge,
        ),
      ),
    );
  }
}
