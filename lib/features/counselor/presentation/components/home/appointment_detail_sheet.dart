import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../domain/entities/appointment_entity.dart';
import '../../providers/counselor_provider.dart';

class AppointmentDetailSheet extends StatefulWidget {
  final AppointmentEntity appointment;
  final String studentName;

  const AppointmentDetailSheet({
    super.key,
    required this.appointment,
    required this.studentName,
  });

  @override
  State<AppointmentDetailSheet> createState() => _AppointmentDetailSheetState();
}

class _AppointmentDetailSheetState extends State<AppointmentDetailSheet> {
  late TextEditingController _motiveController;
  late TextEditingController _observationsController;
  late TextEditingController _agreementController;
  late String _status;
  bool _isEditing = false;
  bool _isLoading = false;

  final List<String> _statusOptions = ['SCHEDULED', 'COMPLETED', 'CANCELLED'];

  @override
  void initState() {
    super.initState();
    _motiveController = TextEditingController(text: widget.appointment.motive);
    _observationsController = TextEditingController(text: widget.appointment.observations ?? '');
    _agreementController = TextEditingController(text: widget.appointment.agreement ?? '');
    _status = widget.appointment.status;
  }

  @override
  void dispose() {
    _motiveController.dispose();
    _observationsController.dispose();
    _agreementController.dispose();
    super.dispose();
  }

