import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AddProductScreen extends StatefulWidget {
  const AddProductScreen({super.key});

  @override
  State<AddProductScreen> createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  // Controllers
  final TextEditingController nameController = TextEditingController();
  final TextEditingController brandController = TextEditingController();
  final TextEditingController codeController = TextEditingController();
  final TextEditingController stockController = TextEditingController();
  final TextEditingController salePriceController = TextEditingController();
  final TextEditingController discountController = TextEditingController();
  final TextEditingController wholesalePriceController = TextEditingController();
  final TextEditingController dealerPriceController = TextEditingController();
  final TextEditingController manufacturerController = TextEditingController();
  final TextEditingController imageUrlController = TextEditingController();

  // Dropdown options
  final List<String> categories = ['Electronics', 'Clothing', 'Books', 'Other'];
  final List<String> units = ['Piece', 'Kg', 'Liter', 'Meter'];
  String? selectedCategory;
  String? selectedUnit;

  @override
  void dispose() {
    // Dispose controllers to prevent memory leaks
    nameController.dispose();
    brandController.dispose();
    codeController.dispose();
    stockController.dispose();
    salePriceController.dispose();
    discountController.dispose();
    wholesalePriceController.dispose();
    dealerPriceController.dispose();
    manufacturerController.dispose();
    imageUrlController.dispose();
    super.dispose();
  }

  Future<void> _saveProduct() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      await FirebaseFirestore.instance.collection('products').add({
        'name': nameController.text.trim(),
        'category': selectedCategory,
        'brand': brandController.text.trim(),
        'code': codeController.text.trim(),
        'stock': int.tryParse(stockController.text) ?? 0,
        'unit': selectedUnit,
        'sale_price': double.tryParse(salePriceController.text) ?? 0.0,
        'discount': double.tryParse(discountController.text) ?? 0.0,
        'wholesale_price': double.tryParse(wholesalePriceController.text) ?? 0.0,
        'dealer_price': double.tryParse(dealerPriceController.text) ?? 0.0,
        'manufacturer': manufacturerController.text.trim(),
        'image_url': imageUrlController.text.trim(),
        'created_at': Timestamp.now(),
      });

      _showSuccessSnackBar('Product saved successfully');
      _resetForm();
      Get.offNamed('/dashboard-seller');
    } catch (e) {
      _showErrorSnackBar('Failed to save product: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  void _showSuccessSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _resetForm() {
    _formKey.currentState!.reset();
    nameController.clear();
    brandController.clear();
    codeController.clear();
    stockController.clear();
    salePriceController.clear();
    discountController.clear();
    wholesalePriceController.clear();
    dealerPriceController.clear();
    manufacturerController.clear();
    imageUrlController.clear();
    setState(() {
      selectedCategory = null;
      selectedUnit = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_outlined),
          onPressed: () => Get.offNamed('/dashboard-seller'),
        ),
        title: const Text('Add Product'),
        backgroundColor: Colors.orange,
        centerTitle: true,
      ),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildTextField('Product Name*', nameController,
                        validator: _validateRequired),
                    _buildDropdown(
                      'Product Category*',
                      categories,
                      selectedCategory,
                      (value) => setState(() => selectedCategory = value),
                      validator: _validateRequired,
                    ),
                    _buildTextField('Brand', brandController),
                    _buildTextField('Product Code*', codeController,
                        validator: _validateRequired),
                    Row(
                      children: [
                        Expanded(
                          child: _buildTextField('Stock*', stockController,
                              keyboardType: TextInputType.number,
                              validator: _validateNumber),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: _buildDropdown(
                            'Unit*',
                            units,
                            selectedUnit,
                            (value) => setState(() => selectedUnit = value),
                            validator: _validateRequired,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: _buildTextField(
                            'Sale Price*',
                            salePriceController,
                            keyboardType: TextInputType.number,
                            validator: _validateNumber,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: _buildTextField(
                            'Discount*',
                            discountController,
                            keyboardType: TextInputType.number,
                            validator: _validateNumber,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: _buildTextField(
                            'Wholesale Price',
                            wholesalePriceController,
                            keyboardType: TextInputType.number,
                            validator: _validateOptionalNumber,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: _buildTextField(
                            'Dealer Price',
                            dealerPriceController,
                            keyboardType: TextInputType.number,
                            validator: _validateOptionalNumber,
                          ),
                        ),
                      ],
                    ),
                    _buildTextField('Manufacturer', manufacturerController),
                    _buildTextField('Image URL', imageUrlController,
                        validator: _validateOptionalUrl),
                    const SizedBox(height: 20),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _isLoading ? null : _saveProduct,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.orange,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: _isLoading
                            ? const SizedBox(
                                height: 24,
                                width: 24,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2,
                                ),
                              )
                            : const Text(
                                'Save & Publish',
                                style: TextStyle(fontSize: 16),
                              ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          if (_isLoading)
            Container(
              color: Colors.black26,
              child: const Center(
                child: CircularProgressIndicator(),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildTextField(
    String label,
    TextEditingController controller, {
    TextInputType? keyboardType,
    String? Function(String?)? validator,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
          focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.orange),
          ),
          labelStyle: const TextStyle(color: Colors.black),
          errorBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.red),
          ),
          focusedErrorBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.red),
          ),
        ),
        validator: validator,
      ),
    );
  }

  Widget _buildDropdown(
    String label,
    List<String> items,
    String? selected,
    Function(String?) onChanged, {
    String? Function(String?)? validator,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: DropdownButtonFormField<String>(
        value: selected,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
          focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.orange),
          ),
          labelStyle: const TextStyle(color: Colors.black),
          errorBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.red),
          ),
          focusedErrorBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.red),
          ),
        ),
        items: items.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
        onChanged: _isLoading ? null : onChanged,
        validator: validator,
      ),
    );
  }

  String? _validateRequired(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'This field is required';
    }
    return null;
  }

  String? _validateNumber(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'This field is required';
    }
    if (double.tryParse(value) == null || double.parse(value) < 0) {
      return 'Enter a valid number';
    }
    return null;
  }

  String? _validateOptionalNumber(String? value) {
    if (value == null || value.trim().isEmpty) {
      return null;
    }
    if (double.tryParse(value) == null || double.parse(value) < 0) {
      return 'Enter a valid number';
    }
    return null;
  }

  String? _validateOptionalUrl(String? value) {
    if (value == null || value.trim().isEmpty) {
      return null;
    }
    // Basic URL validation
    final urlPattern = RegExp(r'^https?://[^\s/$.?#].[^\s]*$');
    if (!urlPattern.hasMatch(value)) {
      return 'Enter a valid URL';
    }
    return null;
  }
}