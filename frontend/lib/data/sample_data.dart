import '../models/schedule_slot_model.dart';

// A small set of time slots and sample slots to show the TimetableGrid
const List<String> sampleTimeSlots = [
  '08:00 - 09:00',
  '09:00 - 10:00',
  '10:15 - 11:15',
  '11:30 - 12:30',
  '01:30 - 02:30',
];

final List<ScheduleSlotModel> sampleSlots = [
  ScheduleSlotModel(
    day: 'Monday',
    timeSlot: sampleTimeSlots[0],
    subject: 'Artificial Intelligence',
    teacher: 'Prof. Sharma',
    room: 'Room 302',
  ),
  ScheduleSlotModel(
    day: 'Monday',
    timeSlot: sampleTimeSlots[1],
    subject: 'Web Technology',
    teacher: 'Er. Adhikari',
    room: 'Lab 2',
    isSubstituted: false,
  ),
  ScheduleSlotModel(
    day: 'Tuesday',
    timeSlot: sampleTimeSlots[0],
    subject: 'Software Engineering',
    teacher: 'Dr. Thapa',
    room: 'Room 302',
  ),
  ScheduleSlotModel(
    day: 'Wednesday',
    timeSlot: sampleTimeSlots[2],
    subject: 'Data Structures',
    teacher: 'Ms. Koirala',
    room: 'Room 101',
  ),
];
