import 'package:flutter/material.dart';
import 'package:frontend/models/schedule_slot_model.dart';

class TimetableGrid extends StatelessWidget {
  final List<ScheduleSlotModel> slots;
  final List<String> timeSlots;
  final List<String> days;

  const TimetableGrid({
    super.key,
    required this.slots,
    required this.timeSlots,
    this.days = const [
      'Sunday',
      'Monday',
      'Tuesday',
      'Wednesday',
      'Thursday',
      'Friday',
    ],
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: SingleChildScrollView(
        child: DataTable(
          columns: [
            const DataColumn(label: Text('Time / Day')),
            ...days.map((day) => DataColumn(label: Text(day))),
          ],
          rows: timeSlots.map((time) {
            return DataRow(
              cells: [
                DataCell(
                  Text(
                    time,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                ...days.map((day) {
                  final slot = slots.firstWhere(
                    (s) => s.day == day && s.timeSlot == time,
                    orElse: () => ScheduleSlotModel(
                      day: day,
                      timeSlot: time,
                      subject: '',
                      teacher: '',
                      room: '',
                    ),
                  );

                  return DataCell(
                    slot.subject.isNotEmpty
                        ? Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.blue.shade50,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  slot.subject,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  '${slot.teacher} (${slot.room})',
                                  style: const TextStyle(fontSize: 11),
                                ),
                              ],
                            ),
                          )
                        : const Text('-'),
                  );
                }),
              ],
            );
          }).toList(),
        ),
      ),
    );
  }
}
