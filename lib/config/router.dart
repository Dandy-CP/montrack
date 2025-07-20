import 'package:go_router/go_router.dart';
import 'package:montrack/root.dart';
import 'package:montrack/screen/login.dart';
import 'package:montrack/screen/onboarding.dart';
import 'package:montrack/screen/signup.dart';
import 'package:montrack/screen/tab_screen.dart';

final GoRouter routerList = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(path: '/', builder: (context, state) => Root()),
    GoRoute(path: '/home', builder: (context, state) => TabScreen()),
    GoRoute(path: '/onboarding', builder: (context, state) => Onboarding()),
    GoRoute(path: '/login', builder: (context, state) => Login()),
    GoRoute(path: '/signup', builder: (context, state) => Signup()),
  ],
);
