import 'package:flutter/material.dart';

import '../../../../core/design_system/app_colors.dart';
import '../../../../core/design_system/widgets/app_button.dart';
import '../../../../core/design_system/widgets/app_state_view.dart';
import '../../../../core/design_system/widgets/app_top_bar.dart';
import '../../../../core/design_system/widgets/mobile_frame.dart';
import '../../../../core/models/appointment.dart';
import '../../../../data/repositories/appointment_repository.dart';
import '../../../appointments/presentation/widgets/appointment_ui.dart';

class DoctorAppointmentsApiScreen extends StatefulWidget {
  const DoctorAppointmentsApiScreen({
    required this.repository,
    required this.onBack,
    super.key,
  });

  final AppointmentRepository repository;
  final VoidCallback onBack;

  @override
  State<DoctorAppointmentsApiScreen> createState() =>
      _DoctorAppointmentsApiScreenState();
}

class _DoctorAppointmentsApiScreenState
    extends State<DoctorAppointmentsApiScreen> {
  AppViewState _state = AppViewState.loading;
  List<AppointmentRecord> _appointments = const [];
  String? _busyId;

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  Widget build(BuildContext context) {
    return MobileFrame(
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: AppTopBar(
                  title: 'Yêu cầu đặt lịch',
                  onBack: widget.onBack,
                  actions: [
                    IconButton(
                      tooltip: 'Làm mới',
                      onPressed: _load,
                      icon: const Icon(Icons.refresh_rounded),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: AppStateView(
                  state: _state,
                  emptyMessage: 'Không có yêu cầu nào đang chờ xác nhận.',
                  onRetry: _load,
                  child: ListView.separated(
                    padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
                    itemCount: _appointments.length,
                    separatorBuilder: (_, _) => const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      final appointment = _appointments[index];
                      return _DoctorAppointmentCard(
                        appointment: appointment,
                        busy: _busyId == appointment.id,
                        onConfirm: () =>
                            _update(appointment, AppointmentStatus.confirmed),
                        onReject: () => _reject(appointment),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _load() async {
    setState(() => _state = AppViewState.loading);
    try {
      final appointments = await widget.repository.forDoctor(
        'doc-nguyen-van-minh',
        status: AppointmentStatus.pending,
      );
      if (!mounted) return;
      setState(() {
        _appointments = appointments;
        _state = appointments.isEmpty
            ? AppViewState.empty
            : AppViewState.content;
      });
    } catch (_) {
      if (mounted) setState(() => _state = AppViewState.error);
    }
  }

  Future<void> _update(
    AppointmentRecord appointment,
    AppointmentStatus status, {
    String? reason,
  }) async {
    setState(() => _busyId = appointment.id);
    try {
      await widget.repository.updateStatus(
        appointment.id,
        status,
        rejectionReason: reason,
      );
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            status == AppointmentStatus.confirmed
                ? 'Đã xác nhận lịch khám cho ${appointment.patientName}.'
                : 'Đã từ chối yêu cầu đặt lịch.',
          ),
          backgroundColor: AppColors.success,
        ),
      );
      await _load();
    } on ApiException catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(error.message),
          backgroundColor: AppColors.danger,
        ),
      );
    } finally {
      if (mounted) setState(() => _busyId = null);
    }
  }

  Future<void> _reject(AppointmentRecord appointment) async {
    final controller = TextEditingController();
    String? errorText;
    final reason = await showDialog<String>(
      context: context,
      builder: (dialogContext) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: const Text('Từ chối lịch hẹn'),
          content: TextField(
            controller: controller,
            maxLines: 3,
            decoration: InputDecoration(
              labelText: 'Lý do từ chối',
              errorText: errorText,
              alignLabelWithHint: true,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: const Text('Quay lại'),
            ),
            FilledButton(
              onPressed: () {
                if (controller.text.trim().length < 3) {
                  setDialogState(
                    () => errorText = 'Vui lòng nhập ít nhất 3 ký tự.',
                  );
                  return;
                }
                Navigator.of(dialogContext).pop(controller.text.trim());
              },
              style: FilledButton.styleFrom(backgroundColor: AppColors.danger),
              child: const Text('Xác nhận từ chối'),
            ),
          ],
        ),
      ),
    );
    controller.dispose();
    if (reason != null) {
      await _update(appointment, AppointmentStatus.rejected, reason: reason);
    }
  }
}

class _DoctorAppointmentCard extends StatelessWidget {
  const _DoctorAppointmentCard({
    required this.appointment,
    required this.busy,
    required this.onConfirm,
    required this.onReject,
  });

  final AppointmentRecord appointment;
  final bool busy;
  final VoidCallback onConfirm;
  final VoidCallback onReject;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const CircleAvatar(
                backgroundColor: AppColors.soft,
                child: Icon(
                  Icons.person_outline_rounded,
                  color: AppColors.deep,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      appointment.patientName,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    Text(
                      appointmentDate(appointment.dateTime),
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
              AppointmentStatusChip(status: appointment.status),
            ],
          ),
          if (appointment.note?.isNotEmpty ?? false) ...[
            const SizedBox(height: 12),
            Text('Ghi chú: ${appointment.note}'),
          ],
          const SizedBox(height: 16),
          AppButton(
            label: 'Xác nhận lịch khám',
            onPressed: busy ? null : onConfirm,
            isLoading: busy,
          ),
          const SizedBox(height: 8),
          AppButton(
            label: 'Từ chối yêu cầu',
            onPressed: busy ? null : onReject,
            style: AppButtonStyle.secondary,
          ),
        ],
      ),
    );
  }
}
