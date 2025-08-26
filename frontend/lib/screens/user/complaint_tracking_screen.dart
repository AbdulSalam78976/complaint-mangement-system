import 'package:flutter/material.dart';
import 'package:frontend/resources/theme/colors.dart';
import 'package:frontend/screens/widgets/appbar.dart';

class ComplaintTrackingScreen extends StatefulWidget {
  const ComplaintTrackingScreen({super.key});

  @override
  State<ComplaintTrackingScreen> createState() =>
      _ComplaintTrackingScreenState();
}

class _ComplaintTrackingScreenState extends State<ComplaintTrackingScreen> {
  final TextEditingController _idController = TextEditingController();
  bool _hasResult = true; // mock toggle

  @override
  void dispose() {
    _idController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppPalette.backgroundColor,
      appBar: const CustomAppBar(
        title: 'Track Complaint',
        showBack: true,
        showLogo: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Enter Complaint ID',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppPalette.textColor,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _idController,
                    decoration: InputDecoration(
                      hintText: 'e.g., CMP-001234',
                      prefixIcon: const Icon(Icons.search),
                      filled: true,
                      fillColor: AppPalette.whiteColor,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: AppPalette.borderColor),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: AppPalette.borderColor),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(
                          color: AppPalette.primaryColor,
                          width: 2,
                        ),
                      ),
                    ),
                    onSubmitted: (_) => setState(() => _hasResult = true),
                  ),
                ),
                const SizedBox(width: 12),
                ElevatedButton.icon(
                  onPressed: () => setState(() => _hasResult = true),
                  icon: const Icon(Icons.play_arrow_rounded),
                  label: const Text('Track'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppPalette.primaryColor,
                    foregroundColor: AppPalette.whiteColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 18,
                      vertical: 14,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            Expanded(child: _hasResult ? _buildResult() : _buildEmpty()),
          ],
        ),
      ),
    );
  }

  Widget _buildEmpty() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.track_changes_outlined,
            size: 56,
            color: AppPalette.greyColor,
          ),
          const SizedBox(height: 12),
          Text(
            'Search a complaint to view its status',
            style: TextStyle(color: AppPalette.greyColor),
          ),
        ],
      ),
    );
  }

  Widget _buildResult() {
    return ListView(
      children: [
        // Summary card
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppPalette.whiteColor,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppPalette.borderColor, width: 1),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      'CMP-001234 • Network Issues in Department',
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        color: AppPalette.textColor,
                      ),
                    ),
                  ),
                  _StatusChip(text: 'IN PROGRESS', color: Colors.orange),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Icon(
                    Icons.apartment_outlined,
                    size: 16,
                    color: AppPalette.greyColor,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    'IT Department',
                    style: TextStyle(color: AppPalette.greyColor),
                  ),
                  const SizedBox(width: 12),
                  Icon(
                    Icons.flag_outlined,
                    size: 16,
                    color: AppPalette.greyColor,
                  ),
                  const SizedBox(width: 6),
                  Text('High', style: TextStyle(color: AppPalette.greyColor)),
                  const Spacer(),
                  Icon(
                    Icons.access_time,
                    size: 16,
                    color: AppPalette.greyColor,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    'Submitted 2 days ago',
                    style: TextStyle(color: AppPalette.greyColor, fontSize: 12),
                  ),
                ],
              ),
            ],
          ),
        ),

        const SizedBox(height: 16),

        // Timeline
        Text(
          'Timeline',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: AppPalette.textColor,
          ),
        ),
        const SizedBox(height: 8),
        _TimelineTile(
          icon: Icons.send_outlined,
          color: AppPalette.primaryColor,
          title: 'Complaint submitted',
          time: '2 days ago',
        ),
        _TimelineTile(
          icon: Icons.person_add_alt_1_outlined,
          color: AppPalette.secondaryColor,
          title: 'Assigned to John Smith',
          time: '1 day ago',
        ),
        _TimelineTile(
          icon: Icons.assignment_turned_in_outlined,
          color: Colors.orange,
          title: 'Status changed to IN PROGRESS',
          time: '2 hours ago',
        ),
      ],
    );
  }
}

class _StatusChip extends StatelessWidget {
  final String text;
  final Color color;
  const _StatusChip({required this.text, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: color,
          fontWeight: FontWeight.w800,
          fontSize: 12,
        ),
      ),
    );
  }
}

class _TimelineTile extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String title;
  final String time;
  const _TimelineTile({
    required this.icon,
    required this.color,
    required this.title,
    required this.time,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppPalette.whiteColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppPalette.borderColor, width: 1),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.12),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: color, size: 18),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: AppPalette.textColor,
                  ),
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    Icon(
                      Icons.access_time,
                      size: 14,
                      color: AppPalette.greyColor,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      time,
                      style: TextStyle(
                        fontSize: 12,
                        color: AppPalette.greyColor,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
