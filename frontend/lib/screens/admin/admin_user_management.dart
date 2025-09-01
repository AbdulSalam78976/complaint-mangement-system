import 'package:flutter/material.dart';
import 'package:frontend/resources/theme/colors.dart';
import 'package:frontend/screens/resuable%20and%20common%20components/appbar.dart';

class AdminUserManagement extends StatefulWidget {
  const AdminUserManagement({super.key});

  @override
  State<AdminUserManagement> createState() => _AdminUserManagementState();
}

class _AdminUserManagementState extends State<AdminUserManagement> {
  String _selectedFilter = 'All Users';
  final List<String> _filters = [
    'All Users',
    'Active',
    'Inactive',
    'Admins',
    'Staff',
    'Customers',
  ];

  // Grid layout control
  bool _isGridView = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppPalette.backgroundColor,
      appBar: const CustomAppBar(
        title: 'User Management',
        isAdmin: true,
        showBack: true,
        showLogo: false,
      ),
      body: Column(
        children: [
          _buildFilterSection(),
          Expanded(child: _isGridView ? _buildUserGrid() : _buildUserList()),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppPalette.primaryColor,
        onPressed: () {
          _showAddUserDialog();
        },
        child: const Icon(Icons.person_add, color: Colors.white),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
    );
  }

