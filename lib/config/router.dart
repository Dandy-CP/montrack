import 'package:go_router/go_router.dart';
import 'package:montrack/root.dart';
import 'package:montrack/screen/create_transaction.dart';
import 'package:montrack/screen/goals/create_goals.dart';
import 'package:montrack/screen/goals/edit_goals.dart';
import 'package:montrack/screen/goals/goals.dart';
import 'package:montrack/screen/goals/goals_detail.dart';
import 'package:montrack/screen/input_pin.dart';
import 'package:montrack/screen/login.dart';
import 'package:montrack/screen/onboarding.dart';
import 'package:montrack/screen/otp.dart';
import 'package:montrack/screen/pocket/create_pocket.dart';
import 'package:montrack/screen/pocket/edit_pocket.dart';
import 'package:montrack/screen/pocket/pocket.dart';
import 'package:montrack/screen/pocket/pocket_detail.dart';
import 'package:montrack/screen/profile/screen_2fa.dart';
import 'package:montrack/screen/signup.dart';
import 'package:montrack/screen/spending.dart';
import 'package:montrack/screen/tab_screen.dart';
import 'package:montrack/screen/wallet/create_wallet.dart';
import 'package:montrack/screen/wallet/edit_wallet.dart';
import 'package:montrack/screen/wallet/wallet.dart';

final GoRouter router = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(path: '/', name: 'root', builder: (context, state) => Root()),
    GoRoute(
      path: '/home',
      name: 'homescreen',
      builder: (context, state) => TabScreen(),
    ),
    GoRoute(
      path: '/onboarding',
      name: 'onboarding',
      builder: (context, state) => Onboarding(),
    ),
    GoRoute(
      path: '/login',
      name: 'login',
      builder: (context, state) => Login(),
    ),
    GoRoute(
      path: '/signup',
      name: 'signup',
      builder: (context, state) => Signup(),
    ),
    GoRoute(
      path: '/otp',
      name: 'otp',
      builder: (context, state) {
        final userId = state.uri.queryParameters['userId'] ?? '';

        return OTPScreen(userId: userId);
      },
    ),
    GoRoute(
      path: '/input-pin',
      name: 'input-pin',
      builder: (context, state) {
        final title = state.uri.queryParameters['title'] ?? '';
        final type = state.uri.queryParameters['type'] ?? '';
        final selectedType = type == 'setup'
            ? PinType.setup
            : type == 'disabled'
            ? PinType.disabled
            : PinType.input;

        return InputPinScreen(title: title, type: selectedType);
      },
    ),
    GoRoute(
      path: '/2fa',
      name: '2fa',
      builder: (context, state) {
        final type = state.uri.queryParameters['type'] ?? '';
        final selectedType = type == 'setup' ? Type2FA.setup : Type2FA.disabled;

        return Screen2FA(type: selectedType);
      },
    ),

    // Wallet Route
    GoRoute(
      path: '/wallet',
      name: 'wallet',
      builder: (context, state) => WalletScreen(),
    ),
    GoRoute(
      path: '/wallet/create',
      builder: (context, state) => CreateWalletScreen(),
    ),
    GoRoute(
      path: '/wallet/edit',
      builder: (context, state) {
        final walletId = state.uri.queryParameters['walletId'] ?? '';
        final walletName = state.uri.queryParameters['walletName'] ?? '';
        final walletAmount = state.uri.queryParameters['walletAmount'] ?? '';

        return EditWalletScreen(
          walletId: walletId,
          walletName: walletName,
          walletAmount: walletAmount,
        );
      },
    ),

    // Pocket Route
    GoRoute(
      path: '/pocket',
      name: 'pocket',
      builder: (context, state) => PocketScreen(),
    ),
    GoRoute(
      path: '/pocket/detail',
      name: 'pocket-detail',
      builder: (context, state) {
        final pocketId = state.uri.queryParameters['pocketId'] ?? '';

        return PocketDetailScreen(pocketId: pocketId);
      },
    ),
    GoRoute(
      path: '/pocket/create',
      name: 'create-pocket',
      builder: (context, state) => CreatePocket(),
    ),
    GoRoute(
      path: '/pocket/edit',
      name: 'edit-pocket',
      builder: (context, state) {
        final pocketId = state.uri.queryParameters['pocketId'] ?? '';

        return EditPocket(pocketId: pocketId);
      },
    ),

    // Goals Route
    GoRoute(
      path: '/goals',
      name: 'goals',
      builder: (context, state) => GoalsScreen(),
    ),
    GoRoute(
      path: '/goals/detail',
      builder: (context, state) {
        final pocketId = state.uri.queryParameters['goalsId'] ?? '';

        return GoalsDetailScreen(goalsId: pocketId);
      },
    ),
    GoRoute(
      path: '/goals/create',
      name: 'create-goals',
      builder: (context, state) => CreateGoals(),
    ),
    GoRoute(
      path: '/goals/edit',
      builder: (context, state) {
        final pocketId = state.uri.queryParameters['goalsId'] ?? '';

        return EditGoalsScreen(goalsId: pocketId);
      },
    ),

    GoRoute(
      path: '/create-transaction',
      name: 'create-transaction',
      builder: (context, state) => CreateTransaction(),
    ),
    GoRoute(
      path: '/spending',
      builder: (context, state) {
        final type = state.uri.queryParameters['transactionType'] ?? '';

        return SpendingScreen(transactionType: type);
      },
    ),
  ],
);
