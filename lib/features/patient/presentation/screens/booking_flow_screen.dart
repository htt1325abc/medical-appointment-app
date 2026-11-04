import 'package:flutter/material.dart';

import '../../../../core/design_system/app_colors.dart';
import '../../../../core/design_system/widgets/app_button.dart';
import '../../../../core/design_system/widgets/app_state_view.dart';
import '../../../../core/design_system/widgets/app_top_bar.dart';
import '../../../../core/design_system/widgets/mobile_frame.dart';
import '../../../../core/models/appointment.dart';
import '../../../../data/repositories/appointment_repository.dart';
import '../../../appointments/presentation/widgets/appointment_ui.dart';

enum _BookingStep { chooseSlot, review, success }

class BookingFlowScreen extends StatefulWidget {
  const BookingFlowScreen({
    required this.repository,
    required this.onBack,
    required this.onViewAppointments,
    this.initialDate,
    super.key,
  });

  final AppointmentRepository repository;
  final VoidCallback onBack;
  final VoidCallback onViewAppointments;
  final DateTime? initialDate;

  @override
  State<BookingFlowScreen> createState() => _BookingFlowScreenState();
}

class _BookingFlowScreenState extends State<BookingFlowScreen> {
  static const doctorId = 'doc-nguyen-van-minh';
  static const patientId = 'patient-tuan-tu';

  final _noteController = TextEditingController();
  _BookingStep _step = _BookingStep.chooseSlot;
  AppViewState _state = AppViewState.loading;
  late DateTime _date;
  List<AppointmentSlot> _slots = const [];
  AppointmentSlot? _selectedSlot;
  AppointmentRecord? _created;
  bool _submitting = false;

  @override
  void initState() {
    super.initState();
    _date = _nextBookableDate(
      widget.initialDate ?? DateTime.now().add(const Duration(days: 1)),
    );
    _loadSlots();
  }

  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
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
                  title: switch (_step) {
                    _BookingStep.chooseSlot => 'Chọn lịch khám',
                    _BookingStep.review => 'Xác nhận lịch hẹn',
                    _BookingStep.success => 'Đã gửi yêu cầu',
                  },
                  onBack: _handleBack,
                ),
              ),
              Expanded(
                child: switch (_step) {
                  _BookingStep.chooseSlot => AppStateView(
                    state: _state,
                    emptyMessage: 'Bác sĩ chưa có lịch trống trong ngày này.',
                    onRetry: _loadSlots,
                    child: _ChooseSlotBody(
                      date: _date,
                      slots: _slots,
                      selectedSlot: _selectedSlot,
                      onDateSelected: _changeDate,
                      onSlotSelected: (slot) =>
                          setState(() => _selectedSlot = slot),
                    ),
                  ),
                  _BookingStep.review => _ReviewBody(
                    slot: _selectedSlot!,
                    noteController: _noteController,
                  ),
                  _BookingStep.success => _SuccessBody(appointment: _created!),
                },
              ),
              _BottomAction(
                step: _step,
                canContinue: _selectedSlot != null,
                submitting: _submitting,
                onPressed: switch (_step) {
                  _BookingStep.chooseSlot => _review,
                  _BookingStep.review => _submit,
                  _BookingStep.success => widget.onViewAppointments,
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _handleBack() {
    if (_step == _BookingStep.review) {
      setState(() => _step = _BookingStep.chooseSlot);
      return;
    }
    widget.onBack();
  }

  Future<void> _loadSlots() async {
    setState(() => _state = AppViewState.loading);
    try {
      final slots = await widget.repository.getSlots(doctorId, _date);
      if (!mounted) return;
      setState(() {
        _slots = slots;
        _selectedSlot = null;
        _state = slots.any((slot) => slot.available)
            ? AppViewState.content
            : AppViewState.empty;
      });
    } catch (_) {
      if (mounted) setState(() => _state = AppViewState.error);
    }
  }

  void _changeDate(DateTime date) {
    _date = date;
    _loadSlots();
  }

  void _review() {
    if (_selectedSlot == null) return;
    setState(() => _step = _BookingStep.review);
  }

  Future<void> _submit() async {
    setState(() => _submitting = true);
    try {
      final created = await widget.repository.create(
        patientId: patientId,
        doctorId: doctorId,
        dateTime: _selectedSlot!.dateTime,
        note: _noteController.text,
      );
      if (!mounted) return;
      setState(() {
        _created = created;
        _step = _BookingStep.success;
      });
    } on ApiException catch (error) {
      if (!mounted) return;
      if (error.statusCode == 409) {
        setState(() => _step = _BookingStep.chooseSlot);
        await _loadSlots();
      }
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(error.message),
          backgroundColor: AppColors.danger,
        ),
      );
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Không thể gửi yêu cầu. Kiểm tra máy chủ rồi thử lại.'),
          backgroundColor: AppColors.danger,
        ),
      );
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }
}

