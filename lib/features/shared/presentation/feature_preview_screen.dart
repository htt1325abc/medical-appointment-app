import 'package:flutter/material.dart';

import '../../../core/design_system/app_colors.dart';
import '../../../core/design_system/app_spacing.dart';
import '../../../core/design_system/widgets/app_button.dart';
import '../../../core/design_system/widgets/app_state_view.dart';
import '../../../core/design_system/widgets/app_top_bar.dart';
import '../../../core/design_system/widgets/mobile_frame.dart';
import '../../../core/design_system/widgets/role_bottom_navigation.dart';
import '../../../core/models/screen_spec.dart';

class FeaturePreviewScreen extends StatefulWidget {
  const FeaturePreviewScreen({
    required this.spec,
    required this.onOpenScreen,
    required this.onOpenCatalog,
    super.key,
  });

  final ScreenSpec spec;
  final ValueChanged<String> onOpenScreen;
  final VoidCallback onOpenCatalog;

  @override
  State<FeaturePreviewScreen> createState() => _FeaturePreviewScreenState();
}

class _FeaturePreviewScreenState extends State<FeaturePreviewScreen> {
  AppViewState _viewState = AppViewState.content;
  int _selected = 0;

  @override
  Widget build(BuildContext context) {
    final content = Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
              child: AppTopBar(
                title: widget.spec.title,
                onBack: () => Navigator.of(context).maybePop(),
                actions: [
                  PopupMenuButton<AppViewState>(
                    tooltip: 'Mô phỏng trạng thái',
                    icon: const Icon(Icons.more_horiz_rounded),
                    onSelected: (value) => setState(() => _viewState = value),
                    itemBuilder: (_) => const [
                      PopupMenuItem(
                        value: AppViewState.content,
                        child: Text('Có dữ liệu'),
                      ),
                      PopupMenuItem(
                        value: AppViewState.loading,
                        child: Text('Đang tải'),
                      ),
                      PopupMenuItem(
                        value: AppViewState.empty,
                        child: Text('Trống'),
                      ),
                      PopupMenuItem(
                        value: AppViewState.error,
                        child: Text('Lỗi'),
                      ),
                      PopupMenuItem(
                        value: AppViewState.offline,
                        child: Text('Ngoại tuyến'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Expanded(
              child: AppStateView(
                state: _viewState,
                emptyMessage: 'Chưa có ${widget.spec.title.toLowerCase()}',
                onRetry: () =>
                    setState(() => _viewState = AppViewState.content),
                child: _ScreenBody(
                  spec: widget.spec,
                  selected: _selected,
                  onSelected: (value) => setState(() => _selected = value),
                ),
              ),
            ),
            if (_viewState == AppViewState.content &&
                (widget.spec.primaryAction != null ||
                    widget.spec.secondaryAction != null))
              _ActionBar(
                spec: widget.spec,
                onPrimary: _handlePrimary,
                onSecondary: _handleSecondary,
              ),
          ],
        ),
      ),
      bottomNavigationBar: RoleBottomNavigation(
        role: widget.spec.role,
        onHome: _openRoleHome,
        onCatalog: widget.onOpenCatalog,
      ),
    );

    if (widget.spec.role == AppRole.admin) {
      return _AdminResponsiveFrame(
        title: widget.spec.title,
        onOpenCatalog: widget.onOpenCatalog,
        child: content,
      );
    }
    return MobileFrame(child: content);
  }

  void _handlePrimary() {
    final next = widget.spec.nextScreenId;
    if (next != null) {
      widget.onOpenScreen(next);
      return;
    }
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('${widget.spec.primaryAction} thành công')),
    );
  }

  void _handleSecondary() {
    if (widget.spec.isDestructive) {
      Navigator.of(context).maybePop();
      return;
    }
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Đã chọn ${widget.spec.secondaryAction}')),
    );
  }

  void _openRoleHome() {
    final id = switch (widget.spec.role) {
      AppRole.patient => 'P20',
      AppRole.doctor => 'D03',
      AppRole.admin => 'A01',
    };
    widget.onOpenScreen(id);
  }
}

class _ScreenBody extends StatelessWidget {
  const _ScreenBody({
    required this.spec,
    required this.selected,
    required this.onSelected,
  });

  final ScreenSpec spec;
  final int selected;
  final ValueChanged<int> onSelected;

