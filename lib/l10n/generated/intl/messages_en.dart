// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a en locale. All the
// messages from the main program should be duplicated here with the same
// function name.

// Ignore issues from commonly used lints in this file.
// ignore_for_file:unnecessary_brace_in_string_interps, unnecessary_new
// ignore_for_file:prefer_single_quotes,comment_references, directives_ordering
// ignore_for_file:annotate_overrides,prefer_generic_function_type_aliases
// ignore_for_file:unused_import, file_names, avoid_escaping_inner_quotes
// ignore_for_file:unnecessary_string_interpolations, unnecessary_string_escapes

import 'package:intl/intl.dart';
import 'package:intl/message_lookup_by_library.dart';

final messages = new MessageLookup();

typedef String MessageIfAbsent(String messageStr, List<dynamic> args);

class MessageLookup extends MessageLookupByLibrary {
  String get localeName => 'en';

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
        "errorConfirmationPasswordValidationInvalid":
            MessageLookupByLibrary.simpleMessage(
                "Confirmation password must be same as password."),
        "errorEmailValidationEmpty": MessageLookupByLibrary.simpleMessage(
            "Please enter your email address."),
        "errorEmailValidationInvalid": MessageLookupByLibrary.simpleMessage(
            "Please enter a valid email address (e.g., user@example.com)."),
        "errorNameValidationEmpty": MessageLookupByLibrary.simpleMessage(
            "Please enter your full name."),
        "errorPasswordValidationEmpty":
            MessageLookupByLibrary.simpleMessage("Please enter your password."),
        "errorPasswordValidationInvalid": MessageLookupByLibrary.simpleMessage(
            "Password must be at least 8 characters or more."),
        "errorPhoneValidationInvalid": MessageLookupByLibrary.simpleMessage(
            "Please enter a valid phone number."),
        "errorVerificationEmpty": MessageLookupByLibrary.simpleMessage(
            "Please enter a valid verification code."),
        "inputConfirmationPasswordLabel":
            MessageLookupByLibrary.simpleMessage("Confirmation Password"),
        "inputEmailPlaceholder":
            MessageLookupByLibrary.simpleMessage("Alamat email kamu."),
        "inputNameLabel": MessageLookupByLibrary.simpleMessage("Fullname"),
        "inputNamePlaceholder":
            MessageLookupByLibrary.simpleMessage("Your full name here."),
        "inputPasswordPlaceholder": MessageLookupByLibrary.simpleMessage(
            "Enter your password (min 8 characters)."),
        "inputPhoneLabel": MessageLookupByLibrary.simpleMessage("Phone Number"),
        "inputPhonePlaceholder":
            MessageLookupByLibrary.simpleMessage("Your phone number."),
        "or": MessageLookupByLibrary.simpleMessage("Or"),
        "pageOnboardingDescription": MessageLookupByLibrary.simpleMessage(
            "Experience the ease of scheduling medical checkup anytime, anywhere with our app."),
        "pageOnboardingTitle":
            MessageLookupByLibrary.simpleMessage("Welcome to Clinic!"),
        "pageSignInDescription": MessageLookupByLibrary.simpleMessage(
            "Hello, how are you? not feeling great? Don\'t worry we got you covered, check your health easily!"),
        "pageSignInNoAccount":
            MessageLookupByLibrary.simpleMessage("Don\'t have an account yet?"),
        "pageSignInTitle": MessageLookupByLibrary.simpleMessage("Hi, Welcome!"),
        "pageSignUpDescription": MessageLookupByLibrary.simpleMessage(
            "Start with make an account and then you can check your health anytime, anywhere!"),
        "pageSignUpHadAccount": MessageLookupByLibrary.simpleMessage(
            "Already have an account yet?"),
        "pageVerificationDescription": MessageLookupByLibrary.simpleMessage(
            "Enter the verification code (OTP) that we have sent to your email."),
        "pageVerificationResendNotice": MessageLookupByLibrary.simpleMessage(
            "Did\'nt recieve the verification code yet?"),
        "resend": MessageLookupByLibrary.simpleMessage("Resend"),
        "signIn": MessageLookupByLibrary.simpleMessage("Sign in"),
        "signUp": MessageLookupByLibrary.simpleMessage("Create an account"),
        "verification": MessageLookupByLibrary.simpleMessage("Verification"),
        "verificationButtonText": MessageLookupByLibrary.simpleMessage("Verify")
      };
}
