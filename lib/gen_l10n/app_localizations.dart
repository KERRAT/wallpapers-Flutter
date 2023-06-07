import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_af.dart';
import 'app_localizations_am.dart';
import 'app_localizations_ar.dart';
import 'app_localizations_az.dart';
import 'app_localizations_be.dart';
import 'app_localizations_bg.dart';
import 'app_localizations_bn.dart';
import 'app_localizations_bs.dart';
import 'app_localizations_ca.dart';
import 'app_localizations_co.dart';
import 'app_localizations_cs.dart';
import 'app_localizations_cy.dart';
import 'app_localizations_da.dart';
import 'app_localizations_de.dart';
import 'app_localizations_el.dart';
import 'app_localizations_en.dart';
import 'app_localizations_eo.dart';
import 'app_localizations_es.dart';
import 'app_localizations_et.dart';
import 'app_localizations_eu.dart';
import 'app_localizations_fa.dart';
import 'app_localizations_fi.dart';
import 'app_localizations_fr.dart';
import 'app_localizations_fy.dart';
import 'app_localizations_ga.dart';
import 'app_localizations_gd.dart';
import 'app_localizations_gl.dart';
import 'app_localizations_gu.dart';
import 'app_localizations_ha.dart';
import 'app_localizations_he.dart';
import 'app_localizations_hi.dart';
import 'app_localizations_hr.dart';
import 'app_localizations_hu.dart';
import 'app_localizations_hy.dart';
import 'app_localizations_id.dart';
import 'app_localizations_is.dart';
import 'app_localizations_it.dart';
import 'app_localizations_ja.dart';
import 'app_localizations_jv.dart';
import 'app_localizations_ka.dart';
import 'app_localizations_kk.dart';
import 'app_localizations_kn.dart';
import 'app_localizations_ko.dart';
import 'app_localizations_ku.dart';
import 'app_localizations_ky.dart';
import 'app_localizations_la.dart';
import 'app_localizations_lb.dart';
import 'app_localizations_lo.dart';
import 'app_localizations_lt.dart';
import 'app_localizations_lv.dart';
import 'app_localizations_mg.dart';
import 'app_localizations_mi.dart';
import 'app_localizations_mk.dart';
import 'app_localizations_ml.dart';
import 'app_localizations_mn.dart';
import 'app_localizations_mr.dart';
import 'app_localizations_ms.dart';
import 'app_localizations_mt.dart';
import 'app_localizations_ne.dart';
import 'app_localizations_nl.dart';
import 'app_localizations_no.dart';
import 'app_localizations_pa.dart';
import 'app_localizations_pl.dart';
import 'app_localizations_pt.dart';
import 'app_localizations_ro.dart';
import 'app_localizations_ru.dart';
import 'app_localizations_sd.dart';
import 'app_localizations_si.dart';
import 'app_localizations_sk.dart';
import 'app_localizations_sl.dart';
import 'app_localizations_sm.dart';
import 'app_localizations_so.dart';
import 'app_localizations_sq.dart';
import 'app_localizations_sr.dart';
import 'app_localizations_su.dart';
import 'app_localizations_sv.dart';
import 'app_localizations_sw.dart';
import 'app_localizations_ta.dart';
import 'app_localizations_te.dart';
import 'app_localizations_tg.dart';
import 'app_localizations_tl.dart';
import 'app_localizations_tr.dart';
import 'app_localizations_uk.dart';
import 'app_localizations_ur.dart';
import 'app_localizations_uz.dart';
import 'app_localizations_vi.dart';
import 'app_localizations_yi.dart';
import 'app_localizations_yo.dart';
import 'app_localizations_zh.dart';

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'gen_l10n/app_localizations.dart';
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
  AppLocalizations(String locale) : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

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
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates = <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('af'),
    Locale('am'),
    Locale('ar'),
    Locale('az'),
    Locale('be'),
    Locale('bg'),
    Locale('bn'),
    Locale('bs'),
    Locale('ca'),
    Locale('co'),
    Locale('cs'),
    Locale('cy'),
    Locale('da'),
    Locale('de'),
    Locale('el'),
    Locale('en'),
    Locale('eo'),
    Locale('es'),
    Locale('et'),
    Locale('eu'),
    Locale('fa'),
    Locale('fi'),
    Locale('fr'),
    Locale('fy'),
    Locale('ga'),
    Locale('gd'),
    Locale('gl'),
    Locale('gu'),
    Locale('ha'),
    Locale('hi'),
    Locale('hr'),
    Locale('hu'),
    Locale('hy'),
    Locale('id'),
    Locale('is'),
    Locale('it'),
    Locale('he'),
    Locale('ja'),
    Locale('jv'),
    Locale('ka'),
    Locale('kk'),
    Locale('kn'),
    Locale('ko'),
    Locale('ku'),
    Locale('ky'),
    Locale('la'),
    Locale('lb'),
    Locale('lo'),
    Locale('lt'),
    Locale('lv'),
    Locale('mg'),
    Locale('mi'),
    Locale('mk'),
    Locale('ml'),
    Locale('mn'),
    Locale('mr'),
    Locale('ms'),
    Locale('mt'),
    Locale('ne'),
    Locale('nl'),
    Locale('no'),
    Locale('pa'),
    Locale('pl'),
    Locale('pt'),
    Locale('ro'),
    Locale('ru'),
    Locale('sd'),
    Locale('si'),
    Locale('sk'),
    Locale('sl'),
    Locale('sm'),
    Locale('so'),
    Locale('sq'),
    Locale('sr'),
    Locale('su'),
    Locale('sv'),
    Locale('sw'),
    Locale('ta'),
    Locale('te'),
    Locale('tg'),
    Locale('tl'),
    Locale('tr'),
    Locale('uk'),
    Locale('ur'),
    Locale('uz'),
    Locale('vi'),
    Locale('yi'),
    Locale('yo'),
    Locale('zh')
  ];

  /// No description provided for @app_name.
  ///
  /// In en, this message translates to:
  /// **'Amazing Wallpapers 4K'**
  String get app_name;

  /// No description provided for @udostepnij_tresc.
  ///
  /// In en, this message translates to:
  /// **'Get app https://play.google.com/store/apps/details?id=brak_ustawienia_GLOWNA_nazwa_paczki_app'**
  String get udostepnij_tresc;

  /// No description provided for @action_settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get action_settings;

  /// No description provided for @drawer_open.
  ///
  /// In en, this message translates to:
  /// **'Open'**
  String get drawer_open;

  /// No description provided for @drawer_close.
  ///
  /// In en, this message translates to:
  /// **'Close the application'**
  String get drawer_close;

  /// No description provided for @change_wallpaper_index_message.
  ///
  /// In en, this message translates to:
  /// **'Go to the wallpaper'**
  String get change_wallpaper_index_message;

  /// No description provided for @error_message_wrong_number.
  ///
  /// In en, this message translates to:
  /// **'Invalid number'**
  String get error_message_wrong_number;

  /// No description provided for @set.
  ///
  /// In en, this message translates to:
  /// **'Submit'**
  String get set;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @notification_image_downloaded_show_image.
  ///
  /// In en, this message translates to:
  /// **'Show wallpaper'**
  String get notification_image_downloaded_show_image;

  /// No description provided for @error.
  ///
  /// In en, this message translates to:
  /// **'error'**
  String get error;

  /// No description provided for @no_internet_connection.
  ///
  /// In en, this message translates to:
  /// **'No internet connection'**
  String get no_internet_connection;

  /// No description provided for @turn_on_wifi.
  ///
  /// In en, this message translates to:
  /// **'Turn on the internet'**
  String get turn_on_wifi;

  /// No description provided for @try_again.
  ///
  /// In en, this message translates to:
  /// **'try again'**
  String get try_again;

  /// No description provided for @exit.
  ///
  /// In en, this message translates to:
  /// **'Exit'**
  String get exit;

  /// No description provided for @no_favorites_message.
  ///
  /// In en, this message translates to:
  /// **'To add wallpaper to your favorites click:'**
  String get no_favorites_message;

  /// No description provided for @back.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get back;

  /// No description provided for @rate_the_app.
  ///
  /// In en, this message translates to:
  /// **'Rate the app'**
  String get rate_the_app;

  /// No description provided for @info_loading_is_in_progress.
  ///
  /// In en, this message translates to:
  /// **'Loading ...'**
  String get info_loading_is_in_progress;

  /// No description provided for @wallpaper_has_been_set_message.
  ///
  /// In en, this message translates to:
  /// **'The wallpaper has been changed'**
  String get wallpaper_has_been_set_message;

  /// No description provided for @wallpaper_has_been_downloaded_message.
  ///
  /// In en, this message translates to:
  /// **'The wallpaper has been saved to the gallery'**
  String get wallpaper_has_been_downloaded_message;

  /// No description provided for @wallpaper_is_loading_message.
  ///
  /// In en, this message translates to:
  /// **'Loading wallpaper...'**
  String get wallpaper_is_loading_message;

  /// No description provided for @exit_confirmation_message.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to close the application?'**
  String get exit_confirmation_message;

  /// No description provided for @wallpaper_changed.
  ///
  /// In en, this message translates to:
  /// **'The wallpaper has been changed'**
  String get wallpaper_changed;

  /// No description provided for @message_on_download_complete.
  ///
  /// In en, this message translates to:
  /// **'The wallpaper has been saved to the gallery'**
  String get message_on_download_complete;

  /// No description provided for @czy_napewno_chcesz_wyjsc_z_aplikacji.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to close the application?'**
  String get czy_napewno_chcesz_wyjsc_z_aplikacji;

  /// No description provided for @wallpaper_changed_ekran_blokady.
  ///
  /// In en, this message translates to:
  /// **'The lock screen wallpaper has been changed'**
  String get wallpaper_changed_ekran_blokady;

  /// No description provided for @wallpaper_changed_ekran_glowny.
  ///
  /// In en, this message translates to:
  /// **'The home screen wallpaper has been changed'**
  String get wallpaper_changed_ekran_glowny;

  /// No description provided for @wallpapers_download_message.
  ///
  /// In en, this message translates to:
  /// **'The wallpaper has been saved to the gallery'**
  String get wallpapers_download_message;

  /// No description provided for @please_wait.
  ///
  /// In en, this message translates to:
  /// **'Please wait...'**
  String get please_wait;

  /// No description provided for @share_wallpapers.
  ///
  /// In en, this message translates to:
  /// **'Share wallpaper'**
  String get share_wallpapers;

  /// No description provided for @categories.
  ///
  /// In en, this message translates to:
  /// **'Categories'**
  String get categories;

  /// No description provided for @search_category.
  ///
  /// In en, this message translates to:
  /// **'Search ...'**
  String get search_category;

  /// No description provided for @set_lockscreen.
  ///
  /// In en, this message translates to:
  /// **'Set on the lock screen'**
  String get set_lockscreen;

  /// No description provided for @set_screen.
  ///
  /// In en, this message translates to:
  /// **'Set on the home screen'**
  String get set_screen;

  /// No description provided for @menu_najlepsze.
  ///
  /// In en, this message translates to:
  /// **'Best'**
  String get menu_najlepsze;

  /// No description provided for @menu_najnowsze.
  ///
  /// In en, this message translates to:
  /// **'New'**
  String get menu_najnowsze;

  /// No description provided for @menu_ulubione.
  ///
  /// In en, this message translates to:
  /// **'My favorites'**
  String get menu_ulubione;

  /// No description provided for @exit_message.
  ///
  /// In en, this message translates to:
  /// **'View recommended applications.'**
  String get exit_message;

  /// No description provided for @exit_polecamy.
  ///
  /// In en, this message translates to:
  /// **'Exit'**
  String get exit_polecamy;

  /// No description provided for @exit_share.
  ///
  /// In en, this message translates to:
  /// **'Recommend app'**
  String get exit_share;

  /// No description provided for @exit_share_text.
  ///
  /// In en, this message translates to:
  /// **'Get app'**
  String get exit_share_text;

  /// No description provided for @exit_rate_app.
  ///
  /// In en, this message translates to:
  /// **'Rate app'**
  String get exit_rate_app;

  /// No description provided for @wcag_menu.
  ///
  /// In en, this message translates to:
  /// **'Menu'**
  String get wcag_menu;

  /// No description provided for @wcag_nastepna.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get wcag_nastepna;

  /// No description provided for @wcag_poprzednia.
  ///
  /// In en, this message translates to:
  /// **'Previous'**
  String get wcag_poprzednia;

  /// No description provided for @wcag_udostepnij.
  ///
  /// In en, this message translates to:
  /// **'Share wallpaper'**
  String get wcag_udostepnij;

  /// No description provided for @wcag_ulubione.
  ///
  /// In en, this message translates to:
  /// **'My favorites'**
  String get wcag_ulubione;

  /// No description provided for @wcag_ustaw_tapete.
  ///
  /// In en, this message translates to:
  /// **'Set on the home screen'**
  String get wcag_ustaw_tapete;

  /// No description provided for @wcag_ustaw_tapete_blokada.
  ///
  /// In en, this message translates to:
  /// **'Set on the lock screen'**
  String get wcag_ustaw_tapete_blokada;

  /// No description provided for @ad_fullscreen_introduction_message.
  ///
  /// In en, this message translates to:
  /// **'Ads loading...'**
  String get ad_fullscreen_introduction_message;

  /// No description provided for @default_notification_channel_id.
  ///
  /// In en, this message translates to:
  /// **'default_notification_channel_id'**
  String get default_notification_channel_id;

  /// No description provided for @default_notification_channel_name.
  ///
  /// In en, this message translates to:
  /// **'News'**
  String get default_notification_channel_name;
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['af', 'am', 'ar', 'az', 'be', 'bg', 'bn', 'bs', 'ca', 'co', 'cs', 'cy', 'da', 'de', 'el', 'en', 'eo', 'es', 'et', 'eu', 'fa', 'fi', 'fr', 'fy', 'ga', 'gd', 'gl', 'gu', 'ha', 'hi', 'hr', 'hu', 'hy', 'id', 'is', 'it', 'he', 'ja', 'jv', 'ka', 'kk', 'kn', 'ko', 'ku', 'ky', 'la', 'lb', 'lo', 'lt', 'lv', 'mg', 'mi', 'mk', 'ml', 'mn', 'mr', 'ms', 'mt', 'ne', 'nl', 'no', 'pa', 'pl', 'pt', 'ro', 'ru', 'sd', 'si', 'sk', 'sl', 'sm', 'so', 'sq', 'sr', 'su', 'sv', 'sw', 'ta', 'te', 'tg', 'tl', 'tr', 'uk', 'ur', 'uz', 'vi', 'yi', 'yo', 'zh'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {


  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'af': return AppLocalizationsAf();
    case 'am': return AppLocalizationsAm();
    case 'ar': return AppLocalizationsAr();
    case 'az': return AppLocalizationsAz();
    case 'be': return AppLocalizationsBe();
    case 'bg': return AppLocalizationsBg();
    case 'bn': return AppLocalizationsBn();
    case 'bs': return AppLocalizationsBs();
    case 'ca': return AppLocalizationsCa();
    case 'co': return AppLocalizationsCo();
    case 'cs': return AppLocalizationsCs();
    case 'cy': return AppLocalizationsCy();
    case 'da': return AppLocalizationsDa();
    case 'de': return AppLocalizationsDe();
    case 'el': return AppLocalizationsEl();
    case 'en': return AppLocalizationsEn();
    case 'eo': return AppLocalizationsEo();
    case 'es': return AppLocalizationsEs();
    case 'et': return AppLocalizationsEt();
    case 'eu': return AppLocalizationsEu();
    case 'fa': return AppLocalizationsFa();
    case 'fi': return AppLocalizationsFi();
    case 'fr': return AppLocalizationsFr();
    case 'fy': return AppLocalizationsFy();
    case 'ga': return AppLocalizationsGa();
    case 'gd': return AppLocalizationsGd();
    case 'gl': return AppLocalizationsGl();
    case 'gu': return AppLocalizationsGu();
    case 'ha': return AppLocalizationsHa();
    case 'hi': return AppLocalizationsHi();
    case 'hr': return AppLocalizationsHr();
    case 'hu': return AppLocalizationsHu();
    case 'hy': return AppLocalizationsHy();
    case 'id': return AppLocalizationsId();
    case 'is': return AppLocalizationsIs();
    case 'it': return AppLocalizationsIt();
    case 'he': return AppLocalizationsHe();
    case 'ja': return AppLocalizationsJa();
    case 'jv': return AppLocalizationsJv();
    case 'ka': return AppLocalizationsKa();
    case 'kk': return AppLocalizationsKk();
    case 'kn': return AppLocalizationsKn();
    case 'ko': return AppLocalizationsKo();
    case 'ku': return AppLocalizationsKu();
    case 'ky': return AppLocalizationsKy();
    case 'la': return AppLocalizationsLa();
    case 'lb': return AppLocalizationsLb();
    case 'lo': return AppLocalizationsLo();
    case 'lt': return AppLocalizationsLt();
    case 'lv': return AppLocalizationsLv();
    case 'mg': return AppLocalizationsMg();
    case 'mi': return AppLocalizationsMi();
    case 'mk': return AppLocalizationsMk();
    case 'ml': return AppLocalizationsMl();
    case 'mn': return AppLocalizationsMn();
    case 'mr': return AppLocalizationsMr();
    case 'ms': return AppLocalizationsMs();
    case 'mt': return AppLocalizationsMt();
    case 'ne': return AppLocalizationsNe();
    case 'nl': return AppLocalizationsNl();
    case 'no': return AppLocalizationsNo();
    case 'pa': return AppLocalizationsPa();
    case 'pl': return AppLocalizationsPl();
    case 'pt': return AppLocalizationsPt();
    case 'ro': return AppLocalizationsRo();
    case 'ru': return AppLocalizationsRu();
    case 'sd': return AppLocalizationsSd();
    case 'si': return AppLocalizationsSi();
    case 'sk': return AppLocalizationsSk();
    case 'sl': return AppLocalizationsSl();
    case 'sm': return AppLocalizationsSm();
    case 'so': return AppLocalizationsSo();
    case 'sq': return AppLocalizationsSq();
    case 'sr': return AppLocalizationsSr();
    case 'su': return AppLocalizationsSu();
    case 'sv': return AppLocalizationsSv();
    case 'sw': return AppLocalizationsSw();
    case 'ta': return AppLocalizationsTa();
    case 'te': return AppLocalizationsTe();
    case 'tg': return AppLocalizationsTg();
    case 'tl': return AppLocalizationsTl();
    case 'tr': return AppLocalizationsTr();
    case 'uk': return AppLocalizationsUk();
    case 'ur': return AppLocalizationsUr();
    case 'uz': return AppLocalizationsUz();
    case 'vi': return AppLocalizationsVi();
    case 'yi': return AppLocalizationsYi();
    case 'yo': return AppLocalizationsYo();
    case 'zh': return AppLocalizationsZh();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.'
  );
}
