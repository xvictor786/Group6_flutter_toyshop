import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:toyshop/models/product.dart';

import '../models/product.dart';
import '../models/http_exception.dart';

class Products with ChangeNotifier {
  late final String? _authToken;
  late final String? _userId;

  Products(this._authToken, this._userId, this._items); 

  Map<String, String> _role = {
    'role': '',
    'userId': '',
  };

  List<Product> _items = [];

  List<Product> get items {
    return [..._items];
  }

  Map<String, String> get role { //panggil role
    retrieveRole(userId);
    print(_role);
    return _role;
  }

  Product findById(String id) {
    return _items
        .firstWhere((prod) => prod.id == id); //untuk mencari id dalam list
  }

  String? get userId {
    return _userId;
  }

  Future<void> addProduct(
    String assetName,
    String dateRegistered,
    String location,
    String status,
  ) async {
    final total = items.length + 1;
    String assetNo = 'A-' + total.toString(); // increment untuk A1,2,3,4.....
    const url =
        'https://toyshopapp-965b2-default-rtdb.asia-southeast1.firebasedatabase.app/products.json';
    try {
      final response = await http.post(
        Uri.parse(url),
        body: json.encode({
          'assetNo': assetNo,
          'assetName': assetName,
          'dateRegistered': dateRegistered,
          'assetLocation': location,
          'status': status,
        }),
      );

      Product item = Product(
        asset_no: 'A-' + total.toString(),
        asset_name: assetName,
        date_registered: dateRegistered,
        asset_location: location,
        asset_status: status,
        id: json.decode(response.body)['name'],
      );
      _items.add(item);
    } catch (error) {
      print(error);
      throw error;
    }

    notifyListeners();
  }

  Future<void> fetchAndSetProducts([bool filterByUser = false]) async {
    var url =
        'https://toyshopapp-965b2-default-rtdb.asia-southeast1.firebasedatabase.app/products.json';
    try {
      final response = await http.get(Uri.parse(url));
      print(json.decode(response.body));

      if (json.decode(response.body) != null) {
        final extractedData =
            json.decode(response.body) as Map<String, dynamic>;

        final List<Product> loadedProducts = [];
        extractedData.forEach((prodId, prodData) {
          loadedProducts.add(Product(
            asset_no: prodData['assetNo'],
            asset_name: prodData['assetName'],
            date_registered: prodData['dateRegistered'],
            asset_location: prodData['assetLocation'],
            asset_status: prodData['status'],
            id: prodId,
          ));
        });
        print(_items);
        _items = loadedProducts;
        notifyListeners();
      }
    } catch (error) {
      throw (error);
    }
  }

  Future<void> retrieveRole(String? userId) async { //panggil dari firebase
    final filterString = 'orderBy="userId"&equalTo="$userId"'; //ikut user id acc
    var url =
        'https://toyshopapp-965b2-default-rtdb.asia-southeast1.firebasedatabase.app/user.json?$filterString';
    try {
      final response = await http.get(Uri.parse(url));
      print(json.decode(response.body));

      if (json.decode(response.body) != null) {
        final extractedData =
            json.decode(response.body) as Map<String, dynamic>;

        extractedData.forEach((prodId, prodData) {
          _role['role'] = prodData['role'];
          _role['userId'] = prodData['userId'];
        });

        notifyListeners();
      }
    } catch (error) {
      throw (error);
    }
  }

  Future<void> updateProduct(String id, Product newProduct) async {
    final prodIndex = _items.indexWhere((prod) => prod.id == id);
    if (prodIndex >= 0) {
      final url =
          'https://toyshopapp-965b2-default-rtdb.asia-southeast1.firebasedatabase.app/products/$id.json';
      await http.patch(Uri.parse(url),
          body: jsonEncode({
            'assetNo': newProduct.asset_no,
            'assetName': newProduct.asset_name,
            'assetLocation': newProduct.asset_location,
            'dateRegistered': newProduct.date_registered,
            'Status': 'Deprecate',
          }));
      _items[prodIndex] = newProduct;
      notifyListeners();
    } else {
      print('...');
    }
  }

  Future<void> deleteProduct(String id) async {
    final url =
        'https://toyshopapp-965b2-default-rtdb.asia-southeast1.firebasedatabase.app/products/$id.json';
    final existingProductIndex = _items.indexWhere((prod) => prod.id == id);
    var existingProduct = _items[existingProductIndex];
    _items.removeAt(
        existingProductIndex); // This approach know as optimistic updating..
    notifyListeners();

    final response = await http.delete(Uri.parse(url));
    if (response.statusCode >= 400) {
      _items.insert(existingProductIndex,
          existingProduct); // Rollback to data in the list if error occurs..!
      notifyListeners();
      throw HttpException('Could not delete the product.');
    }
    //  existingProduct = null;
    existingProduct = <Product>[] as Product; // Reset a default value as null
  }

  Future<void> updateStatusProduct(String id, Product newProduct) async {
    final prodIndex = _items.indexWhere((prod) => prod.id == id);
    if (prodIndex >= 0) {
      final url =
          'https://toyshopapp-965b2-default-rtdb.asia-southeast1.firebasedatabase.app/products/$id.json';
      await http.patch(Uri.parse(url),
          body: jsonEncode({
            'assetNo': newProduct.asset_no,
            'assetName': newProduct.asset_name,
            'assetLocation': newProduct.asset_location,
            'dateRegistered': newProduct.date_registered,
            'status': 'deprecated',
          }));
      _items[prodIndex] = newProduct;
      notifyListeners();
    } else {
      print('...');
    }
  }
}
