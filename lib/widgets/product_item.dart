import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:toyshop/providers/products.dart';
import 'package:toyshop/screens/product_view_screen.dart';

class productItem extends StatelessWidget {
  final String assetNo;
  final String assetName;
  final String id;
  final String status;

  productItem(
    this.id,
    this.assetNo,
    this.assetName,
    this.status,
  );

  @override
  Widget build(BuildContext context) {
    //final item = Provider.of<Item>(context, listen: false);
    final loadedItem = Provider.of<Products>( //card list view
      context,
      listen: false,
    ).findById(id);
    return Consumer<Products>(builder: (context, productData, child) {
      return GestureDetector( //widget untuk function tekan ke list
        onTap: () {
          productData.role['role'] == 'manager' // Tentukan boleh tekan ke view detail dok (manager)
          ? null
          : Navigator.of(context).pushNamed(
            productViewScreen.routeName,
            arguments: id, //find id untuk pass ke product view screen
          );
        },
        child: Card(
          margin: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
          child: Container(
            padding: EdgeInsets.all(20),
            height: 70,
            child: Row(
              children: [
                Text(assetNo),
                Spacer(),
                Text(assetName),
                Spacer(),
                productData.role['role'] == 'manager' // display status untuk manager sahaja ^_^
                ? Text(status)
                : SizedBox()
                //Text(status),
              ],
            ),
          ),
        ),
      );
    });
  }
}
