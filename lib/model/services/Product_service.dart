import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mollet/model/data/Products.dart';
import 'package:mollet/model/data/brands.dart';
import 'package:mollet/model/data/cart.dart';
import 'package:mollet/model/notifiers/brands_notifier.dart';
import 'package:mollet/model/notifiers/cart_notifier.dart';
import 'package:mollet/model/notifiers/products_notifier.dart';
import 'package:mollet/model/services/auth_service.dart';

//Getting products
addAndApdateData(cartItem) async {
  final db = Firestore.instance;
  // final uid = await AuthService().getCurrentUID();
  final uEmail = await AuthService().getCurrentEmail();

  if (cartItem.quantity >= 9) {
    cartItem.quantity = cartItem.quantity = 9;
  } else {
    cartItem.quantity = cartItem.quantity + 1;
  }
  cartItem.totalPrice = cartItem.price * cartItem.quantity;

  CollectionReference cartRef =
      db.collection("userCart").document(uEmail).collection("cartItems");

  await cartRef.document(cartItem.productID).updateData(
    {'quantity': cartItem.quantity, 'totalPrice': cartItem.totalPrice},
  );
}

//Getting brands
addProductToCart(product) async {
  final db = Firestore.instance;
  final uEmail = await AuthService().getCurrentEmail();

  await db
      .collection("userCart")
      .document(uEmail)
      .collection("cartItems")
      .document(product.productID)
      .setData(product.toMap())
      .catchError((e) {
    print(e);
  });
}

//Getting users' cart
getBrands(BrandsNotifier brandsNotifier) async {
  QuerySnapshot snapshot =
      await Firestore.instance.collection("brands").getDocuments();

  List<Brands> _brandsList = [];

  snapshot.documents.forEach((document) {
    Brands brands = Brands.fromMap(document.data);
    _brandsList.add(brands);
  });

  brandsNotifier.brandsList = _brandsList;
}

//Adding users' product to cart
getCart(CartNotifier cartNotifier) async {
  // final uid = await AuthService().getCurrentUID();
  final uEmail = await AuthService().getCurrentEmail();

  QuerySnapshot snapshot = await Firestore.instance
      .collection("userCart")
      .document(uEmail)
      .collection("cartItems")
      .getDocuments();

  List<Cart> _cartList = [];

  snapshot.documents.forEach((document) {
    Cart cart = Cart.fromMap(document.data);
    _cartList.add(cart);
  });

  cartNotifier.cartList = _cartList;
}

//Adding item quantity, Price and updating data in cart
getProdProducts(ProductsNotifier productsNotifier) async {
  QuerySnapshot snapshot =
      await Firestore.instance.collection("food").getDocuments();

  List<ProdProducts> _prodProductsList = [];

  snapshot.documents.forEach((document) {
    ProdProducts prodProducts = ProdProducts.fromMap(document.data);

    _prodProductsList.add(prodProducts);
  });

  productsNotifier.productsList = _prodProductsList;
}

//Subtracting item quantity, Price and updating data in cart
removeItemFromCart(cartItem) async {
  final db = Firestore.instance;
  final uEmail = await AuthService().getCurrentEmail();
  // final uid = await AuthService().getCurrentUID();

  await db
      .collection("userCart")
      .document(uEmail)
      .collection("cartItems")
      .document(cartItem.productID)
      .delete();
}

//Removing item from cart
subAndApdateData(cartItem) async {
  final db = Firestore.instance;
  // final uid = await AuthService().getCurrentUID();
  final uEmail = await AuthService().getCurrentEmail();

  if (cartItem.quantity <= 1) {
    cartItem.quantity = cartItem.quantity = 1;
  } else {
    cartItem.quantity = cartItem.quantity - 1;
  }
  cartItem.totalPrice = cartItem.price * cartItem.quantity;

  CollectionReference cartRef =
      db.collection("userCart").document(uEmail).collection("cartItems");

  await cartRef.document(cartItem.productID).updateData(
    {'quantity': cartItem.quantity, 'totalPrice': cartItem.totalPrice},
  );
}
