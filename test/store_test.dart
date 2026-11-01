import 'package:flutter_test/flutter_test.dart';
import 'package:electromart/store.dart';

void main() {
  group('StoreState', () {
    late StoreState store;

    setUp(() {
      store = StoreState();
    });

    test('menyediakan katalog dummy dari seluruh kategori', () {
      expect(store.products.length, greaterThanOrEqualTo(25));
      expect(store.categories, containsAll(productCategories));
    });

    test('checkout menghitung total dan menyinkronkan stok serta pesanan', () {
      expect(store.login('user@electromart.com', 'user123'), isTrue);
      final firstProduct = store.products.first;
      final secondProduct = store.products[1];
      final firstStock = firstProduct.stock;
      final secondStock = secondProduct.stock;

      expect(store.addToCart(firstProduct.id), isTrue);
      expect(store.addToCart(firstProduct.id), isTrue);
      expect(store.addToCart(secondProduct.id), isTrue);
      final expectedTotal = firstProduct.price * 2 + secondProduct.price;
      expect(store.cartTotal, expectedTotal);

      expect(
        store.checkout('E-wallet', shippingAddress: 'Jalan Merdeka No. 10'),
        isTrue,
      );
      expect(firstProduct.stock, firstStock - 2);
      expect(secondProduct.stock, secondStock - 1);
      expect(store.cartItemCount, 0);
      expect(store.orders.single.total, expectedTotal);
      expect(store.orders.single.paymentMethod, 'E-wallet');
      expect(store.orders.single.shippingAddress, 'Jalan Merdeka No. 10');

      expect(
        store.updateOrderStatus(store.orders.single.id, 'Dibatalkan'),
        isTrue,
      );
      expect(firstProduct.stock, firstStock);
      expect(secondProduct.stock, secondStock);
      expect(
        store.updateOrderStatus(store.orders.single.id, 'Diproses'),
        isTrue,
      );
      expect(firstProduct.stock, firstStock - 2);
    });

    test('stok membatasi jumlah produk di keranjang', () {
      final product = store.products.first;
      product.stock = 1;

      expect(store.addToCart(product.id), isTrue);
      expect(store.addToCart(product.id), isFalse);
      expect(store.quantityInCart(product.id), 1);
    });

    test('kategori yang masih dipakai produk tidak dapat dihapus', () {
      expect(store.removeCategory(productCategories.first), isFalse);
      expect(store.addCategory('Konsol'), isTrue);
      expect(store.removeCategory('Konsol'), isTrue);
    });
  });
}
