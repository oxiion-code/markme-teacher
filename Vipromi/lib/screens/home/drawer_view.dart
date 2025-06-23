import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AppSideDrawer extends StatelessWidget {
  const AppSideDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.orange[50],
      child: ListView(
        children: [
          DrawerHeader(
            decoration: BoxDecoration(color: Colors.grey[200]),
            child: Column(
              children: [
                Image.asset(
                  'assets/images/icon_drawer.png',
                  height: 100,
                  width: 100,
                ),
                SizedBox(height: 8),
                Text('Rudra Narayan Rath'),
              ],
            ),
          ),

          // Menu Buttons
          ListTile(
            leading: Icon(Icons.home),
            title: Text('Home'),
            onTap: () {
              Navigator.pop(context); // Closes the drawer

            },
          ),
          ListTile(
            leading: Icon(Icons.shopping_cart),
            title: Text('Products'),
            onTap: () {
              Navigator.pop(context);
              context.push('/products');              // Navigate to products screen
            },
          ),
          ListTile(
            leading: Icon(Icons.pets),
            title: Text('Know Your Animal'),
            onTap: () {
              // Navigate to KYA screen
              context.push('/knowyouranimal');
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: Icon(Icons.phone),
            title: Text('Contact Us'),
            onTap: () {
              context.push('/contactus');
              Navigator.pop(context);
              // Navigate to contact screen
            },
          ),
          ListTile(
            leading: Icon(Icons.settings),
            title: Text('Settings'),
            onTap: () {
              Navigator.pop(context);
              context.push('/settings') ;  // Navigate to settings
            },
          ),
        ],
      ),
    );
  }
}
