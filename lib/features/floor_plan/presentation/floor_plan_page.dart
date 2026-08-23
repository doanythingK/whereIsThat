import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/localization/app_localizations.dart';
import '../../../core/data/repository_providers.dart';
import '../../../core/models/app_models.dart';
import '../../item/presentation/item_editor_sheet.dart';

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
  String _editMode = 'location';

  Future<void> _showLocationActions(Location location) async {
    final action = await showModalBottomSheet<String>(
      context: context,
      builder: (context) => SafeArea(
        child: Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.edit_outlined),
              title: const Text('위치 이름 수정'),
              onTap: () => Navigator.pop(context, 'edit'),
            ),
            ListTile(
              leading: const Icon(Icons.inventory_2_outlined),
              title: const Text('이 위치에 물건 등록'),
              onTap: () => Navigator.pop(context, 'item'),
            ),
            ListTile(
              leading: const Icon(Icons.delete_outline),
              title: Text(context.l10n.delete),
              onTap: () => Navigator.pop(context, 'delete'),
            ),
          ],
        ),
      ),
    );
    if (!mounted) return;
    if (action == 'edit') {
      final name = await _askText(
        context,
        title: '위치 이름 수정',
        label: context.l10n.locationName,
        initial: location.name,
      );
      if (name == null || name.trim().isEmpty) return;
      try {
        await ref
            .read(workspaceActionsProvider)
            .saveLocation(location.copyWith(name: name.trim()), isNew: false);
      } catch (error) {
        if (mounted) {
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text(error.toString())));
        }
      }
    } else if (action == 'item') {
      await showModalBottomSheet<void>(
        context: context,
        isScrollControlled: true,
        builder: (_) => ItemEditorSheet(
          spaceId: location.spaceId,
          initialLocationId: location.id,
        ),
      );
      ref.invalidate(itemsProvider((spaceId: location.spaceId, search: null)));
    } else if (action == 'delete') {
      await ref.read(workspaceActionsProvider).deleteLocation(location);
    }
  }

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

  void _toggleGridCell(FloorPlan plan, double x, double y) {
    final grid = Map<String, dynamic>.from(
      (plan.layoutData['grid'] as Map?) ?? const {'rows': 20, 'cols': 20},
    );
    final rows = (grid['rows'] as num?)?.toInt() ?? 20;
    final cols = (grid['cols'] as num?)?.toInt() ?? 20;
    final row = (y.clamp(0.0, .999999) * rows).floor();
    final col = (x.clamp(0.0, .999999) * cols).floor();
    final key = '$row:$col';
    final updated = Map<String, dynamic>.from(plan.layoutData);
    final field = _editMode == 'cell' ? 'activeCells' : 'walls';
    final values = ((updated[field] as List<dynamic>?) ?? const <dynamic>[])
        .map((value) => value.toString())
        .toList();
    if (values.contains(key)) {
      values.remove(key);
    } else {
      values.add(key);
    }
    updated[field] = values;
    _pushHistory(updated);
  }

  Future<void> _expandGrid(FloorPlan plan) async {
    final grid = Map<String, dynamic>.from(
      (plan.layoutData['grid'] as Map?) ?? const {'rows': 20, 'cols': 20},
    );
    final rowsController = TextEditingController(
      text: ((grid['rows'] as num?)?.toInt() ?? 20).toString(),
    );
    final colsController = TextEditingController(
      text: ((grid['cols'] as num?)?.toInt() ?? 20).toString(),
    );
    final result = await showDialog<(int, int)?>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('그리드 크기'),
        content: Row(
          children: [
            Expanded(
              child: TextField(
                controller: rowsController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: '세로'),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: TextField(
                controller: colsController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: '가로'),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(context.l10n.cancel),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, (
              int.tryParse(rowsController.text) ?? 20,
              int.tryParse(colsController.text) ?? 20,
            )),
            child: Text(context.l10n.save),
          ),
        ],
      ),
    );
    rowsController.dispose();
    colsController.dispose();
    if (result == null) return;
    final rows = result.$1.clamp(4, 60);
    final cols = result.$2.clamp(4, 60);
    final updated = Map<String, dynamic>.from(plan.layoutData);
    updated['grid'] = {'rows': rows, 'cols': cols};
    _pushHistory(updated);
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
                      onPressed: () => _expandGrid(selected),
                      tooltip: '그리드 크기',
                      icon: const Icon(Icons.grid_4x4),
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
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: SegmentedButton<String>(
                  segments: const [
                    ButtonSegment(
                      value: 'location',
                      icon: Icon(Icons.location_on_outlined),
                      label: Text('위치'),
                    ),
                    ButtonSegment(
                      value: 'cell',
                      icon: Icon(Icons.grid_on),
                      label: Text('영역'),
                    ),
                    ButtonSegment(
                      value: 'wall',
                      icon: Icon(Icons.border_all),
                      label: Text('벽'),
                    ),
                  ],
                  selected: {_editMode},
                  onSelectionChanged: (value) =>
                      setState(() => _editMode = value.first),
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
                            if (_editMode != 'location') {
                              _toggleGridCell(selected, x, y);
                              return;
                            }
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
                              _showLocationActions(hit.single);
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
                                          onTap: () {
                                            Navigator.pop(context);
                                            _showLocationActions(location);
                                          },
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
    final gridData = (plan.layoutData['grid'] as Map?) ?? const {};
    final rows = (gridData['rows'] as num?)?.toInt() ?? 20;
    final cols = (gridData['cols'] as num?)?.toInt() ?? 20;
    final cellWidth = size.width / cols;
    final cellHeight = size.height / rows;
    for (var i = 0; i <= cols; i++) {
      canvas.drawLine(
        Offset(i * cellWidth, 0),
        Offset(i * cellWidth, size.height),
        grid,
      );
    }
    for (var i = 0; i <= rows; i++) {
      canvas.drawLine(
        Offset(0, i * cellHeight),
        Offset(size.width, i * cellHeight),
        grid,
      );
    }
    final activeCells =
        ((plan.layoutData['activeCells'] as List<dynamic>?) ??
                const <dynamic>[])
            .map((value) => value.toString())
            .toSet();
    final activePaint = Paint()..color = const Color(0xFFE0F2FE);
    for (final key in activeCells) {
      final parts = key.split(':');
      if (parts.length != 2) continue;
      final row = int.tryParse(parts[0]);
      final col = int.tryParse(parts[1]);
      if (row == null || col == null || row >= rows || col >= cols) continue;
      canvas.drawRect(
        Rect.fromLTWH(col * cellWidth, row * cellHeight, cellWidth, cellHeight),
        activePaint,
      );
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
          Rect.fromLTWH(
            col * cellWidth,
            row * cellHeight,
            cellWidth,
            cellHeight,
          ),
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
          ..paint(canvas, Offset(col * cellWidth + 8, row * cellHeight + 8));
      }
    }
    final wallPaint = Paint()
      ..color = const Color(0xFF334155)
      ..strokeWidth = 4;
    final walls =
        ((plan.layoutData['walls'] as List<dynamic>?) ?? const <dynamic>[]).map(
          (value) => value.toString(),
        );
    for (final key in walls) {
      final parts = key.split(':');
      if (parts.length != 2) continue;
      final row = int.tryParse(parts[0]);
      final col = int.tryParse(parts[1]);
      if (row == null || col == null || row >= rows || col >= cols) continue;
      canvas.drawRect(
        Rect.fromLTWH(
          col * cellWidth + 1,
          row * cellHeight + 1,
          cellWidth - 2,
          cellHeight - 2,
        ),
        wallPaint,
      );
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
