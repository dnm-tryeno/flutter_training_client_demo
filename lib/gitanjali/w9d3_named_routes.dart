import 'package:flutter/material.dart';

void main() {
  runApp(W9D3NamedRoutes());
}

class W9D3NamedRoutes extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // Define the initial route of your app
      initialRoute: '/',
      // Define named routes
      routes: {
        // Define the named route for the home screen
        '/': (context) => HomeScreen(),
        // Define the named route for the product details screen
        '/productDetails': (context) => ProductDetailsScreen(),
      },
    );
  }
}

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Product List'),
      ),
      body: ListView(
        children: [
          ListTile(
            title: Text('Product 1'),
            // Navigate to product details screen when tapped
            onTap: () {
              Navigator.pushNamed(context, '/productDetails',
                  arguments: 'Product 1');
            },
          ),
          ListTile(
            title: Text('Product 2'),
            onTap: () {
              Navigator.pushNamed(context, '/productDetails',
                  arguments: 'Product 2');
            },
          ),
        ],
      ),
    );
  }
}

class ProductDetailsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Retrieve the product name passed as an argument
    final String? productName =
        ModalRoute.of(context)?.settings.arguments as String?;

    return Scaffold(
      appBar: AppBar(
        title: Text('Product Details'),
      ),
      body: Center(
        child: Text('Details for $productName'),
      ),
    );
  }
}
