import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Lubna Selections',
      theme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: Colors.green,
        fontFamily: 'Roboto',
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.greenAccent,
            foregroundColor: Colors.black,
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 32),
            textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            elevation: 6,
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.grey[900],
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          hintStyle: const TextStyle(color: Colors.white70),
        ),
      ),
      home: const CalculatorPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class CalculatorPage extends StatefulWidget {
  const CalculatorPage({super.key});

  @override
  _CalculatorPageState createState() => _CalculatorPageState();
}

class _CalculatorPageState extends State<CalculatorPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController yController = TextEditingController();
  final TextEditingController aController = TextEditingController();
  final TextEditingController xController = TextEditingController();
  final TextEditingController basePriceController = TextEditingController();
  final TextEditingController markupPercentageController = TextEditingController();

  String resultX = '', resultZ = '', resultPrice = '', errorMessageX = '', errorMessageZ = '';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    yController.dispose();
    aController.dispose();
    xController.dispose();
    basePriceController.dispose();
    markupPercentageController.dispose();
    super.dispose();
  }

  void calculateX() {
    setState(() {
      errorMessageX = '';
      double? y = double.tryParse(yController.text);
      double? a = double.tryParse(aController.text);

      if (y == null || a == null) {
        errorMessageX = 'Please enter valid numbers';
        resultX = '';
        return;
      }
      if (a == 0) {
        errorMessageX = 'Profit percentage cannot be zero';
        resultX = '';
        return;
      }

      double x = (y * 100) / (a + 100);
      resultX = 'Buying Price: ₹${x.toStringAsFixed(2)}';
    });
  }

  void calculateZ() {
    setState(() {
      errorMessageZ = '';
      double? y = double.tryParse(yController.text);
      double? x = double.tryParse(xController.text);

      if (y == null || x == null) {
        errorMessageZ = 'Please enter valid numbers';
        resultZ = '';
        return;
      }
      if (y == 0) {
        errorMessageZ = 'Selling price cannot be zero';
        resultZ = '';
        return;
      }

      double z = ((y - x) * 100) / y;
      resultZ = 'Max Discount: ${z.toStringAsFixed(2)}%';
    });
  }

  void calculatePrice() {
    setState(() {
      double? basePrice = double.tryParse(basePriceController.text);
      double? markupPercentage = double.tryParse(markupPercentageController.text);

      if (basePrice == null || markupPercentage == null) {
        resultPrice = 'Please enter valid numbers';
        return;
      }

      double price = basePrice + (basePrice * markupPercentage / 100);
      resultPrice = 'Selling Price: ₹${price.toStringAsFixed(2)}';
    });
  }

  void clearAllFields() {
    yController.clear();
    aController.clear();
    xController.clear();
    basePriceController.clear();
    markupPercentageController.clear();
    setState(() {
      resultX = '';
      resultZ = '';
      resultPrice = '';
      errorMessageX = '';
      errorMessageZ = '';
    });
  }

  Widget _buildInputCard(String title, List<Widget> children) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      color: Colors.grey[850],
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
            const SizedBox(height: 16),
            ...children,
          ],
        ),
      ),
    );
  }

  Widget _buildResultText(String text, {bool isError = false}) {
    return Padding(
      padding: const EdgeInsets.only(top: 12),
      child: Text(
        text,
        style: TextStyle(fontSize: 16, color: isError ? Colors.red[400] : Colors.green[300], fontWeight: FontWeight.bold),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lubna Selections'),
        actions: [
          IconButton(
            icon: const Icon(Icons.recycling, color: Colors.limeAccent),
            tooltip: 'Clear All Fields',
            onPressed: clearAllFields,
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          tabs: const [Tab(text: 'Discount Calculator'), Tab(text: 'Price Calculator')],
        ),
      ),
      backgroundColor: Colors.grey[900],
      body: TabBarView(
        controller: _tabController,
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                _buildInputCard('Calculate Buying Price', [
                  TextField(controller: yController, decoration: const InputDecoration(labelText: 'Selling Price', prefixText: '₹ '), keyboardType: TextInputType.numberWithOptions(decimal: true)),
                  const SizedBox(height: 16),
                  TextField(controller: aController, decoration: const InputDecoration(labelText: 'Profit Percentage', suffixText: '%'), keyboardType: TextInputType.numberWithOptions(decimal: true)),
                  const SizedBox(height: 20),
                  Center(child: ElevatedButton(onPressed: calculateX, child: const Text('Calculate Buying Price'))),
                  if (resultX.isNotEmpty) _buildResultText(resultX),
                  if (errorMessageX.isNotEmpty) _buildResultText(errorMessageX, isError: true),
                ]),
                _buildInputCard('Calculate Discount Percentage', [
                  TextField(controller: xController, decoration: const InputDecoration(labelText: 'Buying Price', prefixText: '₹ '), keyboardType: TextInputType.numberWithOptions(decimal: true)),
                  const SizedBox(height: 20),
                  Center(child: ElevatedButton(onPressed: calculateZ, child: const Text('Calculate Discount'))),
                  if (resultZ.isNotEmpty) _buildResultText(resultZ),
                  if (errorMessageZ.isNotEmpty) _buildResultText(errorMessageZ, isError: true),
                ]),
              ],
            ),
          ),
          SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: _buildInputCard('Calculate Selling Price', [
              TextField(controller: basePriceController, decoration: const InputDecoration(labelText: 'Buying Price', prefixText: '₹ '), keyboardType: TextInputType.numberWithOptions(decimal: true)),
              const SizedBox(height: 16),
              TextField(controller: markupPercentageController, decoration: const InputDecoration(labelText: 'Profit Percentage', suffixText: '%'), keyboardType: TextInputType.numberWithOptions(decimal: true)),
              const SizedBox(height: 20),
              Center(child: ElevatedButton(onPressed: calculatePrice, child: const Text('Calculate Price'))),
              if (resultPrice.isNotEmpty) _buildResultText(resultPrice, isError: resultPrice.startsWith('Please')),
            ]),
          ),
        ],
      ),
    );
  }
}
