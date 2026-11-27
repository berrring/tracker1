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
}
