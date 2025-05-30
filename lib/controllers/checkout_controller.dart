import 'package:cloud_firestore/cloud_firestore.dart';

class CheckoutController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> submitOrder({
    required Map<String, dynamic> product,
    required String name,
    required String phone,
    required String email,
    required String address,
  }) async {
    try {
      // Create order data
      final orderData = {
        'product_id': product['id'] ?? '',
        'product_name': product['name'] ?? 'Unnamed Product',
        'price': product['sale_price']?.toDouble() ?? 0.0,
        'id_seller': product['user_id'] ?? '', // Added id_seller field using product.uid
        'customer_name': name,
        'phone_number': phone,
        'email': email,
        'delivery_address': address,
        'payment_method': 'Cash on Delivery',
        'order_status': 'pending',
        'created_at': FieldValue.serverTimestamp(),
      };

      // Save order to Firestore
      await _firestore.collection('orders').add(orderData);
    } catch (e) {
      // Rethrow the error to be handled by the UI
      throw Exception('Failed to submit order: $e');
    }
  }

  // New method to fetch all orders
  Future<List<Map<String, dynamic>>> fetchAllOrders({String? sellerId}) async {
    try {
      Query<Map<String, dynamic>> query = _firestore.collection('orders');
      if (sellerId != null) {
        query = query.where('id_seller', isEqualTo: sellerId);
      }
      final querySnapshot = await query.get();
      return querySnapshot.docs
          .map((doc) => {
                'id': doc.id,
                ...doc.data(),
              })
          .toList();
    } catch (e) {
      throw Exception('Failed to fetch orders: $e');
    }
  }

  // Method to update order status
  Future<void> updateOrderStatus(String orderId, String newStatus) async {
    try {
      await _firestore.collection('orders').doc(orderId).update({
        'order_status': newStatus,
        'updated_at': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      throw Exception('Failed to update order status: $e');
    }
  }
}