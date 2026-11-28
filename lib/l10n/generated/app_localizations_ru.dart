// ignore_for_file: deprecated_member_use

// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Russian (`ru`).
class AppLocalizationsRu extends AppLocalizations {
  AppLocalizationsRu([String locale = 'ru']) : super(locale);

  @override
  String get appName => 'SafeTrack Family';

  @override
  String get demo => 'Демо';

  @override
  String get map => 'Карта';

  @override
  String get events => 'События';

  @override
  String get family => 'Семья';

  @override
  String get device => 'Устройство';

  @override
  String get language => 'Язык интерфейса';

  @override
  String get russian => 'Русский';

  @override
  String get english => 'English';

  @override
  String get kyrgyz => 'Кыргызча · русский интерфейс';

  @override
  String get ayan => 'Аян';

  @override
  String get aigul => 'Айгуль';

  @override
  String get timur => 'Тимур';

  @override
  String get tracker => 'Трекер Аяна';

  @override
  String get selector => 'Выбрать трекер';

  @override
  String get selectTracker => 'Трекеры семьи';

  @override
  String get sample => 'Последние известные данные';

  @override
  String get todayTime => 'Сегодня, 14:32';

  @override
  String get staleTime => 'Сегодня, 14:08';

  @override
  String get offlineTime => 'Сегодня, 14:20';

  @override
  String get accuracyGood => '±18 м';

  @override
  String get accuracyStale => '±32 м';

  @override
  String get accuracyOffline => '±24 м';

  @override
  String get accuracy => 'Точность';

  @override
  String get time => 'Время позиции';

  @override
  String get battery => 'Заряд';

  @override
  String get network => 'Связь';

  @override
  String get online => 'В сети · LTE';

  @override
  String get offline => 'Нет связи';

  @override
  String get fresh => 'Свежая позиция';

  @override
  String get stale => 'Устаревшая позиция';

  @override
  String get low => 'Низкий заряд';

  @override
  String get sos => 'Тестовый SOS';

  @override
  String get loading => 'Загрузка данных';

  @override
  String get empty => 'Трекер не подключён';

  @override
  String get unavailable => 'Позиция недоступна';

  @override
  String get error => 'Не удалось загрузить данные';

  @override
  String get recent => '24 сек назад';

  @override
  String get old => '24 мин назад';

  @override
  String get offlineAgo => '12 мин назад';

  @override
  String get lastContact => 'Последняя связь';

  @override
  String get unknown => 'Нет данных';

  @override
  String get mapLegend => 'Демонстрационная карта';

  @override
  String get park => 'Сад Листьев';

  @override
  String get square => 'Сквер Маяк';

  @override
  String get river => 'Река Лента';

  @override
  String get lane => 'Улица Ив';

  @override
  String get recenter => 'На последнее местоположение';

  @override
  String get freshDetail => 'Показана последняя точка из демо-данных.';

  @override
  String get staleDetail =>
      'Позиция давно не обновлялась. Актуальное местоположение неизвестно.';

  @override
  String get offlineDetail => 'Показана точка, сохранённая до потери связи.';

  @override
  String get lowDetail => 'В демо-сценарии заряд опустился ниже 20%.';

  @override
  String get sosDetail =>
      'Выбран сценарий SOS. Проверить его можно во вкладке «Устройство».';

  @override
  String get loadingDetail => 'Получаем демонстрационные данные трекера.';

  @override
  String get emptyDetail =>
      'Добавьте демонстрационный трекер, чтобы увидеть его данные.';

  @override
  String get unavailableDetail =>
      'Трекер на связи, но сохранённых координат пока нет.';

  @override
  String get errorDetail =>
      'Данные трекера недоступны. Попробуйте загрузить их ещё раз.';

  @override
  String get retry => 'Повторить';

  @override
  String get state => 'Демо-сценарий';

  @override
  String get stateHelp => 'Переключайте локальные состояния трекера.';

