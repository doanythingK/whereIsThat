import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/localization/app_localizations.dart';
import '../../../core/data/repository_providers.dart';
import '../../../core/models/app_models.dart';

class FloorPlanPage extends ConsumerStatefulWidget {
  const FloorPlanPage({required this.spaceId, super.key});

  final String spaceId;

  @override
  ConsumerState<FloorPlanPage> createState() => _FloorPlanPageState();
}

class _FloorPlanPageState extends ConsumerState<FloorPlanPage> {
  String? _selectedPlanId;
  final List<Map<String, dynamic>> _history = [];
  int _historyIndex = -1;
  bool _saving = false;

  Future<void> _createPlan() async {
    final name = await _askText(
      context,
      title: '평면도 추가',
      label: '평면도 이름',
      initial: '새 평면도',
    );
    if (name == null || name.trim().isEmpty) return;
    await ref
        .read(workspaceActionsProvider)
        .createFloorPlan(spaceId: widget.spaceId, name: name.trim());
  }

  Future<void> _addLocation(
    FloorPlan plan, {
    double x = .5,
    double y = .5,
  }) async {
    final name = await _askText(
      context,
      title: context.l10n.addLocation,
      label: context.l10n.locationName,
      initial: '수납장',
    );
    if (name == null || name.trim().isEmpty) return;
    final now = DateTime.now().toUtc();
    await ref
        .read(workspaceActionsProvider)
        .saveLocation(
          Location(
            id: '',
            spaceId: plan.spaceId,
            floorPlanId: plan.id,
            name: name.trim(),
            xRatio: x.clamp(0.0, 1.0),
            yRatio: y.clamp(0.0, 1.0),
            createdBy:
                ref.read(appRepositoryProvider).signedInUser?.id ?? 'demo-user',
            createdAt: now,
            updatedAt: now,
          ),
          isNew: true,
        );
  }

