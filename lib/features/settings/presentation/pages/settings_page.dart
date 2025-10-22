import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grocery_planner_app/core/di/service_locator.dart';
import 'package:grocery_planner_app/features/settings/presentation/blocs/settings_bloc.dart';
import 'package:grocery_planner_app/features/settings/presentation/blocs/settings_event.dart';
import 'package:grocery_planner_app/features/settings/presentation/blocs/settings_state.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({Key? key}) : super(key: key);

  /// Route path for this page
  static const String routePath = '/settings';

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<SettingsBloc>()..add(LoadUserSettingsEvent()),
      child: const SettingsView(),
    );
  }
}

class SettingsView extends StatelessWidget {
  const SettingsView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        elevation: 0,
      ),
      body: BlocBuilder<SettingsBloc, SettingsState>(
        builder: (context, state) {
          if (state is SettingsLoadingState) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (state is SettingsErrorState) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.error_outline,
                    size: 64,
                    color: Theme.of(context).colorScheme.error,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Error loading settings',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    state.message,
                    style: Theme.of(context).textTheme.bodyMedium,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      context.read<SettingsBloc>().add(LoadUserSettingsEvent());
                    },
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          if (state is SettingsLoadedState || state is SettingsUpdatedState) {
            final settings = state is SettingsLoadedState
                ? state.settings
                : (state as SettingsUpdatedState).settings;

            return ListView(
              padding: const EdgeInsets.all(16),
              children: [
                _buildSection(
                  context,
                  title: 'Currency',
                  children: [
                    _buildCurrencyTile(context, settings.defaultCurrency),
                  ],
                ),
                const SizedBox(height: 24),
                _buildSection(
                  context,
                  title: 'Theme',
                  children: [
                    _buildThemeTile(context, settings.themeMode),
                  ],
                ),
                const SizedBox(height: 24),
                _buildSection(
                  context,
                  title: 'Notifications',
                  children: [
                    _buildNotificationTile(
                        context, settings.notificationsEnabled),
                  ],
                ),
              ],
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildSection(BuildContext context,
      {required String title, required List<Widget> children}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 16, bottom: 8),
          child: Text(
            title,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: Theme.of(context).colorScheme.primary,
                  fontWeight: FontWeight.w600,
                ),
          ),
        ),
        Card(
          margin: EdgeInsets.zero,
          child: Column(
            children: children,
          ),
        ),
      ],
    );
  }

  Widget _buildCurrencyTile(BuildContext context, String currentCurrency) {
    final currencies = ['\$', '€', '£', '¥', '₹', '₦', 'R', 'kr'];

    return ListTile(
      leading: const Icon(Icons.attach_money),
      title: const Text('Default Currency'),
      subtitle: Text('Current: $currentCurrency'),
      trailing: const Icon(Icons.chevron_right),
      onTap: () {
        showDialog(
          context: context,
          builder: (dialogContext) => AlertDialog(
            title: const Text('Select Currency'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: currencies
                  .map((currency) => ListTile(
                        title: Text(currency),
                        leading: Radio<String>(
                          value: currency,
                          groupValue: currentCurrency,
                          onChanged: (value) {
                            if (value != null) {
                              context.read<SettingsBloc>().add(
                                    UpdateDefaultCurrencyEvent(currency: value),
                                  );
                              Navigator.of(dialogContext).pop();
                            }
                          },
                        ),
                      ))
                  .toList(),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(dialogContext).pop(),
                child: const Text('Cancel'),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildThemeTile(BuildContext context, String currentTheme) {
    return ListTile(
      leading: const Icon(Icons.palette),
      title: const Text('Theme'),
      subtitle: Text('Current: ${_getThemeDisplayName(currentTheme)}'),
      trailing: const Icon(Icons.chevron_right),
      onTap: () {
        // For now, just show that it's coming soon
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Theme selection coming soon!')),
        );
      },
    );
  }

  Widget _buildNotificationTile(BuildContext context, bool isEnabled) {
    return SwitchListTile(
      secondary: const Icon(Icons.notifications),
      title: const Text('Notifications'),
      subtitle: Text(isEnabled ? 'Enabled' : 'Disabled'),
      value: isEnabled,
      onChanged: (value) {
        // For now, just show that it's coming soon
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Notification settings coming soon!')),
        );
      },
    );
  }

  String _getThemeDisplayName(String themeMode) {
    switch (themeMode) {
      case 'light':
        return 'Light';
      case 'dark':
        return 'Dark';
      case 'system':
      default:
        return 'System';
    }
  }
}