  @override
  String get details => 'Данные трекера';

  @override
  String get id => 'Идентификатор';

  @override
  String get firmware => 'Прошивка';

  @override
  String get firmwareValue => '0.0.0 · демо';

  @override
  String get preferences => 'Уведомления';

  @override
  String get notifyBattery => 'Низкий заряд';

  @override
  String get notifyNetwork => 'Потеря связи';

  @override
  String get notifyDetail => 'Настройки сохраняются в текущей сессии.';

  @override
  String get remove => 'Удалить устройство';

  @override
  String get removePrompt =>
      'Трекер исчезнет из карты и списка устройств в текущей демо-сессии.';

  @override
  String get cancel => 'Отмена';

  @override
  String get close => 'Закрыть';

  @override
  String get access => 'Доступ в семье';

  @override
  String get accessIntro =>
      'Здесь видно, кто может просматривать данные трекера и управлять доступом.';

  @override
  String get owner => 'Владелец семьи';

  @override
  String get adult => 'Доверенный взрослый';

  @override
  String get wearer => 'Ребёнок / носитель трекера';

  @override
  String get ownerAccess =>
      'Позиция, заряд, связь и события. Управляет устройством и доступом.';

  @override
  String get adultAccess =>
      'После принятия приглашения — позиция, заряд, связь и события.';

  @override
  String get wearerAccess =>
      'Видит состояние своего трекера и список взрослых с доступом.';

  @override
  String get active => 'Активен';

  @override
  String get invited => 'Приглашение';

  @override
  String get add => 'Добавить устройство';

  @override
  String get pairCode => 'Демонстрационный код';

  @override
  String get pairInstructions => 'Введите указанный код, чтобы продолжить.';

  @override
  String get codeField => 'Код подключения';

  @override
  String get badCode => 'Проверьте демонстрационный код.';

  @override
  String get next => 'Продолжить';

  @override
  String get pairReview => 'Проверьте права доступа';

  @override
  String get pairAccess =>
      'Айгуль получит доступ к позиции, заряду, связи и событиям и сможет управлять трекером. Тимур получит доступ к этим данным после принятия приглашения. Аян увидит, кто имеет доступ к его трекеру.';

  @override
  String get confirmPair => 'Подтвердить подключение';

  @override
  String get paired => 'Демо-трекер подключён';

  @override
  String get pairAlready =>
      'Трекер уже подключён. Можно повторить подключение для демонстрации.';

  @override
  String get feed => 'События безопасности';

  @override
  String get feedIntro => 'Изменения связи, заряда и тесты SOS.';

  @override
  String get today => 'Сегодня';

  @override
  String get yesterday => 'Вчера';

  @override
  String get updated => 'Координаты обновлены';

  @override
  String get updatedDetail =>
      'Получена демонстрационная позиция с точностью ±18 м.';

  @override
  String get lost => 'Устройство потеряло сеть';

  @override
  String get lostDetail => 'Трекер временно перестал передавать данные в демо.';

  @override
  String get restored => 'Соединение восстановлено';

  @override
  String get restoredDetail => 'Демо-трекер снова на связи.';

  @override
  String get chargeEvent => 'Заряд ниже 20%';

  @override
  String get chargeDetail => 'В этом событии заряд составил 18%.';

  @override
  String get sosEvent => 'Тестовый SOS подтверждён';

  @override
  String get sosEventDetail => 'Подтверждение относится только к демонстрации.';

  @override
  String get info => 'Информация';

  @override
  String get attention => 'Внимание';

  @override
  String get ok => 'В порядке';

  @override
  String get now => 'Сейчас';

  @override
  String get savedEvents => 'Сохранённые демо-события доступны ниже.';

  @override
  String get sosWarning =>
      'Это демонстрационный сценарий. Реальный сигнал никому не отправляется.';

  @override
  String get startSos => 'Запустить демонстрацию SOS';

  @override
  String get prepare => 'Подготовка';

