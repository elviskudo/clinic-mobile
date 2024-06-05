// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, lines_longer_than_80_chars
// ignore_for_file: join_return_with_assignment, prefer_final_in_for_each
// ignore_for_file: avoid_redundant_argument_values, avoid_escaping_inner_quotes

class S {
  S();

  static S? _current;

  static S get current {
    assert(_current != null,
        'No instance of S was loaded. Try to initialize the S delegate before accessing S.current.');
    return _current!;
  }

  static const AppLocalizationDelegate delegate = AppLocalizationDelegate();

  static Future<S> load(Locale locale) {
    final name = (locale.countryCode?.isEmpty ?? false)
        ? locale.languageCode
        : locale.toString();
    final localeName = Intl.canonicalizedLocale(name);
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      final instance = S();
      S._current = instance;

      return instance;
    });
  }

  static S of(BuildContext context) {
    final instance = S.maybeOf(context);
    assert(instance != null,
        'No instance of S present in the widget tree. Did you add S.delegate in localizationsDelegates?');
    return instance!;
  }

  static S? maybeOf(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  /// `Oops! It looks like you're offline.`
  String get offline {
    return Intl.message(
      'Oops! It looks like you\'re offline.',
      name: 'offline',
      desc: 'offline',
      args: [],
    );
  }

  /// `Welcome to Clinic!`
  String get pageOnboardingTitle {
    return Intl.message(
      'Welcome to Clinic!',
      name: 'pageOnboardingTitle',
      desc: 'pageOnboardingTitle',
      args: [],
    );
  }

  /// `Experience the ease of scheduling medical checkup anytime, anywhere with our app.`
  String get pageOnboardingDescription {
    return Intl.message(
      'Experience the ease of scheduling medical checkup anytime, anywhere with our app.',
      name: 'pageOnboardingDescription',
      desc: 'pageOnboardingDescription',
      args: [],
    );
  }

  /// `Sign in`
  String get signIn {
    return Intl.message(
      'Sign in',
      name: 'signIn',
      desc: 'signIn',
      args: [],
    );
  }

  /// `Failed to sign in. Make sure your credentials is valid before trying again.`
  String get signInError {
    return Intl.message(
      'Failed to sign in. Make sure your credentials is valid before trying again.',
      name: 'signInError',
      desc: 'signInError',
      args: [],
    );
  }

  /// `Create an account`
  String get signUp {
    return Intl.message(
      'Create an account',
      name: 'signUp',
      desc: 'signUp',
      args: [],
    );
  }

  /// `Failed to create an account. Make sure your credentials is valid before trying again.`
  String get signUpError {
    return Intl.message(
      'Failed to create an account. Make sure your credentials is valid before trying again.',
      name: 'signUpError',
      desc: 'signUpError',
      args: [],
    );
  }

  /// `Account verification failed. Try to resend otp code.`
  String get verificationError {
    return Intl.message(
      'Account verification failed. Try to resend otp code.',
      name: 'verificationError',
      desc: 'verificationError',
      args: [],
    );
  }

  /// `Start with make an account and then you can check your health anytime, anywhere!`
  String get pageSignUpDescription {
    return Intl.message(
      'Start with make an account and then you can check your health anytime, anywhere!',
      name: 'pageSignUpDescription',
      desc: 'pageSignUpDescription',
      args: [],
    );
  }

  /// `Already have an account yet?`
  String get pageSignUpHadAccount {
    return Intl.message(
      'Already have an account yet?',
      name: 'pageSignUpHadAccount',
      desc: 'pageSignUpHadAccount',
      args: [],
    );
  }

  /// `Hi, Welcome!`
  String get pageSignInTitle {
    return Intl.message(
      'Hi, Welcome!',
      name: 'pageSignInTitle',
      desc: 'pageSignInTitle',
      args: [],
    );
  }

  /// `Hello, how are you? not feeling great? Don't worry we got you covered, check your health easily!`
  String get pageSignInDescription {
    return Intl.message(
      'Hello, how are you? not feeling great? Don\'t worry we got you covered, check your health easily!',
      name: 'pageSignInDescription',
      desc: 'pageSignInDescription',
      args: [],
    );
  }

  /// `Don't have an account yet?`
  String get pageSignInNoAccount {
    return Intl.message(
      'Don\'t have an account yet?',
      name: 'pageSignInNoAccount',
      desc: 'pageSignInNoAccount',
      args: [],
    );
  }

  /// `Or`
  String get or {
    return Intl.message(
      'Or',
      name: 'or',
      desc: 'or',
      args: [],
    );
  }

  /// `Add Appointment`
  String get pageHomeAddAppointment {
    return Intl.message(
      'Add Appointment',
      name: 'pageHomeAddAppointment',
      desc: 'pageHomeAddAppointment',
      args: [],
    );
  }

  /// `How's Your health?`
  String get pageHomeMicrocopyDesc {
    return Intl.message(
      'How\'s Your health?',
      name: 'pageHomeMicrocopyDesc',
      desc: 'pageHomeMicrocopyDesc',
      args: [],
    );
  }

  /// `Fullname`
  String get inputNameLabel {
    return Intl.message(
      'Fullname',
      name: 'inputNameLabel',
      desc: 'inputNameLabel',
      args: [],
    );
  }

  /// `Your full name here.`
  String get inputNamePlaceholder {
    return Intl.message(
      'Your full name here.',
      name: 'inputNamePlaceholder',
      desc: 'inputNamePlaceholder',
      args: [],
    );
  }

  /// `Please enter your full name.`
  String get errorNameValidationEmpty {
    return Intl.message(
      'Please enter your full name.',
      name: 'errorNameValidationEmpty',
      desc: 'errorNameValidationEmpty',
      args: [],
    );
  }

  /// `Alamat email kamu.`
  String get inputEmailPlaceholder {
    return Intl.message(
      'Alamat email kamu.',
      name: 'inputEmailPlaceholder',
      desc: 'inputEmailPlaceholder',
      args: [],
    );
  }

  /// `Please enter your email address.`
  String get errorEmailValidationEmpty {
    return Intl.message(
      'Please enter your email address.',
      name: 'errorEmailValidationEmpty',
      desc: 'errorEmailValidationEmpty',
      args: [],
    );
  }

  /// `Please enter a valid email address (e.g., user@example.com).`
  String get errorEmailValidationInvalid {
    return Intl.message(
      'Please enter a valid email address (e.g., user@example.com).',
      name: 'errorEmailValidationInvalid',
      desc: 'errorEmailValidationEmpty',
      args: [],
    );
  }

  /// `Phone Number`
  String get inputPhoneLabel {
    return Intl.message(
      'Phone Number',
      name: 'inputPhoneLabel',
      desc: 'inputPhoneLabel',
      args: [],
    );
  }

  /// `Your phone number.`
  String get inputPhonePlaceholder {
    return Intl.message(
      'Your phone number.',
      name: 'inputPhonePlaceholder',
      desc: 'inputPhonePlaceholder',
      args: [],
    );
  }

  /// `Please enter a valid phone number.`
  String get errorPhoneValidationInvalid {
    return Intl.message(
      'Please enter a valid phone number.',
      name: 'errorPhoneValidationInvalid',
      desc: 'errorPhoneValidationEmpty',
      args: [],
    );
  }

  /// `Enter your password (min 8 characters).`
  String get inputPasswordPlaceholder {
    return Intl.message(
      'Enter your password (min 8 characters).',
      name: 'inputPasswordPlaceholder',
      desc: 'inputPasswordPlaceholder',
      args: [],
    );
  }

  /// `• Should contain at least one upper case\n• Should contain at least one lower case\n• Should contain at least one digit\n• Should contain at least one special character`
  String get inputPasswordDescription {
    return Intl.message(
      '• Should contain at least one upper case\n• Should contain at least one lower case\n• Should contain at least one digit\n• Should contain at least one special character',
      name: 'inputPasswordDescription',
      desc: 'inputPasswordDescription',
      args: [],
    );
  }

  /// `Please enter your password.`
  String get errorPasswordValidationEmpty {
    return Intl.message(
      'Please enter your password.',
      name: 'errorPasswordValidationEmpty',
      desc: 'errorPasswordValidationEmpty',
      args: [],
    );
  }

  /// `Password must be at least 8 characters or more & make sure to match the requirements.`
  String get errorPasswordValidationInvalid {
    return Intl.message(
      'Password must be at least 8 characters or more & make sure to match the requirements.',
      name: 'errorPasswordValidationInvalid',
      desc: 'errorPasswordValidationEmpty',
      args: [],
    );
  }

  /// `Confirmation Password`
  String get inputConfirmationPasswordLabel {
    return Intl.message(
      'Confirmation Password',
      name: 'inputConfirmationPasswordLabel',
      desc: 'inputConfirmationPasswordLabel',
      args: [],
    );
  }

  /// `Confirmation password must be same as password.`
  String get errorConfirmationPasswordValidationInvalid {
    return Intl.message(
      'Confirmation password must be same as password.',
      name: 'errorConfirmationPasswordValidationInvalid',
      desc: 'errorConfirmationPasswordValidationEmpty',
      args: [],
    );
  }

  /// `Verification`
  String get verification {
    return Intl.message(
      'Verification',
      name: 'verification',
      desc: 'verification',
      args: [],
    );
  }

  /// `Verify`
  String get verificationButtonText {
    return Intl.message(
      'Verify',
      name: 'verificationButtonText',
      desc: 'verificationButtonText',
      args: [],
    );
  }

  /// `Enter the verification code (OTP) that we have sent to your email.`
  String get pageVerificationDescription {
    return Intl.message(
      'Enter the verification code (OTP) that we have sent to your email.',
      name: 'pageVerificationDescription',
      desc: 'pageVerificationDescription',
      args: [],
    );
  }

  /// `Did'nt recieve the verification code yet?`
  String get pageVerificationResendNotice {
    return Intl.message(
      'Did\'nt recieve the verification code yet?',
      name: 'pageVerificationResendNotice',
      desc: 'pageVerificationResendNotice',
      args: [],
    );
  }

  /// `Resend`
  String get resend {
    return Intl.message(
      'Resend',
      name: 'resend',
      desc: 'resend',
      args: [],
    );
  }

  /// `Please enter a valid verification code.`
  String get errorVerificationEmpty {
    return Intl.message(
      'Please enter a valid verification code.',
      name: 'errorVerificationEmpty',
      desc: 'errorVerificationEmpty',
      args: [],
    );
  }

  /// `Home`
  String get home {
    return Intl.message(
      'Home',
      name: 'home',
      desc: 'home',
      args: [],
    );
  }

  /// `Histories`
  String get histories {
    return Intl.message(
      'Histories',
      name: 'histories',
      desc: 'histories',
      args: [],
    );
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<S> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'en'),
      Locale.fromSubtags(languageCode: 'id'),
    ];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<S> load(Locale locale) => S.load(locale);
  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    for (var supportedLocale in supportedLocales) {
      if (supportedLocale.languageCode == locale.languageCode) {
        return true;
      }
    }
    return false;
  }
}
