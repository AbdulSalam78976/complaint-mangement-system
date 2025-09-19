import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:frontend/data/api_service.dart';
import 'package:frontend/models/user_model.dart';

class AdminController extends GetxController {
  final api = ApiService();

  // All users
  final users = <UserModel>[].obs;

  // Loading states
  final isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchUsers();
  }

  // Fetch all users
  Future<void> fetchUsers() async {
    try {
      isLoading.value = true;
      final response = await api.get('/admin/users');
      if (response.isSuccess) {
        users.value = (response.data['users'] as List)
            .map((u) => UserModel.fromJson(u))
            .toList();
      } else {
        debugPrint('Failed to fetch users: ${response.errorMessage}');
      }
    } catch (e) {
      debugPrint('Error fetching users: $e');
    } finally {
      isLoading.value = false;
    }
  }

  // Refresh users
  Future<void> refreshUsers() async {
    await fetchUsers();
  }

  // Get user status text
  String getUserStatus(UserModel user) {
    if (user.active && user.verified) {
      return 'Active';
    } else if (user.verified && !user.active) {
      return 'Inactive';
    } else {
      return 'Unverified';
    }
  }

  // Get user status color
  Color getUserStatusColor(UserModel user) {
    if (user.active && user.verified) {
      return Colors.green;
    } else if (user.verified && !user.active) {
      return Colors.orange;
    } else {
      return Colors.red;
    }
  }

  // Get user role display text
  String getUserRoleDisplay(UserModel user) {
    return user.role.toUpperCase();
  }
}
