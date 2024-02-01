import 'package:flutter/material.dart';

class PurchaseConfirmation extends StatelessWidget {
  final List<String> orderedItems;
  final double totalPrice;

  const PurchaseConfirmation({
    required this.orderedItems,
    required this.totalPrice,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Purchase Confirmation'),
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
              Text(
                '- $item',
                style: TextStyle(fontSize: 16),
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
            // Add more widgets for purchase confirmation or payment processing
          ],
        ),
      ),
    );
  }
}
