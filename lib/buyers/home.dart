import 'package:carthage_store/controllers/add_product_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:animate_do/animate_do.dart';
import './product_details_screen.dart';
import './product_card.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin {
  int _selectedIndex = 0;
  int _selectedCategoryIndex = 0;
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  final TextEditingController _searchController = TextEditingController();
  final RxString _searchQuery = ''.obs;
  final AddProductController controller = Get.put(AddProductController());

  final List<Map<String, dynamic>> categories = [
    {"name": "All", "icon": Icons.all_inclusive, 'color': Colors.grey},
    {"name": "Electronics", "icon": Icons.tv, 'color': Colors.blue},
    {"name": "Clothing", "icon": Icons.checkroom, 'color': Colors.purple},
    {"name": "Parfum", "icon": Icons.spa, 'color': Colors.green},
    {"name": "Make-up", "icon": Icons.brush, 'color': Color(0xFF93441A)},
    {"name":"skincare", 'icon': Icons.face_retouching_natural,'color': Colors.orange},
    {"name": "Jewellery", "icon": Icons.diamond, 'color': Colors.pink},
  ];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    _fadeAnimation = CurvedAnimation(parent: _controller, curve: Curves.easeIn);
    _controller.forward();
    controller.getAllProducts();

    _searchController.addListener(() {
      _searchQuery.value = _searchController.text;
      setState(() {});
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            SliverToBoxAdapter(child: _buildSearchBar()),
            SliverToBoxAdapter(child: _buildCategoryList()),
            SliverToBoxAdapter(child: _buildPromoBanner()),
            SliverToBoxAdapter(child: _buildProductGrid()),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomNavigationBar(),
      floatingActionButton: _buildFloatingActionButton(),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      leading: FadeInDown(
        duration: const Duration(milliseconds: 600),
        child: _buildIconButton(Icons.menu, () {}),
      ),
      title: FadeInDown(
        duration: const Duration(milliseconds: 600),
        child: Flexible(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.store, color: const Color(0xFF93441A)),
              const SizedBox(width: 8),
              Flexible(
                child: Text(
                  'Carthage Store',
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                    fontSize: 16,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
      centerTitle: true,
      elevation: 0,
      backgroundColor: Colors.white,
      actions: [
        FadeInDown(
          duration: const Duration(milliseconds: 600),
          delay: const Duration(milliseconds: 200),
          child: _buildIconButton(Icons.shopping_cart, () {
            _showCartBottomSheet(context);
          }),
        ),
      ],
    );
  }

  Widget _buildIconButton(IconData icon, VoidCallback onPressed) {
    return Container(
      margin: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.grey.shade100, Colors.white],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 2,
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: IconButton(
        onPressed: onPressed,
        icon: Icon(icon, color: Colors.black87, size: 26),
      ),
    );
  }

  Widget _buildSearchBar() {
    return SlideInUp(
      duration: const Duration(milliseconds: 800),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.15),
                      spreadRadius: 2,
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: "Search products...",
                    hintStyle: GoogleFonts.poppins(
                      color: Colors.grey.shade500,
                      fontSize: 16,
                    ),
                    prefixIcon: const Icon(Icons.search, color: Color(0xFF93441A)),
                    suffixIcon: Obx(() => _searchQuery.value.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear, color: Color(0xFF93441A)),
                            onPressed: () {
                              _searchController.clear();
                              _searchQuery.value = '';
                              setState(() {});
                            },
                          )
                        : const Icon(Icons.mic, color: Color(0xFF93441A))),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(vertical: 15),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 10),
            FadeInRight(
              duration: const Duration(milliseconds: 800),
              child: _buildIconButton(Icons.filter_list, () {}),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryList() {
    return SlideInUp(
      duration: const Duration(milliseconds: 800),
      delay: const Duration(milliseconds: 100),
      child: Container(
        height: 60,
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: categories.length,
          itemBuilder: (context, index) {
            bool isSelected = _selectedCategoryIndex == index;
            return GestureDetector(
              onTap: () {
                setState(() {
                  _selectedCategoryIndex = index;
                });
              },
              child: FadeInRight(
                duration: const Duration(milliseconds: 600),
                delay: Duration(milliseconds: 100 * index),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  margin: const EdgeInsets.symmetric(horizontal: 6),
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    gradient: isSelected
                        ? LinearGradient(
                            colors: [
                              categories[index]["color"],
                              categories[index]["color"].withOpacity(0.7),
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          )
                        : LinearGradient(
                            colors: [Colors.grey.shade100, Colors.white],
                          ),
                    borderRadius: BorderRadius.circular(25),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.2),
                        spreadRadius: 1,
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Icon(
                        categories[index]["icon"]!,
                        size: 20,
                        color: isSelected ? Colors.white : categories[index]["color"],
                      ),
                      const SizedBox(width: 8),
                      Text(
                        categories[index]["name"]!,
                        style: GoogleFonts.poppins(
                          color: isSelected ? Colors.white : Colors.black87,
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildPromoBanner() {
    return ZoomIn(
      duration: const Duration(milliseconds: 1000),
      child: Container(
        margin: const EdgeInsets.all(16),
        height: 200,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.3),
              spreadRadius: 2,
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Stack(
          children: [
            // Background image with animation
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                image: DecorationImage(
                  image: AssetImage('assets/images/Customer.jpg'), // Use a single image
                  fit: BoxFit.cover,
                  colorFilter: ColorFilter.mode(
                    Colors.black.withOpacity(0.3),
                    BlendMode.darken,
                  ),
                ),
              ),
            ),
            // Foreground content
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  FadeInLeft(
                    duration: const Duration(milliseconds: 800),
                    child: Text(
                      "New Collection",
                      style: GoogleFonts.poppins(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  FadeInLeft(
                    duration: const Duration(milliseconds: 800),
                    delay: const Duration(milliseconds: 200),
                    child: Text(
                      "Discount 50% for the\nfirst transaction",
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        color: Colors.white70,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  FadeInLeft(
                    duration: const Duration(milliseconds: 800),
                    delay: const Duration(milliseconds: 400),
                    child: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25),
                        ),
                        elevation: 3,
                      ),
                      child: Text(
                        "Shop Now",
                        style: GoogleFonts.poppins(
                          color: const Color(0xFF93441A),
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProductGrid() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              FadeInDown(
                duration: const Duration(milliseconds: 600),
                child: Text(
                  "Top Selling",
                  style: GoogleFonts.poppins(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
              ),
              FadeInDown(
                duration: const Duration(milliseconds: 600),
                child: TextButton(
                  onPressed: () => controller.getAllProducts(),
                  child: Text(
                    "View All",
                    style: GoogleFonts.poppins(
                      color: const Color(0xFF93441A),
                      fontSize: 14,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Obx(() {
            if (controller.isLoading.value) {
              return const Center(child: CircularProgressIndicator());
            }
            final filteredProducts = _getFilteredProducts();
            if (filteredProducts.isEmpty) {
              return Center(
                child: Text(
                  'No products found',
                  style: GoogleFonts.poppins(fontSize: 16),
                ),
              );
            }

            return GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 0.6,
              ),
              itemCount: filteredProducts.length,
              itemBuilder: (context, index) {
                return FadeInUp(
                  duration: const Duration(milliseconds: 600),
                  delay: Duration(milliseconds: 100 * index),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ProductDetailsScreen(
                            product: filteredProducts[index],
                          ),
                        ),
                      );
                    },
                    child: ProductCard(product: filteredProducts[index]),
                  ),
                );
              },
            );
          }),
        ],
      ),
    );
  }

  List<Map<String, dynamic>> _getFilteredProducts() {
    final query = _searchQuery.value.toLowerCase();
    List<Map<String, dynamic>> filteredProducts = List.from(controller.products);

    if (_selectedCategoryIndex != 0) {
      filteredProducts = filteredProducts.where((product) {
        final productCategory = product['category']?.toString().toLowerCase() ?? '';
        final selectedCategory = categories[_selectedCategoryIndex]["name"]!.toLowerCase();
        return productCategory == selectedCategory;
      }).toList();
    }

    if (query.isNotEmpty) {
      filteredProducts = filteredProducts.where((product) {
        final name = product['name']?.toString().toLowerCase() ?? '';
        final category = product['category']?.toString().toLowerCase() ?? '';
        return name.contains(query) || category.contains(query);
      }).toList();
    }

    return filteredProducts;
  }

  Widget _buildBottomNavigationBar() {
    return FadeInUp(
      duration: const Duration(milliseconds: 800),
      child: Container(
        margin: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              spreadRadius: 2,
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(30),
          child: BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            currentIndex: _selectedIndex,
            onTap: (index) {
              setState(() => _selectedIndex = index);
              if (index == 1) {
                Navigator.pushNamed(context, '/search');
              }
              if (index == 2) {
                Navigator.pushNamed(context, '/favorites');
              }
              if (index == 3) {
                Navigator.pushNamed(context, '/profile');
              }
            },
            backgroundColor: Colors.white,
            selectedItemColor: const Color(0xFF93441A),
            unselectedItemColor: Colors.grey,
            selectedLabelStyle: GoogleFonts.poppins(fontSize: 12),
            unselectedLabelStyle: GoogleFonts.poppins(fontSize: 12),
            items: const [
              BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
              BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Search'),
              BottomNavigationBarItem(icon: Icon(Icons.favorite), label: 'Favorites'),
              BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFloatingActionButton() {
    return ZoomIn(
      duration: const Duration(milliseconds: 1000),
      child: FloatingActionButton(
        onPressed: () {},
        backgroundColor: const Color(0xFF93441A),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
        child: const Icon(Icons.chat, color: Colors.white),
      ),
    );
  }

  void _showCartBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        maxChildSize: 0.9,
        minChildSize: 0.5,
        expand: false,
        builder: (context, scrollController) => Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.2),
                      spreadRadius: 1,
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Your Cart',
                      style: GoogleFonts.poppins(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close, color: Colors.black87),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: ListView.builder(
                  controller: scrollController,
                  padding: const EdgeInsets.all(16),
                  itemCount: 3,
                  itemBuilder: (context, index) {
                    return FadeInUp(
                      duration: const Duration(milliseconds: 600),
                      delay: Duration(milliseconds: 100 * index),
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 16),
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(15),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.1),
                              spreadRadius: 1,
                              blurRadius: 4,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 60,
                              height: 60,
                              decoration: BoxDecoration(
                                color: Colors.grey[200],
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: const Icon(Icons.image, color: Colors.grey),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Product ${index + 1}',
                                    style: GoogleFonts.poppins(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.black87,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    '\$${(index + 1) * 29.99}',
                                    style: GoogleFonts.poppins(
                                      fontSize: 14,
                                      color: const Color(0xFF93441A),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.remove_circle_outline, color: Colors.red),
                              onPressed: () {},
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.2),
                      spreadRadius: 1,
                      blurRadius: 4,
                      offset: const Offset(0, -2),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Total',
                          style: GoogleFonts.poppins(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                        Text(
                          '\$89.97',
                          style: GoogleFonts.poppins(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: const Color(0xFF93441A),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF93441A),
                        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25),
                        ),
                        minimumSize: const Size(double.infinity, 50),
                      ),
                      child: Text(
                        'Proceed to Checkout',
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}