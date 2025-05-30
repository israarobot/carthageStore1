import 'package:carthage_store/controllers/add_product_controller.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AddProductScreen extends StatelessWidget {
  const AddProductScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(AddProductController());

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_outlined),
          onPressed: () => Get.offNamed('/dashboard-seller'),
        ),
        title: const Text('Add Product'),
        backgroundColor: const Color(0xFF93441A),
        centerTitle: true,
      ),
      body: Obx(
        () => Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: controller.formKey,
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildTextField(
                        'Product Name*',
                        controller.nameController,
                        validator: controller.validateRequired,
                      ),
                      _buildDropdown(
                        'Product Category*',
                        controller.categories,
                        controller.selectedCategory,
                        (value) => controller.selectedCategory.value = value,
                        validator: controller.validateRequired,
                      ),
                      _buildTextField(
                        'Brand',
                        controller.brandController,
                      ),
                      _buildTextField(
                        'Product Code*',
                        controller.codeController,
                        validator: controller.validateRequired,
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: _buildTextField(
                              'Stock*',
                              controller.stockController,
                              keyboardType: TextInputType.number,
                              validator: controller.validateNumber,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: _buildDropdown(
                              'Unit*',
                              controller.units,
                              controller.selectedUnit,
                              (value) => controller.selectedUnit.value = value,
                              validator: controller.validateRequired,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: _buildTextField(
                              'Sale Price*',
                              controller.salePriceController,
                              keyboardType: TextInputType.number,
                              validator: controller.validateNumber,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: _buildTextField(
                              'Discount*',
                              controller.discountController,
                              keyboardType: TextInputType.number,
                              validator: controller.validateNumber,
                            ),
                          ),
                        ],
                      ),
                      _buildTextField(
                        'Description*',
                        controller.descriptionController,
                        maxLines: 4,
                        validator: controller.validateRequired,
                      ),
                      // Multiple Image URLs
                      const Text(
                        'Image URLs*',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      Obx(
                        () => Column(
                          children: [
                            for (int i = 0; i < controller.imageUrlControllers.length; i++)
                              Padding(
                                padding: const EdgeInsets.only(bottom: 8),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: _buildTextField(
                                        'Image URL ${i + 1}*',
                                        controller.imageUrlControllers[i],
                                        validator: controller.validateRequiredUrl,
                                      ),
                                    ),
                                    if (controller.imageUrlControllers.length > 1)
                                      IconButton(
                                        icon: const Icon(Icons.remove_circle, color: Colors.red),
                                        onPressed: () => controller.removeImageUrlField(i),
                                      ),
                                  ],
                                ),
                              ),
                            TextButton.icon(
                              onPressed: controller.addImageUrlField,
                              icon: const Icon(Icons.add_circle, color: Color(0xFF93441A)),
                              label: const Text('Add Another Image URL'),
                            ),
                          ],
                        ),
                      ),
                      // Video URL
                      _buildTextField(
                        'Video URL',
                        controller.videoUrlController,
                        validator: controller.validateOptionalUrl,
                      ),
                      const SizedBox(height: 20),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: controller.isLoading.value
                              ? null
                              : controller.saveProduct,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF93441A),
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: controller.isLoading.value
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
            if (controller.isLoading.value)
              Container(
                color: Colors.black26,
                child: const Center(
                  child: CircularProgressIndicator(),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(
    String label,
    TextEditingController controller, {
    TextInputType? keyboardType,
    String? Function(String?)? validator,
    int? maxLines,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        maxLines: maxLines ?? 1,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
          focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Color(0xFF93441A)),
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
    Rxn<String> selected,
    Function(String?) onChanged, {
    String? Function(String?)? validator,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: DropdownButtonFormField<String>(
        value: selected.value,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
          focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Color(0xFF93441A)),
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
        onChanged: Get.find<AddProductController>().isLoading.value ? null : onChanged,
        validator: validator,
      ),
    );
  }
}