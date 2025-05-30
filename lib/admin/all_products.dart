import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cached_network_image/cached_network_image.dart'; // إضافة مكتبة cached_network_image
import 'package:carthage_store/controllers/add_product_controller.dart';

class CategoryScreen extends StatefulWidget {
  const CategoryScreen({super.key});

  @override
  CategoryScreenState createState() => CategoryScreenState();
}

class CategoryScreenState extends State<CategoryScreen> with SingleTickerProviderStateMixin {
  late AddProductController controller;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  // Synchronize category data with controller.categories
  final Map<String, Map<String, dynamic>> categoryData = {
    'Electronics': {'icon': Icons.electrical_services, 'color': Colors.blue},
    'Clothing': {'icon': Icons.checkroom, 'color': Colors.purple},
    'parfum': {'icon': Icons.spa, 'color': Colors.green},
    'make-up': {'icon': Icons.brush, 'color': Color(0xFF93441A)},
    'jewellery': {'icon': Icons.diamond, 'color': Colors.pink},
  };

  @override
  void initState() {
    super.initState();
    // Initialize controller
    Get.put(AddProductController()); // Register controller
    controller = Get.find<AddProductController>();
    // Initialize animation controller
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _fadeAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeIn,
    );
    _animationController.forward();
    // Fetch products
    controller.getAllProducts();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Categories'),
      ),
      body: Obx(() => Center(
            child: Container(
              width: MediaQuery.of(context).size.width * 0.9,
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: controller.isLoading.value
                  ? const Center(child: CircularProgressIndicator())
                  : FadeTransition(
                      opacity: _fadeAnimation,
                      child: Column(
                        children: [
                          ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: controller.categories.length,
                            itemBuilder: (context, index) {
                              final category = controller.categories[index];
                              final categoryInfo = categoryData[category] ??
                                  {'icon': Icons.category, 'color': Colors.black};
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 12.0),
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(12),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey.withOpacity(0.2),
                                        spreadRadius: 2,
                                        blurRadius: 5,
                                        offset: const Offset(0, 3),
                                      ),
                                    ],
                                  ),
                                  child: ListTile(
                                    contentPadding: const EdgeInsets.symmetric(horizontal: 8.0), // تقليل الهوامش
                                    leading: CircleAvatar(
                                      backgroundColor: categoryInfo['color'].withOpacity(0.1),
                                      child: Icon(
                                        categoryInfo['icon'],
                                        color: categoryInfo['color'],
                                        size: 28,
                                      ),
                                    ),
                                    title: Text(
                                      category,
                                      style: const TextStyle(color: Colors.black87),
                                    ),
                                    trailing: const Icon(
                                      Icons.arrow_forward_ios,
                                      size: 16,
                                      color: Colors.grey,
                                    ),
                                    onTap: () {
                                      controller.selectedCategory.value = category;
                                      print('Selected category: $category');
                                      Get.to(() => ProductListScreen(category: category));
                                    },
                                  ),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
            ),
          )),
    );
  }
}

class ProductListScreen extends StatelessWidget {
  final String category;

  const ProductListScreen({super.key, required this.category});

  @override
  Widget build(BuildContext context) {
    final AddProductController controller = Get.find<AddProductController>();
    // تصفية المنتجات مسبقًا لتحسين الأداء
    final filteredProducts = controller.products.where((product) => product['category'] == category).toList();

    return Scaffold(
      appBar: AppBar(
        title: Text('$category Products'),
      ),
      body: Obx(() => controller.isLoading.value
          ? const Center(child: CircularProgressIndicator())
          : filteredProducts.isEmpty
              ? const Center(child: Text('No products found'))
              : ListView.builder(
                  padding: const EdgeInsets.all(16.0),
                  itemCount: filteredProducts.length,
                  itemBuilder: (context, index) {
                    final product = filteredProducts[index];
                    return Card(
                      margin: const EdgeInsets.only(bottom: 12.0),
                      child: ListTile(
                        contentPadding: const EdgeInsets.symmetric(horizontal: 8.0), // تقليل الهوامش
                        leading: SizedBox(
                          width: 50,
                          height: 50,
                          child: product['image_url'] != null
                              ? CachedNetworkImage(
                                  imageUrl: product['image_url'],
                                  width: 50,
                                  height: 50,
                                  fit: BoxFit.cover,
                                  placeholder: (context, url) => const CircularProgressIndicator(),
                                  errorWidget: (context, url, error) => Image.network(
                                    AddProductController.fallbackImageUrl,
                                    width: 50,
                                    height: 50,
                                    fit: BoxFit.cover,
                                  ),
                                )
                              : Image.network(
                                  AddProductController.fallbackImageUrl,
                                  width: 50,
                                  height: 50,
                                  fit: BoxFit.cover,
                                ),
                        ),
                        title: Text(product['name'] ?? 'Unknown'),
                        subtitle: Text(
                          'Price: \$${product['sale_price']?.toStringAsFixed(2) ?? '0.00'}',
                        ),
                        trailing: GestureDetector(
                          onTap: () async {
                            bool? confirm = await showDialog<bool>(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: const Text('Confirm Delete'),
                                content: Text('Are you sure you want to delete ${product['name']}?'),
                                actions: [
                                  TextButton(
                                    onPressed: () => Navigator.pop(context, false),
                                    child: const Text('Cancel'),
                                  ),
                                  TextButton(
                                    onPressed: () => Navigator.pop(context, true),
                                    child: const Text('Delete', style: TextStyle(color: Colors.red)),
                                  ),
                                ],
                              ),
                            );
                            if (confirm == true) {
                              await controller.deleteProduct(product['id']);
                            }
                          },
                          child: const Icon(Icons.delete, color: Colors.red),
                        ),
                        onTap: () {
                          print('Tapped product: ${product['name']}');
                        
                        },
                      ),
                    );
                  },
                )),
    );
  }
}