  Widget _buildFilterSection() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 24),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(20),
          bottomRight: Radius.circular(20),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Spacer(),
              Row(
                children: [
                  _buildIconButton(
                    icon: Icons.search,
                    onPressed: () {
                      // Show search dialog
                    },
                  ),
                  const SizedBox(width: 8),
                  _buildIconButton(
                    icon: Icons.filter_list,
                    onPressed: () {
                      // Show advanced filter options
                    },
                  ),
                  const SizedBox(width: 8),
                  _buildIconButton(
                    icon: _isGridView ? Icons.list : Icons.grid_view,
                    onPressed: () {
                      setState(() {
                        _isGridView = !_isGridView;
                      });
                    },
                  ),
                ],
              ),
            ],
          ),

          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                // Grid layout controls
                if (_isGridView) ...[const SizedBox(width: 12)],
                // Filter buttons
                ..._filters.map((filter) {
                  final isSelected = _selectedFilter == filter;
                  return Container(
                    margin: const EdgeInsets.only(right: 8),
                    child: ElevatedButton(
                      onPressed: () {
                        setState(() {
                          _selectedFilter = filter;
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: isSelected
                            ? AppPalette.primaryColor
                            : Colors.white,
                        foregroundColor: isSelected
                            ? Colors.white
                            : AppPalette.textColor,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                          side: BorderSide(
                            color: isSelected
                                ? AppPalette.primaryColor
                                : Colors.grey[300]!,
                            width: 1,
                          ),
                        ),
                        elevation: 0,
                        shadowColor: Colors.transparent,
                      ),
                      child: Text(
                        filter,
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildIconButton({
    required IconData icon,
    required VoidCallback onPressed,
  }) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: AppPalette.backgroundColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: IconButton(
        icon: Icon(icon, size: 20, color: AppPalette.textColor),
        onPressed: onPressed,
        padding: EdgeInsets.zero,
      ),
    );
  }

  Widget _buildUserGrid() {
    // Sample user data
    final users = [
      {
        'id': 'USR-1001',
        'name': 'John Doe',
        'email': 'john.doe@example.com',
        'role': 'Admin',
        'status': 'Active',
        'joinDate': '2023-01-15',
        'lastLogin': '2023-06-15 09:30 AM',
        'avatar':
            'https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?auto=format&fit=crop&w=400&q=80',
      },
      {
        'id': 'USR-1002',
        'name': 'Jane Smith',
        'email': 'jane.smith@example.com',
        'role': 'Staff',
        'status': 'Active',
        'joinDate': '2023-02-20',
        'lastLogin': '2023-06-14 02:45 PM',
        'avatar':
            'https://images.unsplash.com/photo-1494790108755-2616b612b786?auto=format&fit=crop&w=400&q=80',
      },
      {
        'id': 'USR-1003',
        'name': 'Robert Johnson',
        'email': 'robert.johnson@example.com',
        'role': 'Customer',
        'status': 'Inactive',
        'joinDate': '2023-03-10',
        'lastLogin': '2023-05-22 11:15 AM',
        'avatar':
            'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?auto=format&fit=crop&w=400&q=80',
      },
      {
        'id': 'USR-1004',
        'name': 'Emily Davis',
        'email': 'emily.davis@example.com',
        'role': 'Staff',
        'status': 'Active',
        'joinDate': '2023-04-05',
        'lastLogin': '2023-06-15 10:20 AM',
        'avatar':
            'https://images.unsplash.com/photo-1438761681033-6461ffad8d80?auto=format&fit=crop&w=400&q=80',
      },
      {
        'id': 'USR-1005',
        'name': 'Michael Wilson',
        'email': 'michael.wilson@example.com',
        'role': 'Customer',
        'status': 'Active',
        'joinDate': '2023-05-12',
        'lastLogin': '2023-06-13 04:10 PM',
        'avatar':
            'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?auto=format&fit=crop&w=400&q=80',
      },
    ];

    // Filter users based on selected filter
    List<Map<String, String>> filteredUsers;

    if (_selectedFilter == 'All Users') {
      filteredUsers = users;
    } else if (_selectedFilter == 'Active' || _selectedFilter == 'Inactive') {
      filteredUsers = users
          .where((u) => u['status'] == _selectedFilter)
          .toList();
    } else {
      // Filter by role (Admins, Staff, Customers)
      filteredUsers = users
          .where(
            (u) =>
                u['role'] ==
                _selectedFilter.substring(0, _selectedFilter.length - 1),
          )
          .toList();
    }

    return filteredUsers.isEmpty
        ? Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.people_outline, size: 80, color: Colors.grey[300]),
                const SizedBox(height: 16),
                Text(
                  'No users found',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.grey[500],
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Try adjusting your filters or add a new user',
                  style: TextStyle(fontSize: 14, color: Colors.grey[400]),
                ),
              ],
            ),
          )
        : GridView.builder(
            padding: const EdgeInsets.all(16),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: 1.5, // Adjusted for grid cards
            ),
            itemCount: filteredUsers.length,
            itemBuilder: (context, index) {
              final user = filteredUsers[index];
              return _buildUserGridCard(user);
            },
          );
  }

  Widget _buildUserGridCard(Map<String, String> user) {
    Color roleColor;
    IconData roleIcon;

    switch (user['role']) {
      case 'Admin':
        roleColor = Colors.purple;
        roleIcon = Icons.admin_panel_settings;
        break;
      case 'Staff':
        roleColor = Colors.blue;
        roleIcon = Icons.support_agent;
        break;
      case 'Customer':
        roleColor = Colors.green;
        roleIcon = Icons.person;
        break;
      default:
        roleColor = Colors.grey;
        roleIcon = Icons.person_outline;
    }

    final isActive = user['status'] == 'Active';

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          _showUserDetailsDialog(user);
        },
        borderRadius: BorderRadius.circular(16),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,

                  children: [
                    // Avatar with status indicator
                    Stack(
                      alignment: Alignment.bottomRight,
                      children: [
                        CircleAvatar(
                          radius: 40,
                          backgroundImage: NetworkImage(user['avatar']!),
                          backgroundColor: roleColor.withOpacity(0.1),
                          child: user['avatar']!.isEmpty
                              ? Icon(roleIcon, color: roleColor, size: 30)
                              : null,
                        ),
                        // Status indicator
                        Container(
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 4,
                                offset: const Offset(0, 1),
                              ),
                            ],
                          ),
                          child: Icon(
                            isActive ? Icons.check_circle : Icons.cancel,
                            size: 16,
                            color: isActive ? Colors.green : Colors.red,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    // User name
                    Text(
                      user['name']!,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                      textAlign: TextAlign.center,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    // User email
                    Text(
                      user['email']!,
                      style: TextStyle(color: Colors.grey[600], fontSize: 12),
                      textAlign: TextAlign.center,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 12),
                    // Role badge
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: roleColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(roleIcon, size: 14, color: roleColor),
                          const SizedBox(width: 4),
                          Text(
                            user['role']!,
                            style: TextStyle(
                              color: roleColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 8),
                    // Join date
                    Text(
                      'Joined ${user['joinDate']!}',
                      style: TextStyle(color: Colors.grey[500], fontSize: 10),
                    ),
                  ],
                ),
              ),
              // More options button
              Positioned(
                top: 8,
                right: 8,
                child: PopupMenuButton(
                  icon: Icon(
                    Icons.more_vert,
                    size: 20,
                    color: Colors.grey[600],
                  ),
                  itemBuilder: (context) => [
                    PopupMenuItem(
                      value: 'edit',
                      child: Row(
                        children: [
                          Icon(Icons.edit, size: 18, color: Colors.blue),
                          const SizedBox(width: 8),
                          const Text('Edit'),
                        ],
                      ),
                    ),
                    PopupMenuItem(
                      value: isActive ? 'deactivate' : 'activate',
                      child: Row(
                        children: [
                          Icon(
                            isActive ? Icons.block : Icons.check_circle,
                            size: 18,
                            color: isActive ? Colors.orange : Colors.green,
                          ),
                          const SizedBox(width: 8),
                          Text(isActive ? 'Deactivate' : 'Activate'),
                        ],
                      ),
                    ),
                    PopupMenuItem(
                      value: 'reset_password',
                      child: Row(
                        children: [
                          Icon(
                            Icons.lock_reset,
                            size: 18,
                            color: Colors.purple,
                          ),
                          const SizedBox(width: 8),
                          const Text('Reset Password'),
                        ],
                      ),
                    ),
                    PopupMenuItem(
                      value: 'delete',
                      child: Row(
                        children: [
                          Icon(Icons.delete, size: 18, color: Colors.red),
                          const SizedBox(width: 8),
                          const Text(
                            'Delete',
                            style: TextStyle(color: Colors.red),
                          ),
                        ],
                      ),
                    ),
                  ],
                  onSelected: (value) {
                    switch (value) {
                      case 'edit':
                        _showEditUserDialog(user);
                        break;
                      case 'activate':
                      case 'deactivate':
                        _toggleUserStatus(user);
                        break;
                      case 'reset_password':
                        _showResetPasswordDialog(user);
                        break;
                      case 'delete':
                        _showDeleteUserDialog(user);
                        break;
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Keep the original list view implementation
  Widget _buildUserList() {
    // Sample user data
    final users = [
      {
        'id': 'USR-1001',
        'name': 'John Doe',
        'email': 'john.doe@example.com',
        'role': 'Admin',
        'status': 'Active',
        'joinDate': '2023-01-15',
        'lastLogin': '2023-06-15 09:30 AM',
        'avatar':
            'https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?auto=format&fit=crop&w=400&q=80',
      },
      {
        'id': 'USR-1002',
        'name': 'Jane Smith',
        'email': 'jane.smith@example.com',
        'role': 'Staff',
        'status': 'Active',
        'joinDate': '2023-02-20',
        'lastLogin': '2023-06-14 02:45 PM',
        'avatar':
            'https://images.unsplash.com/photo-1494790108755-2616b612b786?auto=format&fit=crop&w=400&q=80',
      },
      {
        'id': 'USR-1003',
        'name': 'Robert Johnson',
        'email': 'robert.johnson@example.com',
        'role': 'Customer',
        'status': 'Inactive',
        'joinDate': '2023-03-10',
        'lastLogin': '2023-05-22 11:15 AM',
        'avatar':
            'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?auto=format&fit=crop&w=400&q=80',
      },
      {
        'id': 'USR-1004',
        'name': 'Emily Davis',
        'email': 'emily.davis@example.com',
        'role': 'Staff',
        'status': 'Active',
        'joinDate': '2023-04-05',
        'lastLogin': '2023-06-15 10:20 AM',
        'avatar':
            'https://images.unsplash.com/photo-1438761681033-6461ffad8d80?auto=format&fit=crop&w=400&q=80',
      },
      {
        'id': 'USR-1005',
        'name': 'Michael Wilson',
        'email': 'michael.wilson@example.com',
        'role': 'Customer',
        'status': 'Active',
        'joinDate': '2023-05-12',
        'lastLogin': '2023-06-13 04:10 PM',
        'avatar':
            'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?auto=format&fit=crop&w=400&q=80',
      },
    ];

    // Filter users based on selected filter
    List<Map<String, String>> filteredUsers;

    if (_selectedFilter == 'All Users') {
      filteredUsers = users;
    } else if (_selectedFilter == 'Active' || _selectedFilter == 'Inactive') {
      filteredUsers = users
          .where((u) => u['status'] == _selectedFilter)
          .toList();
    } else {
      // Filter by role (Admins, Staff, Customers)
      filteredUsers = users
          .where(
            (u) =>
                u['role'] ==
                _selectedFilter.substring(0, _selectedFilter.length - 1),
          )
          .toList();
    }

    return filteredUsers.isEmpty
        ? Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.people_outline, size: 80, color: Colors.grey[300]),
                const SizedBox(height: 16),
                Text(
                  'No users found',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.grey[500],
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Try adjusting your filters or add a new user',
                  style: TextStyle(fontSize: 14, color: Colors.grey[400]),
                ),
              ],
            ),
          )
        : ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: filteredUsers.length,
            itemBuilder: (context, index) {
              final user = filteredUsers[index];
              return _buildUserCard(user);
            },
          );
  }

  // Keep the original user card implementation for list view
  Widget _buildUserCard(Map<String, String> user) {
    Color roleColor;
    IconData roleIcon;

    switch (user['role']) {
      case 'Admin':
        roleColor = Colors.purple;
        roleIcon = Icons.admin_panel_settings;
        break;
      case 'Staff':
        roleColor = Colors.blue;
        roleIcon = Icons.support_agent;
        break;
      case 'Customer':
        roleColor = Colors.green;
        roleIcon = Icons.person;
        break;
      default:
        roleColor = Colors.grey;
        roleIcon = Icons.person_outline;
    }

    final isActive = user['status'] == 'Active';

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            _showUserDetailsDialog(user);
          },
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 24,
                  backgroundImage: NetworkImage(user['avatar']!),
                  backgroundColor: roleColor.withOpacity(0.1),
                  child: user['avatar']!.isEmpty
                      ? Icon(roleIcon, color: roleColor, size: 20)
                      : null,
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            user['name']!,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: isActive
                                  ? Colors.green.withOpacity(0.1)
                                  : Colors.red.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  isActive ? Icons.check_circle : Icons.cancel,
                                  size: 14,
                                  color: isActive ? Colors.green : Colors.red,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  user['status']!,
                                  style: TextStyle(
                                    color: isActive ? Colors.green : Colors.red,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        user['email']!,
                        style: TextStyle(color: Colors.grey[600], fontSize: 14),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: roleColor.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              children: [
                                Icon(roleIcon, size: 14, color: roleColor),
                                const SizedBox(width: 4),
                                Text(
                                  user['role']!,
                                  style: TextStyle(
                                    color: roleColor,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 8),
                          Icon(
                            Icons.calendar_today,
                            size: 14,
                            color: Colors.grey[500],
                          ),
                          const SizedBox(width: 4),
                          Text(
                            'Joined ${user['joinDate']!}',
                            style: TextStyle(
                              color: Colors.grey[500],
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                PopupMenuButton(
                  icon: Icon(Icons.more_vert, color: Colors.grey[600]),
                  itemBuilder: (context) => [
                    PopupMenuItem(
                      value: 'edit',
                      child: Row(
                        children: [
                          Icon(Icons.edit, size: 18, color: Colors.blue),
                          const SizedBox(width: 8),
                          const Text('Edit'),
                        ],
                      ),
                    ),
                    PopupMenuItem(
                      value: isActive ? 'deactivate' : 'activate',
                      child: Row(
                        children: [
                          Icon(
                            isActive ? Icons.block : Icons.check_circle,
                            size: 18,
                            color: isActive ? Colors.orange : Colors.green,
                          ),
                          const SizedBox(width: 8),
                          Text(isActive ? 'Deactivate' : 'Activate'),
                        ],
                      ),
                    ),
                    PopupMenuItem(
                      value: 'reset_password',
                      child: Row(
                        children: [
                          Icon(
                            Icons.lock_reset,
                            size: 18,
                            color: Colors.purple,
                          ),
                          const SizedBox(width: 8),
                          const Text('Reset Password'),
                        ],
                      ),
                    ),
                    PopupMenuItem(
                      value: 'delete',
                      child: Row(
                        children: [
                          Icon(Icons.delete, size: 18, color: Colors.red),
                          const SizedBox(width: 8),
                          const Text(
                            'Delete',
                            style: TextStyle(color: Colors.red),
                          ),
                        ],
                      ),
                    ),
                  ],
                  onSelected: (value) {
                    switch (value) {
                      case 'edit':
                        _showEditUserDialog(user);
                        break;
                      case 'activate':
                      case 'deactivate':
                        _toggleUserStatus(user);
                        break;
                      case 'reset_password':
                        _showResetPasswordDialog(user);
                        break;
                      case 'delete':
                        _showDeleteUserDialog(user);
                        break;
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Keep all the dialog methods unchanged

  void _showUserDetailsDialog(Map<String, String> user) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Container(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundImage: NetworkImage(user['avatar']!),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          user['name']!,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          user['email']!,
                          style: TextStyle(color: Colors.grey[600]),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              _buildDetailItem('User ID', user['id']!),
              _buildDetailItem('Role', user['role']!),
              _buildDetailItem('Status', user['status']!),
              _buildDetailItem('Join Date', user['joinDate']!),
              _buildDetailItem('Last Login', user['lastLogin']!),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text('Close'),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      _showEditUserDialog(user);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppPalette.primaryColor,
                    ),
                    child: const Text('Edit User'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailItem(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }

  void _showAddUserDialog() {
    final formKey = GlobalKey<FormState>();
    String name = '';
    String email = '';
    String role = 'Customer';

    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Container(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Add New User',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 24),
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Name',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    prefixIcon: const Icon(Icons.person),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a name';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    name = value!;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Email',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    prefixIcon: const Icon(Icons.email),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter an email';
                    }
                    if (!value.contains('@')) {
                      return 'Please enter a valid email';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    email = value!;
                  },
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  decoration: InputDecoration(
                    labelText: 'Role',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    prefixIcon: const Icon(Icons.work),
                  ),
                  value: role,
                  items: const [
                    DropdownMenuItem(value: 'Admin', child: Text('Admin')),
                    DropdownMenuItem(value: 'Staff', child: Text('Staff')),
                    DropdownMenuItem(
                      value: 'Customer',
                      child: Text('Customer'),
                    ),
                  ],
                  onChanged: (value) {
                    role = value!;
                  },
                ),
                const SizedBox(height: 16),
                Text(
                  'A temporary password will be generated and sent to the user\'s email.',
                  style: TextStyle(color: Colors.grey[600], fontSize: 12),
                ),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: const Text('Cancel'),
                    ),
                    const SizedBox(width: 8),
                    ElevatedButton(
                      onPressed: () {
                        if (formKey.currentState!.validate()) {
                          formKey.currentState!.save();
                          Navigator.of(context).pop();
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: const Text('User added successfully'),
                              backgroundColor: AppPalette.primaryColor,
                              behavior: SnackBarBehavior.floating,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppPalette.primaryColor,
                      ),
                      child: const Text('Add User'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showEditUserDialog(Map<String, String> user) {
    final formKey = GlobalKey<FormState>();
    String name = user['name']!;
    String email = user['email']!;
    String role = user['role']!;

    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Container(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Edit User: ${user['name']}',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 24),
                TextFormField(
                  initialValue: name,
                  decoration: InputDecoration(
                    labelText: 'Name',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    prefixIcon: const Icon(Icons.person),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a name';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    name = value!;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  initialValue: email,
                  decoration: InputDecoration(
                    labelText: 'Email',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    prefixIcon: const Icon(Icons.email),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter an email';
                    }
                    if (!value.contains('@')) {
                      return 'Please enter a valid email';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    email = value!;
                  },
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  decoration: InputDecoration(
                    labelText: 'Role',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    prefixIcon: const Icon(Icons.work),
                  ),
                  value: role,
                  items: const [
                    DropdownMenuItem(value: 'Admin', child: Text('Admin')),
                    DropdownMenuItem(value: 'Staff', child: Text('Staff')),
                    DropdownMenuItem(
                      value: 'Customer',
                      child: Text('Customer'),
                    ),
                  ],
                  onChanged: (value) {
                    role = value!;
                  },
                ),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: const Text('Cancel'),
                    ),
                    const SizedBox(width: 8),
                    ElevatedButton(
                      onPressed: () {
                        if (formKey.currentState!.validate()) {
                          formKey.currentState!.save();
                          Navigator.of(context).pop();
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('User updated successfully'),
                              backgroundColor: Colors.green,
                            ),
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppPalette.primaryColor,
                      ),
                      child: const Text('Save Changes'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _toggleUserStatus(Map<String, String> user) {
    final isActive = user['status'] == 'Active';
    final newStatus = isActive ? 'Inactive' : 'Active';

    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Container(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                isActive ? Icons.block : Icons.check_circle,
                size: 48,
                color: isActive ? Colors.orange : Colors.green,
              ),
              const SizedBox(height: 16),
              Text(
                '${isActive ? 'Deactivate' : 'Activate'} User',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Are you sure you want to ${isActive ? 'deactivate' : 'activate'} ${user['name']}?',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey[600]),
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text('Cancel'),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            'User ${isActive ? 'deactivated' : 'activated'} successfully',
                          ),
                          backgroundColor: isActive
                              ? Colors.orange
                              : Colors.green,
                          behavior: SnackBarBehavior.floating,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isActive ? Colors.orange : Colors.green,
                    ),
                    child: Text(isActive ? 'Deactivate' : 'Activate'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showResetPasswordDialog(Map<String, String> user) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Container(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.lock_reset, size: 48, color: AppPalette.primaryColor),
              const SizedBox(height: 16),
              const Text(
                'Reset Password',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              Text(
                'Are you sure you want to reset the password for ${user['name']}? A temporary password will be sent to their email.',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey[600]),
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text('Cancel'),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            'Password reset email sent successfully',
                          ),
                          backgroundColor: Colors.green,
                          behavior: SnackBarBehavior.floating,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppPalette.primaryColor,
                    ),
                    child: const Text('Reset Password'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showDeleteUserDialog(Map<String, String> user) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Container(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.delete, size: 48, color: Colors.red),
              const SizedBox(height: 16),
              const Text(
                'Delete User',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              Text(
                'Are you sure you want to delete ${user['name']}? This action cannot be undone.',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey[600]),
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text('Cancel'),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('User deleted successfully'),
                          backgroundColor: Colors.red,
                          behavior: SnackBarBehavior.floating,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                    ),
                    child: const Text('Delete'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
