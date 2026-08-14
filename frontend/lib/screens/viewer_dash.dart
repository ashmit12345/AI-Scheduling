import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:frontend/providers/auth_provider.dart';
import 'package:frontend/widgets/timetable_grid.dart';
import 'package:frontend/data/sample_data.dart';

class ViewerDashboard extends StatelessWidget {
  const ViewerDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final name = auth.currentUser?.name ?? 'Viewer';

    return Scaffold(
      appBar: AppBar(
        title: Text('Viewer Dashboard — $name'),
        actions: [
          IconButton(
            tooltip: 'Sign out',
            icon: const Icon(Icons.logout_outlined),
            onPressed: () {
              context.read<AuthProvider>().logout();
              Navigator.of(context).pushReplacementNamed('/login');
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            Card(
              margin: EdgeInsets.zero,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Row(
                  children: [
                    const Icon(Icons.calendar_month_outlined, size: 28),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Weekly timetable preview',
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(fontWeight: FontWeight.w600),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: TimetableGrid(
                slots: sampleSlots,
                timeSlots: sampleTimeSlots,
                // days default to Sunday..Friday in TimetableGrid
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        tooltip: 'Add placeholder',
        onPressed: () {
          // demo action: no-op or show snackbar
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(const SnackBar(content: Text('This is a demo UI.')));
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
