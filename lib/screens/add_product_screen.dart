import 'package:flutter/material.dart';
import 'package:toyshop/providers/products.dart';
import 'package:provider/provider.dart';

class addProduct extends StatelessWidget {
  static const routeName = '/add_product';
  final _form = GlobalKey<FormState>();

  String assetName = '';
  String assetLocation = '';

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _form,
      child: Scaffold(
        backgroundColor: Colors.purple.shade100,
        appBar: AppBar(
          title: Text('Add Asset'),
          actions: <Widget>[
            IconButton(
              icon: const Icon(Icons.save),
              onPressed: () {
                Provider.of<Products>(context, listen: false).addProduct(
                    assetName,
                    DateTime.now().toString(),
                    assetLocation,
                    'Active');
                Navigator.of(context).pop();
              },
            ),
          ],
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              decoration: BoxDecoration(
                // borderRadius: BorderRadius.circular(200),
                gradient: LinearGradient(
                  colors: [
                    Color.fromRGBO(215, 117, 255, 1).withOpacity(0.5),
                    Color.fromRGBO(255, 188, 117, 1).withOpacity(0.9),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  stops: [0, 1],
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 16),
              child: TextField(
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Enter assets name',
                  ),
                  onChanged: (value) {
                    assetName = value;
                  }),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
              child: TextFormField(
                  decoration: const InputDecoration(
                    border: UnderlineInputBorder(),
                    labelText: 'Enter asset location',
                  ),
                  onChanged: (value) {
                    assetLocation = value;
                  }),
            ),
          ],
        ),
      ),
    );
  }
}
