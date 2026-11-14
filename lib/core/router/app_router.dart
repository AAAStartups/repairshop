import 'package:go_router/go_router.dart';
import '../../features/splash/presentation/screens/splash_screen.dart';
import '../../features/home/presentation/screens/home_screen.dart';
import '../../features/catalog/presentation/screens/brand_selection_screen.dart';
import '../../features/catalog/presentation/screens/model_selection_screen.dart';
import '../../features/catalog/presentation/screens/repair_selection_screen.dart';
import '../../features/booking/presentation/screens/problem_description_screen.dart';
import '../../features/booking/presentation/screens/pickup_address_screen.dart';
import '../../features/booking/presentation/screens/pickup_scheduling_screen.dart';
import '../../features/booking/presentation/screens/booking_summary_screen.dart';
import '../../features/booking/presentation/screens/booking_success_screen.dart';
import '../../features/tracking/presentation/screens/repair_tracking_screen.dart';
import '../../features/orders/presentation/screens/orders_screen.dart';
import '../../features/profile/presentation/screens/profile_screen.dart';
import '../../features/support/presentation/screens/support_screen.dart';
import '../navigation/main_shell.dart';

final appRouter = GoRouter(
  initialLocation: '/splash',
  routes: [
    GoRoute(
      path: '/splash',
      builder: (context, state) => const SplashScreen(),
    ),
    // Booking flow full-screen modals & screens
    GoRoute(
      path: '/select-brand',
      builder: (context, state) => const BrandSelectionScreen(),
    ),
    GoRoute(
      path: '/select-model',
      builder: (context, state) => const ModelSelectionScreen(),
    ),
    GoRoute(
      path: '/select-repairs',
      builder: (context, state) => const RepairSelectionScreen(),
    ),
    GoRoute(
      path: '/describe-problem',
      builder: (context, state) => const ProblemDescriptionScreen(),
    ),
    GoRoute(
      path: '/pickup-address',
      builder: (context, state) => const PickupAddressScreen(),
    ),
    GoRoute(
      path: '/pickup-slot',
      builder: (context, state) => const PickupSchedulingScreen(),
    ),
    GoRoute(
      path: '/booking-summary',
      builder: (context, state) => const BookingSummaryScreen(),
    ),
    GoRoute(
      path: '/booking-success/:orderId',
      builder: (context, state) => BookingSuccessScreen(
        orderId: state.pathParameters['orderId'] ?? 'QF-00000',
      ),
    ),
    GoRoute(
      path: '/track-repair/:orderId',
      builder: (context, state) => RepairTrackingScreen(
        orderId: state.pathParameters['orderId'] ?? 'QF-00000',
      ),
    ),
    // Main bottom navigation tabs shell
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) => MainShell(navigationShell: navigationShell),
      branches: [
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/home',
              builder: (context, state) => const HomeScreen(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/orders',
              builder: (context, state) => const OrdersScreen(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/support',
              builder: (context, state) => const SupportScreen(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/profile',
              builder: (context, state) => const ProfileScreen(),
            ),
          ],
        ),
      ],
    ),
  ],
);
