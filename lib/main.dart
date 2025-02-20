import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Lubna Selections ',
      theme: ThemeData(
        brightness: Brightness.dark, // Dark theme for the whole app
        primaryColor: Colors.green,
        fontFamily: 'Roboto',
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.greenAccent, // Bright neon color for buttons
            foregroundColor: Colors.black, // Button text color to black
            padding: EdgeInsets.symmetric(vertical: 20, horizontal: 40),
            textStyle: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            elevation: 8,
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.grey[900], // Dark fill for text fields
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 18),
          hintStyle: TextStyle(color: Colors.white70), // Lighter text for hints
        ),
      ),
      home: CalculatorPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class CalculatorPage extends StatefulWidget {
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

  String resultX = '';
  String resultZ = '';
  String resultPrice = '';
  String errorMessageX = '';
  String errorMessageZ = '';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
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

  Widget _buildInputCard(String title, List<Widget> children) {
    return Card(
      elevation: 4,
      margin: EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      color: Colors.grey[850], // Dark card background
      child: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
            ),
            SizedBox(height: 16),
            ...children,
          ],
        ),
      ),
    );
  }

  Widget _buildResultText(String text, {bool isError = false}) {
    return Padding(
      padding: EdgeInsets.only(top: 12),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 16,
          color: isError ? Colors.red[400] : Colors.green[300], // Error text is red, success is green
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Lubna Selections'),
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            Tab(text: 'Discount Calculator'),
            Tab(text: 'Price Calculator'),
          ],
        ),
      ),
      backgroundColor: Colors.grey[900], // Dark background for entire page
      body: TabBarView(
        controller: _tabController,
        children: [
          SingleChildScrollView(
            padding: EdgeInsets.all(16),
            child: Column(
              children: [
                _buildInputCard(
                  'Calculate Buying Price',
                  [
                    TextField(
                      controller: yController,
                      decoration: InputDecoration(
                        labelText: 'Selling Price',
                        prefixText: '₹ ', // Add ₹ symbol on the left side
                      ),
                      keyboardType: TextInputType.numberWithOptions(decimal: true),
                    ),
                    SizedBox(height: 16),
                    TextField(
                      controller: aController,
                      decoration: InputDecoration(
                        labelText: 'Profit Percentage',
                        suffixText: '%',
                      ),
                      keyboardType: TextInputType.numberWithOptions(decimal: true),
                    ),
                    SizedBox(height: 20),
                    Center(
                      child: ElevatedButton(
                        onPressed: calculateX,
                        child: Text('Calculate Buying Price'),
                      ),
                    ),
                    if (resultX.isNotEmpty) _buildResultText(resultX),
                    if (errorMessageX.isNotEmpty)
                      _buildResultText(errorMessageX, isError: true),
                  ],
                ),
                _buildInputCard(
                  'Calculate Discount Percentage',
                  [
                    TextField(
                      controller: xController,
                      decoration: InputDecoration(
                        labelText: 'Buying Price',
                        prefixText: '₹ ', // Add ₹ symbol on the left side
                      ),
                      keyboardType: TextInputType.numberWithOptions(decimal: true),
                    ),
                    SizedBox(height: 20),
                    Center(
                      child: ElevatedButton(
                        onPressed: calculateZ,
                        child: Text('Calculate Discount'),
                      ),
                    ),
                    if (resultZ.isNotEmpty) _buildResultText(resultZ),
                    if (errorMessageZ.isNotEmpty)
                      _buildResultText(errorMessageZ, isError: true),
                  ],
                ),
              ],
            ),
          ),
          SingleChildScrollView(
            padding: EdgeInsets.all(16),
            child: _buildInputCard(
              'Calculate Selling Price',
              [
                TextField(
                  controller: basePriceController,
                  decoration: InputDecoration(
                    labelText: 'Buying Price',
                    prefixText: '₹ ', // Add ₹ symbol on the left side
                  ),
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                ),
                SizedBox(height: 16),
                TextField(
                  controller: markupPercentageController,
                  decoration: InputDecoration(
                    labelText: 'Profit Percentage',
                    suffixText: '%',
                  ),
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                ),
                SizedBox(height: 20),
                Center(
                  child: ElevatedButton(
                    onPressed: calculatePrice,
                    child: Text('Calculate Price'),
                  ),
                ),
                if (resultPrice.isNotEmpty)
                  _buildResultText(
                    resultPrice,
                    isError: resultPrice.startsWith('Please'),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
