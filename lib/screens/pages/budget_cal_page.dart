import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';

class BudgetCalculatorScreen extends StatefulWidget {
  @override
  _BudgetCalculatorScreenState createState() => _BudgetCalculatorScreenState();
}

class _BudgetCalculatorScreenState extends State<BudgetCalculatorScreen> with TickerProviderStateMixin {
  final TextEditingController _budgetController = TextEditingController();
  double totalBudget = 0;
  late AnimationController _animationController;

  Map<String, BudgetCategory> budgetCategories = {
    'Venue': BudgetCategory('Venue', 40, Icons.location_city, Colors.purple),
    'Catering': BudgetCategory('Catering', 25, Icons.restaurant, Colors.orange),
    'Photography': BudgetCategory('Photography', 15, Icons.camera_alt, Colors.blue),
    'Decoration': BudgetCategory('Decoration', 10, Icons.palette, Colors.green),
    'Miscellaneous': BudgetCategory('Miscellaneous', 10, Icons.more_horiz, Colors.grey),
  };

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: Duration(milliseconds: 1500),
      vsync: this,
    );
  }

  @override
  void dispose() {
    _budgetController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  void _calculateBudget() {
    setState(() {
      totalBudget = double.tryParse(_budgetController.text.replaceAll(',', '')) ?? 0;
    });
    if (totalBudget > 0) {
      _animationController.forward();
    }
  }

  void _updateCategoryPercentage(String category, double percentage) {
    setState(() {
      double totalOther = budgetCategories.entries
          .where((entry) => entry.key != category)
          .fold(0.0, (sum, entry) => sum + entry.value.percentage);

      if (totalOther + percentage <= 100) {
        budgetCategories[category]!.percentage = percentage;
      }
    });
  }

  double get totalPercentage {
    return budgetCategories.values.fold(0.0, (sum, category) => sum + category.percentage);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Budget Calculator',style: TextStyle(color: Color(0xFFE91E63)),),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Budget Input Card
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              child: Padding(
                padding: EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '💰 Total Wedding Budget',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey[800],
                      ),
                    ),
                    SizedBox(height: 16),
                    TextField(
                      controller: _budgetController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: 'Enter total budget (₹)',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: Colors.pink.shade400),
                        ),
                        prefixIcon: Icon(Icons.currency_rupee, color: Colors.pink.shade400),
                        hintText: 'e.g., 500000',
                      ),
                      onChanged: (value) {
                        // Auto-calculate on change
                        if (value.isNotEmpty) {
                          _calculateBudget();
                        }
                      },
                      onSubmitted: (val) => _calculateBudget(),
                    ),
                    SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: _calculateBudget,
                        icon: Icon(Icons.calculate),
                        label: Text('Calculate Budget'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.pink.shade400,
                          foregroundColor: Colors.white,
                          padding: EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            SizedBox(height: 20),

            if (totalBudget > 0) ...[
              // Budget Overview Card
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                child: Container(
                  padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    gradient: LinearGradient(
                      colors: [Colors.pink.shade50, Colors.pink.shade100],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                  child: Column(
                    children: [
                      Text(
                        'Budget Overview',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.pink.shade800,
                        ),
                      ),
                      SizedBox(height: 16),
                      CircularPercentIndicator(
                        radius: 80.0,
                        lineWidth: 10.0,
                        animation: true,
                        animationDuration: 1200,
                        percent: totalPercentage / 100,
                        center: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              '₹${_formatCurrency(totalBudget)}',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: Colors.pink.shade800,
                              ),
                            ),
                            Text(
                              'Total Budget',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.pink.shade600,
                              ),
                            ),
                          ],
                        ),
                        circularStrokeCap: CircularStrokeCap.round,
                        progressColor: Colors.pink.shade400,
                        backgroundColor: Colors.pink.shade200,
                      ),
                      SizedBox(height: 16),
                      Text(
                        '${totalPercentage.toInt()}% Allocated',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.pink.shade700,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              SizedBox(height: 20),

              // Budget Breakdown
              Text(
                '📊 Budget Breakdown',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[800],
                ),
              ),
              SizedBox(height: 16),

              ...budgetCategories.entries.map((entry) {
                return _buildCategoryCard(entry.key, entry.value);
              }).toList(),

              SizedBox(height: 20),

              // Quick Budget Tips
              Card(
                elevation: 2,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                child: Container(
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: Colors.blue.shade50,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.lightbulb_outline, color: Colors.blue.shade600),
                          SizedBox(width: 8),
                          Text(
                            'Budget Tips',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.blue.shade800,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 12),
                      _buildTip('Venue typically takes 40-50% of total budget'),
                      _buildTip('Book venues 6-12 months in advance for better rates'),
                      _buildTip('Consider weekday weddings for 20-30% savings'),
                      _buildTip('Keep 10% buffer for unexpected expenses'),
                    ],
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryCard(String categoryName, BudgetCategory category) {
    double amount = totalBudget * (category.percentage / 100);

    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return Transform.scale(
          scale: 0.95 + (0.05 * _animationController.value),
          child: Container(
            margin: EdgeInsets.only(bottom: 12),
            child: Card(
              elevation: 3,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: category.color.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Icon(
                            category.icon,
                            color: category.color,
                            size: 24,
                          ),
                        ),
                        SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                categoryName,
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey[800],
                                ),
                              ),
                              Text(
                                '₹${_formatCurrency(amount)}',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: category.color,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Text(
                          '${category.percentage.toInt()}%',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: category.color,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 12),
                    LinearPercentIndicator(
                      width: MediaQuery.of(context).size.width - 80,
                      animation: true,
                      lineHeight: 8.0,
                      animationDuration: 1000,
                      percent: category.percentage / 100,
                      linearStrokeCap: LinearStrokeCap.roundAll,
                      progressColor: category.color,
                      backgroundColor: category.color.withOpacity(0.2),
                    ),
                    SizedBox(height: 8),
                    Slider(
                      value: category.percentage,
                      min: 0,
                      max: 60,
                      divisions: 12,
                      label: '${category.percentage.toInt()}%',
                      activeColor: category.color,
                      onChanged: (value) {
                        _updateCategoryPercentage(categoryName, value);
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildTip(String tip) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 2),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('• ', style: TextStyle(color: Colors.blue.shade600)),
          Expanded(
            child: Text(
              tip,
              style: TextStyle(
                color: Colors.blue.shade700,
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _formatCurrency(double amount) {
    if (amount >= 100000) {
      return '${(amount / 100000).toStringAsFixed(1)}L';
    } else if (amount >= 1000) {
      return '${(amount / 1000).toStringAsFixed(1)}K';
    } else {
      return amount.toStringAsFixed(0);
    }
  }
}

class BudgetCategory {
  final String name;
  double percentage;
  final IconData icon;
  final Color color;

  BudgetCategory(this.name, this.percentage, this.icon, this.color);
}
