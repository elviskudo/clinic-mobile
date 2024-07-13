// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_router.dart';

// **************************************************************************
// GoRouterGenerator
// **************************************************************************

List<RouteBase> get $appRoutes => [
      $authRoute,
    ];

RouteBase get $authRoute => ShellRouteData.$route(
      navigatorKey: AuthRoute.$navigatorKey,
      factory: $AuthRouteExtension._fromState,
      routes: [
        GoRouteData.$route(
          path: '/onboarding',
          factory: $OnboardingRouteExtension._fromState,
        ),
        GoRouteData.$route(
          path: '/signin',
          factory: $SigninRouteExtension._fromState,
        ),
        GoRouteData.$route(
          path: '/signup',
          factory: $SignupRouteExtension._fromState,
        ),
        GoRouteData.$route(
          path: '/verification',
          factory: $VerificationRouteExtension._fromState,
        ),
      ],
    );

extension $AuthRouteExtension on AuthRoute {
  static AuthRoute _fromState(GoRouterState state) => AuthRoute();
}

extension $OnboardingRouteExtension on OnboardingRoute {
  static OnboardingRoute _fromState(GoRouterState state) => OnboardingRoute();

  String get location => GoRouteData.$location(
        '/onboarding',
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

extension $SigninRouteExtension on SigninRoute {
  static SigninRoute _fromState(GoRouterState state) => SigninRoute();

  String get location => GoRouteData.$location(
        '/signin',
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

extension $SignupRouteExtension on SignupRoute {
  static SignupRoute _fromState(GoRouterState state) => SignupRoute();

  String get location => GoRouteData.$location(
        '/signup',
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

extension $VerificationRouteExtension on VerificationRoute {
  static VerificationRoute _fromState(GoRouterState state) =>
      VerificationRoute();

  String get location => GoRouteData.$location(
        '/verification',
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}
