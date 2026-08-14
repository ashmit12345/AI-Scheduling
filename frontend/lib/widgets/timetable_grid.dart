import 'package:flutter/material.dart';

import '../models/schedule_slot_model.dart';

/// Default day ordering used when the caller doesn't supply its own.
const List<String> kDefaultWeekDays = [
  'Sunday',
  'Monday',
  'Tuesday',
  'Wednesday',
  'Thursday',
  'Friday',
];

/// Renders a weekly timetable as a grid: days across the top, time slots
/// down the left side, and one [ScheduleSlotModel] card per occupied cell.
///
/// - Empty (day, timeSlot) coordinates render as a quiet placeholder.
/// - Slots with [ScheduleSlotModel.isSubstituted] are visually flagged
///   with an accent border/badge so a substitution never blends in with
///   a normal class.
/// - The grid scrolls horizontally on narrow screens (e.g. phones) while
///   keeping the time-slot column pinned, so the layout stays usable
///   without ever compressing text unreadably.
class TimetableGrid extends StatelessWidget {
  final List<ScheduleSlotModel> slots;

  /// Column order. Defaults to [kDefaultWeekDays].
  final List<String> days;

  /// Row order, e.g. `['08:00 - 09:00', '09:00 - 10:00', ...]`.
  /// Required — the grid has no way to infer a canonical row order from
  /// unordered slot data alone.
  final List<String> timeSlots;

  /// Fixed width for each day column. The grid is wrapped in horizontal
  /// scroll, so this can safely stay generous on small screens.
  final double columnWidth;

  /// Height of each row.
  final double rowHeight;

  final void Function(ScheduleSlotModel slot)? onSlotTap;

  const TimetableGrid({
    super.key,
    required this.slots,
    required this.timeSlots,
    this.days = kDefaultWeekDays,
    this.columnWidth = 160,
    this.rowHeight = 84,
    this.onSlotTap,
  });

  /// O(1) lookup of a slot by (day, timeSlot) instead of scanning the list
  /// per cell — matters once a full week's worth of slots is rendered.
  Map<String, ScheduleSlotModel> _indexSlots() {
    return {for (final slot in slots) '${slot.day}|${slot.timeSlot}': slot};
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final index = _indexSlots();
    const timeColumnWidth = 96.0;

    return LayoutBuilder(
      builder: (context, constraints) {
        final gridWidth = timeColumnWidth + (columnWidth * days.length);
        final needsScroll = gridWidth > constraints.maxWidth;

        final grid = SizedBox(
          width: needsScroll ? gridWidth : constraints.maxWidth,
          child: Column(
            children: [
              _buildHeaderRow(theme, timeColumnWidth),
              Divider(height: 1, color: theme.colorScheme.outlineVariant),
              ...timeSlots.map(
                (slot) => _buildRow(
                  context,
                  theme,
                  slot,
                  index,
                  timeColumnWidth,
                  needsScroll
                      ? columnWidth
                      : (constraints.maxWidth - timeColumnWidth) / days.length,
                ),
              ),
            ],
          ),
        );

        final bordered = Container(
          decoration: BoxDecoration(
            border: Border.all(color: theme.colorScheme.outlineVariant),
            borderRadius: BorderRadius.circular(16),
          ),
          clipBehavior: Clip.antiAlias,
          child: grid,
        );

        return needsScroll
            ? SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: bordered,
              )
            : bordered;
      },
    );
  }

  Widget _buildHeaderRow(ThemeData theme, double timeColumnWidth) {
    return Container(
      color: theme.colorScheme.surfaceContainerHigh,
      child: Row(
        children: [
          SizedBox(
            width: timeColumnWidth,
            height: 48,
            child: Center(
              child: Icon(
                Icons.schedule_rounded,
                size: 18,
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ),
          ...days.map(
            (day) => SizedBox(
              width: columnWidth,
              height: 48,
              child: Center(
                child: Text(
                  day,
                  style: theme.textTheme.labelLarge?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRow(
    BuildContext context,
    ThemeData theme,
    String timeSlot,
    Map<String, ScheduleSlotModel> index,
    double timeColumnWidth,
    double cellWidth,
  ) {
    return Container(
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(
            color: theme.colorScheme.outlineVariant.withValues(alpha: 0.6),
          ),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            width: timeColumnWidth,
            height: rowHeight,
            alignment: Alignment.center,
            color: theme.colorScheme.surfaceContainerLow,
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: Text(
              timeSlot,
              textAlign: TextAlign.center,
              style: theme.textTheme.labelMedium,
            ),
          ),
          ...days.map((day) {
            final slot = index['$day|$timeSlot'];
            return SizedBox(
              width: cellWidth,
              height: rowHeight,
              child: Padding(
                padding: const EdgeInsets.all(4),
                child: slot == null
                    ? _EmptyCell()
                    : _SlotCell(slot: slot, onTap: onSlotTap),
              ),
            );
          }),
        ],
      ),
    );
  }
}

class _EmptyCell extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return DecoratedBox(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(10),
      ),
    );
  }
}

class _SlotCell extends StatelessWidget {
  final ScheduleSlotModel slot;
  final void Function(ScheduleSlotModel slot)? onTap;

  const _SlotCell({required this.slot, this.onTap});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isSub = slot.isSubstituted;

    final baseColor = isSub
        ? theme.colorScheme.tertiaryContainer
        : theme.colorScheme.primaryContainer.withValues(alpha: 0.55);
    final onBaseColor = isSub
        ? theme.colorScheme.onTertiaryContainer
        : theme.colorScheme.onPrimaryContainer;

    final cell = Material(
      color: baseColor,
      borderRadius: BorderRadius.circular(10),
      child: InkWell(
        borderRadius: BorderRadius.circular(10),
        onTap: onTap == null ? null : () => onTap!(slot),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
          decoration: isSub
              ? BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: theme.colorScheme.tertiary,
                    width: 1.4,
                  ),
                )
              : null,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      slot.subject,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.labelLarge?.copyWith(
                        color: onBaseColor,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  if (isSub)
                    Icon(
                      Icons.swap_horiz_rounded,
                      size: 14,
                      color: theme.colorScheme.tertiary,
                    ),
                ],
              ),
              const SizedBox(height: 2),
              Text(
                slot.effectiveTeacher,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.bodySmall?.copyWith(color: onBaseColor),
              ),
              Text(
                slot.room,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: onBaseColor.withValues(alpha: 0.75),
                ),
              ),
            ],
          ),
        ),
      ),
    );

    if (!isSub) return cell;

    return Tooltip(message: 'Substitute for ${slot.teacher}', child: cell);
  }
}
