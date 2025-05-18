import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SettingsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_outlined),
           onPressed: (){
          Get.offNamed('/dashboard-seller');
          },
        ),
        title: Text(
          "Settings",
          style: TextStyle(
            color: Colors.white,
            fontFamily: 'Poppins',
            fontWeight: FontWeight.bold,
          ),
        ),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.orange.shade400, Colors.purple.shade400],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        elevation: 0,
      ),
      body: ListView(
        padding: EdgeInsets.all(16),
        children: [
          _buildSectionTitle("Account Settings"),
          _buildSettingsTile(
            icon: Icons.person,
            title: "Edit Profile",
            subtitle: "Update your name, email, and password",
            onTap: () {
              Get.snackbar(
                'Feature Coming Soon',
                'Edit Profile functionality will be available in the next update.',
                snackPosition: SnackPosition.BOTTOM,
                backgroundColor: Colors.orange.shade600,
                colorText: Colors.white,
                margin: EdgeInsets.all(16),
                borderRadius: 12,
              );
            },
          ),
          _buildSettingsTile(
            icon: Icons.store,
            title: "Store Settings",
            subtitle: "Manage your store details and preferences",
            onTap: () {
              Get.snackbar(
                'Feature Coming Soon',
                'Store Settings functionality will be available in the next update.',
                snackPosition: SnackPosition.BOTTOM,
                backgroundColor: Colors.orange.shade600,
                colorText: Colors.white,
                margin: EdgeInsets.all(16),
                borderRadius: 12,
              );
            },
          ),
          _buildSectionTitle("Preferences"),
          _buildSettingsTile(
            icon: Icons.notifications,
            title: "Notifications",
            subtitle: "Enable or disable order notifications",
            onTap: () {
              Get.snackbar(
                'Feature Coming Soon',
                'Notification settings will be available in the next update.',
                snackPosition: SnackPosition.BOTTOM,
                backgroundColor: Colors.orange.shade600,
                colorText: Colors.white,
                margin: EdgeInsets.all(16),
                borderRadius: 12,
              );
            },
          ),
          _buildSettingsTile(
            icon: Icons.language,
            title: "Language",
            subtitle: "Change app language",
            onTap: () {
              Get.snackbar(
                'Feature Coming Soon',
                'Language settings will be available in the next update.',
                snackPosition: SnackPosition.BOTTOM,
                backgroundColor: Colors.orange.shade600,
                colorText: Colors.white,
                margin: EdgeInsets.all(16),
                borderRadius: 12,
              );
            },
          ),
          _buildSectionTitle("Support"),
          _buildSettingsTile(
            icon: Icons.help,
            title: "Help & Support",
            subtitle: "Get assistance with your account",
            onTap: () {
              Get.snackbar(
                'Feature Coming Soon',
                'Help & Support will be available in the next update.',
                snackPosition: SnackPosition.BOTTOM,
                backgroundColor: Colors.orange.shade600,
                colorText: Colors.white,
                margin: EdgeInsets.all(16),
                borderRadius: 12,
              );
            },
          ),
          _buildSettingsTile(
            icon: Icons.info,
            title: "About",
            subtitle: "App version and information",
            onTap: () {
              Get.snackbar(
                'App Info',
                'Seller Dashboard v1.0.0',
                snackPosition: SnackPosition.BOTTOM,
                backgroundColor: Colors.orange.shade600,
                colorText: Colors.white,
                margin: EdgeInsets.all(16),
                borderRadius: 12,
              );
            },
          ),
          SizedBox(height: 20),
          _buildLogoutButton(),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 12),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          fontFamily: 'Poppins',
          color: Colors.black87,
        ),
      ),
    );
  }

  Widget _buildSettingsTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: 4,
      margin: EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: Icon(
          icon,
          color: Colors.orange.shade600,
          size: 28,
        ),
        title: Text(
          title,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            fontFamily: 'Poppins',
            color: Colors.black87,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey.shade600,
            fontFamily: 'Poppins',
          ),
        ),
        trailing: Icon(
          Icons.arrow_forward_ios,
          color: Colors.grey.shade400,
          size: 16,
        ),
        onTap: onTap,
      ),
    );
  }

  Widget _buildLogoutButton() {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.red.shade600,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        padding: EdgeInsets.symmetric(vertical: 14),
        elevation: 2,
      ),
      onPressed: () {
        Get.defaultDialog(
          title: "Logout",
          titleStyle: TextStyle(
            fontFamily: 'Poppins',
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
          middleText: "Are you sure you want to logout?",
          middleTextStyle: TextStyle(
            fontFamily: 'Poppins',
            color: Colors.grey.shade600,
          ),
          textConfirm: "Yes",
          textCancel: "No",
          confirmTextColor: Colors.white,
          buttonColor: Colors.red.shade600,
          cancelTextColor: Colors.grey.shade600,
          onConfirm: () {
            Get.back(); // Close the dialog
            Get.back(); // Navigate back to the previous screen (e.g., login)
            Get.snackbar(
              'Logged Out',
              'You have been successfully logged out.',
              snackPosition: SnackPosition.BOTTOM,
              backgroundColor: Colors.red.shade600,
              colorText: Colors.white,
              margin: EdgeInsets.all(16),
              borderRadius: 12,
            );
          },
        );
      },
      child: Text(
        "Logout",
        style: TextStyle(
          fontSize: 16,
          fontFamily: 'Poppins',
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}