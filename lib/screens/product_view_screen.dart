//import 'dart:html';

import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:toyshop/providers/products.dart';
import 'package:toyshop/widgets/app_drawer.dart';

class productViewScreen extends StatelessWidget {
  static const routeName = '/productView';

  @override
  Widget build(BuildContext context) {
    final productId = ModalRoute.of(context)!.settings.arguments
        as String; // untuk kutip semula id yang telah di pass
    final loadedProduct = Provider.of<Products>(
      context,
      listen: false,
    ).findById(
        productId); //untuk cari id dalam product dan save dalam loaded product
    return Scaffold(
      backgroundColor: Colors.purple.shade100,
      appBar: AppBar(
        title: Text('Product Detail'),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.add_box_rounded),
            onPressed: () {
              // Navigator.of(context)
              //     .pushNamed(EditProductScreen.routeName, arguments: id);
            },
            color: Theme.of(context).primaryColor,
          ),
        ],
      ),
      body: Center(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 18, vertical: 32),
          child: Column(
            children: [
              Container(
                height: 50,
                width: MediaQuery.of(context).size.width,
                // color: Colors.blueGrey,
                decoration: BoxDecoration(
                  color: Colors.lightBlue.shade900,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Center(
                    child: Text(
                  'Details',
                  style:
                      TextStyle(color: Color(0xFFE1F5FE), fontFamily: 'Lato', fontSize: 20),
                )),
              ),
              Container(
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 18, vertical: 32),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(loadedProduct.asset_no),

                      // Text(loadedProduct.asset_name),
                      // Text(loadedProduct.date_registered),
                      // Text(loadedProduct.asset_location),
                      // Text(loadedProduct.asset_status),
                    ],
                  ),
                ),
                height: 90,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: const Color(0xFFB3E5FC),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey,
                        offset: Offset(0, 1),
                      ),
                    ]),
              ),
              Container(
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 18, vertical: 32),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Text(loadedProduct.asset_no),
                      Text(loadedProduct.asset_name),
                      // Text(loadedProduct.date_registered),
                      // Text(loadedProduct.asset_location),
                      // Text(loadedProduct.asset_status),
                    ],
                  ),
                ),
                height: 90,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                    // height: 120,
                    borderRadius: BorderRadius.circular(10),
                    color: const Color(0xFF81D4FA),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey,
                        offset: Offset(0, 1),
                      ),
                    ]),
              ),
              Container(
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 18, vertical: 32),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Text(loadedProduct.asset_no),
                      //Text(loadedProduct.asset_name),
                      Text(loadedProduct.date_registered),
                      // Text(loadedProduct.asset_location),
                      // Text(loadedProduct.asset_status),
                    ],
                  ),
                ),
                // height: 455 ,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: const Color(0xFF4FC3F7),
                    // boxShadow: [
                    //   // BoxShadow(
                    //   //   color: Colors.grey,
                    //   //   offset: Offset(0, 1),
                    //   // ),
                    // ]
                    ),
              ),
              Container(
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 18, vertical: 32),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Text(loadedProduct.asset_no),
                      //Text(loadedProduct.asset_name),
                      // Text(loadedProduct.date_registered),
                      Text(loadedProduct.asset_location),
                      // Text(loadedProduct.asset_status),
                    ],
                  ),
                ),
                // height: 455 ,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: const Color(0xFF29B6F6),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey,
                        offset: Offset(0, 1),
                      ),
                    ]),
              ),
              Container(
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 18, vertical: 32),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Text(loadedProduct.asset_no),
                      //Text(loadedProduct.asset_name),
                      // Text(loadedProduct.date_registered),
                      // Text(loadedProduct.asset_location),
                      Text(loadedProduct.asset_status),
                    ],
                  ),
                ),
                // height: 455 ,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: const Color(0xFF03A9FA),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey,
                        offset: Offset(0, 1),
                      ),
                    ]),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.delete),
        onPressed: () {
          Provider.of<Products>(context, listen: false).updateStatusProduct(
              loadedProduct.id,
              loadedProduct); //asset no by id dan loaded sebagai satu list
          Navigator.of(context).pop(); //back semula
        },
      ),
    );
  }
}
