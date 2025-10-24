import 'user_settings_service.dart';

Future<void> initAppServices() async {
  UserSettingsService.instance.initialize();
}
