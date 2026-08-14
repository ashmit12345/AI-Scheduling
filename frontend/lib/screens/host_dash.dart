import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/auth_provider.dart';

class HostDashboard extends StatelessWidget {
  const HostDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final name = auth.currentUser?.name ?? 'Host';

    return Scaffold(
      appBar: AppBar(
        title: Text('Host Dashboard — $name'),
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
          'Host dashboard (manage schedules).',
          style: Theme.of(context).textTheme.bodyLarge,
        ),
      ),
    );
  }
}