  Future<void> _handleUpdate() async {
    setState(() => _isLoading = true);
    final provider = context.read<CounselorProvider>();
    
    final success = await provider.updateAppointment(
      widget.appointment.id,
      {
        'motive': _motiveController.text.trim(),
        'observations': _observationsController.text.trim(),
        'agreement': _agreementController.text.trim(),
        'status': _status,
      },
    );

    if (mounted) {
      setState(() => _isLoading = false);
      if (success) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Cita actualizada correctamente'), backgroundColor: Colors.green),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(provider.errorMessage ?? 'Error al actualizar'), backgroundColor: Colors.redAccent),
        );
      }
    }
  }

  Future<void> _handleDelete() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Eliminar cita'),
        content: const Text('¿Estás seguro de que deseas eliminar esta cita? Esta acción no se puede deshacer.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Cancelar')),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Eliminar'),
          ),
        ],
      ),
    );

    if (confirm == true && mounted) {
      setState(() => _isLoading = true);
      final provider = context.read<CounselorProvider>();
      final success = await provider.deleteAppointment(widget.appointment.id);
      
      if (mounted) {
        setState(() => _isLoading = false);
        if (success) {
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Cita eliminada'), backgroundColor: Colors.orange),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    const primaryColor = Color(0xFF311B92);
    const darkText = Color(0xFF1D1B4B);

    return Container(
      height: 0.85.sh,
      padding: EdgeInsets.all(24.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(32.r)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                _isEditing ? 'Editar Cita' : 'Detalle de la Cita',
                style: TextStyle(fontSize: 22.sp, fontWeight: FontWeight.w900, color: darkText),
              ),
              if (!_isEditing)
                IconButton(
                  onPressed: () => setState(() => _isEditing = true),
                  icon: const Icon(Icons.edit_outlined, color: primaryColor),
                ),
            ],
          ),
          SizedBox(height: 20.h),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _infoTile(Icons.person_outline, 'Alumno', widget.studentName),
                  _infoTile(
                    Icons.calendar_today_outlined,
                    'Fecha',
                    DateFormat("EEEE d 'de' MMMM, yyyy", 'es_MX').format(widget.appointment.sessionDate.toLocal()),
                  ),
                  _infoTile(
                    Icons.access_time,
                    'Hora',
                    DateFormat("hh:mm a").format(widget.appointment.sessionDate.toLocal()),
                  ),
                  const Divider(height: 32),
                  if (!_isEditing) ...[
                    _dataSection('Motivo', widget.appointment.motive),
                    _dataSection('Observaciones', widget.appointment.observations ?? 'Sin observaciones'),
                    _dataSection('Acuerdos', widget.appointment.agreement ?? 'Sin acuerdos registrados'),
                    _statusBadge(_status),
                  ] else ...[
                    _editField('Motivo', _motiveController),
                    _editField('Observaciones', _observationsController, maxLines: 3),
                    _editField('Acuerdos', _agreementController, maxLines: 3),
                    SizedBox(height: 16.h),
                    Text('Estado', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14.sp)),
                    DropdownButtonFormField<String>(
                      value: _status,
                      items: _statusOptions.map((s) => DropdownMenuItem(value: s, child: Text(s))).toList(),
                      onChanged: (val) => setState(() => _status = val!),
                      decoration: InputDecoration(border: OutlineInputBorder(borderRadius: BorderRadius.circular(12.r))),
                    ),
                  ],
                ],
              ),
            ),
          ),
          SizedBox(height: 20.h),
          if (_isEditing)
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => setState(() => _isEditing = false),
                    style: OutlinedButton.styleFrom(
                      minimumSize: Size.fromHeight(50.h),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
                    ),
                    child: const Text('Cancelar'),
                  ),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _handleUpdate,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryColor,
                      foregroundColor: Colors.white,
                      minimumSize: Size.fromHeight(50.h),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
                    ),
                    child: _isLoading ? const CircularProgressIndicator(color: Colors.white) : const Text('Guardar'),
                  ),
                ),
              ],
            )
          else
            Row(
              children: [
                Expanded(
                  child: TextButton.icon(
                    onPressed: _isLoading ? null : _handleDelete,
                    icon: const Icon(Icons.delete_outline, color: Colors.red),
                    label: const Text('Eliminar Cita', style: TextStyle(color: Colors.red)),
                    style: TextButton.styleFrom(minimumSize: Size.fromHeight(50.h)),
                  ),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryColor,
                      foregroundColor: Colors.white,
                      minimumSize: Size.fromHeight(50.h),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
                    ),
                    child: const Text('Cerrar'),
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }

  Widget _infoTile(IconData icon, String label, String value) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12.h),
      child: Row(
        children: [
          Icon(icon, size: 20.sp, color: Colors.grey[600]),
          SizedBox(width: 12.w),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: TextStyle(fontSize: 11.sp, color: Colors.grey[600])),
              Text(value, style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.bold)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _dataSection(String title, String content) {
    return Padding(
      padding: EdgeInsets.only(bottom: 16.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13.sp, color: Colors.grey[700])),
          SizedBox(height: 4.h),
          Text(content, style: TextStyle(fontSize: 14.sp)),
        ],
      ),
    );
  }

  Widget _editField(String label, TextEditingController controller, {int maxLines = 1}) {
    return Padding(
      padding: EdgeInsets.only(bottom: 16.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14.sp)),
          SizedBox(height: 8.h),
          TextField(
            controller: controller,
            maxLines: maxLines,
            decoration: InputDecoration(
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12.r)),
              filled: true,
              fillColor: Colors.grey[50],
            ),
          ),
        ],
      ),
    );
  }

  Widget _statusBadge(String status) {
    Color bg;
    Color text;
    switch (status) {
      case 'COMPLETED':
        bg = Colors.green[50]!;
        text = Colors.green[800]!;
        break;
      case 'CANCELLED':
        bg = Colors.red[50]!;
        text = Colors.red[800]!;
        break;
      default:
        bg = Colors.blue[50]!;
        text = Colors.blue[800]!;
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
      decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(8.r)),
      child: Text(status, style: TextStyle(color: text, fontWeight: FontWeight.bold, fontSize: 12.sp)),
    );
  }
}

void showAppointmentDetailSheet(BuildContext context, AppointmentEntity appointment, String studentName) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (_) => AppointmentDetailSheet(appointment: appointment, studentName: studentName),
  );
}
