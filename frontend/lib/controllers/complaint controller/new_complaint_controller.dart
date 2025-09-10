import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:frontend/data/api_service.dart';
import 'package:frontend/utils/utils.dart';
import 'package:frontend/resources/theme/colors.dart';

class AddNewComplaintController extends GetxController {
  // Form key
  final formKey = GlobalKey<FormState>();

  // Text Controllers
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  final phoneController = TextEditingController();
  final emailController = TextEditingController();

  // Errors
  final phoneError = ''.obs;
  final emailError = ''.obs;

  // Dropdown & Priority
  final selectedCategory = 'IT Department'.obs;
  final selectedPriority = 'Medium'.obs;

  // Submission state
  final isSubmitting = false.obs;

  // Attachments
  final attachments = <PlatformFile>[].obs;

  // Categories & Priorities
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

  // Validators
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

  // File Picker
  Future<void> pickFiles() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      allowMultiple: true,
      type: FileType.any,
    );

    if (result != null) {
      attachments.addAll(result.files);
    }
  }

  // Remove file from attachments
  void removeFile(PlatformFile file) {
    attachments.remove(file);
  }

  bool get isFormValid => phoneError.value.isEmpty && emailError.value.isEmpty;

  Future<void> submitComplaint() async {
    if (formKey.currentState!.validate() && isFormValid) {
      final api = ApiService();
      final fields = {
        'title': titleController.text,
        'description': descriptionController.text,
        'phone': phoneController.text,
        'email': emailController.text,
        'category': selectedCategory.value,
        'priority': selectedPriority.value,
      };

      try {
        isSubmitting.value = true;

        // Convert PlatformFile to File objects for upload
        List<File> filesToUpload = [];
        List<String> fileNames = [];

        for (var attachment in attachments) {
          if (attachment.path != null) {
            filesToUpload.add(File(attachment.path!));
            fileNames.add(attachment.name);
          }
        }

        // Check if we have too many files
        if (filesToUpload.length > 5) {
          Utils.snackBar(
            title: 'Error',
            message: 'Maximum 5 attachments allowed',
          );
          isSubmitting.value = false;
          return;
        }

        final result = await api.upload(
          '/complaints/create',
          fields,
          files: filesToUpload,
          fileNames: fileNames,
          fileField: 'attachments', // Explicitly set the field name
        );

        if (result.isSuccess) {
          Get.back();
          Get.delete<AddNewComplaintController>();

          isSubmitting.value = false;
          Utils.snackBar(
            title: 'Success',
            message:
                "Complaint submitted successfully. We'll get back to you soon",
          );
        } else {
          isSubmitting.value = false;
          Utils.snackBar(
            title: 'Error',
            message: result.errorMessage ?? "Failed to submit complaint",
          );
        }
      } catch (e) {
        Get.back();
        Utils.snackBar(
          title: 'Error',
          message: "Failed to submit complaint: ${e.toString()}",
        );
        isSubmitting.value = false;
      }
    }
  }

  @override
  void onClose() {
    titleController.dispose();
    descriptionController.dispose();
    phoneController.dispose();
    emailController.dispose();
    super.onClose();
  }
}
