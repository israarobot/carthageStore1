import 'package:flutter/material.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<Map<String, dynamic>> _filteredProducts = [];
  final List<Map<String, dynamic>> _allProducts = [
    {"image": "assets/images/Lamp.jpg", "name": "Modern Lamp", "price": 50.0, "rating": 4.5},
    {"image": "assets/images/Bag.jpg", "name": "Leather Bag", "price": 80.0, "rating": 4.8},
    {"image": "assets/images/Headphone.jpg", "name": "Wireless Headphones", "price": 120.0, "rating": 4.7},
    {"image": "assets/images/Jewellery.jpg", "name": "Gold Necklace", "price": 200.0, "rating": 4.9},
    {"image": "assets/images/shoes.jpg", "name": "Sports Shoes", "price": 95.0, "rating": 4.6},
    {"image": "assets/images/clothing.jpg", "name": "Summer Dress", "price": 70.0, "rating": 4.4},
  ];

  @override
  void initState() {
    super.initState();
    _filteredProducts = _allProducts;
    _searchController.addListener(_filterProducts);
  }

  void _filterProducts() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filteredProducts = _allProducts
          .where((product) => product["name"]!.toLowerCase().contains(query))
          .toList();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Search", style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        elevation: 0,
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            _buildSearchBar(),
            SizedBox(height: 20),
            Expanded(child: _buildSearchResults()),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 2,
            blurRadius: 8,
          ),
        ],
      ),
      child: TextField(
        controller: _searchController,
        decoration: InputDecoration(
          hintText: "Search products...",
          prefixIcon: Icon(Icons.search, color: Colors.grey),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(vertical: 15),
        ),
      ),
    );
  }

  Widget _buildSearchResults() {
    return _filteredProducts.isEmpty
        ? Center(child: Text("No products found", style: TextStyle(color: Colors.grey)))
        : ListView.builder(
            itemCount: _filteredProducts.length,
            itemBuilder: (context, index) {
              final product = _filteredProducts[index];
              return ListTile(
                leading: Image.asset(product["image"]!, width: 50, height: 50, fit: BoxFit.cover),
                title: Text(product["name"]!, style: TextStyle(fontWeight: FontWeight.bold)),
                subtitle: Text("\$${product["price"]} - Rating: ${product["rating"]}"),
                trailing: Icon(Icons.add_shopping_cart, color: Colors.orange),
                onTap: () {},
              );
            },
          );
  }
}