  @override
  String get sending => 'Отправка';

  @override
  String get demoAck => 'Подтверждено в демо-режиме';

  @override
  String get demoSuccess => 'Демо-SOS подтверждён';

  @override
  String get demoSuccessDetail =>
      'Это только симуляция интерфейса. Реальное сообщение не отправлялось.';

  @override
  String get offlineLast => 'Последняя связь с устройством: 12 мин назад.';

  @override
  String get unconfirmed => 'SOS не подтверждён.';

  @override
  String get noDelivery => 'Нет данных, подтверждающих доставку сигнала.';

  @override
  String get hardwareTitle => 'Физический трекер';

  @override
  String get hardwareIntro =>
      'Стендовая настройка по USB. Карта и события семьи остаются демонстрационными.';

  @override
  String get hardwareOpen => 'Настройка по USB';

  @override
  String get hardwareConnect => 'Выбрать USB-порт';

  @override
  String get hardwareDisconnect => 'Отключить USB';

  @override
  String get hardwareDisconnected => 'USB не подключён';

  @override
  String get hardwareConnected => 'USB подключён';

  @override
  String get hardwareUnsupported =>
      'Выбор USB недоступен. Используйте Chrome или Edge на компьютере либо локальную утилиту из HARDWARE_SETUP.md.';

  @override
  String get hardwareSteps =>
      'Подключите ESP32-S3 кабелем передачи данных. Закройте Arduino Serial Monitor и выберите порт ESP32-S3.';

  @override
  String get hardwareBoard => 'Модель платы';

  @override
  String get hardwareName => 'Имя устройства';

  @override
  String get hardwarePhone => 'Номер для тестового SOS';

  @override
  String get hardwarePhoneHint =>
      'Международный формат. Введите +, код страны и номер без пробелов.';

  @override
  String get hardwareNameInvalid =>
      'Введите имя до 48 байт без вертикальной черты.';

  @override
  String get hardwarePhoneInvalid =>
      'Введите + и 8–15 цифр. Первая цифра не может быть 0.';

  @override
  String get hardwareSave => 'Проверить и записать контакт';

  @override
  String get hardwareConfirm => 'Подтвердить контакт';

  @override
  String get hardwareConsent =>
      'Владелец номера согласен получать тестовые SMS.';

  @override
  String get hardwarePrivate =>
      'Номер записывается на подключённую плату. Страница не сохраняет его в браузере.';

  @override
  String get hardwareDiagnostics => 'Проверить модем и GNSS';

  @override
  String get hardwareConfig => 'Контакт на плате';

  @override
  String get hardwareConfigured => 'Сохранён';

  @override
  String get hardwareUnconfigured => 'Не настроен';

  @override
  String get hardwareModem => 'Ответ модема';

  @override
  String get hardwareGnss => 'Статус GNSS';

  @override
  String get hardwareUnavailable => 'Недоступно';

  @override
  String get hardwareNotChecked => 'Не проверено';

  @override
  String get hardwareReady => 'Отвечает';

  @override
  String get hardwareRegistered => 'Модем зарегистрирован';

  @override
  String get hardwareNotRegistered => 'Регистрация не подтверждена';

  @override
  String get hardwareFix => 'Есть фиксация';

  @override
  String get hardwareNoFix => 'Нет фиксации';

  @override
  String get hardwareLocked =>
      'Стендовый профиль выключен. Сверьте ревизию платы перед включением GPIO.';

  @override
  String get hardwarePending =>
      'Ожидание подтверждения на плате. Нажмите BOOT для выбранного действия.';

  @override
  String get hardwareBusy => 'Выполняется проверка USB или диагностика.';

  @override
  String get hardwareTest => 'Отправить тестовое SMS';

  @override
  String get hardwareTestTitle => 'Подтвердить тестовое SMS';

  @override
  String get hardwareTestCopy =>
      'Плата попробует отправить на сохранённый номер сообщение «SafeTrack bench test. No emergency.». Оператор может взять плату.';

