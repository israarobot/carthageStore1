import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SellerDashboardController extends GetxController {
  var totalEarnings = 1300.50.obs; // Mock total earnings
  var selectedIndex = 0.obs;

  void navigateTo(int index) {
    // Prevent navigation if already on the selected screen
    if (selectedIndex.value == index) return;

    selectedIndex.value = index;
    switch (index) {
      case 0:
        Get.offNamed('/dashboard-seller');
        break;
      case 1:
        Get.offNamed('/form_sellers');
        break;
      case 2:
        Get.offNamed('/order-seller');
        break;
      case 3:
        Get.offNamed('/setting-seller');
        break;
      case 4:
        Get.offNamed('/earning-seller');
        break;
    }
  }
}

class SellerDashboard extends StatelessWidget {
  final SellerDashboardController controller = Get.put(SellerDashboardController());
  final String sellerName = "Israa Zitouni";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(),
            Expanded(
              child: Center(
                child: Text(
                  "Use the navigation below to manage\nyour orders, settings, or earnings.",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.grey.shade600,
                    fontFamily: 'Poppins',
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      flexibleSpace: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.orange.shade400, Colors.purple.shade400],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
      ),
      leading: Padding(
        padding: EdgeInsets.all(8),
        child: CircleAvatar(
          backgroundColor: Colors.white,
          child: Text(
            sellerName[0],
            style: TextStyle(color: Colors.orange, fontWeight: FontWeight.bold),
          ),
        ),
      ),
      title: Text(
        "$sellerName's Store",
        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontFamily: 'Poppins'),
      ),
      centerTitle: true,
      actions: [
        _buildIconButton(Icons.logout, () => Get.offNamed('/login')), // Adjust to your login route
      ],
    );
  }

  Widget _buildIconButton(IconData icon, VoidCallback onPressed) {
    return Container(
      margin: EdgeInsets.all(8),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white,
        boxShadow: [
          BoxShadow(color: Colors.grey.withOpacity(0.3), blurRadius: 6, offset: Offset(0, 2)),
        ],
      ),
      child: IconButton(icon: Icon(icon, color: Colors.black87), onPressed: onPressed),
    );
  }

  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Welcome, $sellerName!",
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, fontFamily: 'Poppins'),
        ),
        SizedBox(height: 8),
        Obx(() => Text(
              "Total Earnings: ${controller.totalEarnings.value.toStringAsFixed(2)} \Dt",
              style: TextStyle(fontSize: 16, color: Colors.green.shade600, fontFamily: 'Poppins'),
            )),
      ],
    );
  }

  Widget _buildBottomNav() {
    return Obx(() => BottomNavigationBar(
          currentIndex: controller.selectedIndex.value,
          onTap: controller.navigateTo,
          selectedItemColor: Colors.orange.shade600,
          unselectedItemColor: Colors.grey.shade600,
          items: [
            BottomNavigationBarItem(icon: Icon(Icons.store), label: 'Dashboard'),
            BottomNavigationBarItem(icon: Icon(Icons.assignment), label: 'form'),
            BottomNavigationBarItem(icon: Icon(Icons.receipt), label: 'Orders'),
            BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Settings'),
            BottomNavigationBarItem(icon: Icon(Icons.account_balance_wallet), label: 'Earnings'),
          ],
        ));
  }
}