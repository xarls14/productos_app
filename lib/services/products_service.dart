

import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:productos_app/models/models.dart';
import 'package:http/http.dart' as http;

//usaremos con provider
class ProductsService extends ChangeNotifier{

  final String _baseUrl = 'flutter-varios-d808d-default-rtdb.firebaseio.com';

  final List<Product> products = [];

  late Product selectedProduct;

  final storage = const FlutterSecureStorage();

  File? newPictureFile;

  bool isLoading = true;
  bool isSaving = false;

  ProductsService(){

    loadProducts();

  }

  Future loadProducts() async{

    isLoading = true;
    notifyListeners();

    final url = Uri.https(_baseUrl, 'products.json', {
      'auth': await storage.read(key: 'token') ?? ''
    });
    final resp = await http.get(url);

    final Map<String, dynamic> productsMap = json.decode(resp.body);

    productsMap.forEach((key, value) {
      final tempProduct = Product.fromMap(value);
      tempProduct.id = key;
      products.add(tempProduct);
    });
    
    isLoading = false;
    notifyListeners();

    return products;

  }

  Future saveOrCreateProduct(Product product) async{

    isSaving = true;
    notifyListeners();

    if (product.id == null) {
      await this.createProduct(product);
    }else{
      await this.updateProduct(product);
    }

    isSaving = false;
    notifyListeners();


  }

  Future<String?> updateProduct(Product product)async{

    final url = Uri.https(_baseUrl, 'products/${ product.id }.json', {
      'auth': await storage.read(key: 'token') ?? ''
    });
    final resp = await http.put(url, body: product.toJson());
    final decodedData = resp.body;

    final index = this.products.indexWhere((element) => element.id == product.id);
    this.products[index] = product;

    return product.id;
  }

  Future<String?> createProduct(Product product)async{

    final url = Uri.https(_baseUrl, 'products.json', {
      'auth': await storage.read(key: 'token') ?? ''
    });
    final resp = await http.post(url, body: product.toJson());
    final decodedData = json.decode(resp.body);
    
    product.id = decodedData['name'];
    this.products.add(product);

    return product.id;



  }

  void updateSelectedProductImage(String path) {
    this.selectedProduct.picture = path;
    this.newPictureFile = File.fromUri(Uri(path: path));
    notifyListeners();

  }

  Future<String?> uploadImage()async {
    if(this.newPictureFile == null) return null;

      this.isSaving = true;
      notifyListeners();

      final url = Uri.parse('https://api.cloudinary.com/v1_1/dgdsyes9s/image/upload?upload_preset=v3ar63tj');

      final imageUploadRequest = http.MultipartRequest('POST', url );

      final file = await http.MultipartFile.fromPath('file', newPictureFile!.path );

      imageUploadRequest.files.add(file);

      final streamResponse = await imageUploadRequest.send();
      final resp = await http.Response.fromStream(streamResponse);

      if ( resp.statusCode != 200 && resp.statusCode != 201 ) {
        print('algo salio mal');
        print( resp.body );
        return null;
      }

      this.newPictureFile = null;

      final decodedData = json.decode( resp.body );
      return decodedData['secure_url'];
    }
}