class _ChooseSlotBody extends StatelessWidget {
  const _ChooseSlotBody({
    required this.date,
    required this.slots,
    required this.selectedSlot,
    required this.onDateSelected,
    required this.onSlotSelected,
  });

  final DateTime date;
  final List<AppointmentSlot> slots;
  final AppointmentSlot? selectedSlot;
  final ValueChanged<DateTime> onDateSelected;
  final ValueChanged<AppointmentSlot> onSlotSelected;

  @override
  Widget build(BuildContext context) {
    final dates = _bookableDateOptions(date);
    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
      children: [
        const _DoctorSummary(),
        const SizedBox(height: 20),
        Text('Chọn ngày', style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 10),
        SizedBox(
          height: 74,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: dates.length,
            separatorBuilder: (_, _) => const SizedBox(width: 8),
            itemBuilder: (context, index) {
              final candidate = dates[index];
              final selected = _sameDay(candidate, date);
              return InkWell(
                onTap: () => onDateSelected(candidate),
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  width: 58,
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  decoration: BoxDecoration(
                    color: selected ? AppColors.primary : AppColors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: selected ? AppColors.primary : AppColors.border,
                    ),
                  ),
                  child: Column(
                    children: [
                      Text(
                        _weekday(candidate),
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color: selected ? AppColors.white : AppColors.muted,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${candidate.day}',
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(
                              color: selected ? AppColors.white : AppColors.ink,
                            ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 22),
        Text(
          'Khung giờ khả dụng',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: [
            for (final slot in slots)
              ChoiceChip(
                selected: identical(slot, selectedSlot),
                onSelected: slot.available ? (_) => onSlotSelected(slot) : null,
                label: Text(_slotTime(slot.dateTime)),
              ),
          ],
        ),
        const SizedBox(height: 22),
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: AppColors.soft,
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Row(
            children: [
              Icon(Icons.info_outline_rounded, color: AppColors.deep),
              SizedBox(width: 10),
              Expanded(
                child: Text(
                  'Yêu cầu sẽ ở trạng thái chờ cho tới khi bác sĩ xác nhận.',
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _ReviewBody extends StatelessWidget {
  const _ReviewBody({required this.slot, required this.noteController});

  final AppointmentSlot slot;
  final TextEditingController noteController;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
      children: [
        const _DoctorSummary(),
        const SizedBox(height: 18),
        _ReviewRow(
          icon: Icons.person_outline_rounded,
          label: 'Bệnh nhân',
          value: 'Huỳnh Tuấn Tú',
        ),
        _ReviewRow(
          icon: Icons.calendar_month_outlined,
          label: 'Thời gian',
          value: appointmentDate(slot.dateTime),
        ),
        const _ReviewRow(
          icon: Icons.location_on_outlined,
          label: 'Địa điểm',
          value: 'Bệnh viện Đà Nẵng',
        ),
        const _ReviewRow(
          icon: Icons.payments_outlined,
          label: 'Phí khám',
          value: '300.000đ',
        ),
        const SizedBox(height: 12),
        TextField(
          controller: noteController,
          maxLength: 500,
          maxLines: 3,
          decoration: const InputDecoration(
            labelText: 'Ghi chú cho bác sĩ (không bắt buộc)',
            alignLabelWithHint: true,
          ),
        ),
      ],
    );
  }
}

class _SuccessBody extends StatelessWidget {
  const _SuccessBody({required this.appointment});

  final AppointmentRecord appointment;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          const SizedBox(height: 36),
          Container(
            width: 96,
            height: 96,
            decoration: BoxDecoration(
              color: AppColors.warning.withValues(alpha: .12),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.schedule_rounded,
              size: 50,
              color: AppColors.warning,
            ),
          ),
          const SizedBox(height: 22),
          Text(
            'Đã gửi yêu cầu đặt lịch',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 8),
          Text(
            'Bác sĩ cần xác nhận trước khi lịch khám có hiệu lực.',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyMedium
                ?.copyWith(color: AppColors.muted),
          ),
          const SizedBox(height: 24),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: AppColors.border),
            ),
            child: Column(
              children: [
                AppointmentStatusChip(status: appointment.status),
                const SizedBox(height: 12),
                Text(
                  appointment.doctorName,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 4),
                Text(appointmentDate(appointment.dateTime)),
                const SizedBox(height: 4),
                Text(
                  'Mã lịch hẹn · ${appointment.id.substring(0, 8).toUpperCase()}',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _BottomAction extends StatelessWidget {
  const _BottomAction({
    required this.step,
    required this.canContinue,
    required this.submitting,
    required this.onPressed,
  });

  final _BookingStep step;
  final bool canContinue;
  final bool submitting;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 16),
      decoration: const BoxDecoration(
        color: AppColors.white,
        border: Border(top: BorderSide(color: AppColors.border)),
      ),
      child: AppButton(
        label: switch (step) {
          _BookingStep.chooseSlot => 'Kiểm tra thông tin',
          _BookingStep.review => 'Gửi yêu cầu đặt lịch',
          _BookingStep.success => 'Xem lịch hẹn của tôi',
        },
        onPressed: step == _BookingStep.chooseSlot && !canContinue
            ? null
            : onPressed,
        isLoading: submitting,
      ),
    );
  }
}

class _DoctorSummary extends StatelessWidget {
  const _DoctorSummary();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.soft,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          const CircleAvatar(
            radius: 28,
            backgroundColor: AppColors.primary,
            child: Icon(
              Icons.medical_services_outlined,
              color: AppColors.white,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'BS. Nguyễn Văn Minh',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                Text(
                  'Nội khoa · Bệnh viện Đà Nẵng',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ReviewRow extends StatelessWidget {
  const _ReviewRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 9),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 21, color: AppColors.primary),
          const SizedBox(width: 12),
          Expanded(
            child: Text(label, style: Theme.of(context).textTheme.bodySmall),
          ),
          const SizedBox(width: 12),
          Flexible(
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: Theme.of(context).textTheme.labelMedium,
            ),
          ),
        ],
      ),
    );
  }
}

DateTime _nextBookableDate(DateTime input) {
  var value = DateTime(input.year, input.month, input.day);
  if (value.weekday == DateTime.sunday) {
    value = value.add(const Duration(days: 1));
  }
  return value;
}

List<DateTime> _bookableDateOptions(DateTime selected) {
  final dates = <DateTime>[];
  var previous = selected.subtract(const Duration(days: 1));
  while (previous.weekday == DateTime.sunday) {
    previous = previous.subtract(const Duration(days: 1));
  }
  dates.add(previous);
  var cursor = selected;
  while (dates.length < 6) {
    if (cursor.weekday != DateTime.sunday) dates.add(cursor);
    cursor = cursor.add(const Duration(days: 1));
  }
  return dates;
}

bool _sameDay(DateTime first, DateTime second) =>
    first.year == second.year &&
    first.month == second.month &&
    first.day == second.day;

String _weekday(DateTime date) =>
    const ['T2', 'T3', 'T4', 'T5', 'T6', 'T7', 'CN'][date.weekday - 1];

String _slotTime(DateTime dateTime) {
  final value = dateTime.toUtc();
  String two(int number) => number.toString().padLeft(2, '0');
  return '${two(value.hour)}:${two(value.minute)}';
}
