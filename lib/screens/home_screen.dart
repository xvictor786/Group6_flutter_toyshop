import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:toyshop/models/product.dart';
import 'package:toyshop/screens/add_product_screen.dart';
import 'package:toyshop/widgets/app_drawer.dart';
import 'package:toyshop/widgets/product_item.dart';
import '../providers/products.dart';

import 'package:intl/intl.dart';
import '../providers/auth.dart';

class homeScreen extends StatefulWidget {
  const homeScreen({Key? key}) : super(key: key);

  @override
  _homeScreenState createState() => _homeScreenState();
}

class _homeScreenState extends State<homeScreen> {
  Future<void> _refreshProducts(BuildContext context) async {
    await Provider.of<Products>(context, listen: false).fetchAndSetProducts();
  }

  var _isInit = true;
  var _isLoading = false;

  @override
  void didChangeDependencies() {
    // Will run after the widget fully initialise but before widget build
    if (_isInit) {
      // for the first time..!!
      setState(() {
        _isLoading = true;
      });
      Provider.of<Products>(context).fetchAndSetProducts().then((_) {
        setState(() {
          _isLoading = false;
        });
      });
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<Products>(
      builder: (context, productData, child) {
        return Scaffold(
      backgroundColor: Colors.purple.shade100,
          appBar: AppBar(
            title: Text('Toy Shop'),
            actions: [Text(productData.role['role'].toString())],
          ),
          floatingActionButton: productData.role['role'] == 'manager' //jika manager floating button tutup
              ? null
              : FloatingActionButton(
                  //button tambah nota
                  mini: false,
                  backgroundColor: Colors.blue,
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => addProduct()));
                  },
                  child: Icon(Icons.add),
                ),
          body: RefreshIndicator(
            
            onRefresh: () => _refreshProducts(context),
            child: Consumer<Products>(
              builder: (ctx, productsData, child) => Padding(
                padding: EdgeInsets.all(8),
                child: ListView.builder(
                  itemCount: productsData.items.length,
                  itemBuilder: (context, i) => Column(
                    children: [
                      productItem(
                        productsData.items[i].id,
                        productsData.items[i].asset_no,
                        productsData.items[i].asset_name,
                        productsData.items[i].asset_status,
                      ),
                      // Divider(),
                    ],
                  ),
                ),
              ),
            ),
            // child: RaisedButton(
            //     child: Text(''),
            //     onPressed: () {
            //       Provider.of<Products>(context, listen: false).addProduct(
            //         'assetName',
            //         DateFormat.yMMMd().format(DateTime.now()).toString(),
            //         'location',
            //         "status",
            //       );
            //     }),
          ),
          drawer: AppDrawer(),
        );
      },
    );
  }
}
