import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/localization/app_localizations.dart';
import '../../../core/data/repository_providers.dart';
import '../../../core/errors/app_exception.dart';
import '../../../core/models/app_models.dart';
import '../../../core/services/app_services.dart';
import '../../item/presentation/item_editor_sheet.dart';

int _gridDimension(Object? value) {
  final dimension = value is num ? value.toInt() : 20;
  return dimension.clamp(4, 60).toInt();
}

({int rows, int cols}) _gridDimensions(Map<String, dynamic> layoutData) {
  final grid = layoutData['grid'];
  return (
    rows: _gridDimension(grid is Map ? grid['rows'] : null),
    cols: _gridDimension(grid is Map ? grid['cols'] : null),
  );
}

List<dynamic> _layoutList(Object? value) =>
    value is List ? value.cast<dynamic>() : const <dynamic>[];

Map<String, dynamic>? _layoutMap(Object? value) =>
    value is Map ? Map<String, dynamic>.from(value) : null;

class FloorPlanPage extends ConsumerStatefulWidget {
  const FloorPlanPage({required this.spaceId, this.focusLocationId, super.key});

  final String spaceId;
  final String? focusLocationId;

  @override
  ConsumerState<FloorPlanPage> createState() => _FloorPlanPageState();
}

class _FloorPlanPageState extends ConsumerState<FloorPlanPage> {
  static const _sceneSize = Size(600, 600);

  String? _selectedPlanId;
  final List<Map<String, dynamic>> _history = [];
  int _historyIndex = -1;
  String? _historyPlanId;
  bool _saving = false;
  String _editMode = 'location';
  bool _hasUserSelectedPlan = false;
  final _transformationController = TransformationController();
  final _viewportKey = GlobalKey();

  bool get _hasUnsavedChanges =>
      _historyPlanId == _selectedPlanId && _historyIndex >= 0;

  ({double x, double y})? _normalizedPosition(TapUpDetails details) {
    final renderObject = _viewportKey.currentContext?.findRenderObject();
    if (renderObject is! RenderBox) return null;

    // The painter renders scene coordinates, while the raw tap is in the
    // viewport. Convert through the same controller used by InteractiveViewer.
    final viewportPosition = renderObject.globalToLocal(details.globalPosition);
    final scenePosition = _transformationController.toScene(viewportPosition);
    if (scenePosition.dx < 0 ||
        scenePosition.dy < 0 ||
        scenePosition.dx > _sceneSize.width ||
        scenePosition.dy > _sceneSize.height) {
      return null;
    }
    return (
      x: (scenePosition.dx / _sceneSize.width).clamp(0.0, 1.0).toDouble(),
      y: (scenePosition.dy / _sceneSize.height).clamp(0.0, 1.0).toDouble(),
    );
  }

  @override
  void dispose() {
    _transformationController.dispose();
    super.dispose();
  }

