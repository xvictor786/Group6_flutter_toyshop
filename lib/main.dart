//import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:toyshop/providers/auth.dart';
import 'package:toyshop/providers/products.dart';
import 'package:toyshop/screens/add_product_screen.dart';
import 'package:toyshop/screens/home_screen.dart';
import 'package:toyshop/screens/product_view_screen.dart';
import 'package:toyshop/widgets/product_item.dart';
import './screens/auth_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider( //untuk guna banyak provider
      providers: [
        ChangeNotifierProvider.value( //untuk ambik value dari provider
          value: Auth(),
        ),
        ChangeNotifierProxyProvider<Auth, Products>( 
          create: (ctx) => Products(null, null,
              []), //Note: for dependencies version is version 4.00 above (in pubspec.yaml)=> must issue create:
          update: (ctx, auth, previousProducts) => Products(
            //Note: for dependencies version is version 4.00 above (in pubspec.yaml)=> must use :update NOT a :builder..!
            auth.token,
            auth.userId,
            previousProducts == null ? [] : previousProducts.items,
          ),
        ),
      ],
      child: Consumer<Auth>(
        builder: (ctx, auth, _) => (MaterialApp(
          title: 'Toyshop',
          home: auth.isAuth ? homeScreen() : AuthScreen(), //tentukan untuk login
          routes: { //untuk tukar page
            addProduct.routeName: (ctx) => addProduct(),
            productViewScreen.routeName: (ctx) => productViewScreen(),
          },
        )),
      ),
    );
  }
}
