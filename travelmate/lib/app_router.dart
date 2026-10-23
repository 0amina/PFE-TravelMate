import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:travelmate/View/Auth/signin.dart';



class AppRouter {
  late final GoRouter router = GoRouter(
    routes: <GoRoute>[
      GoRoute(
        name: 'signup',
        path: '/',
        builder: (BuildContext context, GoRouterState state) {
          return const SignInScreen();
        },
      ),
      
    ],
  );
}
