import 'package:flutter/material.dart';
import 'package:frontend/resources/theme/colors.dart';
import 'package:frontend/screens/resuable%20and%20common%20components/appbar.dart';

class AdminReports extends StatefulWidget {
  const AdminReports({super.key});

  @override
  State<AdminReports> createState() => _AdminReportsState();
}

class _AdminReportsState extends State<AdminReports> {
  String _selectedPeriod = 'Monthly';
  final List<String> _periods = ['Weekly', 'Monthly', 'Quarterly', 'Yearly'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppPalette.backgroundColor,
      appBar: const CustomAppBar(
        title: 'Reports & Analytics',
        isAdmin: true,
        showBack: true,
        showLogo: false,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildPeriodSelector(),
            const SizedBox(height: 24),
            _buildSummaryCards(),
            const SizedBox(height: 24),
            _buildComplaintTrendsChart(),
            const SizedBox(height: 24),
            _buildCategoryDistributionChart(),
            const SizedBox(height: 24),
            _buildResolutionTimeChart(),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppPalette.primaryColor,
        onPressed: () {
          _showExportDialog();
        },
        child: const Icon(Icons.download),
      ),
    );
  }

  Widget _buildPeriodSelector() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Report Period',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppPalette.textColor,
            ),
          ),
          const SizedBox(height: 16),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: _periods.map((period) {
                final isSelected = _selectedPeriod == period;
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: ChoiceChip(
                    selected: isSelected,
                    label: Text(period),
                    onSelected: (selected) {
                      setState(() {
                        _selectedPeriod = period;
                      });
                    },
                    backgroundColor: Colors.grey[200],
                    selectedColor: AppPalette.primaryColor.withOpacity(0.2),
                    labelStyle: TextStyle(
                      color: isSelected
                          ? AppPalette.primaryColor
                          : Colors.black87,
                      fontWeight: isSelected
                          ? FontWeight.bold
                          : FontWeight.normal,
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryCards() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Summary',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppPalette.textColor,
          ),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: _buildSummaryCard(
                title: 'Total Complaints',
                value: '124',
                icon: Icons.report_problem,
                color: AppPalette.primaryColor,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildSummaryCard(
                title: 'Resolved',
                value: '96',
                icon: Icons.check_circle,
                color: Colors.green,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: _buildSummaryCard(
                title: 'Pending',
                value: '28',
                icon: Icons.pending_actions,
                color: Colors.orange,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildSummaryCard(
                title: 'Avg. Resolution Time',
                value: '3.2 days',
                icon: Icons.timer,
                color: Colors.purple,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSummaryCard({
    required String title,
    required String value,
    required IconData icon,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 32),
          const SizedBox(height: 12),
          Text(
            value,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            title,
            style: TextStyle(color: Colors.grey[600], fontSize: 14),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildComplaintTrendsChart() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Complaint Trends',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppPalette.textColor,
            ),
          ),
          const SizedBox(height: 16),
          Container(
            height: 200,
            width: double.infinity,
            child: CustomPaint(painter: ChartPainter()),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildLegendItem('New', AppPalette.primaryColor),
              const SizedBox(width: 24),
              _buildLegendItem('Resolved', Colors.green),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryDistributionChart() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Complaint Categories',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppPalette.textColor,
            ),
          ),
          const SizedBox(height: 16),
          Container(
            height: 200,
            width: double.infinity,
            child: CustomPaint(painter: PieChartPainter()),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildLegendItem('Technical', Colors.blue),
              _buildLegendItem('Billing', Colors.orange),
              _buildLegendItem('Service', Colors.green),
              _buildLegendItem('Other', Colors.purple),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildResolutionTimeChart() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Average Resolution Time by Category',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppPalette.textColor,
            ),
          ),
          const SizedBox(height: 16),
          Container(
            height: 200,
            width: double.infinity,
            child: CustomPaint(painter: BarChartPainter()),
          ),
        ],
      ),
    );
  }

  Widget _buildLegendItem(String label, Color color) {
    return Row(
      children: [
        Container(
          width: 16,
          height: 16,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 8),
        Text(label, style: TextStyle(color: Colors.grey[700], fontSize: 14)),
      ],
    );
  }

  void _showExportDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Export Report'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Select export format:'),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildExportOption('PDF', Icons.picture_as_pdf, Colors.red),
                _buildExportOption('Excel', Icons.table_chart, Colors.green),
                _buildExportOption('CSV', Icons.insert_drive_file, Colors.blue),
              ],
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
  }

  Widget _buildExportOption(String format, IconData icon, Color color) {
    return InkWell(
      onTap: () {
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Exporting as $format...'),
            backgroundColor: color,
          ),
        );
      },
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color, size: 32),
          ),
          const SizedBox(height: 8),
          Text(
            format,
            style: TextStyle(color: color, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}

class ChartPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final width = size.width;
    final height = size.height;
    final paint = Paint()
      ..color = Colors.grey[300]!
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke;

    // Draw grid lines
    for (int i = 0; i <= 4; i++) {
      final y = height - (height / 4 * i);
      canvas.drawLine(Offset(0, y), Offset(width, y), paint);
    }

    // Draw new complaints line
    final newComplaintsPaint = Paint()
      ..color = AppPalette.primaryColor
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke;

    final newComplaintsPath = Path();
    final newPoints = [
      Offset(width * 0.1, height * 0.7),
      Offset(width * 0.25, height * 0.5),
      Offset(width * 0.4, height * 0.6),
      Offset(width * 0.55, height * 0.4),
      Offset(width * 0.7, height * 0.3),
      Offset(width * 0.85, height * 0.5),
    ];

    newComplaintsPath.moveTo(newPoints[0].dx, newPoints[0].dy);
    for (int i = 1; i < newPoints.length; i++) {
      newComplaintsPath.lineTo(newPoints[i].dx, newPoints[i].dy);
    }

    canvas.drawPath(newComplaintsPath, newComplaintsPaint);

    // Draw resolved complaints line
    final resolvedComplaintsPaint = Paint()
      ..color = Colors.green
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke;

    final resolvedComplaintsPath = Path();
    final resolvedPoints = [
      Offset(width * 0.1, height * 0.8),
      Offset(width * 0.25, height * 0.7),
      Offset(width * 0.4, height * 0.5),
      Offset(width * 0.55, height * 0.6),
      Offset(width * 0.7, height * 0.4),
      Offset(width * 0.85, height * 0.3),
    ];

    resolvedComplaintsPath.moveTo(resolvedPoints[0].dx, resolvedPoints[0].dy);
    for (int i = 1; i < resolvedPoints.length; i++) {
      resolvedComplaintsPath.lineTo(resolvedPoints[i].dx, resolvedPoints[i].dy);
    }

    canvas.drawPath(resolvedComplaintsPath, resolvedComplaintsPaint);

    // Draw points on the lines
    for (final point in newPoints) {
      canvas.drawCircle(point, 5, Paint()..color = AppPalette.primaryColor);
    }

    for (final point in resolvedPoints) {
      canvas.drawCircle(point, 5, Paint()..color = Colors.green);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}

class PieChartPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width < size.height
        ? size.width / 2 - 40
        : size.height / 2 - 40;

    final paint = Paint()..style = PaintingStyle.fill;

    // Draw pie segments
    double startAngle = 0;

    // Technical - 35%
    paint.color = Colors.blue;
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      startAngle,
      0.35 * 2 * 3.14159,
      true,
      paint,
    );
    startAngle += 0.35 * 2 * 3.14159;

    // Billing - 25%
    paint.color = Colors.orange;
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      startAngle,
      0.25 * 2 * 3.14159,
      true,
      paint,
    );
    startAngle += 0.25 * 2 * 3.14159;

    // Service - 30%
    paint.color = Colors.green;
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      startAngle,
      0.3 * 2 * 3.14159,
      true,
      paint,
    );
    startAngle += 0.3 * 2 * 3.14159;

    // Other - 10%
    paint.color = Colors.purple;
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      startAngle,
      0.1 * 2 * 3.14159,
      true,
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}

class BarChartPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final width = size.width;
    final height = size.height;
    final barWidth = width / 5;

    // Draw grid lines
    final gridPaint = Paint()
      ..color = Colors.grey[300]!
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke;

    for (int i = 0; i <= 4; i++) {
      final y = height - (height / 4 * i);
      canvas.drawLine(Offset(0, y), Offset(width, y), gridPaint);
    }

    // Draw bars
    final categories = ['Technical', 'Billing', 'Service', 'Other'];
    final values = [4.2, 2.8, 3.5, 1.9]; // Days
    final colors = [Colors.blue, Colors.orange, Colors.green, Colors.purple];

    for (int i = 0; i < categories.length; i++) {
      final barHeight = (values[i] / 5) * height; // Scale to fit
      final barPaint = Paint()
        ..color = colors[i]
        ..style = PaintingStyle.fill;

      final left = (i + 0.5) * barWidth - 20;
      final top = height - barHeight;
      final right = left + 40;
      final bottom = height;

      final rect = Rect.fromLTRB(left, top, right, bottom);
      canvas.drawRect(rect, barPaint);

      // Draw value text
      final textPainter = TextPainter(
        text: TextSpan(
          text: '${values[i]} days',
          style: TextStyle(
            color: Colors.white,
            fontSize: 10,
            fontWeight: FontWeight.bold,
          ),
        ),
        textDirection: TextDirection.ltr,
      );

      textPainter.layout();
      textPainter.paint(
        canvas,
        Offset(left + (right - left) / 2 - textPainter.width / 2, top + 10),
      );

      // Draw category text
      final categoryTextPainter = TextPainter(
        text: TextSpan(
          text: categories[i],
          style: TextStyle(color: Colors.grey[700], fontSize: 12),
        ),
        textDirection: TextDirection.ltr,
      );

      categoryTextPainter.layout();
      categoryTextPainter.paint(
        canvas,
        Offset(
          left + (right - left) / 2 - categoryTextPainter.width / 2,
          height + 5,
        ),
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
