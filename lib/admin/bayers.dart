import 'package:flutter/material.dart';

class BuyersScreen extends StatefulWidget {
  @override
  _BuyersScreenState createState() => _BuyersScreenState();
}

class _BuyersScreenState extends State<BuyersScreen> {
  List<Map<String, dynamic>> buyers = [
    {
      "id": "BUY001",
      "name": "Alice Johnson",
      "email": "alice@example.com",
      "purchases": 15,
      "status": "Active",
      "phone": "+1-555-0123",
      "joinDate": "2024-01-15",
      "totalSpent": 599.75,
      "address": "123 Main St, Springfield"
    },
    {
      "id": "BUY002",
      "name": "Bob Smith",
      "email": "bob@example.com",
      "purchases": 8,
      "status": "Active",
      "phone": "+1-555-0456",
      "joinDate": "2024-03-20",
      "totalSpent": 349.90,
      "address": "456 Oak Ave, Rivertown"
    },
    {
      "id": "BUY003",
      "name": "Carol Williams",
      "email": "carol@example.com",
      "purchases": 22,
      "status": "Inactive",
      "phone": "+1-555-0789",
      "joinDate": "2023-11-10",
      "totalSpent": 899.45,
      "address": "789 Pine Rd, Lakeside"
    },
  ];

  void _showUpdateDialog(BuildContext context, Map<String, dynamic> buyer) {
    final nameController = TextEditingController(text: buyer["name"]);
    final emailController = TextEditingController(text: buyer["email"]);
    final phoneController = TextEditingController(text: buyer["phone"]);
    final addressController = TextEditingController(text: buyer["address"]);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Update Buyer', style: TextStyle(color: Colors.green)),
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
                controller: addressController,
                decoration: _inputDecoration('Address'),
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
              backgroundColor: Colors.green,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            onPressed: () {
              setState(() {
                final index = buyers.indexWhere((b) => b["id"] == buyer["id"]);
                buyers[index] = {
                  ...buyers[index],
                  "name": nameController.text,
                  "email": emailController.text,
                  "phone": phoneController.text,
                  "address": addressController.text,
                };
              });
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Buyer updated successfully")),
              );
            },
            child: const Text('Update', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _deleteBuyer(String id) {
    setState(() {
      buyers.removeWhere((buyer) => buyer["id"] == id);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Buyer deleted successfully")),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text(
          "Buyers Management",
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
      body: buyers.isEmpty
          ? const Center(
              child: Text(
                "No buyers found",
                style: TextStyle(fontSize: 18, color: Colors.grey),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(20),
              itemCount: buyers.length,
              itemBuilder: (context, index) => _buildBuyerCard(buyers[index], context),
            ),
    );
  }

  Widget _buildBuyerCard(Map<String, dynamic> buyer, BuildContext context) {
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
                  backgroundColor: Colors.green.shade100,
                  child: Text(
                    buyer["name"][0],
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                    ),
                  ),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        buyer["name"],
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        buyer["email"],
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
                _buildInfoChip("Purchases", "${buyer["purchases"]}", Colors.blue),
                _buildInfoChip("Status", buyer["status"],
                    buyer["status"] == "Active" ? Colors.green : Colors.red),
                _buildInfoChip("Phone", buyer["phone"], Colors.purple),
                _buildInfoChip("Joined", buyer["joinDate"], Colors.orange),
                _buildInfoChip("Spent", "\$${buyer["totalSpent"]}", Colors.teal),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              "Address: ${buyer["address"]}",
              style: TextStyle(fontSize: 14, color: Colors.grey[700]),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                  icon: const Icon(Icons.edit, color: Colors.blue, size: 28),
                  onPressed: () => _showUpdateDialog(context, buyer),
                  tooltip: 'Edit Buyer',
                ),
                const SizedBox(width: 8),
                IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red, size: 28),
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text('Confirm Delete'),
                        content: Text('Are you sure you want to delete ${buyer["name"]}?'),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text('Cancel'),
                          ),
                          TextButton(
                            onPressed: () {
                              _deleteBuyer(buyer["id"]);
                              Navigator.pop(context);
                            },
                            child: const Text('Delete', style: TextStyle(color: Colors.red)),
                          ),
                        ],
                      ),
                    );
                  },
                  tooltip: 'Delete Buyer',
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
        borderSide: const BorderSide(color: Colors.green, width: 2),
        borderRadius: BorderRadius.circular(12),
      ),
      prefixIcon: Icon(
        label == 'Name'
            ? Icons.person
            : label == 'Email'
                ? Icons.email
                : label == 'Phone'
                    ? Icons.phone
                    : Icons.location_on,
        color: Colors.green,
      ),
    );
  }
}