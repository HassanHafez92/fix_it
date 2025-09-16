import 'package:fix_it/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:fix_it/features/booking/domain/usecases/client_confirm_completion_usecase.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/di/injection_container.dart' as di;
import '../../../services/presentation/bloc/services_bloc/services_bloc.dart';

import '../../../booking/presentation/bloc/bookings_bloc.dart';
import '../../../booking/domain/usecases/get_user_bookings_usecase.dart';
import '../../../booking/domain/usecases/get_booking_details_usecase.dart';
import '../../../booking/domain/usecases/cancel_booking_usecase.dart';
import '../../../booking/domain/usecases/reschedule_booking_usecase.dart';

import '../../../notifications/presentation/bloc/notifications_bloc.dart';
import '../../../profile/presentation/bloc/user_profile_bloc/user_profile_bloc.dart';
import '../../../settings/presentation/bloc/settings_bloc/settings_bloc.dart';
import '../widgets/dashboard_home_tab.dart';
import '../widgets/dashboard_services_tab.dart';
import '../widgets/dashboard_bookings_tab.dart';
import '../widgets/dashboard_chat_tab.dart';
import '../widgets/dashboard_profile_tab.dart';
import '../../../chat/presentation/bloc/chat_list_bloc/chat_list_bloc.dart';

/// Main Dashboard with bottom navigation providing access to all major features
///
/// This comprehensive dashboard serves as the central hub for the Fix It app,
/// following the technical plan's requirement for unified navigation and
/// feature accessibility.
///
/// Features:
/// - Bottom navigation with 5 main tabs
/// - Home tab with quick access to services and actions
/// - Services tab for browsing and searching services
/// - Bookings tab for managing user bookings
/// - Chat tab for communication with providers
/// - Profile tab for account management and settings
class MainDashboard extends StatefulWidget {
  const MainDashboard({super.key});

  @override
  State<MainDashboard> createState() => _MainDashboardState();
}

class _MainDashboardState extends State<MainDashboard> {
  int _currentIndex = 0;
  late PageController _pageController;
  final List<GlobalKey> _tabKeys = List.generate(5, (index) => GlobalKey());

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onTabTapped(int index) {
    if (_currentIndex == index) return;

    setState(() {
      _currentIndex = index;
    });

    if (_pageController.hasClients) {
      _pageController.animateToPage(
        index,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>(
          create: (context) => di.sl<AuthBloc>(),
        ),
        BlocProvider<ServicesBloc>(
          create: (context) => ServicesBloc(),
        ),
        BlocProvider<BookingsBloc>(
          create: (context) => BookingsBloc(
            getUserBookings: di.sl<GetUserBookingsUseCase>(),
            getBookingDetails: di.sl<GetBookingDetailsUseCase>(),
            cancelBooking: di.sl<CancelBookingUseCase>(),
            clientConfirmCompletion: di.sl<ClientConfirmCompletionUseCase>(),
            rescheduleBooking: di.sl<RescheduleBookingUseCase>(),
          ),
        ),
        BlocProvider<NotificationsBloc>(
          create: (context) => di.sl<NotificationsBloc>(),
        ),
        BlocProvider<UserProfileBloc>(
          create: (context) => di.sl<UserProfileBloc>(),
        ),
        BlocProvider<SettingsBloc>(
          create: (context) => SettingsBloc(),
        ),
        BlocProvider<ChatListBloc>(
          create: (context) => di.sl<ChatListBloc>(),
        ),
      ],
      child: Scaffold(
        body: PageView(
          controller: _pageController,
          physics: const PageScrollPhysics(),
          onPageChanged: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
          children: [
            Builder(
              key: _tabKeys[0],
              builder: (context) => DashboardHomeTab(),
            ),
            Builder(
              key: _tabKeys[1],
              builder: (context) => DashboardServicesTab(),
            ),
            Builder(
              key: _tabKeys[2],
              builder: (context) => DashboardBookingsTab(),
            ),
            Builder(
              key: _tabKeys[3],
              builder: (context) => DashboardChatTab(),
            ),
            Builder(
              key: _tabKeys[4],
              builder: (context) => DashboardProfileTab(),
            ),
          ],
        ),
        bottomNavigationBar: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withValues(alpha: 0.15),
                blurRadius: 12,
                offset: const Offset(0, -3),
              ),
            ],
          ),
          child: SafeArea(
            child: Container(
              height: 75,
              padding:
                  const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildNavItem(
                    icon: Icons.home_outlined,
                    activeIcon: Icons.home,
                    label: 'Home',
                    index: 0,
                    theme: theme,
                  ),
                  _buildNavItem(
                    icon: Icons.build_circle_outlined,
                    activeIcon: Icons.build_circle,
                    label: 'Services',
                    index: 1,
                    theme: theme,
                  ),
                  _buildNavItem(
                    icon: Icons.calendar_today_outlined,
                    activeIcon: Icons.calendar_today,
                    label: 'Bookings',
                    index: 2,
                    theme: theme,
                  ),
                  _buildNavItem(
                    icon: Icons.chat_bubble_outline,
                    activeIcon: Icons.chat_bubble,
                    label: 'Chat',
                    index: 3,
                    theme: theme,
                  ),
                  _buildNavItem(
                    icon: Icons.person_outline,
                    activeIcon: Icons.person,
                    label: 'Profile',
                    index: 4,
                    theme: theme,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem({
    required IconData icon,
    required IconData activeIcon,
    required String label,
    required int index,
    required ThemeData theme,
  }) {
    final isActive = _currentIndex == index;

    return Expanded(
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () => _onTabTapped(index),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 250),
            curve: Curves.easeInOut,
            padding: const EdgeInsets.symmetric(vertical: 6.0, horizontal: 8.0),
            decoration: BoxDecoration(
              color: isActive
                  ? theme.primaryColor.withValues(alpha: 0.12)
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(16),
            ),
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Icon with animation
                  AnimatedScale(
                    scale: isActive ? 1.1 : 1.0,
                    duration: const Duration(milliseconds: 200),
                    child: Container(
                      padding: const EdgeInsets.all(2),
                      child: Icon(
                        isActive ? activeIcon : icon,
                        color: isActive ? theme.primaryColor : Colors.grey[600],
                        size: 22,
                      ),
                    ),
                  ),
                  const SizedBox(height: 2),
                  // Label with animation
                  AnimatedDefaultTextStyle(
                    duration: const Duration(milliseconds: 200),
                    style: GoogleFonts.cairo(
                      fontSize: isActive ? 11 : 10,
                      fontWeight: isActive ? FontWeight.w600 : FontWeight.w500,
                      color: isActive ? theme.primaryColor : Colors.grey[600],
                    ),
                    child: Text(
                      label,
                      textAlign: TextAlign.center,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
