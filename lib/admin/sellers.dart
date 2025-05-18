import 'package:flutter/material.dart';

class SellersScreen extends StatefulWidget {
  @override
  _SellersScreenState createState() => _SellersScreenState();
}

class _SellersScreenState extends State<SellersScreen> {
  List<Map<String, dynamic>> sellers = [
    {
      "id": "SEL001",
      "name": "David Brown",
      "email": "david@example.com",
      "products": 12,
      "sales": 45,
      "phone": "+1-555-1234",
      "joinDate": "2024-02-10",
      "totalRevenue": 2450.80,
      "storeName": "Brown's Electronics",
      "status": "Active"
    },
    {
      "id": "SEL002",
      "name": "Emma Davis",
      "email": "emma@example.com",
      "products": 8,
      "sales": 32,
      "phone": "+1-555-5678",
      "joinDate": "2024-04-15",
      "totalRevenue": 1789.60,
      "storeName": "Davis Fashion",
      "status": "Active"
    },
    {
      "id": "SEL003",
      "name": "Frank Wilson",
      "email": "frank@example.com",
      "products": 15,
      "sales": 60,
      "phone": "+1-555-9012",
      "joinDate": "2023-12-05",
      "totalRevenue": 3890.25,
      "storeName": "Wilson's Gadgets",
      "status": "Inactive"
    },
  ];

  void _showUpdateDialog(BuildContext context, Map<String, dynamic> seller) {
    final nameController = TextEditingController(text: seller["name"]);
    final emailController = TextEditingController(text: seller["email"]);
    final phoneController = TextEditingController(text: seller["phone"]);
    final storeNameController = TextEditingController(text: seller["storeName"]);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Update Seller', style: TextStyle(color: Colors.purple)),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: _inputDecoration('Name'),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: emailController,
                decoration: _inputDecoration('Email'),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: phoneController,
                decoration: _inputDecoration('Phone'),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: storeNameController,
                decoration: _inputDecoration('Store Name'),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel', style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.purple,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            onPressed: () {
              setState(() {
                final index = sellers.indexWhere((s) => s["id"] == seller["id"]);
                sellers[index] = {
                  ...sellers[index],
                  "name": nameController.text,
                  "email": emailController.text,
                  "phone": phoneController.text,
                  "storeName": storeNameController.text,
                };
              });
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Seller updated successfully")),
              );
            },
            child: const Text('Update', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _deleteSeller(String id) {
    setState(() {
      sellers.removeWhere((seller) => seller["id"] == id);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Seller deleted successfully")),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text(
          "Sellers Management",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 24,
            shadows: [Shadow(color: Colors.black26, offset: Offset(1, 1))],
          ),
        ),
        centerTitle: true,
        elevation: 0,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.orange, Colors.deepOrange],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      body: sellers.isEmpty
          ? const Center(
              child: Text(
                "No sellers found",
                style: TextStyle(fontSize: 18, color: Colors.grey),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(20),
              itemCount: sellers.length,
              itemBuilder: (context, index) => _buildSellerCard(sellers[index], context),
            ),
    );
  }

  Widget _buildSellerCard(Map<String, dynamic> seller, BuildContext context) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.symmetric(vertical: 10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 35,
                  backgroundColor: Colors.purple.shade100,
                  child: Text(
                    seller["name"][0],
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.purple,
                    ),
                  ),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        seller["name"],
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        seller["email"],
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 16,
              runSpacing: 8,
              children: [
                _buildInfoChip("Products", "${seller["products"]}", Colors.purple),
                _buildInfoChip("Sales", "${seller["sales"]}", Colors.blue),
                _buildInfoChip("Status", seller["status"],
                    seller["status"] == "Active" ? Colors.green : Colors.red),
                _buildInfoChip("Phone", seller["phone"], Colors.teal),
                _buildInfoChip("Joined", seller["joinDate"], Colors.orange),
                _buildInfoChip("Revenue", "\$${seller["totalRevenue"]}", Colors.green),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              "Store: ${seller["storeName"]}",
              style: TextStyle(fontSize: 14, color: Colors.grey[700]),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                  icon: const Icon(Icons.edit, color: Colors.blue, size: 28),
                  onPressed: () => _showUpdateDialog(context, seller),
                  tooltip: 'Edit Seller',
                ),
                const SizedBox(width: 8),
                IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red, size: 28),
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text('Confirm Delete'),
                        content: Text('Are you sure you want to delete ${seller["name"]}?'),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text('Cancel'),
                          ),
                          TextButton(
                            onPressed: () {
                              _deleteSeller(seller["id"]);
                              Navigator.pop(context);
                            },
                            child: const Text('Delete', style: TextStyle(color: Colors.red)),
                          ),
                        ],
                      ),
                    );
                  },
                  tooltip: 'Delete Seller',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoChip(String label, String value, Color color) {
    return Chip(
      avatar: CircleAvatar(
        backgroundColor: color.withOpacity(0.1),
        child: Text(
          label[0],
          style: TextStyle(color: color, fontSize: 12),
        ),
      ),
      label: Text(
        "$label: $value",
        style: TextStyle(color: color, fontSize: 14),
      ),
      backgroundColor: color.withOpacity(0.05),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    );
  }

  InputDecoration _inputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      focusedBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: Colors.purple, width: 2),
        borderRadius: BorderRadius.circular(12),
      ),
      prefixIcon: Icon(
        label == 'Name'
            ? Icons.person
            : label == 'Email'
                ? Icons.email
                : label == 'Phone'
                    ? Icons.phone
                    : Icons.store,
        color: Colors.purple,
      ),
    );
  }
}