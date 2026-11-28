// ignore_for_file: deprecated_member_use
import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_ky.dart';
import 'app_localizations_ru.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'generated/app_localizations.dart';
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
    Locale('ky'),
    Locale('ru'),
  ];

  /// No description provided for @appName.
  ///
  /// In ru, this message translates to:
  /// **'SafeTrack Family'**
  String get appName;

  /// No description provided for @demo.
  ///
  /// In ru, this message translates to:
  /// **'Демо'**
  String get demo;

  /// No description provided for @map.
  ///
  /// In ru, this message translates to:
  /// **'Карта'**
  String get map;

  /// No description provided for @events.
  ///
  /// In ru, this message translates to:
  /// **'События'**
  String get events;

  /// No description provided for @family.
  ///
  /// In ru, this message translates to:
  /// **'Семья'**
  String get family;

  /// No description provided for @device.
  ///
  /// In ru, this message translates to:
  /// **'Устройство'**
  String get device;

  /// No description provided for @language.
  ///
  /// In ru, this message translates to:
  /// **'Язык интерфейса'**
  String get language;

  /// No description provided for @russian.
  ///
  /// In ru, this message translates to:
  /// **'Русский'**
  String get russian;

  /// No description provided for @english.
  ///
  /// In ru, this message translates to:
  /// **'English'**
  String get english;

  /// No description provided for @kyrgyz.
  ///
  /// In ru, this message translates to:
  /// **'Кыргызча · русский интерфейс'**
  String get kyrgyz;

  /// No description provided for @ayan.
  ///
  /// In ru, this message translates to:
  /// **'Аян'**
  String get ayan;

  /// No description provided for @aigul.
  ///
  /// In ru, this message translates to:
  /// **'Айгуль'**
  String get aigul;

  /// No description provided for @timur.
  ///
  /// In ru, this message translates to:
  /// **'Тимур'**
  String get timur;

  /// No description provided for @tracker.
  ///
  /// In ru, this message translates to:
  /// **'Трекер Аяна'**
  String get tracker;

  /// No description provided for @selector.
  ///
  /// In ru, this message translates to:
  /// **'Выбрать трекер'**
  String get selector;

  /// No description provided for @selectTracker.
  ///
  /// In ru, this message translates to:
  /// **'Трекеры семьи'**
  String get selectTracker;

  /// No description provided for @sample.
  ///
  /// In ru, this message translates to:
  /// **'Последние известные данные'**
  String get sample;

  /// No description provided for @todayTime.
  ///
  /// In ru, this message translates to:
  /// **'Сегодня, 14:32'**
  String get todayTime;

  /// No description provided for @staleTime.
  ///
  /// In ru, this message translates to:
  /// **'Сегодня, 14:08'**
  String get staleTime;

  /// No description provided for @offlineTime.
  ///
  /// In ru, this message translates to:
  /// **'Сегодня, 14:20'**
  String get offlineTime;

  /// No description provided for @accuracyGood.
  ///
  /// In ru, this message translates to:
  /// **'±18 м'**
  String get accuracyGood;

  /// No description provided for @accuracyStale.
  ///
  /// In ru, this message translates to:
  /// **'±32 м'**
  String get accuracyStale;

  /// No description provided for @accuracyOffline.
  ///
  /// In ru, this message translates to:
  /// **'±24 м'**
  String get accuracyOffline;

  /// No description provided for @accuracy.
  ///
  /// In ru, this message translates to:
  /// **'Точность'**
  String get accuracy;

  /// No description provided for @time.
  ///
  /// In ru, this message translates to:
  /// **'Время позиции'**
  String get time;

  /// No description provided for @battery.
  ///
  /// In ru, this message translates to:
  /// **'Заряд'**
  String get battery;

  /// No description provided for @network.
  ///
  /// In ru, this message translates to:
  /// **'Связь'**
  String get network;

  /// No description provided for @online.
  ///
  /// In ru, this message translates to:
  /// **'В сети · LTE'**
  String get online;

  /// No description provided for @offline.
  ///
  /// In ru, this message translates to:
  /// **'Нет связи'**
  String get offline;

  /// No description provided for @fresh.
  ///
  /// In ru, this message translates to:
  /// **'Свежая позиция'**
  String get fresh;

  /// No description provided for @stale.
  ///
  /// In ru, this message translates to:
  /// **'Устаревшая позиция'**
  String get stale;

  /// No description provided for @low.
  ///
  /// In ru, this message translates to:
  /// **'Низкий заряд'**
  String get low;

  /// No description provided for @sos.
  ///
  /// In ru, this message translates to:
  /// **'Тестовый SOS'**
  String get sos;

  /// No description provided for @loading.
  ///
  /// In ru, this message translates to:
  /// **'Загрузка данных'**
  String get loading;

  /// No description provided for @empty.
  ///
  /// In ru, this message translates to:
  /// **'Трекер не подключён'**
  String get empty;

  /// No description provided for @unavailable.
  ///
  /// In ru, this message translates to:
  /// **'Позиция недоступна'**
  String get unavailable;

  /// No description provided for @error.
  ///
  /// In ru, this message translates to:
  /// **'Не удалось загрузить данные'**
  String get error;

  /// No description provided for @recent.
  ///
  /// In ru, this message translates to:
  /// **'24 сек назад'**
  String get recent;

  /// No description provided for @old.
  ///
  /// In ru, this message translates to:
  /// **'24 мин назад'**
  String get old;

  /// No description provided for @offlineAgo.
  ///
  /// In ru, this message translates to:
  /// **'12 мин назад'**
  String get offlineAgo;

  /// No description provided for @lastContact.
  ///
  /// In ru, this message translates to:
  /// **'Последняя связь'**
  String get lastContact;

  /// No description provided for @unknown.
  ///
  /// In ru, this message translates to:
  /// **'Нет данных'**
  String get unknown;

  /// No description provided for @mapLegend.
  ///
  /// In ru, this message translates to:
  /// **'Демонстрационная карта'**
  String get mapLegend;

  /// No description provided for @park.
  ///
  /// In ru, this message translates to:
  /// **'Сад Листьев'**
  String get park;

  /// No description provided for @square.
  ///
  /// In ru, this message translates to:
  /// **'Сквер Маяк'**
  String get square;

  /// No description provided for @river.
  ///
  /// In ru, this message translates to:
  /// **'Река Лента'**
  String get river;

  /// No description provided for @lane.
  ///
  /// In ru, this message translates to:
  /// **'Улица Ив'**
  String get lane;

  /// No description provided for @recenter.
  ///
  /// In ru, this message translates to:
  /// **'На последнее местоположение'**
  String get recenter;

  /// No description provided for @freshDetail.
  ///
  /// In ru, this message translates to:
  /// **'Показана последняя точка из демо-данных.'**
  String get freshDetail;

  /// No description provided for @staleDetail.
  ///
  /// In ru, this message translates to:
  /// **'Позиция давно не обновлялась. Актуальное местоположение неизвестно.'**
  String get staleDetail;

  /// No description provided for @offlineDetail.
  ///
  /// In ru, this message translates to:
  /// **'Показана точка, сохранённая до потери связи.'**
  String get offlineDetail;

  /// No description provided for @lowDetail.
  ///
  /// In ru, this message translates to:
  /// **'В демо-сценарии заряд опустился ниже 20%.'**
  String get lowDetail;

  /// No description provided for @sosDetail.
  ///
  /// In ru, this message translates to:
  /// **'Выбран сценарий SOS. Проверить его можно во вкладке «Устройство».'**
  String get sosDetail;

  /// No description provided for @loadingDetail.
  ///
  /// In ru, this message translates to:
  /// **'Получаем демонстрационные данные трекера.'**
  String get loadingDetail;

  /// No description provided for @emptyDetail.
  ///
  /// In ru, this message translates to:
  /// **'Добавьте демонстрационный трекер, чтобы увидеть его данные.'**
  String get emptyDetail;

  /// No description provided for @unavailableDetail.
  ///
  /// In ru, this message translates to:
  /// **'Трекер на связи, но сохранённых координат пока нет.'**
  String get unavailableDetail;

  /// No description provided for @errorDetail.
  ///
  /// In ru, this message translates to:
  /// **'Данные трекера недоступны. Попробуйте загрузить их ещё раз.'**
  String get errorDetail;

  /// No description provided for @retry.
  ///
  /// In ru, this message translates to:
  /// **'Повторить'**
  String get retry;

  /// No description provided for @state.
  ///
  /// In ru, this message translates to:
  /// **'Демо-сценарий'**
  String get state;

  /// No description provided for @stateHelp.
  ///
  /// In ru, this message translates to:
  /// **'Переключайте локальные состояния трекера.'**
  String get stateHelp;

  /// No description provided for @details.
  ///
  /// In ru, this message translates to:
  /// **'Данные трекера'**
  String get details;

  /// No description provided for @id.
  ///
  /// In ru, this message translates to:
  /// **'Идентификатор'**
  String get id;

  /// No description provided for @firmware.
  ///
  /// In ru, this message translates to:
  /// **'Прошивка'**
  String get firmware;

  /// No description provided for @firmwareValue.
  ///
  /// In ru, this message translates to:
  /// **'0.0.0 · демо'**
  String get firmwareValue;

  /// No description provided for @preferences.
  ///
  /// In ru, this message translates to:
  /// **'Уведомления'**
  String get preferences;

  /// No description provided for @notifyBattery.
  ///
  /// In ru, this message translates to:
  /// **'Низкий заряд'**
  String get notifyBattery;

  /// No description provided for @notifyNetwork.
  ///
  /// In ru, this message translates to:
  /// **'Потеря связи'**
  String get notifyNetwork;

  /// No description provided for @notifyDetail.
  ///
  /// In ru, this message translates to:
  /// **'Настройки сохраняются в текущей сессии.'**
  String get notifyDetail;

  /// No description provided for @remove.
  ///
  /// In ru, this message translates to:
  /// **'Удалить устройство'**
  String get remove;

  /// No description provided for @removePrompt.
  ///
  /// In ru, this message translates to:
  /// **'Трекер исчезнет из карты и списка устройств в текущей демо-сессии.'**
  String get removePrompt;

  /// No description provided for @cancel.
  ///
  /// In ru, this message translates to:
  /// **'Отмена'**
  String get cancel;

  /// No description provided for @close.
  ///
  /// In ru, this message translates to:
  /// **'Закрыть'**
  String get close;

  /// No description provided for @access.
  ///
  /// In ru, this message translates to:
  /// **'Доступ в семье'**
  String get access;

  /// No description provided for @accessIntro.
  ///
  /// In ru, this message translates to:
  /// **'Здесь видно, кто может просматривать данные трекера и управлять доступом.'**
  String get accessIntro;

  /// No description provided for @owner.
  ///
  /// In ru, this message translates to:
  /// **'Владелец семьи'**
  String get owner;

  /// No description provided for @adult.
  ///
  /// In ru, this message translates to:
  /// **'Доверенный взрослый'**
  String get adult;

  /// No description provided for @wearer.
  ///
  /// In ru, this message translates to:
  /// **'Ребёнок / носитель трекера'**
  String get wearer;

  /// No description provided for @ownerAccess.
  ///
  /// In ru, this message translates to:
  /// **'Позиция, заряд, связь и события. Управляет устройством и доступом.'**
  String get ownerAccess;

  /// No description provided for @adultAccess.
  ///
  /// In ru, this message translates to:
  /// **'После принятия приглашения — позиция, заряд, связь и события.'**
  String get adultAccess;

  /// No description provided for @wearerAccess.
  ///
  /// In ru, this message translates to:
  /// **'Видит состояние своего трекера и список взрослых с доступом.'**
  String get wearerAccess;

  /// No description provided for @active.
  ///
  /// In ru, this message translates to:
  /// **'Активен'**
  String get active;

  /// No description provided for @invited.
  ///
  /// In ru, this message translates to:
  /// **'Приглашение'**
  String get invited;

  /// No description provided for @add.
  ///
  /// In ru, this message translates to:
  /// **'Добавить устройство'**
  String get add;

  /// No description provided for @pairCode.
  ///
  /// In ru, this message translates to:
  /// **'Демонстрационный код'**
  String get pairCode;

  /// No description provided for @pairInstructions.
  ///
  /// In ru, this message translates to:
  /// **'Введите указанный код, чтобы продолжить.'**
  String get pairInstructions;

  /// No description provided for @codeField.
  ///
  /// In ru, this message translates to:
  /// **'Код подключения'**
  String get codeField;

  /// No description provided for @badCode.
  ///
  /// In ru, this message translates to:
  /// **'Проверьте демонстрационный код.'**
  String get badCode;

  /// No description provided for @next.
  ///
  /// In ru, this message translates to:
  /// **'Продолжить'**
  String get next;

  /// No description provided for @pairReview.
  ///
  /// In ru, this message translates to:
  /// **'Проверьте права доступа'**
  String get pairReview;

  /// No description provided for @pairAccess.
  ///
  /// In ru, this message translates to:
  /// **'Айгуль получит доступ к позиции, заряду, связи и событиям и сможет управлять трекером. Тимур получит доступ к этим данным после принятия приглашения. Аян увидит, кто имеет доступ к его трекеру.'**
  String get pairAccess;

  /// No description provided for @confirmPair.
  ///
  /// In ru, this message translates to:
  /// **'Подтвердить подключение'**
  String get confirmPair;

  /// No description provided for @paired.
  ///
  /// In ru, this message translates to:
  /// **'Демо-трекер подключён'**
  String get paired;

  /// No description provided for @pairAlready.
  ///
  /// In ru, this message translates to:
  /// **'Трекер уже подключён. Можно повторить подключение для демонстрации.'**
  String get pairAlready;

  /// No description provided for @feed.
  ///
  /// In ru, this message translates to:
  /// **'События безопасности'**
  String get feed;

  /// No description provided for @feedIntro.
  ///
  /// In ru, this message translates to:
  /// **'Изменения связи, заряда и тесты SOS.'**
  String get feedIntro;

  /// No description provided for @today.
  ///
  /// In ru, this message translates to:
  /// **'Сегодня'**
  String get today;

  /// No description provided for @yesterday.
  ///
  /// In ru, this message translates to:
  /// **'Вчера'**
  String get yesterday;

  /// No description provided for @updated.
  ///
  /// In ru, this message translates to:
  /// **'Координаты обновлены'**
  String get updated;

  /// No description provided for @updatedDetail.
  ///
  /// In ru, this message translates to:
  /// **'Получена демонстрационная позиция с точностью ±18 м.'**
  String get updatedDetail;

  /// No description provided for @lost.
  ///
  /// In ru, this message translates to:
  /// **'Устройство потеряло сеть'**
  String get lost;

  /// No description provided for @lostDetail.
  ///
  /// In ru, this message translates to:
  /// **'Трекер временно перестал передавать данные в демо.'**
  String get lostDetail;

  /// No description provided for @restored.
  ///
  /// In ru, this message translates to:
  /// **'Соединение восстановлено'**
  String get restored;

  /// No description provided for @restoredDetail.
  ///
  /// In ru, this message translates to:
  /// **'Демо-трекер снова на связи.'**
  String get restoredDetail;

  /// No description provided for @chargeEvent.
  ///
  /// In ru, this message translates to:
  /// **'Заряд ниже 20%'**
  String get chargeEvent;

  /// No description provided for @chargeDetail.
  ///
  /// In ru, this message translates to:
  /// **'В этом событии заряд составил 18%.'**
  String get chargeDetail;

  /// No description provided for @sosEvent.
  ///
  /// In ru, this message translates to:
  /// **'Тестовый SOS подтверждён'**
  String get sosEvent;

  /// No description provided for @sosEventDetail.
  ///
  /// In ru, this message translates to:
  /// **'Подтверждение относится только к демонстрации.'**
  String get sosEventDetail;

  /// No description provided for @info.
  ///
  /// In ru, this message translates to:
  /// **'Информация'**
  String get info;

  /// No description provided for @attention.
  ///
  /// In ru, this message translates to:
  /// **'Внимание'**
  String get attention;

  /// No description provided for @ok.
  ///
  /// In ru, this message translates to:
  /// **'В порядке'**
  String get ok;

  /// No description provided for @now.
  ///
  /// In ru, this message translates to:
  /// **'Сейчас'**
  String get now;

  /// No description provided for @savedEvents.
  ///
  /// In ru, this message translates to:
  /// **'Сохранённые демо-события доступны ниже.'**
  String get savedEvents;

  /// No description provided for @sosWarning.
  ///
  /// In ru, this message translates to:
  /// **'Это демонстрационный сценарий. Реальный сигнал никому не отправляется.'**
  String get sosWarning;

  /// No description provided for @startSos.
  ///
  /// In ru, this message translates to:
  /// **'Запустить демонстрацию SOS'**
  String get startSos;

  /// No description provided for @prepare.
  ///
  /// In ru, this message translates to:
  /// **'Подготовка'**
  String get prepare;

  /// No description provided for @sending.
  ///
  /// In ru, this message translates to:
  /// **'Отправка'**
  String get sending;

  /// No description provided for @demoAck.
  ///
  /// In ru, this message translates to:
  /// **'Подтверждено в демо-режиме'**
  String get demoAck;

  /// No description provided for @demoSuccess.
  ///
  /// In ru, this message translates to:
  /// **'Демо-SOS подтверждён'**
  String get demoSuccess;

  /// No description provided for @demoSuccessDetail.
  ///
  /// In ru, this message translates to:
  /// **'Это только симуляция интерфейса. Реальное сообщение не отправлялось.'**
  String get demoSuccessDetail;

  /// No description provided for @offlineLast.
  ///
  /// In ru, this message translates to:
  /// **'Последняя связь с устройством: 12 мин назад.'**
  String get offlineLast;

  /// No description provided for @unconfirmed.
  ///
  /// In ru, this message translates to:
  /// **'SOS не подтверждён.'**
  String get unconfirmed;

  /// No description provided for @noDelivery.
  ///
  /// In ru, this message translates to:
  /// **'Нет данных, подтверждающих доставку сигнала.'**
  String get noDelivery;

  /// No description provided for @hardwareTitle.
  ///
  /// In ru, this message translates to:
  /// **'Физический трекер'**
  String get hardwareTitle;

  /// No description provided for @hardwareIntro.
  ///
  /// In ru, this message translates to:
  /// **'Стендовая настройка по USB. Карта и события семьи остаются демонстрационными.'**
  String get hardwareIntro;

  /// No description provided for @hardwareOpen.
  ///
  /// In ru, this message translates to:
  /// **'Настройка по USB'**
  String get hardwareOpen;

  /// No description provided for @hardwareConnect.
  ///
  /// In ru, this message translates to:
  /// **'Выбрать USB-порт'**
  String get hardwareConnect;

  /// No description provided for @hardwareDisconnect.
  ///
  /// In ru, this message translates to:
  /// **'Отключить USB'**
  String get hardwareDisconnect;

  /// No description provided for @hardwareDisconnected.
  ///
  /// In ru, this message translates to:
  /// **'USB не подключён'**
  String get hardwareDisconnected;

  /// No description provided for @hardwareConnected.
  ///
  /// In ru, this message translates to:
  /// **'USB подключён'**
  String get hardwareConnected;

  /// No description provided for @hardwareUnsupported.
  ///
  /// In ru, this message translates to:
  /// **'Выбор USB недоступен. Используйте Chrome или Edge на компьютере либо локальную утилиту из HARDWARE_SETUP.md.'**
  String get hardwareUnsupported;

  /// No description provided for @hardwareSteps.
  ///
  /// In ru, this message translates to:
  /// **'Подключите ESP32-S3 кабелем передачи данных. Закройте Arduino Serial Monitor и выберите порт ESP32-S3.'**
  String get hardwareSteps;

  /// No description provided for @hardwareBoard.
  ///
  /// In ru, this message translates to:
  /// **'Модель платы'**
  String get hardwareBoard;

  /// No description provided for @hardwareName.
  ///
  /// In ru, this message translates to:
  /// **'Имя устройства'**
  String get hardwareName;

  /// No description provided for @hardwarePhone.
  ///
  /// In ru, this message translates to:
  /// **'Номер для тестового SOS'**
  String get hardwarePhone;

  /// No description provided for @hardwarePhoneHint.
  ///
  /// In ru, this message translates to:
  /// **'Международный формат. Введите +, код страны и номер без пробелов.'**
  String get hardwarePhoneHint;

  /// No description provided for @hardwareNameInvalid.
  ///
  /// In ru, this message translates to:
  /// **'Введите имя до 48 байт без вертикальной черты.'**
  String get hardwareNameInvalid;

  /// No description provided for @hardwarePhoneInvalid.
  ///
  /// In ru, this message translates to:
  /// **'Введите + и 8–15 цифр. Первая цифра не может быть 0.'**
  String get hardwarePhoneInvalid;

  /// No description provided for @hardwareSave.
  ///
  /// In ru, this message translates to:
  /// **'Проверить и записать контакт'**
  String get hardwareSave;

  /// No description provided for @hardwareConfirm.
  ///
  /// In ru, this message translates to:
  /// **'Подтвердить контакт'**
  String get hardwareConfirm;

  /// No description provided for @hardwareConsent.
  ///
  /// In ru, this message translates to:
  /// **'Владелец номера согласен получать тестовые SMS.'**
  String get hardwareConsent;

  /// No description provided for @hardwarePrivate.
  ///
  /// In ru, this message translates to:
  /// **'Номер записывается на подключённую плату. Страница не сохраняет его в браузере.'**
  String get hardwarePrivate;

  /// No description provided for @hardwareDiagnostics.
  ///
  /// In ru, this message translates to:
  /// **'Проверить модем и GNSS'**
  String get hardwareDiagnostics;

  /// No description provided for @hardwareConfig.
  ///
  /// In ru, this message translates to:
  /// **'Контакт на плате'**
  String get hardwareConfig;

  /// No description provided for @hardwareConfigured.
  ///
  /// In ru, this message translates to:
  /// **'Сохранён'**
  String get hardwareConfigured;

  /// No description provided for @hardwareUnconfigured.
  ///
  /// In ru, this message translates to:
  /// **'Не настроен'**
  String get hardwareUnconfigured;

  /// No description provided for @hardwareModem.
  ///
  /// In ru, this message translates to:
  /// **'Ответ модема'**
  String get hardwareModem;

  /// No description provided for @hardwareGnss.
  ///
  /// In ru, this message translates to:
  /// **'Статус GNSS'**
  String get hardwareGnss;

  /// No description provided for @hardwareUnavailable.
  ///
  /// In ru, this message translates to:
  /// **'Недоступно'**
  String get hardwareUnavailable;

  /// No description provided for @hardwareNotChecked.
  ///
  /// In ru, this message translates to:
  /// **'Не проверено'**
  String get hardwareNotChecked;

  /// No description provided for @hardwareReady.
  ///
  /// In ru, this message translates to:
  /// **'Отвечает'**
  String get hardwareReady;

  /// No description provided for @hardwareRegistered.
  ///
  /// In ru, this message translates to:
  /// **'Модем зарегистрирован'**
  String get hardwareRegistered;

  /// No description provided for @hardwareNotRegistered.
  ///
  /// In ru, this message translates to:
  /// **'Регистрация не подтверждена'**
  String get hardwareNotRegistered;

  /// No description provided for @hardwareFix.
  ///
  /// In ru, this message translates to:
  /// **'Есть фиксация'**
  String get hardwareFix;

  /// No description provided for @hardwareNoFix.
  ///
  /// In ru, this message translates to:
  /// **'Нет фиксации'**
  String get hardwareNoFix;

  /// No description provided for @hardwareLocked.
  ///
  /// In ru, this message translates to:
  /// **'Стендовый профиль выключен. Сверьте ревизию платы перед включением GPIO.'**
  String get hardwareLocked;

  /// No description provided for @hardwarePending.
  ///
  /// In ru, this message translates to:
  /// **'Ожидание подтверждения на плате. Нажмите BOOT для выбранного действия.'**
  String get hardwarePending;

  /// No description provided for @hardwareBusy.
  ///
  /// In ru, this message translates to:
  /// **'Выполняется проверка USB или диагностика.'**
  String get hardwareBusy;

  /// No description provided for @hardwareTest.
  ///
  /// In ru, this message translates to:
  /// **'Отправить тестовое SMS'**
  String get hardwareTest;

  /// No description provided for @hardwareTestTitle.
  ///
  /// In ru, this message translates to:
  /// **'Подтвердить тестовое SMS'**
  String get hardwareTestTitle;

  /// No description provided for @hardwareTestCopy.
  ///
  /// In ru, this message translates to:
  /// **'Плата попробует отправить на сохранённый номер сообщение «SafeTrack bench test. No emergency.». Оператор может взять плату.'**
  String get hardwareTestCopy;

  /// No description provided for @hardwareClear.
  ///
  /// In ru, this message translates to:
  /// **'Удалить контакт с платы'**
  String get hardwareClear;

  /// No description provided for @hardwareClearCopy.
  ///
  /// In ru, this message translates to:
  /// **'Номер будет удалён с платы после нажатия BOOT.'**
  String get hardwareClearCopy;

  /// No description provided for @hardwareCleared.
  ///
  /// In ru, this message translates to:
  /// **'Контакт удалён с платы.'**
  String get hardwareCleared;

  /// No description provided for @hardwareAccepted.
  ///
  /// In ru, this message translates to:
  /// **'Модем принял тестовое SMS. Доставка получателю не подтверждена.'**
  String get hardwareAccepted;

  /// No description provided for @hardwareUnknownSms.
  ///
  /// In ru, this message translates to:
  /// **'Нет итогового ответа модема. Статус отправки и доставки неизвестен.'**
  String get hardwareUnknownSms;

  /// No description provided for @hardwareRejected.
  ///
  /// In ru, this message translates to:
  /// **'Модем отклонил тестовое SMS.'**
  String get hardwareRejected;

  /// No description provided for @hardwareNoNetwork.
  ///
  /// In ru, this message translates to:
  /// **'Регистрация в сети не подтверждена. SMS не отправлялось.'**
  String get hardwareNoNetwork;

  /// No description provided for @hardwareTimeout.
  ///
  /// In ru, this message translates to:
  /// **'Время ожидания истекло. Проверьте порт или повторите подтверждение на плате.'**
  String get hardwareTimeout;

  /// No description provided for @hardwareWrong.
  ///
  /// In ru, this message translates to:
  /// **'Устройство не ответило протоколом SafeTrack. Проверьте порт и прошивку.'**
  String get hardwareWrong;

  /// No description provided for @hardwarePortError.
  ///
  /// In ru, this message translates to:
  /// **'Сбой обмена по USB. Проверьте кабель и закройте монитор порта.'**
  String get hardwarePortError;

  /// No description provided for @hardwareStorage.
  ///
  /// In ru, this message translates to:
  /// **'Плата не подтвердила запись в память.'**
  String get hardwareStorage;

  /// No description provided for @hardwareNoModem.
  ///
  /// In ru, this message translates to:
  /// **'Модем не ответил. Проверьте питание и переключатели.'**
  String get hardwareNoModem;

  /// No description provided for @hardwareSelectionCancelled.
  ///
  /// In ru, this message translates to:
  /// **'Выбор USB-порта отменён.'**
  String get hardwareSelectionCancelled;

  /// No description provided for @notifyDetailWeb.
  ///
  /// In ru, this message translates to:
  /// **'Настройки сохраняются в этом браузере.'**
  String get notifyDetailWeb;

  /// No description provided for @setupConnect.
  ///
  /// In ru, this message translates to:
  /// **'Подключите устройство'**
  String get setupConnect;

  /// No description provided for @setupIdentify.
  ///
  /// In ru, this message translates to:
  /// **'Проверьте плату и прошивку'**
  String get setupIdentify;

  /// No description provided for @setupCellular.
  ///
  /// In ru, this message translates to:
  /// **'Проверьте SIM и модем'**
  String get setupCellular;

  /// No description provided for @setupContact.
  ///
  /// In ru, this message translates to:
  /// **'Настройте контакт'**
  String get setupContact;

  /// No description provided for @setupGnss.
  ///
  /// In ru, this message translates to:
  /// **'Проверьте GNSS'**
  String get setupGnss;

  /// No description provided for @setupBattery.
  ///
  /// In ru, this message translates to:
  /// **'Проверьте аккумулятор'**
  String get setupBattery;

  /// No description provided for @setupSos.
  ///
  /// In ru, this message translates to:
  /// **'Проверьте тестовый SOS'**
  String get setupSos;

  /// No description provided for @setupFinish.
  ///
  /// In ru, this message translates to:
  /// **'Итоги настройки'**
  String get setupFinish;

  /// No description provided for @setupPrevious.
  ///
  /// In ru, this message translates to:
  /// **'Предыдущий шаг'**
  String get setupPrevious;

  /// No description provided for @setupContinue.
  ///
  /// In ru, this message translates to:
  /// **'Далее'**
  String get setupContinue;

  /// No description provided for @setupDone.
  ///
  /// In ru, this message translates to:
  /// **'Выйти из настройки'**
  String get setupDone;

  /// No description provided for @setupSim.
  ///
  /// In ru, this message translates to:
  /// **'SIM-карта'**
  String get setupSim;

  /// No description provided for @setupSimLocked.
  ///
  /// In ru, this message translates to:
  /// **'SIM не готова или заблокирована'**
  String get setupSimLocked;

  /// No description provided for @setupSimUnready.
  ///
  /// In ru, this message translates to:
  /// **'SIM не готова. Тестовое SMS не отправлено.'**
  String get setupSimUnready;

  /// No description provided for @setupSlide.
  ///
  /// In ru, this message translates to:
  /// **'После подтверждения удержите OFF не менее 250 мс, затем ON не менее 1,5 с. Окно подтверждения — 20 с.'**
  String get setupSlide;

  /// No description provided for @setupBoot.
  ///
  /// In ru, this message translates to:
  /// **'После подтверждения нажмите и отпустите BOOT на плате в течение 20 с.'**
  String get setupBoot;

  /// No description provided for @setupGnssPrivacy.
  ///
  /// In ru, this message translates to:
  /// **'На экране только статус фиксации. Координаты платы не считываются приложением.'**
  String get setupGnssPrivacy;

  /// No description provided for @setupBatteryHelp.
  ///
  /// In ru, this message translates to:
  /// **'Процент и напряжение появляются после ответа датчика платы. Если результата нет, данные недоступны.'**
  String get setupBatteryHelp;

  /// No description provided for @setupVoltage.
  ///
  /// In ru, this message translates to:
  /// **'Напряжение'**
  String get setupVoltage;

  /// No description provided for @setupFinishHelp.
  ///
  /// In ru, this message translates to:
  /// **'Результат теста означает ответ модема. Получение сообщения проверяется отдельно на телефоне контакта.'**
  String get setupFinishHelp;

  /// No description provided for @demoSource.
  ///
  /// In ru, this message translates to:
  /// **'Учебные данные'**
  String get demoSource;

  /// No description provided for @demoMapNote.
  ///
  /// In ru, this message translates to:
  /// **'Эта точка создана для демонстрации и не получена с физического трекера.'**
  String get demoMapNote;

  /// No description provided for @demoFamilyNote.
  ///
  /// In ru, this message translates to:
  /// **'Доступ показан на вымышленной семье. Физический трекер настраивается отдельно по USB.'**
  String get demoFamilyNote;

  /// No description provided for @demoEventTime.
  ///
  /// In ru, this message translates to:
  /// **'Демо-журнал'**
  String get demoEventTime;

  /// No description provided for @demoDeviceNotice.
  ///
  /// In ru, this message translates to:
  /// **'USB для платы и диагностики. Показатели ниже относятся к демо.'**
  String get demoDeviceNotice;

  /// No description provided for @setupStep.
  ///
  /// In ru, this message translates to:
  /// **'Шаг {number} из 8'**
  String setupStep(int number);

  /// No description provided for @setupMillivolts.
  ///
  /// In ru, this message translates to:
  /// **'{number} мВ'**
  String setupMillivolts(int number);
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
      <String>['en', 'ky', 'ru'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'ky':
      return AppLocalizationsKy();
    case 'ru':
      return AppLocalizationsRu();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
