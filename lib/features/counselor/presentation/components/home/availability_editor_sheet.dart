import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../../domain/entities/availability_slot_entity.dart';
import '../../providers/counselor_provider.dart';


const _primary = Color(0xFF311B92);
const _days = <int, String>{
  1: 'Lunes',
  2: 'Martes',
  3: 'Miércoles',
  4: 'Jueves',
  5: 'Viernes',
  6: 'Sábado',
  0: 'Domingo',
};

class AvailabilityEditorSheet extends StatefulWidget {
  const AvailabilityEditorSheet({super.key});

  @override
  State<AvailabilityEditorSheet> createState() =>
      _AvailabilityEditorSheetState();
}

class _AvailabilityEditorSheetState
    extends State<AvailabilityEditorSheet> {
  late List<AvailabilitySlotEntity> _slots;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    _slots = List.of(
      context.read<CounselorProvider>().availability,
    );
  }

  Future<void> _addSlot() async {
    var day = 1;
    var start = const TimeOfDay(hour: 8, minute: 0);
    var end = const TimeOfDay(hour: 12, minute: 0);

    final result = await showDialog<AvailabilitySlotEntity>(
      context: context,
      builder: (dialogContext) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: const Text('Agregar horario'),
          // =====================================================
          // FIX: bug conocido de Flutter (>=3.32) donde un
          // DropdownButtonFormField dentro del `content` de un
          // AlertDialog provoca fallos en el cálculo de layout
          // "dry" (computeDryBaseline / IntrinsicWidth), que en
          // cascada dispara asserts de semántica repetidos
          // ('!semantics.parentDataDirty',
          // '!childSemantics.renderObject._needsLayout').
          // Reporte oficial: https://github.com/flutter/flutter/issues/169214
          //
          // Workaround: forzar un ancho fijo con SizedBox para
          // que Flutter no necesite calcular el ancho intrínseco
          // del contenido (que es donde falla el cálculo dry).
          // =====================================================
          content: SizedBox(
            width: 300.w,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                DropdownButtonFormField<int>(
                  value: day,
                  decoration: const InputDecoration(
                    labelText: 'Día de la semana',
                  ),
                  items: _days.entries
                      .map(
                        (item) => DropdownMenuItem(
                      value: item.key,
                      child: Text(item.value),
                    ),
                  )
                      .toList(),
                  onChanged: (value) {
                    if (value != null) {
                      setDialogState(() => day = value);
                    }
                  },
                ),
                SizedBox(height: 14.h),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: const Icon(Icons.login_rounded),
                  title: const Text('Hora de inicio'),
                  trailing: Text(start.format(context)),
                  onTap: () async {
                    final value = await showTimePicker(
                      context: context,
                      initialTime: start,
                    );
                    if (value != null) {
                      setDialogState(() => start = value);
                    }
                  },
                ),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: const Icon(Icons.logout_rounded),
                  title: const Text('Hora de fin'),
                  trailing: Text(end.format(context)),
                  onTap: () async {
                    final value = await showTimePicker(
                      context: context,
                      initialTime: end,
                    );
                    if (value != null) {
                      setDialogState(() => end = value);
                    }
                  },
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('Cancelar'),
            ),
            FilledButton(
              onPressed: () {
                final startMinutes = start.hour * 60 + start.minute;
                final endMinutes = end.hour * 60 + end.minute;
                if (startMinutes >= endMinutes) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                        'La hora final debe ser posterior a la inicial.',
                      ),
                    ),
                  );
                  return;
                }
                Navigator.pop(
                  dialogContext,
                  AvailabilitySlotEntity(
                    dayOfWeek: day,
                    startTime: _formatTime(start),
                    endTime: _formatTime(end),
                  ),
                );
              },
              child: const Text('Agregar'),
            ),
          ],
        ),
      ),
    );

    if (result != null) {
      setState(() {
        _slots.add(result);
        _slots.sort((a, b) {
          final day = a.dayOfWeek.compareTo(b.dayOfWeek);
          return day != 0 ? day : a.startTime.compareTo(b.startTime);
        });
      });
    }
  }

  Future<void> _save() async {
    setState(() => _saving = true);
    final provider = context.read<CounselorProvider>();
    final ok = await provider.saveAvailability(_slots);
    if (!mounted) return;
    setState(() => _saving = false);

    if (ok) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Disponibilidad guardada correctamente.'),
          backgroundColor: Colors.green,
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            provider.errorMessage ??
                'No fue posible guardar la disponibilidad.',
          ),
          backgroundColor: Colors.redAccent,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Container(
        constraints: BoxConstraints(maxHeight: .86.sh),
        padding: EdgeInsets.fromLTRB(20.w, 12.h, 20.w, 22.h),
        decoration: BoxDecoration(
          color: const Color(0xFFF8F9FE),
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(28.r),
          ),
        ),
        child: Column(
          children: [
            Container(
              width: 44.w,
              height: 5.h,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(8.r),
              ),
            ),
            SizedBox(height: 18.h),
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Mi disponibilidad',
                        style: TextStyle(
                          fontSize: 20.sp,
                          fontWeight: FontWeight.w900,
                          color: const Color(0xFF17164A),
                        ),
                      ),
                      Text(
                        'Define los horarios en que puedes atender citas.',
                        style: TextStyle(
                          fontSize: 11.sp,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton.filled(
                  onPressed: _addSlot,
                  style: IconButton.styleFrom(
                    backgroundColor: _primary,
                  ),
                  icon: const Icon(Icons.add_rounded),
                ),
              ],
            ),
            SizedBox(height: 16.h),
            Expanded(
              child: _slots.isEmpty
                  ? Center(
                child: Text(
                  'Aún no tienes horarios configurados.',
                  style: TextStyle(color: Colors.grey.shade600),
                ),
              )
                  : ListView.separated(
                itemCount: _slots.length,
                separatorBuilder: (_, __) =>
                    SizedBox(height: 10.h),
                itemBuilder: (_, index) {
                  final slot = _slots[index];
                  return Container(
                    padding: EdgeInsets.all(14.w),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16.r),
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.schedule_rounded,
                          color: _primary,
                        ),
                        SizedBox(width: 12.w),
                        Expanded(
                          child: Column(
                            crossAxisAlignment:
                            CrossAxisAlignment.start,
                            children: [
                              Text(
                                _days[slot.dayOfWeek] ?? 'Día',
                                style: const TextStyle(
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                              Text(
                                '${slot.startTime} – ${slot.endTime}',
                              ),
                            ],
                          ),
                        ),
                        IconButton(
                          tooltip: 'Eliminar bloque',
                          onPressed: () {
                            setState(() => _slots.removeAt(index));
                          },
                          icon: const Icon(
                            Icons.delete_outline,
                            color: Colors.redAccent,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            SizedBox(height: 14.h),
            SizedBox(
              width: double.infinity,
              height: 52.h,
              child: FilledButton(
                onPressed: _saving ? null : _save,
                style: FilledButton.styleFrom(
                  backgroundColor: _primary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.r),
                  ),
                ),
                child: _saving
                    ? const CircularProgressIndicator(
                  color: Colors.white,
                )
                    : const Text('Guardar disponibilidad'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  static String _formatTime(TimeOfDay value) {
    return '${value.hour.toString().padLeft(2, '0')}:'
        '${value.minute.toString().padLeft(2, '0')}';
  }
}

void showAvailabilityEditorSheet(BuildContext context) {
  showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (_) => const AvailabilityEditorSheet(),
  );
}