  @override
  Widget build(BuildContext context) {
    return switch (spec.layout) {
      ScreenLayout.success => _SuccessBody(spec: spec),
      ScreenLayout.chat => _ChatBody(spec: spec),
      ScreenLayout.calendar => _CalendarBody(
        spec: spec,
        selected: selected,
        onSelected: onSelected,
      ),
      ScreenLayout.video => _VideoBody(spec: spec),
      ScreenLayout.form || ScreenLayout.auth => _FormBody(spec: spec),
      ScreenLayout.dashboard => _DashboardBody(spec: spec),
      ScreenLayout.metrics => _MetricsBody(spec: spec),
      ScreenLayout.profile => _ProfileBody(spec: spec),
      ScreenLayout.list || ScreenLayout.detail || ScreenLayout.settings =>
        _ContentBody(spec: spec, selected: selected, onSelected: onSelected),
    };
  }
}

class _HeroHeader extends StatelessWidget {
  const _HeroHeader({required this.spec});

  final ScreenSpec spec;

  @override
  Widget build(BuildContext context) {
    final accent = _roleColor(spec.role);
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [accent.withValues(alpha: .15), AppColors.white],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          Container(
            width: 54,
            height: 54,
            decoration: BoxDecoration(
              color: accent,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(spec.icon, color: AppColors.white, size: 28),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(spec.title, style: Theme.of(context).textTheme.titleLarge),
                const SizedBox(height: 4),
                Text(
                  spec.subtitle,
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

class _ContentBody extends StatelessWidget {
  const _ContentBody({
    required this.spec,
    required this.selected,
    required this.onSelected,
  });

  final ScreenSpec spec;
  final int selected;
  final ValueChanged<int> onSelected;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
      children: [
        _HeroHeader(spec: spec),
        const SizedBox(height: AppSpacing.lg),
        for (var index = 0; index < spec.items.length; index++) ...[
          _InfoTile(
            label: spec.items[index],
            icon: _tileIcon(spec.layout, index),
            selected: selected == index,
            selectable: spec.layout != ScreenLayout.detail,
            trailing: spec.layout == ScreenLayout.settings
                ? Switch.adaptive(
                    value: selected == index,
                    onChanged: (_) => onSelected(index),
                  )
                : null,
            onTap: () => onSelected(index),
          ),
          const SizedBox(height: 10),
        ],
      ],
    );
  }
}

class _DashboardBody extends StatelessWidget {
  const _DashboardBody({required this.spec});

  final ScreenSpec spec;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final columns = constraints.maxWidth >= 760 ? 4 : 2;
        return ListView(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
          children: [
            _HeroHeader(spec: spec),
            const SizedBox(height: AppSpacing.lg),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: spec.items.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: columns,
                mainAxisExtent: 116,
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
              ),
              itemBuilder: (context, index) => _MetricCard(
                label: spec.items[index],
                icon: _tileIcon(ScreenLayout.dashboard, index),
                color: _roleColor(spec.role),
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            _MiniChart(color: _roleColor(spec.role)),
          ],
        );
      },
    );
  }
}

class _MetricsBody extends StatelessWidget {
  const _MetricsBody({required this.spec});

  final ScreenSpec spec;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
      children: [
        _HeroHeader(spec: spec),
        const SizedBox(height: 20),
        _MiniChart(color: _roleColor(spec.role)),
        const SizedBox(height: 20),
        for (var index = 0; index < spec.items.length; index++) ...[
          _MetricRow(label: spec.items[index], index: index),
          const SizedBox(height: 10),
        ],
      ],
    );
  }
}

class _CalendarBody extends StatelessWidget {
  const _CalendarBody({
    required this.spec,
    required this.selected,
    required this.onSelected,
  });

  final ScreenSpec spec;
  final int selected;
  final ValueChanged<int> onSelected;

