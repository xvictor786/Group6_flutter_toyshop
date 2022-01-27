// import 'dart:js';

import 'package:flutter/material.dart';
// import 'package:flutter_shop_app/providers/auth.dart';
import '../providers/auth.dart';
import 'package:provider/provider.dart';
// import '../screens/orders_screen.dart';
// import '../screens/user_products_screen.dart';

class AppDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer( //function menu burger
      child: Column(
        children: <Widget>[
          AppBar(
            title: Text('Menu'),
            automaticallyImplyLeading: false,
          ),
          Divider(), //untuk menu seterusnya
          ListTile(
            leading: Icon(Icons.account_balance_rounded),
            title: Text('Assets List'),
            onTap: () {
              Navigator.of(context)
                  .pushReplacementNamed('/'); //Go to root route
            },
          ),
          Divider(), //untuk menu seterusnya
          ListTile(
            leading: Icon(Icons.exit_to_app),
            title: Text('Logout'),
            onTap: () {
              // Navigator.of(context)
              //     .pushReplacementNamed(UserProductsScreen.routeName);
              Navigator.of(context).pop(); //untuk keluar back
              Navigator.of(context).pushReplacementNamed('/');
              Provider.of<Auth>(context, listen: false).logout(); //untuk logout
            },
          ),
        ],
      ),
    );
  }
}
