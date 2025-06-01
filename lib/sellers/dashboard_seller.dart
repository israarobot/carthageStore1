import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:carthage_store/controllers/auth-controller.dart';
import 'package:carthage_store/controllers/add_product_controller.dart';
import 'package:cached_network_image/cached_network_image.dart';

class SellerDashboardController extends GetxController {
  var totalEarnings = 1300.50.obs; // Mock total earnings
  var selectedIndex = 0.obs;

  // Store the product being edited
  var editingProduct = Rxn<Map<String, dynamic>>();

  void navigateTo(int index) {
    if (selectedIndex.value == index) return;
    selectedIndex.value = index;
    switch (index) {
      case 0:
        Get.offNamed('/dashboard-seller');
        break;
      case 1:
        // Reset editing product when navigating to form
        editingProduct.value = null;
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

  // Method to initiate product editing
  void startEditingProduct(Map<String, dynamic> product) {
    editingProduct.value = Map<String, dynamic>.from(product);
    Get.toNamed('/form_sellers');
  }
}

class SellerDashboard extends StatelessWidget {
  final SellerDashboardController controller = Get.put(SellerDashboardController());
  final AuthController authController = Get.find<AuthController>();
  final AddProductController productController = Get.put(AddProductController());

  SellerDashboard({super.key}) {
    // Fetch products when the dashboard is initialized
    productController.getAllProducts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(),
            const SizedBox(height: 16),
            const Text(
              "Your Products",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w600,
                fontFamily: 'Poppins',
                color: Color(0xFF2D2D2D),
              ),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: Obx(() => productController.isLoading.value
                  ? const Center(child: CircularProgressIndicator(color: Color(0xFF93441A)))
                  : productController.products.isEmpty
                      ? Center(
                          child: Text(
                            "No products found. Add a product to get started!",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey.shade600,
                              fontFamily: 'Poppins',
                              height: 1.5,
                            ),
                          ),
                        )
                      : ListView.builder(
                          itemCount: productController.products.length,
                          itemBuilder: (context, index) {
                            final product = productController.products[index];
                            return _buildProductCard(context, product);
                          },
                        )),
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
          colors: [Color(0xFF93441A), Color(0xFF6A1B9A).withOpacity(0.9)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          stops: [0.0, 1.0],
        ),
      ),
    ),
    elevation: 6,
    shadowColor: Colors.black.withOpacity(0.3),
    leading: Padding(
      padding: const EdgeInsets.all(10),
      child: Obx(() {
        final sellerName = authController.userData['fullName'] ?? 'User';
        return CircleAvatar(
          backgroundColor: Colors.white,
          radius: 22,
          child: Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.15),
                  blurRadius: 4,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: Center(
              child: Text(
                sellerName.isNotEmpty ? sellerName[0].toUpperCase() : 'U',
                style: const TextStyle(
                  color: Color(0xFF93441A),
                  fontWeight: FontWeight.w800,
                  fontSize: 20,
                  fontFamily: 'Poppins',
                ),
              ),
            ),
          ),
        );
      }),
    ),
    title: Obx(() {
      final sellerName = authController.userData['fullName'] ?? 'User';
      return Text(
        "$sellerName's Store",
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w700,
          fontSize: 22,
          fontFamily: 'Poppins',
          letterSpacing: 0.8,
          shadows: [
            Shadow(
              color: Colors.black38,
              blurRadius: 3,
              offset: Offset(1, 1),
            ),
          ],
        ),
      );
    }),
    centerTitle: true,
    actions: [
      _buildIconButton(Icons.logout, () => authController.logout()),
    ],
  );
}
  Widget _buildIconButton(IconData icon, VoidCallback onPressed) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: GestureDetector(
        onTap: onPressed,
        child: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.15),
                blurRadius: 8,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Icon(icon, color: const Color(0xFF2D2D2D), size: 24),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Obx(() {
          final sellerName = authController.userData['fullName'] ?? 'User';
          return Text(
            "Welcome, $sellerName!",
            style: const TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.w700,
              fontFamily: 'Poppins',
              color: Color(0xFF2D2D2D),
            ),
          );
        }),
        const SizedBox(height: 8),
        Obx(() => Text(
              "Total Earnings: ${controller.totalEarnings.value.toStringAsFixed(2)} \Dt",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Colors.green.shade700,
                fontFamily: 'Poppins',
              ),
            )),
      ],
    );
  }

  Widget _buildBottomNav() {
    return Obx(() => Container(
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 10,
                offset: const Offset(0, -2),
              ),
            ],
          ),
          child: BottomNavigationBar(
            currentIndex: controller.selectedIndex.value,
            onTap: controller.navigateTo,
            selectedItemColor: const Color(0xFF93441A),
            unselectedItemColor: Colors.grey.shade500,
            backgroundColor: Colors.white,
            selectedLabelStyle: const TextStyle(
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w600,
              fontSize: 12,
            ),
            unselectedLabelStyle: const TextStyle(
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w400,
              fontSize: 12,
            ),
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.store, size: 28),
                label: 'Dashboard',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.assignment, size: 28),
                label: 'Form',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.receipt, size: 28),
                label: 'Orders',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.settings, size: 28),
                label: 'Settings',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.account_balance_wallet, size: 28),
                label: 'Earnings',
              ),
            ],
          ),
        ));
  }

  Widget _buildProductCard(BuildContext context, Map<String, dynamic> product) {
    final String productId = product['id']?.toString() ?? '';
    final String productName = product['name']?.toString() ?? 'Unnamed Product';

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () {}, // Optional tap effect
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Product Image
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: CachedNetworkImage(
                  imageUrl: (product['image_urls'] as List<dynamic>?)?.isNotEmpty == true
                      ? product['image_urls'][0].toString()
                      : AddProductController.fallbackImageUrl,
                  width: 90,
                  height: 90,
                  fit: BoxFit.cover,
                  placeholder: (context, url) => Container(
                    width: 90,
                    height: 90,
                    color: Colors.grey.shade200,
                    child: const Center(child: CircularProgressIndicator(color: Color(0xFF93441A))),
                  ),
                  errorWidget: (context, url, error) => Container(
                    width: 90,
                    height: 90,
                    color: Colors.grey.shade200,
                    child: Icon(Icons.broken_image, color: Colors.grey.shade400, size: 40),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              // Product Details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      productName,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'Poppins',
                        color: Color(0xFF2D2D2D),
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 6),
                    Text(
                      product['brand']?.toString() ?? 'No Brand',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.shade600,
                        fontFamily: 'Poppins',
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      "Price: ${product['sale_price']?.toStringAsFixed(2) ?? '0.00'} \Dt",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Colors.green.shade700,
                        fontFamily: 'Poppins',
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      "Stock: ${product['stock']?.toString() ?? '0'} ${product['unit']?.toString() ?? ''}",
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.shade600,
                        fontFamily: 'Poppins',
                      ),
                    ),
                  ],
                ),
              ),
              // Action Buttons
              Column(
                children: [
                  IconButton(
                    icon: const Icon(Icons.edit, color: Colors.blue, size: 24),
                    onPressed: productId.isNotEmpty
                        ? () {
                            controller.startEditingProduct(product);
                          }
                        : null,
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red, size: 24),
                    onPressed: productId.isNotEmpty
                        ? () {
                            _confirmDelete(context, productId, productName);
                          }
                        : null,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _confirmDelete(BuildContext context, String productId, String productName) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text(
          'Confirm Delete',
          style: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.w600),
        ),
        content: Text(
          'Are you sure you want to delete "$productName"?',
          style: const TextStyle(fontFamily: 'Poppins', fontSize: 16),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'Cancel',
              style: TextStyle(fontFamily: 'Poppins', color: Colors.grey),
            ),
          ),
          TextButton(
            onPressed: () {
              if (productId.isNotEmpty) {
                productController.deleteProduct(productId);
              }
              Navigator.pop(context);
            },
            child: const Text(
              'Delete',
              style: TextStyle(fontFamily: 'Poppins', color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }
}