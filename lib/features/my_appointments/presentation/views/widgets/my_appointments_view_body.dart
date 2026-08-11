import 'package:docdoc/core/widgets/custom_app_bar.dart';
import 'package:docdoc/core/widgets/synced_tab_bar_page_view.dart';
import 'package:docdoc/features/bookAppoint/domain/repos/booking_repo.dart';
import 'package:docdoc/core/services/get_it_service.dart';
import 'package:docdoc/features/my_appointments/data/appointments_refresh_notifier.dart';
import 'package:docdoc/features/my_appointments/data/my_appointments_loader.dart';
import 'package:docdoc/features/my_appointments/domain/entities/user_appointment_entity.dart';
import 'package:docdoc/features/my_appointments/presentation/views/reschedule_appointment_view.dart';
import 'package:docdoc/features/my_appointments/presentation/widgets/my_appointment_cards.dart';
import 'package:flutter/material.dart';

class MyAppointmentsViewBody extends StatefulWidget {
  const MyAppointmentsViewBody({super.key, this.showBackButton = true});
  final bool showBackButton;

  @override
  State<MyAppointmentsViewBody> createState() => _MyAppointmentsViewBodyState();
}

class _MyAppointmentsViewBodyState extends State<MyAppointmentsViewBody> {
  final MyAppointmentsLoader _loader = MyAppointmentsLoader();
  final AppointmentsRefreshNotifier _refreshNotifier =
      getIt<AppointmentsRefreshNotifier>();
  List<UserAppointmentEntity> _all = [];
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _refreshNotifier.addListener(_onAppointmentsChanged);
    _load();
  }

  @override
  void dispose() {
    _refreshNotifier.removeListener(_onAppointmentsChanged);
    super.dispose();
  }

  void _onAppointmentsChanged() {
    if (!mounted) return;
    _load();
  }

  Future<void> _load() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final list = await _loader.loadForCurrentUser();
      if (!mounted) return;
      setState(() {
        _all = list;
        _loading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _error = e.toString();
        _loading = false;
      });
    }
  }

  List<UserAppointmentEntity> _byPending() {
    final items = _all.where((e) => e.isPending).toList();
    items.sort((a, b) => a.startTime.compareTo(b.startTime));
    return items;
  }

  List<UserAppointmentEntity> _byFinished() =>
      _all.where((e) => e.isFinished).toList();

  List<UserAppointmentEntity> _byCancelled() =>
      _all.where((e) => e.isCancelled).toList();

  Future<void> _cancel(UserAppointmentEntity item) async {
    await getIt<BookingRepo>().updateAppointmentById(
      id: item.supabaseRowId,
      data: {'status': 'cancelled'},
    );
  }

  Future<void> _openReschedule(UserAppointmentEntity item) async {
    await Navigator.pushNamed<bool>(
      context,
      RescheduleAppointmentView.routeName,
      arguments: RescheduleAppointmentArgs(
        doctor: item.doctor,
        initialStartTime: item.startTime,
        supabaseAppointmentId: item.supabaseRowId,
      ),
    );
  }

  Widget _buildListForTab(List<UserAppointmentEntity> items, int tabIndex) {
    if (_loading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (_error != null) {
      return Center(child: Text(_error!, textAlign: TextAlign.center));
    }
    if (items.isEmpty) {
      return Center(
        child: Text(
          tabIndex == 0
              ? 'No upcoming appointments'
              : tabIndex == 1
                  ? 'No completed appointments'
                  : 'No cancelled appointments',
          style: const TextStyle(color: Color(0xff757575)),
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _load,
      child: ListView.builder(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.only(bottom: 24),
        itemCount: items.length,
        itemBuilder: (context, index) {
          final item = items[index];
          if (tabIndex == 0) {
            return MyAppointmentUpcomingCard(
              item: item,
              onCancel: () => _cancel(item),
              onReschedule: () => _openReschedule(item),
            );
          }
          final kind = tabIndex == 1
              ? MyAppointmentHistoryKind.completed
              : MyAppointmentHistoryKind.cancelled;
          return MyAppointmentHistoryCard(item: item, kind: kind);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'My Appointments',
        leftPadding: widget.showBackButton ? 0 : 100,
        showLeading: widget.showBackButton,
        onTap: widget.showBackButton ? () => Navigator.of(context).pop() : null,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: SyncedTabBarPageView(
          tabLabels: const ['Upcoming', 'Completed', 'Cancelled'],
          pageBuilder: (context, index) {
            final items = index == 0
                ? _byPending()
                : index == 1
                    ? _byFinished()
                    : _byCancelled();
            return _buildListForTab(items, index);
          },
        ),
      ),
    );
  }
}
