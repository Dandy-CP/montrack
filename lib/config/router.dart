import 'package:go_router/go_router.dart';
import 'package:montrack/root.dart';
import 'package:montrack/screen/expense.dart';
import 'package:montrack/screen/goals/create_goals.dart';
import 'package:montrack/screen/goals/goals.dart';
import 'package:montrack/screen/goals/goals_detail.dart';
import 'package:montrack/screen/income.dart';
import 'package:montrack/screen/login.dart';
import 'package:montrack/screen/onboarding.dart';
import 'package:montrack/screen/pocket/create_pocket.dart';
import 'package:montrack/screen/pocket/pocket.dart';
import 'package:montrack/screen/pocket/pocket_detail.dart';
import 'package:montrack/screen/signup.dart';
import 'package:montrack/screen/tab_screen.dart';

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
      path: '/pocket',
      name: 'pocket',
      builder: (context, state) => PocketScreen(),
    ),
    GoRoute(
      path: '/pocket/detail',
      builder: (context, state) {
        final pocketId = state.uri.queryParameters['pocketId'] ?? '';

        return PocketDetailScreen(pocketId: pocketId);
      },
    ),
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
      path: '/income',
      name: 'income',
      builder: (context, state) => IncomeScreen(),
    ),
    GoRoute(
      path: '/expense',
      name: 'expense',
      builder: (context, state) => ExpenseScreen(),
    ),
    GoRoute(
      path: '/create-pocket',
      name: 'create-pocket',
      builder: (context, state) => CreatePocket(),
    ),
    GoRoute(
      path: '/create-goals',
      name: 'create-goals',
      builder: (context, state) => CreateGoals(),
    ),
  ],
);