  Future<void> _showLocationActions(Location location) async {
    final action = await showModalBottomSheet<String>(
      context: context,
      builder: (context) => SafeArea(
        child: Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.edit_outlined),
              title: Text(context.l10n.renameLocation),
              onTap: () => Navigator.pop(context, 'edit'),
            ),
            ListTile(
              leading: const Icon(Icons.inventory_2_outlined),
              title: Text(context.l10n.addItemAtLocation),
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
      final details = await _askLocation(
        context,
        title: context.l10n.renameLocation,
        initial: location.name,
        location: location,
      );
      if (details == null || details.name.trim().isEmpty) return;
      if (!mounted) return;
      try {
        await ref
            .read(workspaceActionsProvider)
            .saveLocation(
              location.copyWith(
                name: details.name.trim(),
                locationType: details.type,
                iconKey: details.iconKey,
                iconColor: details.color,
                showLabel: details.showLabel,
              ),
              isNew: false,
            );
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
      if (mounted) {
        ref.invalidate(itemsProvider((spaceId: location.spaceId, search: null)));
      }
    } else if (action == 'delete') {
      try {
        await ref.read(workspaceActionsProvider).deleteLocation(location);
      } catch (error) {
        if (mounted) {
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text(error.toString())));
        }
      }
    }
  }

  Future<void> _createPlan() async {
    final name = await _askText(
      context,
      title: context.l10n.floorPlanAdd,
      label: context.l10n.floorPlanName,
      initial: context.l10n.newFloorPlan,
    );
    if (name == null || name.trim().isEmpty) return;
    if (!mounted) return;
    try {
      await ref
          .read(workspaceActionsProvider)
          .createFloorPlan(spaceId: widget.spaceId, name: name.trim());
    } catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(error.toString())));
      }
    }
  }

  Future<void> _addLocation(
    FloorPlan plan, {
    double x = .5,
    double y = .5,
  }) async {
    final details = await _askLocation(
      context,
      title: context.l10n.addLocation,
      initial: context.l10n.defaultLocationName,
    );
    if (details == null || details.name.trim().isEmpty) return;
    if (!mounted) return;
    final now = DateTime.now().toUtc();
    try {
      await ref
          .read(workspaceActionsProvider)
          .saveLocation(
            Location(
              id: '',
              spaceId: plan.spaceId,
              floorPlanId: plan.id,
              roomKey: _roomAt(plan, x, y),
              name: details.name.trim(),
              locationType: details.type,
              iconKey: details.iconKey,
              iconColor: details.color,
              showLabel: details.showLabel,
              xRatio: x.clamp(0.0, 1.0).toDouble(),
              yRatio: y.clamp(0.0, 1.0).toDouble(),
              createdBy:
                  ref.read(appRepositoryProvider).signedInUser?.id ??
                  'demo-user',
              createdAt: now,
              updatedAt: now,
            ),
            isNew: true,
          );
    } catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(error.toString())));
      }
    }
  }

  String? _roomAt(FloorPlan plan, double x, double y) {
    final dimensions = _gridDimensions(plan.layoutData);
    final rows = dimensions.rows;
    final cols = dimensions.cols;
    final row = (y.clamp(0.0, .999999) * rows).floor();
    final col = (x.clamp(0.0, .999999) * cols).floor();
    final key = '$row:$col';
    final rooms = _layoutList(plan.layoutData['rooms']);
    for (final raw in rooms) {
      final room = _layoutMap(raw);
      if (room == null) continue;
      final cells = _layoutList(room['cells']);
      if (cells.any((cell) => cell.toString() == key)) {
        final roomId = room['id'];
        return roomId is String ? roomId : null;
      }
    }
    return null;
  }

  Future<void> _addRoom(FloorPlan plan) async {
    final currentRooms = <Map<String, dynamic>>[];
    for (final raw in _layoutList(plan.layoutData['rooms'])) {
      final room = _layoutMap(raw);
      if (room != null) currentRooms.add(room);
    }
    final selectedCells = _layoutList(plan.layoutData['activeCells'])
        .map((cell) => cell.toString())
        .toSet();
    if (selectedCells.isEmpty) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(context.l10n.roomAreaPrompt)));
      return;
    }
    final occupiedCells = currentRooms
        .expand(
          (room) => _layoutList(room['cells']).map((cell) => cell.toString()),
        )
        .toSet();
    if (selectedCells.any(occupiedCells.contains)) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(context.l10n.roomOverlap)));
      return;
    }
    final room = await _askRoom(
      context,
      initialName: context.l10n.defaultRoomName,
    );
    if (room == null || room.name.trim().isEmpty) return;
    if (!mounted) return;
    final roomId = 'room-${DateTime.now().microsecondsSinceEpoch}';
    final updated = Map<String, dynamic>.from(plan.layoutData);
    currentRooms.add({
      'id': roomId,
      'name': room.name.trim(),
      'color': room.color,
      'cells': selectedCells.toList(),
    });
    updated['rooms'] = currentRooms;
    _pushHistory(updated, plan.id);
  }

  void _pushHistory(Map<String, dynamic> layout, String planId) {
    setState(() {
      if (_historyPlanId != planId) {
        _history.clear();
        _historyIndex = -1;
        _historyPlanId = planId;
      }
      if (_historyIndex + 1 < _history.length) {
        _history.removeRange(_historyIndex + 1, _history.length);
      }
      _history.add(layout);
      _historyIndex = _history.length - 1;
    });
  }

  void _toggleGridCell(FloorPlan plan, double x, double y) {
    final dimensions = _gridDimensions(plan.layoutData);
    final rows = dimensions.rows;
    final cols = dimensions.cols;
    final row = (y.clamp(0.0, .999999) * rows).floor();
    final col = (x.clamp(0.0, .999999) * cols).floor();
    final key = '$row:$col';
    final updated = Map<String, dynamic>.from(plan.layoutData);
    final field = _editMode == 'cell' ? 'activeCells' : 'walls';
    final values = _layoutList(updated[field])
        .map((value) => value.toString())
        .toList();
    if (values.contains(key)) {
      values.remove(key);
    } else {
      values.add(key);
    }
    updated[field] = values;
    _pushHistory(updated, plan.id);
  }

  Future<void> _expandGrid(FloorPlan plan) async {
    final dimensions = _gridDimensions(plan.layoutData);
    final rowsController = TextEditingController(
      text: dimensions.rows.toString(),
    );
    final colsController = TextEditingController(
      text: dimensions.cols.toString(),
    );
    final result = await showDialog<(int, int)?>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(context.l10n.gridSize),
        content: Row(
          children: [
            Expanded(
              child: TextField(
                controller: rowsController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(labelText: context.l10n.rows),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: TextField(
                controller: colsController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(labelText: context.l10n.columns),
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
    if (result == null || !mounted) return;
    final rows = result.$1.clamp(4, 60);
    final cols = result.$2.clamp(4, 60);
    final updated = Map<String, dynamic>.from(plan.layoutData);
    updated['grid'] = {'rows': rows, 'cols': cols};
    _pushHistory(updated, plan.id);
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
        setState(() {
          _history.clear();
          _historyIndex = -1;
          _historyPlanId = plan.id;
        });
      }
      if (mounted) {
        await AppServices.current.showInterstitialIfAllowed();
      }
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(context.l10n.floorPlanSaved)));
      }
    } catch (error) {
      if (mounted) {
        if (error is ConflictException) {
          final reload = await showDialog<bool>(
            context: context,
            builder: (context) => AlertDialog(
              title: Text(context.l10n.conflictTitle),
              content: Text(context.l10n.conflictBody),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context, false),
                  child: Text(context.l10n.cancel),
                ),
                FilledButton(
                  onPressed: () => Navigator.pop(context, true),
                  child: Text(context.l10n.reloadLatest),
                ),
              ],
            ),
          );
          if (reload == true && mounted) {
            setState(() {
              _history.clear();
              _historyIndex = -1;
              _historyPlanId = null;
            });
            ref.invalidate(floorPlansProvider(widget.spaceId));
          }
        } else {
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text(error.toString())));
        }
      }
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  Future<bool> _confirmDiscardIfNeeded() async {
    if (!_hasUnsavedChanges) return true;
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(context.l10n.unsavedChanges),
        content: Text(context.l10n.discardChangesQuestion),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(context.l10n.cancel),
          ),
          OutlinedButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(context.l10n.discardAndLeave),
          ),
        ],
      ),
    );
    if (result == true && mounted) {
      setState(() {
        _history.clear();
        _historyIndex = -1;
        _historyPlanId = null;
      });
    }
    return result == true;
  }

  Future<void> _selectPlan(String? planId) async {
    if (planId == null || planId == _selectedPlanId) return;
    if (!await _confirmDiscardIfNeeded() || !mounted) return;
    setState(() {
      _selectedPlanId = planId;
      _hasUserSelectedPlan = true;
      _history.clear();
      _historyIndex = -1;
      _historyPlanId = planId;
    });
  }

  Future<void> _deletePlan(FloorPlan plan) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(context.l10n.deleteNamed(plan.name)),
        content: Text(context.l10n.deleteFloorPlanMessage(plan.name)),
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
    if (confirmed != true || !mounted) return;
    if (!await _confirmDiscardIfNeeded() || !mounted) return;
    try {
      await ref.read(workspaceActionsProvider).deleteFloorPlan(plan);
    } catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(error.toString())));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final plans = ref.watch(floorPlansProvider(widget.spaceId));
    AsyncValue<List<Location>>? focusedLocationsState;
    Location? focusedLocation;
    if (widget.focusLocationId != null) {
      focusedLocationsState = ref.watch(
        locationsForSpaceProvider(widget.spaceId),
      );
      final allLocations = focusedLocationsState.value ?? const <Location>[];
      focusedLocation = allLocations
          .where((location) => location.id == widget.focusLocationId)
          .firstOrNull;
    }
    return PopScope(
      canPop: !_hasUnsavedChanges,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) return;
        if (await _confirmDiscardIfNeeded() && context.mounted) {
          Navigator.of(context).pop();
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(context.l10n.floorPlan),
          actions: [
            IconButton(
              onPressed: _createPlan,
              icon: const Icon(Icons.add),
              tooltip: context.l10n.floorPlanAdd,
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
            final focusPlanId = focusedLocation?.floorPlanId;
            final shouldUseFocusedPlan =
                !_hasUserSelectedPlan &&
                !_hasUnsavedChanges &&
                focusedLocationsState?.hasValue == true &&
                focusPlanId != null;
            final selected =
                values
                    .where(
                      (plan) =>
                          plan.id ==
                          (shouldUseFocusedPlan ? focusPlanId : _selectedPlanId),
                    )
                    .firstOrNull ??
                values.first;
            if (_selectedPlanId != selected.id) _selectedPlanId = selected.id;
            final editedLayout =
                _historyPlanId == selected.id && _historyIndex >= 0
                ? _history[_historyIndex]
                : selected.layoutData;
            final displayedPlan = selected.copyWith(layoutData: editedLayout);
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
                          decoration: InputDecoration(
                            labelText: context.l10n.floorPlan,
                          ),
                          items: [
                            for (final plan in values)
                              DropdownMenuItem(
                                value: plan.id,
                                child: Text(plan.name),
                              ),
                          ],
                          onChanged: _selectPlan,
                        ),
                      ),
                      const SizedBox(width: 8),
                      IconButton(
                        onPressed: () => _addRoom(displayedPlan),
                        tooltip: context.l10n.roomAdd,
                        icon: const Icon(Icons.meeting_room_outlined),
                      ),
                      IconButton(
                        onPressed: () => _expandGrid(displayedPlan),
                        tooltip: context.l10n.gridSize,
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
                    segments: [
                      ButtonSegment(
                        value: 'location',
                        icon: Icon(Icons.location_on_outlined),
                        label: Text(context.l10n.locationMode),
                      ),
                      ButtonSegment(
                        value: 'cell',
                        icon: Icon(Icons.grid_on),
                        label: Text(context.l10n.areaMode),
                      ),
                      ButtonSegment(
                        value: 'wall',
                        icon: Icon(Icons.border_all),
                        label: Text(context.l10n.wallMode),
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
                    data: (locationValues) => LayoutBuilder(
                      builder: (context, constraints) => Center(
                        child: SizedBox(
                          key: _viewportKey,
                          width: constraints.maxWidth,
                          height: constraints.maxHeight,
                          child: InteractiveViewer(
                            transformationController: _transformationController,
                            constrained: false,
                            alignment: Alignment.topLeft,
                            minScale: .5,
                            maxScale: 3,
                            boundaryMargin: const EdgeInsets.all(120),
                            child: SizedBox(
                              width: _sceneSize.width,
                              height: _sceneSize.height,
                              child: GestureDetector(
                                onTapUp: (details) {
                                  final normalized = _normalizedPosition(
                                    details,
                                  );
                                  if (normalized == null) return;
                                  final x = normalized.x;
                                  final y = normalized.y;
                                  if (_editMode != 'location') {
                                    _toggleGridCell(displayedPlan, x, y);
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
                                    _addLocation(displayedPlan, x: x, y: y);
                                  }
                                },
                                child: CustomPaint(
                                  size: _sceneSize,
                                  painter: _FloorPlanPainter(
                                    plan: displayedPlan,
                                    locations: locationValues,
                                    focusLocationId: widget.focusLocationId,
                                  ),
                                ),
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
                        label: Text(context.l10n.undo),
                      ),
                      const SizedBox(width: 8),
                      OutlinedButton.icon(
                        onPressed: _historyIndex + 1 < _history.length
                            ? () => setState(() => _historyIndex++)
                            : null,
                        icon: const Icon(Icons.redo),
                        label: Text(context.l10n.redo),
                      ),
                      const Spacer(),
                      FilledButton.icon(
                        onPressed: _saving
                            ? null
                            : () => _save(selected, editedLayout),
                        icon: _saving
                            ? const SizedBox(
                                width: 18,
                                height: 18,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
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
                onPressed: () => _addLocation(
                  plans.value!
                          .where((plan) => plan.id == _selectedPlanId)
                          .firstOrNull ??
                      plans.value!.first,
                ),
                child: const Icon(Icons.add_location_alt_outlined),
              )
            : null,
      ),
    );
  }
}

class _FloorPlanPainter extends CustomPainter {
  _FloorPlanPainter({
    required this.plan,
    required this.locations,
    this.focusLocationId,
  });

  final FloorPlan plan;
  final List<Location> locations;
  final String? focusLocationId;

  @override
  void paint(Canvas canvas, Size size) {
    final background = Paint()..color = const Color(0xFFF8FAFC);
    canvas.drawRect(Offset.zero & size, background);
    final grid = Paint()
      ..color = const Color(0xFFE2E8F0)
      ..strokeWidth = 1;
    final dimensions = _gridDimensions(plan.layoutData);
    final rows = dimensions.rows;
    final cols = dimensions.cols;
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
    final activeCells = _layoutList(plan.layoutData['activeCells'])
        .map((value) => value.toString())
        .toSet();
    final activePaint = Paint()..color = const Color(0xFFE0F2FE);
    for (final key in activeCells) {
      final parts = key.split(':');
      if (parts.length != 2) continue;
      final row = int.tryParse(parts[0]);
      final col = int.tryParse(parts[1]);
      if (row == null ||
          col == null ||
          row < 0 ||
          col < 0 ||
          row >= rows ||
          col >= cols) {
        continue;
      }
      canvas.drawRect(
        Rect.fromLTWH(col * cellWidth, row * cellHeight, cellWidth, cellHeight),
        activePaint,
      );
    }
    final rooms = _layoutList(plan.layoutData['rooms']);
    for (final raw in rooms) {
      final room = _layoutMap(raw);
      if (room == null) continue;
      final cells = _layoutList(room['cells']);
      final roomColor = room['color'];
      final roomPaint = Paint()
        ..color = _color(roomColor is String ? roomColor : '#DBEAFE')
            .withValues(alpha: .55);
      for (final rawCell in cells) {
        final parts = rawCell.toString().split(':');
        if (parts.length != 2) continue;
        final row = int.tryParse(parts[0]) ?? 0;
        final col = int.tryParse(parts[1]) ?? 0;
        if (row < 0 || col < 0 || row >= rows || col >= cols) continue;
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
        if (row < 0 || col < 0 || row >= rows || col >= cols) continue;
        final roomName = room['name'];
        TextPainter(
            text: TextSpan(
              text: roomName is String ? roomName : '',
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
    final walls = _layoutList(plan.layoutData['walls']).map(
      (value) => value.toString(),
    );
    for (final key in walls) {
      final parts = key.split(':');
      if (parts.length != 2) continue;
      final row = int.tryParse(parts[0]);
      final col = int.tryParse(parts[1]);
      if (row == null ||
          col == null ||
          row < 0 ||
          col < 0 ||
          row >= rows ||
          col >= cols) {
        continue;
      }
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
      if (location.id == focusLocationId) {
        canvas.drawCircle(
          center,
          29,
          Paint()
            ..color = const Color(0xFFF59E0B)
            ..style = PaintingStyle.stroke
            ..strokeWidth = 5,
        );
      }
      final icon = switch (location.iconKey) {
        'cabinet' => '▤',
        'closet' => '▥',
        'box' => '□',
        _ => '⌂',
      };
      final iconPainter = TextPainter(
        text: TextSpan(
          text: icon,
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
      oldDelegate.plan != plan ||
      oldDelegate.locations != locations ||
      oldDelegate.focusLocationId != focusLocationId;
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

Future<
  ({String name, String type, String iconKey, String color, bool showLabel})?
>
_askLocation(
  BuildContext context, {
  required String title,
  required String initial,
  Location? location,
}) async {
  final controller = TextEditingController(text: initial);
  const locationKeys = {'shelf', 'cabinet', 'closet', 'box'};
  var type = locationKeys.contains(location?.locationType)
      ? location!.locationType!
      : 'shelf';
  var iconKey = locationKeys.contains(location?.iconKey)
      ? location!.iconKey
      : 'shelf';
  var color = location?.iconColor ?? '#2563EB';
  var showLabel = location?.showLabel ?? true;
  final result =
      await showDialog<
        ({
          String name,
          String type,
          String iconKey,
          String color,
          bool showLabel,
        })?
      >(
        context: context,
        builder: (context) => StatefulBuilder(
          builder: (context, setState) => AlertDialog(
            title: Text(title),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: controller,
                    autofocus: true,
                    decoration: InputDecoration(
                      labelText: context.l10n.locationName,
                    ),
                  ),
                  const SizedBox(height: 12),
                  DropdownButtonFormField<String>(
                    initialValue: type,
                    decoration: InputDecoration(
                      labelText: context.l10n.locationType,
                    ),
                    items: [
                      DropdownMenuItem(
                        value: 'shelf',
                        child: Text(context.l10n.shelfType),
                      ),
                      DropdownMenuItem(
                        value: 'cabinet',
                        child: Text(context.l10n.cabinetType),
                      ),
                      DropdownMenuItem(
                        value: 'closet',
                        child: Text(context.l10n.closetType),
                      ),
                      DropdownMenuItem(
                        value: 'box',
                        child: Text(context.l10n.boxType),
                      ),
                    ],
                    onChanged: (value) => setState(() => type = value ?? type),
                  ),
                  const SizedBox(height: 12),
                  DropdownButtonFormField<String>(
                    initialValue: iconKey,
                    decoration: InputDecoration(
                      labelText: context.l10n.locationIcon,
                    ),
                    items: [
                      DropdownMenuItem(
                        value: 'shelf',
                        child: Text(context.l10n.shelfType),
                      ),
                      DropdownMenuItem(
                        value: 'cabinet',
                        child: Text(context.l10n.cabinetType),
                      ),
                      DropdownMenuItem(
                        value: 'closet',
                        child: Text(context.l10n.closetType),
                      ),
                      DropdownMenuItem(
                        value: 'box',
                        child: Text(context.l10n.boxType),
                      ),
                    ],
                    onChanged: (value) =>
                        setState(() => iconKey = value ?? iconKey),
                  ),
                  SwitchListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text(context.l10n.showLabel),
                    value: showLabel,
                    onChanged: (value) => setState(() => showLabel = value),
                  ),
                  Wrap(
                    spacing: 8,
                    children: [
                      for (final candidate in <String>[
                        '#2563EB',
                        '#16A34A',
                        '#EA580C',
                        '#9333EA',
                      ])
                        ChoiceChip(
                          label: CircleAvatar(
                            radius: 10,
                            backgroundColor: _parseHexColor(candidate),
                          ),
                          selected: color == candidate,
                          onSelected: (_) => setState(() => color = candidate),
                        ),
                    ],
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text(context.l10n.cancel),
              ),
              FilledButton(
                onPressed: () => Navigator.pop(context, (
                  name: controller.text,
                  type: type,
                  iconKey: iconKey,
                  color: color,
                  showLabel: showLabel,
                )),
                child: Text(context.l10n.save),
              ),
            ],
          ),
        ),
      );
  controller.dispose();
  return result;
}

Future<({String name, String color})?> _askRoom(
  BuildContext context, {
  required String initialName,
}) async {
  final controller = TextEditingController(text: initialName);
  var color = '#DBEAFE';
  final result = await showDialog<({String name, String color})>(
    context: context,
    builder: (context) => StatefulBuilder(
      builder: (context, setState) => AlertDialog(
        title: Text(context.l10n.roomAdd),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: controller,
              autofocus: true,
              decoration: InputDecoration(labelText: context.l10n.roomName),
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 8,
              children: [
                for (final candidate in <String>[
                  '#DBEAFE',
                  '#DCFCE7',
                  '#FEF3C7',
                  '#FCE7F3',
                  '#EDE9FE',
                ])
                  ChoiceChip(
                    label: CircleAvatar(
                      radius: 10,
                      backgroundColor: _parseHexColor(candidate),
                    ),
                    selected: color == candidate,
                    onSelected: (_) => setState(() => color = candidate),
                  ),
              ],
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(context.l10n.cancel),
          ),
          FilledButton(
            onPressed: () =>
                Navigator.pop(context, (name: controller.text, color: color)),
            child: Text(context.l10n.save),
          ),
        ],
      ),
    ),
  );
  controller.dispose();
  return result;
}

Color _parseHexColor(String value) {
  final hex = value.replaceFirst('#', '');
  final parsed = int.tryParse('FF$hex', radix: 16);
  return parsed == null ? Colors.blue : Color(parsed);
}

extension<T> on Iterable<T> {
  T? get firstOrNull => isEmpty ? null : first;
}
