import 'package:flutter/material.dart';
import 'purchase_confirmation.dart'; // Import the new Dart file

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Ordering App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<String> orderedItems = [];
  double totalPrice = 0.0;

  void _openMenuDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Select Items from Menu'),
          content: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                // Display the menu with categories and items
                for (var category in menu.keys)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '$category:',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      for (var item in menu[category]!.keys)
                        ListTile(
                          title: Text(
                              '$item: \$${menu[category]![item]!.toStringAsFixed(2)}'),
                          onTap: () {
                            setState(() {
                              // Add the selected item to the order
                              orderedItems.add(item);
                              totalPrice += menu[category]![item]!;
                            });
                            Navigator.of(context).pop();
                          },
                        ),
                    ],
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _removeItem(String item) {
    setState(() {
      orderedItems.remove(item);
      totalPrice -= menu.entries
          .where((entry) => entry.value.containsKey(item))
          .map((entry) => entry.value[item]!)
          .fold(0.0, (a, b) => a + b);
    });
  }

  void _openPurchaseConfirmation(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PurchaseConfirmation(
          orderedItems: orderedItems,
          totalPrice: totalPrice,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text('Ordering App'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            // Display ordered items
            Text(
              'Ordered Items:',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            for (var item in orderedItems)
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '- $item',
                    style: TextStyle(fontSize: 16),
                  ),
                  IconButton(
                    icon: Icon(Icons.remove_circle),
                    onPressed: () => _removeItem(item),
                  ),
                ],
              ),
            SizedBox(height: 10),
            // Display total price
            Text(
              'Total Price: \$${totalPrice.toStringAsFixed(2)}',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            SizedBox(height: 20),
            // Purchase button
            ElevatedButton(
              onPressed: () {
                if (orderedItems.isNotEmpty) {
                  _openPurchaseConfirmation(context);
                } else {
                  // Show a snackbar or alert to inform the user that the order is empty
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                          'Please add items to your order before purchasing.'),
                    ),
                  );
                }
              },
              child: Text('Purchase'),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _openMenuDialog(context);
        },
        tooltip: 'Order',
        child: const Icon(Icons.shopping_cart),
      ),
    );
  }

  // Define the menu with categories and items
  Map<String, Map<String, double>> menu = {
    'Burgers': {
      'Classic Burger': 5.99,
      'Cheeseburger': 6.99,
      'Bacon Burger': 7.99,
    },
    'Pizzas': {
      'Margherita': 8.99,
      'Pepperoni': 9.99,
      'Vegetarian': 10.99,
    },
    'Salads': {
      'Caesar Salad': 4.99,
      'Greek Salad': 5.99,
      'Chicken Salad': 6.99,
    },
    'Drinks': {
      'Soda': 1.99,
      'Water': 0.99,
      'Iced Tea': 2.49,
    },
  };
}