  Future<void> _addRoom(FloorPlan plan) async {
    final name = await _askText(
      context,
      title: '방 추가',
      label: '방 이름',
      initial: '거실',
    );
    if (name == null || name.trim().isEmpty) return;
    final currentRooms =
        ((plan.layoutData['rooms'] as List<dynamic>?) ?? const <dynamic>[])
            .map((room) => Map<String, dynamic>.from(room as Map))
            .toList();
    final roomId = 'room-${DateTime.now().microsecondsSinceEpoch}';
    final cells = <String>[];
    for (var row = 2; row < 9; row++) {
      for (var col = 2; col < 9; col++) {
        cells.add('$row:$col');
      }
    }
    final updated = Map<String, dynamic>.from(plan.layoutData);
    currentRooms.add({
      'id': roomId,
      'name': name.trim(),
      'color': '#DBEAFE',
      'cells': cells,
    });
    updated['rooms'] = currentRooms;
    _pushHistory(updated);
    try {
      await ref
          .read(workspaceActionsProvider)
          .saveFloorPlan(
            plan.copyWith(layoutData: updated),
            version: plan.version,
          );
    } catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(error.toString())));
      }
    }
  }

  void _pushHistory(Map<String, dynamic> layout) {
    setState(() {
      if (_historyIndex + 1 < _history.length) {
        _history.removeRange(_historyIndex + 1, _history.length);
      }
      _history.add(layout);
      _historyIndex = _history.length - 1;
    });
  }

  Future<void> _save(FloorPlan plan, Map<String, dynamic> layout) async {
    setState(() => _saving = true);
    try {
      await ref
          .read(workspaceActionsProvider)
          .saveFloorPlan(
            plan.copyWith(layoutData: layout),
            version: plan.version,
          );
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text('평면도를 저장했습니다.')));
      }
    } catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(error.toString())));
      }
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  Future<void> _deletePlan(FloorPlan plan) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('${plan.name} 삭제'),
        content: const Text('30일 동안 복구할 수 있습니다. 연결된 물건은 위치 미지정으로 바뀝니다.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(context.l10n.cancel),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(context.l10n.delete),
          ),
        ],
      ),
    );
    if (confirmed == true) {
      await ref.read(workspaceActionsProvider).deleteFloorPlan(plan);
    }
  }

  @override
  Widget build(BuildContext context) {
    final plans = ref.watch(floorPlansProvider(widget.spaceId));
    return Scaffold(
      appBar: AppBar(
        title: Text(context.l10n.floorPlan),
        actions: [
          IconButton(
            onPressed: _createPlan,
            icon: const Icon(Icons.add),
            tooltip: '평면도 추가',
          ),
        ],
      ),
      body: plans.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(child: Text(error.toString())),
        data: (values) {
          if (values.isEmpty) {
            return Center(
              child: FilledButton.icon(
                onPressed: _createPlan,
                icon: const Icon(Icons.add),
                label: Text(context.l10n.createFirstFloorPlan),
              ),
            );
          }
          final selected =
              values.where((plan) => plan.id == _selectedPlanId).firstOrNull ??
              values.first;
          if (_selectedPlanId != selected.id) _selectedPlanId = selected.id;
          final locations = ref.watch(locationsProvider(selected.id));
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
                child: Row(
                  children: [
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        initialValue: selected.id,
                        decoration: const InputDecoration(labelText: '평면도'),
                        items: [
                          for (final plan in values)
                            DropdownMenuItem(
                              value: plan.id,
                              child: Text(plan.name),
                            ),
                        ],
                        onChanged: (value) =>
                            setState(() => _selectedPlanId = value),
                      ),
                    ),
                    const SizedBox(width: 8),
                    IconButton(
                      onPressed: () => _addRoom(selected),
                      tooltip: '방 추가',
                      icon: const Icon(Icons.meeting_room_outlined),
                    ),
                    IconButton(
                      onPressed: values.length > 1
                          ? () => _deletePlan(selected)
                          : null,
                      tooltip: context.l10n.delete,
                      icon: const Icon(Icons.delete_outline),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: locations.when(
                  loading: () =>
                      const Center(child: CircularProgressIndicator()),
                  error: (error, stack) =>
                      Center(child: Text(error.toString())),
                  data: (locationValues) => Center(
                    child: InteractiveViewer(
                      minScale: .5,
                      maxScale: 3,
                      boundaryMargin: const EdgeInsets.all(120),
                      child: SizedBox(
                        width: 600,
                        height: 600,
                        child: GestureDetector(
                          onTapUp: (details) {
                            final x = details.localPosition.dx / 600;
                            final y = details.localPosition.dy / 600;
                            final hit = locationValues
                                .where(
                                  (location) =>
                                      math.max(
                                        (location.xRatio - x).abs(),
                                        (location.yRatio - y).abs(),
                                      ) <
                                      .07,
                                )
                                .toList();
                            if (hit.length == 1) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text(hit.single.name)),
                              );
                            } else if (hit.length > 1) {
                              showModalBottomSheet<void>(
                                context: context,
                                builder: (_) => SafeArea(
                                  child: ListView(
                                    shrinkWrap: true,
                                    children: [
                                      for (final location in hit)
                                        ListTile(
                                          title: Text(location.name),
                                          onTap: () => Navigator.pop(context),
                                        ),
                                    ],
                                  ),
                                ),
                              );
                            } else {
                              _addLocation(selected, x: x, y: y);
                            }
                          },
                          child: CustomPaint(
                            painter: _FloorPlanPainter(
                              plan: selected,
                              locations: locationValues,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
                child: Row(
                  children: [
                    OutlinedButton.icon(
                      onPressed: _historyIndex >= 0
                          ? () => setState(() => _historyIndex--)
                          : null,
                      icon: const Icon(Icons.undo),
                      label: const Text('Undo'),
                    ),
                    const SizedBox(width: 8),
                    OutlinedButton.icon(
                      onPressed: _historyIndex + 1 < _history.length
                          ? () => setState(() => _historyIndex++)
                          : null,
                      icon: const Icon(Icons.redo),
                      label: const Text('Redo'),
                    ),
                    const Spacer(),
                    FilledButton.icon(
                      onPressed: _saving
                          ? null
                          : () => _save(
                              selected,
                              _historyIndex >= 0
                                  ? _history[_historyIndex]
                                  : selected.layoutData,
                            ),
                      icon: _saving
                          ? const SizedBox(
                              width: 18,
                              height: 18,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : const Icon(Icons.save),
                      label: Text(context.l10n.save),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
      floatingActionButton: plans.value?.isNotEmpty == true
          ? FloatingActionButton(
              onPressed: () => _addLocation(plans.value!.first),
              child: const Icon(Icons.add_location_alt_outlined),
            )
          : null,
    );
  }
}

class _FloorPlanPainter extends CustomPainter {
  _FloorPlanPainter({required this.plan, required this.locations});

  final FloorPlan plan;
  final List<Location> locations;

  @override
  void paint(Canvas canvas, Size size) {
    final background = Paint()..color = const Color(0xFFF8FAFC);
    canvas.drawRect(Offset.zero & size, background);
    final grid = Paint()
      ..color = const Color(0xFFE2E8F0)
      ..strokeWidth = 1;
    final cell = size.width / 20;
    for (var i = 0; i <= 20; i++) {
      canvas.drawLine(Offset(i * cell, 0), Offset(i * cell, size.height), grid);
      canvas.drawLine(Offset(0, i * cell), Offset(size.width, i * cell), grid);
    }
    final rooms =
        (plan.layoutData['rooms'] as List<dynamic>?) ?? const <dynamic>[];
    for (final raw in rooms) {
      final room = Map<String, dynamic>.from(raw as Map);
      final cells = (room['cells'] as List<dynamic>?) ?? const <dynamic>[];
      final roomPaint = Paint()
        ..color = _color(room['color'] as String? ?? '#DBEAFE')
            .withValues(alpha: .55);
      for (final rawCell in cells) {
        final parts = rawCell.toString().split(':');
        if (parts.length != 2) continue;
        final row = int.tryParse(parts[0]) ?? 0;
        final col = int.tryParse(parts[1]) ?? 0;
        canvas.drawRect(
          Rect.fromLTWH(col * cell, row * cell, cell, cell),
          roomPaint,
        );
      }
      final first = cells.firstOrNull?.toString().split(':');
      if (first != null && first.length == 2) {
        final row = int.tryParse(first[0]) ?? 0;
        final col = int.tryParse(first[1]) ?? 0;
        TextPainter(
            text: TextSpan(
              text: room['name'] as String? ?? '',
              style: const TextStyle(
                fontSize: 14,
                color: Color(0xFF1E3A8A),
                fontWeight: FontWeight.w700,
              ),
            ),
            textDirection: TextDirection.ltr,
          )
          ..layout()
          ..paint(canvas, Offset(col * cell + 8, row * cell + 8));
      }
    }
    for (final location in locations) {
      final center = Offset(
        location.xRatio * size.width,
        location.yRatio * size.height,
      );
      final marker = Paint()..color = _color(location.iconColor ?? '#2563EB');
      canvas.drawCircle(center, 22, marker);
      final iconPainter = TextPainter(
        text: const TextSpan(
          text: '⌂',
          style: TextStyle(fontSize: 22, color: Colors.white),
        ),
        textDirection: TextDirection.ltr,
      )..layout();
      iconPainter.paint(
        canvas,
        center - Offset(iconPainter.width / 2, iconPainter.height / 2),
      );
      if (location.showLabel) {
        TextPainter(
            text: TextSpan(
              text: location.name,
              style: const TextStyle(
                fontSize: 12,
                color: Color(0xFF0F172A),
                fontWeight: FontWeight.w600,
              ),
            ),
            textDirection: TextDirection.ltr,
          )
          ..layout(maxWidth: 130)
          ..paint(canvas, center + const Offset(-50, 26));
      }
    }
  }

  Color _color(String value) {
    final hex = value.replaceFirst('#', '');
    final parsed = int.tryParse(hex.length == 6 ? 'FF$hex' : hex, radix: 16);
    return parsed == null ? const Color(0xFF2563EB) : Color(parsed);
  }

  @override
  bool shouldRepaint(covariant _FloorPlanPainter oldDelegate) =>
      oldDelegate.plan != plan || oldDelegate.locations != locations;
}

Future<String?> _askText(
  BuildContext context, {
  required String title,
  required String label,
  required String initial,
}) async {
  final controller = TextEditingController(text: initial);
  final result = await showDialog<String>(
    context: context,
    builder: (context) => AlertDialog(
      title: Text(title),
      content: TextField(
        controller: controller,
        autofocus: true,
        decoration: InputDecoration(labelText: label),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(context.l10n.cancel),
        ),
        FilledButton(
          onPressed: () => Navigator.pop(context, controller.text),
          child: Text(context.l10n.save),
        ),
      ],
    ),
  );
  controller.dispose();
  return result;
}

extension<T> on Iterable<T> {
  T? get firstOrNull => isEmpty ? null : first;
}
