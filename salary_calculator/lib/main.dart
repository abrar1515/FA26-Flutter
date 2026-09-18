import 'package:flutter/material.dart';

void main() {
  runApp(const SalaryCalculatorApp());
}

class SalaryCalculatorApp extends StatelessWidget {
  const SalaryCalculatorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Salary Calculator',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        // High-luminance color scheme
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.yellowAccent,
          brightness: Brightness.light,
          primary: Colors.amber,
        ),
      ),
      home: const SalaryCalculatorHome(),
    );
  }
}

class SalaryCalculatorHome extends StatefulWidget {
  const SalaryCalculatorHome({super.key});

  @override
  State<SalaryCalculatorHome> createState() => _SalaryCalculatorHomeState();
}

class _SalaryCalculatorHomeState extends State<SalaryCalculatorHome> with SingleTickerProviderStateMixin {
  final TextEditingController _incomeController = TextEditingController();
  final TextEditingController _medicalController = TextEditingController();
  final TextEditingController _travelController = TextEditingController();
  final TextEditingController _residentialController = TextEditingController();
  final TextEditingController _taxController = TextEditingController();

  double _totalSalary = 0.0;
  double _taxAmount = 0.0;
  bool _showResult = false;
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _scaleAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.elasticOut,
    );
  }

  @override
  void dispose() {
    _incomeController.dispose();
    _medicalController.dispose();
    _travelController.dispose();
    _residentialController.dispose();
    _taxController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  void _calculateSalary() {
    final double income = double.tryParse(_incomeController.text) ?? 0.0;
    final double medical = double.tryParse(_medicalController.text) ?? 0.0;
    final double travel = double.tryParse(_travelController.text) ?? 0.0;
    final double residential = double.tryParse(_residentialController.text) ?? 0.0;
    final double taxPercent = double.tryParse(_taxController.text) ?? 0.0;

    final double grossSalary = income + medical + travel + residential;
    final double taxAmount = grossSalary * (taxPercent / 100);

    setState(() {
      _taxAmount = taxAmount;
      _totalSalary = grossSalary - taxAmount;
      _showResult = true;
    });
    _animationController.reset();
    _animationController.forward();
  }

  Widget _buildTextField(TextEditingController controller, String label, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextField(
        controller: controller,
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          filled: true,
          fillColor: Theme.of(context).colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Salary Calculator'),
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildTextField(_incomeController, 'Monthly Income', Icons.attach_money),
            _buildTextField(_medicalController, 'Medical Allowance', Icons.medical_services),
            _buildTextField(_travelController, 'Travel Allowance', Icons.directions_car),
            _buildTextField(_residentialController, 'Residential Allowance', Icons.home),
            _buildTextField(_taxController, 'Tax Deduction (%)', Icons.percent),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _calculateSalary,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                backgroundColor: Theme.of(context).colorScheme.primary,
                foregroundColor: Theme.of(context).colorScheme.onPrimary,
              ),
              child: const Text(
                'Calculate Net Salary',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 32),
            if (_showResult)
              ScaleTransition(
                scale: _scaleAnimation,
                child: FadeTransition(
                  opacity: _animationController,
                  child: Card(
                    elevation: 8,
                    color: Theme.of(context).colorScheme.secondaryContainer,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Column(
                        children: [
                          Text(
                            'Tax Deduction',
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                  color: Theme.of(context).colorScheme.error,
                                ),
                          ),
                          Text(
                            '-\$${_taxAmount.toStringAsFixed(2)}',
                            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                  color: Theme.of(context).colorScheme.error,
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                          const Divider(height: 32),
                          Text(
                            'Net Monthly Salary',
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            '\$${(_totalSalary).toStringAsFixed(2)}',
                            style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                                  color: Theme.of(context).colorScheme.primary,
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
