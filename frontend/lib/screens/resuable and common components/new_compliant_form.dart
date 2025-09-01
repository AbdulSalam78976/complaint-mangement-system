import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:frontend/resources/theme/colors.dart';

class ComplaintFormController extends GetxController {
  final phoneController = TextEditingController();
  final emailController = TextEditingController();

  final phoneError = RxString('');
  final emailError = RxString('');

  void validatePhone(String value) {
    if (value.isEmpty) {
      phoneError.value = 'Phone number is required';
    } else if (!RegExp(r'^[0-9]{10,15}$').hasMatch(value)) {
      phoneError.value = 'Enter a valid phone number';
    } else {
      phoneError.value = '';
    }
  }

  void validateEmail(String value) {
    if (value.isEmpty) {
      emailError.value = 'Email is required';
    } else if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
      emailError.value = 'Enter a valid email address';
    } else {
      emailError.value = '';
    }
  }

  bool get isFormValid => phoneError.value.isEmpty && emailError.value.isEmpty;

  @override
  void onClose() {
    phoneController.dispose();
    emailController.dispose();
    super.onClose();
  }
}

void showComplaintDialog() {
  final formKey = GlobalKey<FormState>();
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  String selectedCategory = 'IT Department';
  String selectedPriority = 'Medium'; // Default priority
  bool isSubmitting = false;

  final complaintController = Get.put(ComplaintFormController());

  final categories = [
    {
      'value': 'IT Department',
      'icon': Icons.computer_outlined,
      'color': Colors.blue,
    },
    {
      'value': 'HR Department',
      'icon': Icons.people_outline,
      'color': Colors.purple,
    },
    {
      'value': 'Finance',
      'icon': Icons.account_balance_wallet_outlined,
      'color': Colors.green,
    },
    {
      'value': 'Facilities',
      'icon': Icons.business_outlined,
      'color': Colors.orange,
    },
    {'value': 'Security', 'icon': Icons.security_outlined, 'color': Colors.red},
    {'value': 'Other', 'icon': Icons.help_outline, 'color': Colors.grey},
  ];

  final priorities = [
    {
      'value': 'High',
      'icon': Icons.error_outline,
      'color': AppPalette.errorColor,
      'description': 'Critical issue requiring immediate attention',
    },
    {
      'value': 'Medium',
      'icon': Icons.warning_outlined,
      'color': AppPalette.accentColor,
      'description': 'Important issue that should be addressed soon',
    },
    {
      'value': 'Low',
      'icon': Icons.info_outline,
      'color': AppPalette.successColor,
      'description': 'Minor issue that can be addressed later',
    },
  ];

  Get.dialog(
    StatefulBuilder(
      builder: (context, setState) {
        return Dialog(
          backgroundColor: AppPalette.backgroundColor,
          insetPadding: const EdgeInsets.all(20),
          child: Container(
            constraints: const BoxConstraints(maxWidth: 500),
            decoration: BoxDecoration(
              color: AppPalette.whiteColor,
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: AppPalette.textColor.withOpacity(0.1),
                  blurRadius: 30,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Modern Header
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: AppPalette.whiteColor,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(24),
                      topRight: Radius.circular(24),
                    ),
                    border: Border(
                      bottom: BorderSide(color: Colors.grey.shade200, width: 1),
                    ),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.blue.shade50,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(Icons.report_problem_outlined, size: 28),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Submit New Complaint',
                              style: TextStyle(
                                color: AppPalette.textColor,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'We\'ll get back to you soon',
                              style: TextStyle(
                                color: AppPalette.greyColor,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        onPressed: () => Get.back(),
                        icon: Icon(Icons.close_rounded, size: 24),
                      ),
                    ],
                  ),
                ),

                // Form Content
                Flexible(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(24),
                    child: Form(
                      key: formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Title
                          Text(
                            'Complaint Title',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.grey.shade800,
                            ),
                          ),
                          const SizedBox(height: 8),
                          TextFormField(
                            controller: titleController,
                            decoration: InputDecoration(
                              hintText: 'Brief description of your issue',
                              prefixIcon: Icon(
                                Icons.title,
                                color: AppPalette.greyColor,
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(
                                  color: Colors.grey.shade300,
                                ),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(
                                  color: Colors.grey.shade300,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(
                                  color: Colors.blue.shade400,
                                  width: 2,
                                ),
                              ),
                              filled: true,
                              fillColor: AppPalette.greyColor.withOpacity(0.1),
                            ),
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return 'Please enter a title';
                              }
                              return null;
                            },
                          ),

                          const SizedBox(height: 24),

                          // Category
                          Text(
                            'Department',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.grey.shade800,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            decoration: BoxDecoration(
                              color: Colors.grey.shade50,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: Colors.grey.shade300),
                            ),
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton<String>(
                                value: selectedCategory,
                                isExpanded: true,
                                icon: Icon(
                                  Icons.arrow_drop_down_rounded,
                                  color: Colors.grey.shade600,
                                ),
                                items: categories.map((category) {
                                  final color = category['color'] as Color;
                                  return DropdownMenuItem(
                                    value: category['value'] as String,
                                    child: Row(
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.all(6),
                                          decoration: BoxDecoration(
                                            color: color.withOpacity(0.1),
                                            borderRadius: BorderRadius.circular(
                                              8,
                                            ),
                                          ),
                                          child: Icon(
                                            category['icon'] as IconData,
                                            color: color,
                                            size: 20,
                                          ),
                                        ),
                                        const SizedBox(width: 12),
                                        Text(
                                          category['value'] as String,
                                          style: TextStyle(
                                            color: Colors.grey.shade800,
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                }).toList(),
                                onChanged: (value) {
                                  setState(() {
                                    selectedCategory = value!;
                                  });
                                },
                              ),
                            ),
                          ),

                          const SizedBox(height: 24),

                          // Priority Selection
                          Text(
                            'Priority Level',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.grey.shade800,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'How urgent is this issue?',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey.shade600,
                            ),
                          ),
                          const SizedBox(height: 12),

                          // Priority Cards
                          Column(
                            children: priorities.map((priority) {
                              final isSelected =
                                  selectedPriority == priority['value'];
                              final color = priority['color'] as Color;
                              final description =
                                  priority['description'] as String;

                              return GestureDetector(
                                onTap: () {
                                  setState(() {
                                    selectedPriority =
                                        priority['value'] as String;
                                  });
                                },
                                child: Container(
                                  width: double.infinity,
                                  margin: const EdgeInsets.only(bottom: 12),
                                  padding: const EdgeInsets.all(16),
                                  decoration: BoxDecoration(
                                    color: isSelected
                                        ? color.withOpacity(0.1)
                                        : Colors.grey.shade50,
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(
                                      color: isSelected
                                          ? color
                                          : Colors.grey.shade300,
                                      width: isSelected ? 2 : 1,
                                    ),
                                  ),
                                  child: Row(
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.all(8),
                                        decoration: BoxDecoration(
                                          color: color.withOpacity(0.2),
                                          borderRadius: BorderRadius.circular(
                                            8,
                                          ),
                                        ),
                                        child: Icon(
                                          priority['icon'] as IconData,
                                          color: color,
                                          size: 20,
                                        ),
                                      ),
                                      const SizedBox(width: 12),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              priority['value'] as String,
                                              style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w600,
                                                color: color,
                                              ),
                                            ),
                                            const SizedBox(height: 4),
                                            Text(
                                              description,
                                              style: TextStyle(
                                                fontSize: 12,
                                                color: Colors.grey.shade600,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      if (isSelected)
                                        Icon(
                                          Icons.check_circle_rounded,
                                          color: color,
                                          size: 20,
                                        ),
                                    ],
                                  ),
                                ),
                              );
                            }).toList(),
                          ),

                          const SizedBox(height: 24),

                          // Contact Information Section
                          Text(
                            'Contact Information',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.grey.shade800,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'We\'ll use this to follow up with you',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey.shade600,
                            ),
                          ),
                          const SizedBox(height: 16),

                          // Phone Number
                          Text(
                            'Phone Number',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: Colors.grey.shade700,
                            ),
                          ),
                          const SizedBox(height: 4),
                          TextFormField(
                            controller: complaintController.phoneController,
                            keyboardType: TextInputType.phone,
                            decoration: InputDecoration(
                              hintText: 'Enter your phone number',
                              prefixIcon: Icon(
                                Icons.phone_rounded,
                                color: Colors.grey.shade500,
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(
                                  color: Colors.grey.shade300,
                                ),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(
                                  color: Colors.grey.shade300,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(
                                  color: Colors.blue.shade400,
                                  width: 2,
                                ),
                              ),
                              filled: true,
                              fillColor: Colors.grey.shade50,
                              errorText:
                                  complaintController
                                      .phoneError
                                      .value
                                      .isNotEmpty
                                  ? complaintController.phoneError.value
                                  : null,
                            ),
                            onChanged: complaintController.validatePhone,
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return 'Phone number is required';
                              }
                              if (!RegExp(r'^[0-9]{10,15}$').hasMatch(value)) {
                                return 'Enter a valid phone number';
                              }
                              return null;
                            },
                          ),

                          const SizedBox(height: 16),

                          // Email
                          Text(
                            'Email Address',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: Colors.grey.shade700,
                            ),
                          ),
                          const SizedBox(height: 4),
                          TextFormField(
                            controller: complaintController.emailController,
                            keyboardType: TextInputType.emailAddress,
                            decoration: InputDecoration(
                              hintText: 'Enter your email address',
                              prefixIcon: Icon(
                                Icons.email_rounded,
                                color: Colors.grey.shade500,
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(
                                  color: Colors.grey.shade300,
                                ),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(
                                  color: Colors.grey.shade300,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(
                                  color: Colors.blue.shade400,
                                  width: 2,
                                ),
                              ),
                              filled: true,
                              fillColor: Colors.grey.shade50,
                              errorText:
                                  complaintController
                                      .emailError
                                      .value
                                      .isNotEmpty
                                  ? complaintController.emailError.value
                                  : null,
                            ),
                            onChanged: complaintController.validateEmail,
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return 'Email is required';
                              }
                              if (!RegExp(
                                r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                              ).hasMatch(value)) {
                                return 'Enter a valid email address';
                              }
                              return null;
                            },
                          ),

                          const SizedBox(height: 24),

                          // Description
                          Text(
                            'Description',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.grey.shade800,
                            ),
                          ),
                          const SizedBox(height: 8),
                          TextFormField(
                            controller: descriptionController,
                            maxLines: 5,
                            decoration: InputDecoration(
                              hintText: 'Describe your issue in detail...',
                              alignLabelWithHint: true,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(
                                  color: Colors.grey.shade300,
                                ),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(
                                  color: Colors.grey.shade300,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(
                                  color: Colors.blue.shade400,
                                  width: 2,
                                ),
                              ),
                              filled: true,
                              fillColor: Colors.grey.shade50,
                            ),
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return 'Please provide a description';
                              }
                              return null;
                            },
                          ),

                          const SizedBox(height: 24),

                          // Attachment
                          GestureDetector(
                            onTap: () {
                              Get.snackbar(
                                'File Picker',
                                'File picker would open here',
                                snackPosition: SnackPosition.BOTTOM,
                                backgroundColor: Colors.blue.shade100,
                                colorText: Colors.blue.shade800,
                                margin: const EdgeInsets.all(16),
                                borderRadius: 12,
                              );
                            },
                            child: Container(
                              width: double.infinity,
                              padding: const EdgeInsets.all(20),
                              decoration: BoxDecoration(
                                color: Colors.grey.shade50,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: Colors.grey.shade300,
                                  style: BorderStyle.solid,
                                ),
                              ),
                              child: Column(
                                children: [
                                  Icon(
                                    Icons.attach_file_rounded,
                                    size: 36,
                                    color: Colors.grey.shade400,
                                  ),
                                  const SizedBox(height: 12),
                                  Text(
                                    'Add attachments (Optional)',
                                    style: TextStyle(
                                      color: Colors.grey.shade600,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    'Support images, documents, etc.',
                                    style: TextStyle(
                                      color: Colors.grey.shade500,
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                // Footer Buttons
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade50,
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(24),
                      bottomRight: Radius.circular(24),
                    ),
                    border: Border(
                      top: BorderSide(color: Colors.grey.shade200, width: 1),
                    ),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: isSubmitting ? null : () => Get.back(),
                          child: Text(
                            'Cancel',
                            style: TextStyle(
                              color: AppPalette.greyColor,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: isSubmitting
                              ? null
                              : () async {
                                  if (formKey.currentState!.validate() &&
                                      complaintController.isFormValid) {
                                    setState(() {
                                      isSubmitting = true;
                                    });

                                    // Collect all form data
                                    final complaintData = {
                                      'title': titleController.text,
                                      'department': selectedCategory,
                                      'priority': selectedPriority,
                                      'phone': complaintController
                                          .phoneController
                                          .text,
                                      'email': complaintController
                                          .emailController
                                          .text,
                                      'description': descriptionController.text,
                                      'timestamp': DateTime.now(),
                                    };

                                    print('Complaint Data: $complaintData');

                                    await Future.delayed(
                                      const Duration(seconds: 2),
                                    );

                                    setState(() {
                                      isSubmitting = false;
                                    });

                                    Get.back();
                                    Get.snackbar(
                                      'Success',
                                      'Complaint submitted successfully!',
                                      snackPosition: SnackPosition.BOTTOM,
                                      backgroundColor: Colors.green.shade100,
                                      colorText: Colors.green.shade800,
                                      margin: const EdgeInsets.all(16),
                                      borderRadius: 12,
                                      icon: Icon(
                                        Icons.check_circle,
                                        color: Colors.green.shade600,
                                      ),
                                    );
                                  }
                                },
                          child: isSubmitting
                              ? const SizedBox(
                                  height: 24,
                                  width: 24,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                      Colors.white,
                                    ),
                                  ),
                                )
                              : Text(
                                  'Submit',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
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
      },
    ),
  );
}