  @override
  String get hardwareClear => 'Удалить контакт с платы';

  @override
  String get hardwareClearCopy =>
      'Номер будет удалён с платы после нажатия BOOT.';

  @override
  String get hardwareCleared => 'Контакт удалён с платы.';

  @override
  String get hardwareAccepted =>
      'Модем принял тестовое SMS. Доставка получателю не подтверждена.';

  @override
  String get hardwareUnknownSms =>
      'Нет итогового ответа модема. Статус отправки и доставки неизвестен.';

  @override
  String get hardwareRejected => 'Модем отклонил тестовое SMS.';

  @override
  String get hardwareNoNetwork =>
      'Регистрация в сети не подтверждена. SMS не отправлялось.';

  @override
  String get hardwareTimeout =>
      'Время ожидания истекло. Проверьте порт или повторите подтверждение на плате.';

  @override
  String get hardwareWrong =>
      'Устройство не ответило протоколом SafeTrack. Проверьте порт и прошивку.';

  @override
  String get hardwarePortError =>
      'Сбой обмена по USB. Проверьте кабель и закройте монитор порта.';

  @override
  String get hardwareStorage => 'Плата не подтвердила запись в память.';

  @override
  String get hardwareNoModem =>
      'Модем не ответил. Проверьте питание и переключатели.';

  @override
  String get hardwareSelectionCancelled => 'Выбор USB-порта отменён.';

  @override
  String get notifyDetailWeb => 'Настройки сохраняются в этом браузере.';

  @override
  String get setupConnect => 'Подключите устройство';

  @override
  String get setupIdentify => 'Проверьте плату и прошивку';

  @override
  String get setupCellular => 'Проверьте SIM и модем';

  @override
  String get setupContact => 'Настройте контакт';

  @override
  String get setupGnss => 'Проверьте GNSS';

  @override
  String get setupBattery => 'Проверьте аккумулятор';

  @override
  String get setupSos => 'Проверьте тестовый SOS';

  @override
  String get setupFinish => 'Итоги настройки';

  @override
  String get setupPrevious => 'Предыдущий шаг';

  @override
  String get setupContinue => 'Далее';

  @override
  String get setupDone => 'Выйти из настройки';

  @override
  String get setupSim => 'SIM-карта';

  @override
  String get setupSimLocked => 'SIM не готова или заблокирована';

  @override
  String get setupSimUnready => 'SIM не готова. Тестовое SMS не отправлено.';

  @override
  String get setupSlide =>
      'После подтверждения удержите OFF не менее 250 мс, затем ON не менее 1,5 с. Окно подтверждения — 20 с.';

  @override
  String get setupBoot =>
      'После подтверждения нажмите и отпустите BOOT на плате в течение 20 с.';

  @override
  String get setupGnssPrivacy =>
      'На экране только статус фиксации. Координаты платы не считываются приложением.';

  @override
  String get setupBatteryHelp =>
      'Процент и напряжение появляются после ответа датчика платы. Если результата нет, данные недоступны.';

  @override
  String get setupVoltage => 'Напряжение';

  @override
  String get setupFinishHelp =>
      'Результат теста означает ответ модема. Получение сообщения проверяется отдельно на телефоне контакта.';

  @override
  String get demoSource => 'Учебные данные';

  @override
  String get demoMapNote =>
      'Эта точка создана для демонстрации и не получена с физического трекера.';

  @override
  String get demoFamilyNote =>
      'Доступ показан на вымышленной семье. Физический трекер настраивается отдельно по USB.';

  @override
  String get demoEventTime => 'Демо-журнал';

  @override
  String get demoDeviceNotice =>
      'USB для платы и диагностики. Показатели ниже относятся к демо.';

  @override
  String setupStep(int number) {
    return 'Шаг $number из 8';
  }

  @override
  String setupMillivolts(int number) {
    return '$number мВ';
  }
}
