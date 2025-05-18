import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OrdersScreen extends StatelessWidget {
  // Mock list of 10 orders managed with Rx for reactivity
  final RxList<Order> orders =
      <Order>[
        Order(
          id: 'ORD001',
          customerName: 'John Doe',
          item: 'Laptop Pro',
          status: 'pending',
        ),
        Order(
          id: 'ORD002',
          customerName: 'Jane Smith',
          item: 'Wireless Mouse',
          status: 'pending',
        ),
        Order(
          id: 'ORD003',
          customerName: 'Alice Johnson',
          item: 'USB-C Hub',
          status: 'in progress',
        ),
        Order(
          id: 'ORD004',
          customerName: 'Bob Wilson',
          item: 'Ergonomic Keyboard',
          status: 'pending',
        ),
        Order(
          id: 'ORD005',
          customerName: 'Emma Brown',
          item: 'Monitor Stand',
          status: 'done',
        ),
        Order(
          id: 'ORD006',
          customerName: 'Michael Chen',
          item: 'Webcam HD',
          status: 'in progress',
        ),
        Order(
          id: 'ORD007',
          customerName: 'Sarah Davis',
          item: 'Noise-Canceling Headphones',
          status: 'rejected',
        ),
        Order(
          id: 'ORD008',
          customerName: 'David Lee',
          item: 'Portable SSD',
          status: 'pending',
        ),
        Order(
          id: 'ORD009',
          customerName: 'Laura Martinez',
          item: 'Smartphone Charger',
          status: 'in progress',
        ),
        Order(
          id: 'ORD010',
          customerName: 'Chris Taylor',
          item: 'Gaming Mouse Pad',
          status: 'done',
        ),
      ].obs;

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

        title: const Text(
          "Orders",
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
      body: Obx(
        () =>
            orders.isEmpty
                ? Center(
                  child: Text(
                    "No orders available.",
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.grey.shade600,
                      fontFamily: 'Poppins',
                    ),
                    textAlign: TextAlign.center,
                  ),
                )
                : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: orders.length,
                  itemBuilder: (context, index) {
                    final order = orders[index];
                    return _buildOrderCard(order, index);
                  },
                ),
      ),
    );
  }

  Widget _buildOrderCard(Order order, int index) {
    return Card(
      elevation: 6,
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Order #${order.id}",
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Poppins',
                    color: Colors.black87,
                  ),
                ),
                _buildStatusChip(order.status),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              "Customer: ${order.customerName}",
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey.shade800,
                fontFamily: 'Poppins',
              ),
            ),
            const SizedBox(height: 4),
            Text(
              "Item: ${order.item}",
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey.shade800,
                fontFamily: 'Poppins',
              ),
            ),
            const SizedBox(height: 16),
            _buildActionButtons(order, index),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusChip(String status) {
    Color color;
    String label;
    switch (status) {
      case 'pending':
        color = Colors.orange.shade100;
        label = 'Pending';
        break;
      case 'in progress':
        color = Colors.blue.shade100;
        label = 'In Progress';
        break;
      case 'done':
        color = Colors.green.shade100;
        label = 'Done';
        break;
      case 'rejected':
        color = Colors.red.shade100;
        label = 'Rejected';
        break;
      default:
        color = Colors.grey.shade100;
        label = 'Unknown';
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.5)),
      ),
      child: Text(
        label,
        style: const TextStyle(
          fontSize: 12,
          fontFamily: 'Poppins',
          color: Colors.black87,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildActionButtons(Order order, int index) {
    if (order.status == 'pending') {
      return Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          _buildActionButton(
            label: 'Accept',
            icon: Icons.check,
            color: Colors.green.shade600,
            onPressed: () {
              orders[index] = order.copyWith(status: 'in progress');
              orders.refresh();
              Get.snackbar(
                'Order Accepted',
                'Order #${order.id} is now in progress.',
                snackPosition: SnackPosition.BOTTOM,
                backgroundColor: Colors.green.shade600,
                colorText: Colors.white,
                margin: const EdgeInsets.all(16),
                borderRadius: 12,
              );
            },
          ),
          const SizedBox(width: 12),
          _buildActionButton(
            label: 'Reject',
            icon: Icons.close,
            color: Colors.red.shade600,
            onPressed: () {
              orders[index] = order.copyWith(status: 'rejected');
              orders.refresh();
              Get.snackbar(
                'Order Rejected',
                'Order #${order.id} has been rejected.',
                snackPosition: SnackPosition.BOTTOM,
                backgroundColor: Colors.red.shade600,
                colorText: Colors.white,
                margin: const EdgeInsets.all(16),
                borderRadius: 12,
              );
            },
          ),
        ],
      );
    } else if (order.status == 'in progress') {
      return Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          _buildActionButton(
            label: 'Mark as Done',
            icon: Icons.done_all,
            color: Colors.green.shade600,
            onPressed: () {
              orders[index] = order.copyWith(status: 'done');
              orders.refresh();
              Get.snackbar(
                'Order Completed',
                'Order #${order.id} is now done.',
                snackPosition: SnackPosition.BOTTOM,
                backgroundColor: Colors.green.shade600,
                colorText: Colors.white,
                margin: const EdgeInsets.all(16),
                borderRadius: 12,
              );
            },
          ),
        ],
      );
    }
    return const SizedBox.shrink(); // No buttons for 'done' or 'rejected' status
  }

  Widget _buildActionButton({
    required String label,
    required IconData icon,
    required Color color,
    required VoidCallback onPressed,
  }) {
    return ElevatedButton.icon(
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        elevation: 2,
      ),
      onPressed: onPressed,
      icon: Icon(icon, size: 18),
      label: Text(
        label,
        style: const TextStyle(
          fontSize: 14,
          fontFamily: 'Poppins',
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

// Data model for an order
class Order {
  final String id;
  final String customerName;
  final String item;
  final String status;

  Order({
    required this.id,
    required this.customerName,
    required this.item,
    required this.status,
  });

  Order copyWith({
    String? id,
    String? customerName,
    String? item,
    String? status,
  }) {
    return Order(
      id: id ?? this.id,
      customerName: customerName ?? this.customerName,
      item: item ?? this.item,
      status: status ?? this.status,
    );
  }
}
