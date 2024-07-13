// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_router.dart';

// **************************************************************************
// GoRouterGenerator
// **************************************************************************

List<RouteBase> get $appRoutes => [
      $onboardingRoute,
      $signinRoute,
      $signupRoute,
      $verificationRoute,
    ];

RouteBase get $onboardingRoute => GoRouteData.$route(
      path: '/auth/onboarding',
      factory: $OnboardingRouteExtension._fromState,
    );

extension $OnboardingRouteExtension on OnboardingRoute {
  static OnboardingRoute _fromState(GoRouterState state) =>
      const OnboardingRoute();

  String get location => GoRouteData.$location(
        '/auth/onboarding',
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

RouteBase get $signinRoute => GoRouteData.$route(
      path: '/auth/signin',
      factory: $SigninRouteExtension._fromState,
    );

extension $SigninRouteExtension on SigninRoute {
  static SigninRoute _fromState(GoRouterState state) => const SigninRoute();

  String get location => GoRouteData.$location(
        '/auth/signin',
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

RouteBase get $signupRoute => GoRouteData.$route(
      path: '/auth/signup',
      factory: $SignupRouteExtension._fromState,
    );

extension $SignupRouteExtension on SignupRoute {
  static SignupRoute _fromState(GoRouterState state) => const SignupRoute();

  String get location => GoRouteData.$location(
        '/auth/signup',
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

RouteBase get $verificationRoute => GoRouteData.$route(
      path: '/auth/verification',
      factory: $VerificationRouteExtension._fromState,
    );

extension $VerificationRouteExtension on VerificationRoute {
  static VerificationRoute _fromState(GoRouterState state) => VerificationRoute(
        shouldRequest: _$convertMapValue(
                'should-request', state.uri.queryParameters, _$boolConverter) ??
            false,
      );

  String get location => GoRouteData.$location(
        '/auth/verification',
        queryParams: {
          if (shouldRequest != false)
            'should-request': shouldRequest.toString(),
        },
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

T? _$convertMapValue<T>(
  String key,
  Map<String, String> map,
  T Function(String) converter,
) {
  final value = map[key];
  return value == null ? null : converter(value);
}

bool _$boolConverter(String value) {
  switch (value) {
    case 'true':
      return true;
    case 'false':
      return false;
    default:
      throw UnsupportedError('Cannot convert "$value" into a bool.');
  }
}
