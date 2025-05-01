import 'package:textomize/core/exports.dart';

class SettingsView extends StatelessWidget {
  const SettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    bool isDarkMode = false; // Replace with actual dark mode state

    return Scaffold(
      appBar: CustomAppBar(title: 'Settings', centerTitle: true,),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildSettingItem(
            icon: Icons.person,
            title: 'Profile',
            onTap: () {
              // Navigate to profile
            },
          ),
          _buildSettingItem(
            icon: Icons.dark_mode,
            title: 'Dark Mode',
            trailing: Switch(
              value: isDarkMode,
              onChanged: (value) {
                // Toggle dark mode logic
              },
            ),
          ),
          _buildSettingItem(
            icon: Icons.logout,
            title: 'Logout',
            onTap: () {
              // Handle logout
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSettingItem({
    required IconData icon,
    required String title,
    Widget? trailing,
    VoidCallback? onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: Colors.blueAccent),
      title: Text(title, style: const TextStyle(fontSize: 16)),
      trailing: trailing ?? const Icon(Icons.arrow_forward_ios, size: 16),
      onTap: onTap,
    );
  }
}
