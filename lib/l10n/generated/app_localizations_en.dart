// ignore_for_file: deprecated_member_use

// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appName => 'SafeTrack Family';

  @override
  String get demo => 'Demo';

  @override
  String get map => 'Map';

  @override
  String get events => 'Events';

  @override
  String get family => 'Family';

  @override
  String get device => 'Device';

  @override
  String get language => 'App language';

  @override
  String get russian => 'Русский';

  @override
  String get english => 'English';

  @override
  String get kyrgyz => 'Кыргызча · Russian preview';

  @override
  String get ayan => 'Ayan';

  @override
  String get aigul => 'Aigul';

  @override
  String get timur => 'Timur';

  @override
  String get tracker => 'Ayan’s tracker';

  @override
  String get selector => 'Select tracker';

  @override
  String get selectTracker => 'Family trackers';

  @override
  String get sample => 'Last known location';

  @override
  String get todayTime => 'Today, 14:32';

  @override
  String get staleTime => 'Today, 14:08';

  @override
  String get offlineTime => 'Today, 14:20';

  @override
  String get accuracyGood => '±18 m';

  @override
  String get accuracyStale => '±32 m';

  @override
  String get accuracyOffline => '±24 m';

  @override
  String get accuracy => 'Accuracy';

  @override
  String get time => 'Location time';

  @override
  String get battery => 'Battery';

  @override
  String get network => 'Network';

  @override
  String get online => 'Online · LTE';

  @override
  String get offline => 'Offline';

  @override
  String get fresh => 'Fresh location';

  @override
  String get stale => 'Stale location';

  @override
  String get low => 'Low battery';

  @override
  String get sos => 'Test SOS';

  @override
  String get loading => 'Loading data';

  @override
  String get empty => 'No paired tracker';

  @override
  String get unavailable => 'Location unavailable';

  @override
  String get error => 'Couldn’t load data';

  @override
  String get recent => '24 sec ago';

  @override
  String get old => '24 min ago';

  @override
  String get offlineAgo => '12 min ago';

  @override
  String get lastContact => 'Last contact';

  @override
  String get unknown => 'No data';

  @override
  String get mapLegend => 'Demo map';

  @override
  String get park => 'Leaf Garden';

  @override
  String get square => 'Beacon Square';

  @override
  String get river => 'Ribbon River';

  @override
  String get lane => 'Willow Street';

  @override
  String get recenter => 'Center on last location';

  @override
  String get freshDetail => 'Showing the latest point from the demo data.';

  @override
  String get staleDetail =>
      'This position hasn’t updated in a while. The current location is unknown.';

  @override
  String get offlineDetail =>
      'Showing the point saved before contact was lost.';

  @override
  String get lowDetail => 'In this demo scenario, the battery fell below 20%.';

  @override
  String get sosDetail =>
      'The SOS scenario is selected. Test it on the Device tab.';

  @override
  String get loadingDetail => 'Getting demo tracker data.';

  @override
  String get emptyDetail => 'Add a demo tracker to see its data.';

  @override
  String get unavailableDetail =>
      'The tracker is online, but no coordinates are available yet.';

  @override
  String get errorDetail =>
      'Tracker data is unavailable. Try loading it again.';

  @override
  String get retry => 'Try again';

  @override
  String get state => 'Demo scenario';

  @override
  String get stateHelp => 'Switch between local tracker states.';

  @override
  String get details => 'Tracker details';

  @override
  String get id => 'Device ID';

  @override
  String get firmware => 'Firmware';

  @override
  String get firmwareValue => '0.0.0 · demo';

  @override
  String get preferences => 'Notifications';

  @override
  String get notifyBattery => 'Low battery';

  @override
  String get notifyNetwork => 'Loss of connection';

  @override
  String get notifyDetail => 'Preferences apply to this session.';

  @override
  String get remove => 'Remove tracker';

  @override
  String get removePrompt =>
      'The tracker will disappear from the map and devices for this demo session.';

  @override
  String get cancel => 'Cancel';

  @override
  String get close => 'Close';

  @override
  String get access => 'Family access';

  @override
  String get accessIntro => 'See who can view tracker data and manage access.';

  @override
  String get owner => 'Family owner';

  @override
  String get adult => 'Trusted adult';

  @override
  String get wearer => 'Child / tracker wearer';

  @override
  String get ownerAccess =>
      'Location, battery, connectivity and events. Manages tracker and access.';

  @override
  String get adultAccess =>
      'After accepting the invite: location, battery, connectivity and events.';

  @override
  String get wearerAccess =>
      'Can see their tracker status and which adults have access.';

  @override
  String get active => 'Active';

  @override
  String get invited => 'Invited';

  @override
  String get add => 'Add tracker';

  @override
  String get pairCode => 'Demo pairing code';

  @override
  String get pairInstructions => 'Enter the code shown above to continue.';

  @override
  String get codeField => 'Pairing code';

  @override
  String get badCode => 'Check the demo pairing code.';

  @override
  String get next => 'Continue';

  @override
  String get pairReview => 'Review access';

  @override
  String get pairAccess =>
      'Aigul can view location, battery, connectivity and events and manage the tracker. Timur can view these details after accepting the invite. Ayan can see who has access to the tracker.';

  @override
  String get confirmPair => 'Confirm pairing';

  @override
  String get paired => 'Demo tracker paired';

  @override
  String get pairAlready =>
      'The tracker is already paired. You can repeat pairing to demonstrate the flow.';

  @override
  String get feed => 'Safety events';

  @override
  String get feedIntro => 'Connectivity, battery changes and SOS tests.';

  @override
  String get today => 'Today';

  @override
  String get yesterday => 'Yesterday';

  @override
  String get updated => 'Location updated';

  @override
  String get updatedDetail =>
      'A demo position with ±18 m accuracy was received.';

  @override
  String get lost => 'Tracker lost connection';

  @override
  String get lostDetail => 'The demo tracker temporarily stopped reporting.';

  @override
  String get restored => 'Connection restored';

  @override
  String get restoredDetail => 'The demo tracker is back online.';

  @override
  String get chargeEvent => 'Battery below 20%';

  @override
  String get chargeDetail => 'Battery was at 18% for this event.';

  @override
  String get sosEvent => 'Test SOS acknowledged';

  @override
  String get sosEventDetail =>
      'The acknowledgement applies only to the simulation.';

  @override
  String get info => 'Info';

  @override
  String get attention => 'Attention';

  @override
  String get ok => 'OK';

  @override
  String get now => 'Just now';

  @override
  String get savedEvents => 'Saved demo events are available below.';

  @override
  String get sosWarning =>
      'This is a demonstration. No real signal will be sent to anyone.';

  @override
  String get startSos => 'Start SOS demo';

  @override
  String get prepare => 'Preparing';

  @override
  String get sending => 'Sending';

  @override
  String get demoAck => 'Acknowledged in demo mode';

  @override
  String get demoSuccess => 'Demo SOS acknowledged';

  @override
  String get demoSuccessDetail =>
      'This is a simulation of the interface. No real message was sent.';

  @override
  String get offlineLast => 'Last contact with tracker: 12 min ago.';

  @override
  String get unconfirmed => 'SOS unconfirmed.';

  @override
  String get noDelivery =>
      'There is no evidence that the signal was delivered.';

  @override
  String get hardwareTitle => 'Physical tracker';

  @override
  String get hardwareIntro =>
      'USB bench setup. Map and family activity remain simulated.';

  @override
  String get hardwareOpen => 'USB setup';

  @override
  String get hardwareConnect => 'Choose USB port';

  @override
  String get hardwareDisconnect => 'Disconnect USB';

  @override
  String get hardwareDisconnected => 'USB disconnected';

  @override
  String get hardwareConnected => 'USB connected';

  @override
  String get hardwareUnsupported =>
      'USB selection is unavailable. Use desktop Chrome or Edge, or the local utility in HARDWARE_SETUP.md.';

  @override
  String get hardwareSteps =>
      'Connect the ESP32-S3 using a data cable. Close Arduino Serial Monitor and choose the ESP32-S3 port.';

  @override
  String get hardwareBoard => 'Board model';

  @override
  String get hardwareName => 'Device name';

  @override
  String get hardwarePhone => 'Test SOS contact';

  @override
  String get hardwarePhoneHint =>
      'Enter +, country code and number without spaces.';

  @override
  String get hardwareNameInvalid =>
      'Enter a name up to 48 bytes without the vertical bar.';

  @override
  String get hardwarePhoneInvalid =>
      'Enter + and 8–15 digits. The first digit cannot be 0.';

  @override
  String get hardwareSave => 'Review and save contact';

  @override
  String get hardwareConfirm => 'Confirm contact';

  @override
  String get hardwareConsent =>
      'The owner of this number agrees to receive test SMS.';

  @override
  String get hardwarePrivate =>
      'The number is saved on the connected device. The page does not keep it in browser storage.';

  @override
  String get hardwareDiagnostics => 'Check modem and GNSS';

  @override
  String get hardwareConfig => 'Contact on device';

  @override
  String get hardwareConfigured => 'Saved';

  @override
  String get hardwareUnconfigured => 'Not configured';

  @override
  String get hardwareModem => 'Modem response';

  @override
  String get hardwareGnss => 'GNSS status';

  @override
  String get hardwareUnavailable => 'Unavailable';

  @override
  String get hardwareNotChecked => 'Not checked';

  @override
  String get hardwareReady => 'Responding';

  @override
  String get hardwareRegistered => 'Modem registered';

  @override
  String get hardwareNotRegistered => 'Registration unconfirmed';

  @override
  String get hardwareFix => 'Fix available';

  @override
  String get hardwareNoFix => 'No fix';

  @override
  String get hardwareLocked =>
      'The bench profile is disabled. Verify the board revision before enabling GPIO.';

  @override
  String get hardwarePending =>
      'Waiting for confirmation on the board. Press BOOT to approve the requested action.';

  @override
  String get hardwareBusy => 'Checking USB or running diagnostics.';

  @override
  String get hardwareTest => 'Send test SMS';

  @override
  String get hardwareTestTitle => 'Confirm test SMS';

  @override
  String get hardwareTestCopy =>
      'The board will attempt to send “SafeTrack bench test. No emergency.” to the saved contact. Carrier charges may apply.';

  @override
  String get hardwareClear => 'Clear contact from device';

  @override
  String get hardwareClearCopy =>
      'The number will be cleared after a BOOT press.';

  @override
  String get hardwareCleared => 'Contact cleared from the device.';

  @override
  String get hardwareAccepted =>
      'The modem accepted the test SMS. Delivery to the recipient is unconfirmed.';

  @override
  String get hardwareUnknownSms =>
      'No final modem response. Submission and delivery are unknown.';

  @override
  String get hardwareRejected => 'The modem rejected the test SMS.';

  @override
  String get hardwareNoNetwork =>
      'Network registration is unconfirmed. The test SMS was not submitted.';

  @override
  String get hardwareTimeout =>
      'The request timed out. Check the port or repeat confirmation on the board.';

  @override
  String get hardwareWrong =>
      'The device did not respond with the SafeTrack protocol. Check the port and firmware.';

  @override
  String get hardwarePortError =>
      'USB communication failed. Check the cable and close the serial monitor.';

  @override
  String get hardwareStorage =>
      'The device did not confirm the write to storage.';

  @override
  String get hardwareNoModem =>
      'The modem did not respond. Check power and switches.';

  @override
  String get hardwareSelectionCancelled => 'USB port selection cancelled.';

  @override
  String get notifyDetailWeb => 'Preferences are saved in this browser.';

  @override
  String get setupConnect => 'Connect the tracker';

  @override
  String get setupIdentify => 'Identify the board and firmware';

  @override
  String get setupCellular => 'Check SIM and modem';

  @override
  String get setupContact => 'Set the emergency contact';

  @override
  String get setupGnss => 'Check GNSS';

  @override
  String get setupBattery => 'Check the battery';

  @override
  String get setupSos => 'Run a local SOS test';

  @override
  String get setupFinish => 'Setup summary';

  @override
  String get setupPrevious => 'Previous step';

  @override
  String get setupContinue => 'Continue';

  @override
  String get setupDone => 'Close setup';

  @override
  String get setupSim => 'SIM card';

  @override
  String get setupSimLocked => 'SIM is locked or unavailable';

  @override
  String get setupSimUnready =>
      'SIM is not ready. A test SMS was not submitted.';

  @override
  String get setupSlide =>
      'After confirming, keep the switch OFF for at least 250 ms, then ON for at least 1.5 s. The approval window is 20 s.';

  @override
  String get setupBoot =>
      'After confirming, press and release BOOT within 20 s.';

  @override
  String get setupGnssPrivacy =>
      'Only fix status is shown. The app does not read the tracker’s coordinates.';

  @override
  String get setupBatteryHelp =>
      'Charge and voltage appear after the board reports readings. Otherwise they are unavailable.';

  @override
  String get setupVoltage => 'Voltage';

  @override
  String get setupFinishHelp =>
      'The test result reflects the modem response. Check message receipt separately on the contact’s phone.';

  @override
  String get demoSource => 'Demo data';

  @override
  String get demoMapNote =>
      'This position is illustrative and was not read from a physical tracker.';

  @override
  String get demoFamilyNote =>
      'Access is illustrated with a fictional family. Configure a physical tracker separately over USB.';

  @override
  String get demoEventTime => 'Demo history';

  @override
  String get demoDeviceNotice =>
      'USB for board setup and diagnostics. The readings below are simulated.';

  @override
  String setupStep(int number) {
    return 'Step $number of 8';
  }

  @override
  String setupMillivolts(int number) {
    return '$number mV';
  }
}
