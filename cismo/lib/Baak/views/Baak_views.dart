import 'package:flutter/material.dart';

class BaakScreen extends StatelessWidget {
  const BaakScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue,
      appBar: AppBar(
        title: Text('Home Screen'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Welcome to Baak Screen',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Add logic for menu item 1
              },
              child: Text('Request IK'),
            ),
            ElevatedButton(
              onPressed: () {
                // Add logic for menu item 2
              },
              child: Text('Menu Item 2'),
            ),
            // Add more menu items as needed
          ],
        ),
      ),
    );
  }
}
