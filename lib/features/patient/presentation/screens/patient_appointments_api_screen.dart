import 'package:flutter/material.dart';

import '../../../../core/design_system/app_colors.dart';
import '../../../../core/design_system/widgets/app_state_view.dart';
import '../../../../core/design_system/widgets/app_top_bar.dart';
import '../../../../core/design_system/widgets/mobile_frame.dart';
import '../../../../core/models/appointment.dart';
import '../../../../data/repositories/appointment_repository.dart';
import '../../../appointments/presentation/widgets/appointment_ui.dart';

class PatientAppointmentsApiScreen extends StatefulWidget {
  const PatientAppointmentsApiScreen({
    required this.repository,
    required this.onBack,
    required this.onBook,
    super.key,
  });

  final AppointmentRepository repository;
  final VoidCallback onBack;
  final VoidCallback onBook;

  @override
  State<PatientAppointmentsApiScreen> createState() =>
      _PatientAppointmentsApiScreenState();
}

class _PatientAppointmentsApiScreenState
    extends State<PatientAppointmentsApiScreen> {
  AppViewState _state = AppViewState.loading;
  List<AppointmentRecord> _appointments = const [];

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
                  title: 'Lịch hẹn của tôi',
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
                  emptyMessage: 'Bạn chưa có lịch hẹn nào.',
                  onRetry: _load,
                  child: ListView.separated(
                    padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
                    itemCount: _appointments.length,
                    separatorBuilder: (_, _) => const SizedBox(height: 12),
                    itemBuilder: (context, index) =>
                        _AppointmentCard(appointment: _appointments[index]),
                  ),
                ),
              ),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: widget.onBook,
          icon: const Icon(Icons.add_rounded),
          label: const Text('Đặt lịch'),
        ),
      ),
    );
  }

  Future<void> _load() async {
    setState(() => _state = AppViewState.loading);
    try {
      final appointments = await widget.repository.forPatient(
        'patient-tuan-tu',
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
}

class _AppointmentCard extends StatelessWidget {
  const _AppointmentCard({required this.appointment});

  final AppointmentRecord appointment;

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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const CircleAvatar(
                backgroundColor: AppColors.soft,
                child: Icon(
                  Icons.medical_services_outlined,
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      appointment.doctorName,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    Text(
                      appointment.specialtyName,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          AppointmentStatusChip(status: appointment.status),
          const SizedBox(height: 12),
          _Meta(
            icon: Icons.schedule_rounded,
            text: appointmentDate(appointment.dateTime),
          ),
          _Meta(icon: Icons.location_on_outlined, text: appointment.hospital),
          _Meta(
            icon: Icons.payments_outlined,
            text: appointmentFee(appointment.fee),
          ),
          if (appointment.status == AppointmentStatus.pending) ...[
            const SizedBox(height: 8),
            Text(
              'Đang chờ bác sĩ phản hồi. Bạn sẽ thấy trạng thái mới sau khi làm mới.',
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ],
      ),
    );
  }
}

class _Meta extends StatelessWidget {
  const _Meta({required this.icon, required this.text});

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 7),
      child: Row(
        children: [
          Icon(icon, size: 18, color: AppColors.muted),
          const SizedBox(width: 8),
          Expanded(child: Text(text)),
        ],
      ),
    );
  }
}
