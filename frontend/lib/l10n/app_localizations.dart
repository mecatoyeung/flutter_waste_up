import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_zh.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('zh'),
    Locale('zh', 'CN'),
    Locale('zh', 'TW'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'Waste Up'**
  String get appTitle;

  /// No description provided for @notifications.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get notifications;

  /// No description provided for @account.
  ///
  /// In en, this message translates to:
  /// **'Account'**
  String get account;

  /// No description provided for @signIn.
  ///
  /// In en, this message translates to:
  /// **'Sign in'**
  String get signIn;

  /// No description provided for @signUp.
  ///
  /// In en, this message translates to:
  /// **'Sign up'**
  String get signUp;

  /// No description provided for @welcomeBack.
  ///
  /// In en, this message translates to:
  /// **'Welcome back'**
  String get welcomeBack;

  /// No description provided for @signInSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Sign in to continue finding work that works for you.'**
  String get signInSubtitle;

  /// No description provided for @createAccount.
  ///
  /// In en, this message translates to:
  /// **'Create your account'**
  String get createAccount;

  /// No description provided for @signUpSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Join Waste Up and discover work with purpose.'**
  String get signUpSubtitle;

  /// No description provided for @username.
  ///
  /// In en, this message translates to:
  /// **'Username'**
  String get username;

  /// No description provided for @usernameHint.
  ///
  /// In en, this message translates to:
  /// **'Enter your username'**
  String get usernameHint;

  /// No description provided for @password.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password;

  /// No description provided for @confirmPassword.
  ///
  /// In en, this message translates to:
  /// **'Confirm password'**
  String get confirmPassword;

  /// No description provided for @showPassword.
  ///
  /// In en, this message translates to:
  /// **'Show password'**
  String get showPassword;

  /// No description provided for @hidePassword.
  ///
  /// In en, this message translates to:
  /// **'Hide password'**
  String get hidePassword;

  /// No description provided for @rememberMe.
  ///
  /// In en, this message translates to:
  /// **'Remember me'**
  String get rememberMe;

  /// No description provided for @forgotPassword.
  ///
  /// In en, this message translates to:
  /// **'Forgot password?'**
  String get forgotPassword;

  /// No description provided for @orContinueWith.
  ///
  /// In en, this message translates to:
  /// **'or continue with'**
  String get orContinueWith;

  /// No description provided for @continueWithGoogle.
  ///
  /// In en, this message translates to:
  /// **'Continue with Google'**
  String get continueWithGoogle;

  /// No description provided for @newToWasteUp.
  ///
  /// In en, this message translates to:
  /// **'New to Waste Up?'**
  String get newToWasteUp;

  /// No description provided for @alreadyHaveAccount.
  ///
  /// In en, this message translates to:
  /// **'Already have an account?'**
  String get alreadyHaveAccount;

  /// No description provided for @featureComingSoon.
  ///
  /// In en, this message translates to:
  /// **'This feature will be available soon.'**
  String get featureComingSoon;

  /// No description provided for @authenticationPreview.
  ///
  /// In en, this message translates to:
  /// **'Authentication is not connected yet.'**
  String get authenticationPreview;

  /// No description provided for @signOut.
  ///
  /// In en, this message translates to:
  /// **'Sign out'**
  String get signOut;

  /// No description provided for @allCaughtUp.
  ///
  /// In en, this message translates to:
  /// **'You are all caught up.'**
  String get allCaughtUp;

  /// No description provided for @greeting.
  ///
  /// In en, this message translates to:
  /// **'Good morning, Amara'**
  String get greeting;

  /// No description provided for @heroTitle.
  ///
  /// In en, this message translates to:
  /// **'Find work that\nworks for you.'**
  String get heroTitle;

  /// No description provided for @searchHint.
  ///
  /// In en, this message translates to:
  /// **'Job title, skill, or organisation'**
  String get searchHint;

  /// No description provided for @clearSearch.
  ///
  /// In en, this message translates to:
  /// **'Clear search'**
  String get clearSearch;

  /// No description provided for @nearby.
  ///
  /// In en, this message translates to:
  /// **'Nearby'**
  String get nearby;

  /// No description provided for @nearMe.
  ///
  /// In en, this message translates to:
  /// **'Near me'**
  String get nearMe;

  /// No description provided for @filters.
  ///
  /// In en, this message translates to:
  /// **'Filters'**
  String get filters;

  /// No description provided for @filtersMessage.
  ///
  /// In en, this message translates to:
  /// **'Filters will help tailor your search.'**
  String get filtersMessage;

  /// No description provided for @impactTitle.
  ///
  /// In en, this message translates to:
  /// **'Small steps, real momentum.'**
  String get impactTitle;

  /// No description provided for @impactDescription.
  ///
  /// In en, this message translates to:
  /// **'Complete your profile to unlock better matches.'**
  String get impactDescription;

  /// No description provided for @profileComplete.
  ///
  /// In en, this message translates to:
  /// **'Your profile is 80% complete.'**
  String get profileComplete;

  /// No description provided for @recommended.
  ///
  /// In en, this message translates to:
  /// **'Recommended for you'**
  String get recommended;

  /// No description provided for @seeAll.
  ///
  /// In en, this message translates to:
  /// **'See all'**
  String get seeAll;

  /// No description provided for @showingAll.
  ///
  /// In en, this message translates to:
  /// **'Showing all opportunities.'**
  String get showingAll;

  /// No description provided for @progress.
  ///
  /// In en, this message translates to:
  /// **'Your progress'**
  String get progress;

  /// No description provided for @profileStrength.
  ///
  /// In en, this message translates to:
  /// **'Profile strength'**
  String get profileStrength;

  /// No description provided for @profileStrengthValue.
  ///
  /// In en, this message translates to:
  /// **'80%'**
  String get profileStrengthValue;

  /// No description provided for @availabilityPrompt.
  ///
  /// In en, this message translates to:
  /// **'Add your availability to make your profile stand out.'**
  String get availabilityPrompt;

  /// No description provided for @discover.
  ///
  /// In en, this message translates to:
  /// **'Discover'**
  String get discover;

  /// No description provided for @saved.
  ///
  /// In en, this message translates to:
  /// **'Saved'**
  String get saved;

  /// No description provided for @applied.
  ///
  /// In en, this message translates to:
  /// **'Applied'**
  String get applied;

  /// No description provided for @profile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profile;

  /// No description provided for @savedRoles.
  ///
  /// In en, this message translates to:
  /// **'Saved roles'**
  String get savedRoles;

  /// No description provided for @yourApplications.
  ///
  /// In en, this message translates to:
  /// **'Your applications'**
  String get yourApplications;

  /// No description provided for @yourProfile.
  ///
  /// In en, this message translates to:
  /// **'Your profile'**
  String get yourProfile;

  /// No description provided for @noOpportunities.
  ///
  /// In en, this message translates to:
  /// **'No opportunities found'**
  String get noOpportunities;

  /// No description provided for @tryDifferentSearch.
  ///
  /// In en, this message translates to:
  /// **'Try a different title or skill.'**
  String get tryDifferentSearch;

  /// No description provided for @removeSavedJob.
  ///
  /// In en, this message translates to:
  /// **'Remove saved job'**
  String get removeSavedJob;

  /// No description provided for @saveJob.
  ///
  /// In en, this message translates to:
  /// **'Save job'**
  String get saveJob;

  /// No description provided for @applyNow.
  ///
  /// In en, this message translates to:
  /// **'Apply now'**
  String get applyNow;

  /// No description provided for @applicationStarted.
  ///
  /// In en, this message translates to:
  /// **'Application started for {jobTitle}.'**
  String applicationStarted(Object jobTitle);

  /// No description provided for @communityGardenAssistant.
  ///
  /// In en, this message translates to:
  /// **'Community Garden Assistant'**
  String get communityGardenAssistant;

  /// No description provided for @greenRootsCollective.
  ///
  /// In en, this message translates to:
  /// **'Green Roots Collective'**
  String get greenRootsCollective;

  /// No description provided for @riversideLocation.
  ///
  /// In en, this message translates to:
  /// **'Riverside · 1.4 km away'**
  String get riversideLocation;

  /// No description provided for @partTime.
  ///
  /// In en, this message translates to:
  /// **'Part-time'**
  String get partTime;

  /// No description provided for @recyclingSorter.
  ///
  /// In en, this message translates to:
  /// **'Recycling Sorter'**
  String get recyclingSorter;

  /// No description provided for @secondCycle.
  ///
  /// In en, this message translates to:
  /// **'Second Cycle Co.'**
  String get secondCycle;

  /// No description provided for @centralDistrictLocation.
  ///
  /// In en, this message translates to:
  /// **'Central District · 2.1 km away'**
  String get centralDistrictLocation;

  /// No description provided for @flexibleShifts.
  ///
  /// In en, this message translates to:
  /// **'Flexible shifts'**
  String get flexibleShifts;

  /// No description provided for @kitchenSupportWorker.
  ///
  /// In en, this message translates to:
  /// **'Kitchen Support Worker'**
  String get kitchenSupportWorker;

  /// No description provided for @goodTable.
  ///
  /// In en, this message translates to:
  /// **'The Good Table'**
  String get goodTable;

  /// No description provided for @marketSquareLocation.
  ///
  /// In en, this message translates to:
  /// **'Market Square · 3.0 km away'**
  String get marketSquareLocation;

  /// No description provided for @fullTime.
  ///
  /// In en, this message translates to:
  /// **'Full-time'**
  String get fullTime;

  /// No description provided for @pay14.
  ///
  /// In en, this message translates to:
  /// **'£14/hr'**
  String get pay14;

  /// No description provided for @pay15.
  ///
  /// In en, this message translates to:
  /// **'£15/hr'**
  String get pay15;

  /// No description provided for @pay16.
  ///
  /// In en, this message translates to:
  /// **'£16/hr'**
  String get pay16;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'zh'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when language+country codes are specified.
  switch (locale.languageCode) {
    case 'zh':
      {
        switch (locale.countryCode) {
          case 'CN':
            return AppLocalizationsZhCn();
          case 'TW':
            return AppLocalizationsZhTw();
        }
        break;
      }
  }

  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'zh':
      return AppLocalizationsZh();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