  @override
  Widget build(BuildContext context) {
    const days = ['T2', 'T3', 'T4', 'T5', 'T6', 'T7', 'CN'];
    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
      children: [
        _HeroHeader(spec: spec),
        const SizedBox(height: 20),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: _cardDecoration(),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Icon(Icons.chevron_left_rounded),
                  Expanded(
                    child: Text(
                      spec.items.isEmpty ? 'Tháng 11, 2026' : spec.items.first,
                      textAlign: TextAlign.center,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ),
                  const Icon(Icons.chevron_right_rounded),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  for (var index = 0; index < days.length; index++)
                    Expanded(
                      child: Column(
                        children: [
                          Text(
                            days[index],
                            style: Theme.of(context).textTheme.labelSmall,
                          ),
                          const SizedBox(height: 8),
                          InkWell(
                            onTap: () => onSelected(index),
                            customBorder: const CircleBorder(),
                            child: CircleAvatar(
                              radius: 18,
                              backgroundColor: selected == index
                                  ? _roleColor(spec.role)
                                  : AppColors.soft,
                              child: Text(
                                '${index + 3}',
                                style: Theme.of(context).textTheme.labelMedium
                                    ?.copyWith(
                                      color: selected == index
                                          ? AppColors.white
                                          : AppColors.ink,
                                    ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 18),
        Text(
          'Khung giờ khả dụng',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 12),
        if (spec.items.skip(1).any((item) => item.length > 18))
          for (var index = 1; index < spec.items.length; index++) ...[
            _InfoTile(
              label: spec.items[index],
              icon: Icons.schedule_rounded,
              selected: selected == index + 6,
              selectable: true,
              onTap: () => onSelected(index + 6),
            ),
            const SizedBox(height: 10),
          ]
        else
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              for (var index = 1; index < spec.items.length; index++)
                ChoiceChip(
                  selected: selected == index + 6,
                  onSelected: (_) => onSelected(index + 6),
                  label: Text(spec.items[index]),
                ),
            ],
          ),
      ],
    );
  }
}

class _FormBody extends StatelessWidget {
  const _FormBody({required this.spec});

  final ScreenSpec spec;

  @override
  Widget build(BuildContext context) {
    final isOtp =
        spec.items.length == 6 && spec.items.every((item) => item.length == 1);
    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
      children: [
        _HeroHeader(spec: spec),
        const SizedBox(height: 20),
        if (isOtp)
          Row(
            children: [
              for (final item in spec.items) ...[
                Expanded(
                  child: Container(
                    height: 52,
                    alignment: Alignment.center,
                    decoration: _cardDecoration(),
                    child: Text(
                      item,
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                  ),
                ),
                if (item != spec.items.last) const SizedBox(width: 8),
              ],
            ],
          )
        else
          for (final item in spec.items) ...[
            TextFormField(
              key: ValueKey('${spec.id}-$item'),
              obscureText: item.toLowerCase().contains('mật khẩu'),
              maxLines: item.contains('Lời') || item.contains('Nội dung')
                  ? 3
                  : 1,
              decoration: InputDecoration(
                labelText: item,
                prefixIcon: Icon(_formIcon(item), size: 20),
              ),
            ),
            const SizedBox(height: 14),
          ],
        if (spec.layout == ScreenLayout.auth) ...[
          const SizedBox(height: 8),
          Row(
            children: [
              const Icon(
                Icons.shield_outlined,
                size: 18,
                color: AppColors.success,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Thông tin được mã hóa và bảo mật',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ),
            ],
          ),
        ],
      ],
    );
  }
}

class _ChatBody extends StatelessWidget {
  const _ChatBody({required this.spec});

  final ScreenSpec spec;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 16),
            itemCount: spec.items.length,
            itemBuilder: (context, index) {
              final mine = index.isOdd;
              return Align(
                alignment: mine ? Alignment.centerRight : Alignment.centerLeft,
                child: Container(
                  constraints: const BoxConstraints(maxWidth: 280),
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.all(13),
                  decoration: BoxDecoration(
                    color: mine ? _roleColor(spec.role) : AppColors.soft,
                    borderRadius: BorderRadius.only(
                      topLeft: const Radius.circular(16),
                      topRight: const Radius.circular(16),
                      bottomLeft: Radius.circular(mine ? 16 : 4),
                      bottomRight: Radius.circular(mine ? 4 : 16),
                    ),
                  ),
                  child: Text(
                    spec.items[index],
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: mine ? AppColors.white : AppColors.ink,
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        Container(
          padding: const EdgeInsets.fromLTRB(16, 10, 16, 12),
          decoration: const BoxDecoration(
            color: AppColors.white,
            border: Border(top: BorderSide(color: AppColors.border)),
          ),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  decoration: const InputDecoration(
                    hintText: 'Nhập tin nhắn...',
                    prefixIcon: Icon(Icons.attach_file_rounded, size: 20),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              IconButton.filled(
                onPressed: () {},
                icon: const Icon(Icons.send_rounded),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _VideoBody extends StatelessWidget {
  const _VideoBody({required this.spec});

  final ScreenSpec spec;

  @override
  Widget build(BuildContext context) {
    final isMap = spec.id == 'P33';
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
      child: Column(
        children: [
          Expanded(
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: isMap
                      ? [const Color(0xFFD8EEE4), const Color(0xFFE8F3F8)]
                      : [AppColors.ink, AppColors.deep],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Stack(
                children: [
                  Center(
                    child: Icon(
                      isMap ? Icons.location_on_rounded : Icons.face_3_rounded,
                      size: isMap ? 64 : 96,
                      color: isMap ? AppColors.danger : AppColors.white,
                    ),
                  ),
                  Positioned(
                    left: 16,
                    right: 16,
                    bottom: 18,
                    child: Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: AppColors.white.withValues(alpha: .94),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Text(
                        spec.subtitle,
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.labelLarge,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              for (final icon in [
                Icons.mic_rounded,
                Icons.videocam_rounded,
                Icons.volume_up_rounded,
              ]) ...[
                CircleAvatar(
                  radius: 23,
                  backgroundColor: AppColors.soft,
                  child: Icon(icon, color: AppColors.deep),
                ),
                if (icon != Icons.volume_up_rounded) const SizedBox(width: 16),
              ],
            ],
          ),
        ],
      ),
    );
  }
}

class _ProfileBody extends StatelessWidget {
  const _ProfileBody({required this.spec});

  final ScreenSpec spec;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
      children: [
        Center(
          child: CircleAvatar(
            radius: 50,
            backgroundColor: AppColors.soft,
            child: Icon(spec.icon, size: 52, color: _roleColor(spec.role)),
          ),
        ),
        const SizedBox(height: 14),
        Text(
          spec.title,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        Text(
          spec.subtitle,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.bodySmall,
        ),
        const SizedBox(height: 24),
        for (var index = 0; index < spec.items.length; index++) ...[
          _InfoTile(
            label: spec.items[index],
            icon: _tileIcon(ScreenLayout.profile, index),
          ),
          const SizedBox(height: 10),
        ],
      ],
    );
  }
}

class _SuccessBody extends StatelessWidget {
  const _SuccessBody({required this.spec});

  final ScreenSpec spec;

  @override
  Widget build(BuildContext context) {
    final color = spec.isDestructive ? AppColors.danger : AppColors.success;
    return SingleChildScrollView(
      padding: const EdgeInsets.all(28),
      child: Column(
        children: [
          const SizedBox(height: 52),
          Container(
            width: 104,
            height: 104,
            decoration: BoxDecoration(
              color: color.withValues(alpha: .12),
              shape: BoxShape.circle,
            ),
            child: Icon(spec.icon, color: color, size: 58),
          ),
          const SizedBox(height: 24),
          Text(
            spec.title,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 8),
          Text(
            spec.subtitle,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyMedium
                ?.copyWith(color: AppColors.muted),
          ),
          const SizedBox(height: 28),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: _cardDecoration(),
            child: Column(
              children: [
                for (final item in spec.items)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 5),
                    child: Text(
                      item,
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ActionBar extends StatelessWidget {
  const _ActionBar({
    required this.spec,
    required this.onPrimary,
    required this.onSecondary,
  });

  final ScreenSpec spec;
  final VoidCallback onPrimary;
  final VoidCallback onSecondary;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 14),
      decoration: const BoxDecoration(
        color: AppColors.white,
        border: Border(top: BorderSide(color: AppColors.border)),
      ),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (spec.primaryAction != null)
              AppButton(
                label: spec.primaryAction!,
                onPressed: onPrimary,
                style: spec.isDestructive
                    ? AppButtonStyle.danger
                    : AppButtonStyle.primary,
              ),
            if (spec.secondaryAction != null) ...[
              const SizedBox(height: 8),
              AppButton(
                label: spec.secondaryAction!,
                onPressed: onSecondary,
                style: AppButtonStyle.secondary,
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _InfoTile extends StatelessWidget {
  const _InfoTile({
    required this.label,
    required this.icon,
    this.selected = false,
    this.selectable = false,
    this.trailing,
    this.onTap,
  });

  final String label;
  final IconData icon;
  final bool selected;
  final bool selectable;
  final Widget? trailing;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: selected && selectable ? AppColors.soft : AppColors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
        side: BorderSide(
          color: selected && selectable ? AppColors.primary : AppColors.border,
        ),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Row(
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: AppColors.soft,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, size: 21, color: AppColors.primary),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  label,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ),
              trailing ??
                  const Icon(
                    Icons.chevron_right_rounded,
                    size: 20,
                    color: AppColors.muted,
                  ),
            ],
          ),
        ),
      ),
    );
  }
}

class _MetricCard extends StatelessWidget {
  const _MetricCard({
    required this.label,
    required this.icon,
    required this.color,
  });

  final String label;
  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: _cardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 24),
          const Spacer(),
          Text(
            label,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.labelMedium,
          ),
        ],
      ),
    );
  }
}

class _MetricRow extends StatelessWidget {
  const _MetricRow({required this.label, required this.index});

  final String label;
  final int index;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: _cardDecoration(),
      child: Row(
        children: [
          CircularProgressIndicator(
            value: .62 + index * .08,
            strokeWidth: 5,
            backgroundColor: AppColors.soft,
            color: index == 2 ? AppColors.warning : AppColors.success,
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Text(label, style: Theme.of(context).textTheme.bodyMedium),
          ),
        ],
      ),
    );
  }
}

class _MiniChart extends StatelessWidget {
  const _MiniChart({required this.color});

  final Color color;

  @override
  Widget build(BuildContext context) {
    const values = [42.0, 68.0, 54.0, 86.0, 72.0, 94.0, 78.0];
    return Container(
      height: 150,
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
      decoration: _cardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Xu hướng 7 ngày',
            style: Theme.of(context).textTheme.labelLarge,
          ),
          const SizedBox(height: 12),
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                for (final value in values)
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      child: Container(
                        height: value,
                        decoration: BoxDecoration(
                          color: color.withValues(alpha: .75),
                          borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(6),
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _AdminResponsiveFrame extends StatelessWidget {
  const _AdminResponsiveFrame({
    required this.title,
    required this.onOpenCatalog,
    required this.child,
  });

  final String title;
  final VoidCallback onOpenCatalog;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth < 760) return MobileFrame(child: child);
        return Scaffold(
          backgroundColor: AppColors.soft,
          body: SafeArea(
            child: Row(
              children: [
                Container(
                  width: 240,
                  color: AppColors.deep,
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Row(
                        children: [
                          Icon(Icons.favorite_rounded, color: AppColors.white),
                          SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              'MediCare+ Admin',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                color: AppColors.white,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 34),
                      for (final item in [
                        'Tổng quan',
                        'Lịch hẹn',
                        'Bác sĩ',
                        'Bệnh nhân',
                        'Báo cáo',
                        'Cài đặt',
                      ])
                        Material(
                          color: Colors.transparent,
                          child: ListTile(
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 8,
                            ),
                            leading: const Icon(
                              Icons.grid_view_rounded,
                              color: AppColors.white,
                            ),
                            title: Text(
                              item,
                              style: const TextStyle(color: AppColors.white),
                            ),
                            onTap: onOpenCatalog,
                          ),
                        ),
                      const Spacer(),
                      Text(
                        title,
                        style: const TextStyle(color: Colors.white70),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Center(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 1180),
                      child: child,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

BoxDecoration _cardDecoration() => BoxDecoration(
  color: AppColors.white,
  borderRadius: BorderRadius.circular(14),
  border: Border.all(color: AppColors.border),
  boxShadow: const [
    BoxShadow(color: Color(0x0A101B32), blurRadius: 12, offset: Offset(0, 4)),
  ],
);

Color _roleColor(AppRole role) => switch (role) {
  AppRole.patient => AppColors.primary,
  AppRole.doctor => AppColors.deep,
  AppRole.admin => const Color(0xFF3659B8),
};

IconData _tileIcon(ScreenLayout layout, int index) => switch (layout) {
  ScreenLayout.settings => [
    Icons.person_outline,
    Icons.lock_outline,
    Icons.language,
    Icons.security_outlined,
    Icons.tune_rounded,
  ][index % 5],
  ScreenLayout.dashboard => [
    Icons.event_note,
    Icons.payments_outlined,
    Icons.groups_outlined,
    Icons.trending_up_rounded,
  ][index % 4],
  ScreenLayout.profile => [
    Icons.workspace_premium_outlined,
    Icons.star_outline,
    Icons.local_hospital_outlined,
    Icons.verified_outlined,
  ][index % 4],
  _ => [
    Icons.event_note_outlined,
    Icons.person_outline,
    Icons.location_on_outlined,
    Icons.payments_outlined,
  ][index % 4],
};

IconData _formIcon(String label) {
  final value = label.toLowerCase();
  if (value.contains('mật khẩu')) return Icons.lock_outline_rounded;
  if (value.contains('email')) return Icons.mail_outline_rounded;
  if (value.contains('điện thoại')) return Icons.phone_outlined;
  if (value.contains('thời gian')) return Icons.schedule_rounded;
  return Icons.edit_outlined;
}
