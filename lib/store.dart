import 'package:flutter/foundation.dart';

const productCategories = <String>[
  'HP',
  'Laptop',
  'Tablet',
  'AC',
  'Kipas Angin',
  'TV',
  'Aksesori',
];

class Product {
  Product({
    required this.id,
    required this.name,
    required this.category,
    required this.price,
    required this.description,
    required this.rating,
    required this.stock,
    required this.imageUrl,
    this.featured = false,
  });

  final String id;
  String name;
  String category;
  int price;
  String description;
  double rating;
  int stock;
  String imageUrl;
  bool featured;
}

class CartLine {
  const CartLine({required this.productId, required this.quantity});

  final String productId;
  final int quantity;
}

class OrderLine {
  const OrderLine({
    required this.productId,
    required this.name,
    required this.price,
    required this.quantity,
    required this.imageUrl,
  });

  final String productId;
  final String name;
  final int price;
  final int quantity;
  final String imageUrl;
}

class ShopOrder {
  ShopOrder({
    required this.id,
    required this.customerName,
    required this.createdAt,
    required this.lines,
    required this.total,
    required this.paymentMethod,
    required this.shippingAddress,
    this.status = 'Diproses',
  });

  final String id;
  final String customerName;
  final DateTime createdAt;
  final List<OrderLine> lines;
  final int total;
  final String paymentMethod;
  final String shippingAddress;
  String status;
}

class StoreState extends ChangeNotifier {
  StoreState() : products = _initialProducts();

  final List<Product> products;
  final Map<String, int> _cart = {};
  final Set<String> _favorites = {};
  final List<ShopOrder> orders = [];
  final List<String> categories = List.of(productCategories);

  String? userEmail;
  String? userName;
  bool get isAdmin => userEmail == 'admin@electromart.com';
  bool get isLoggedIn => userEmail != null;

  List<Product> get availableProducts => products;
  List<String> get favoriteIds => _favorites.toList();
  bool isFavorite(String productId) => _favorites.contains(productId);
  int quantityInCart(String productId) => _cart[productId] ?? 0;
  int get cartItemCount =>
      _cart.values.fold(0, (sum, quantity) => sum + quantity);
  int get cartTotal => _cart.entries.fold(0, (sum, item) {
    final product = productById(item.key);
    return sum + (product?.price ?? 0) * item.value;
  });

  List<CartLine> get cartLines => _cart.entries
      .map((entry) => CartLine(productId: entry.key, quantity: entry.value))
      .toList();

  Product? productById(String id) {
    for (final product in products) {
      if (product.id == id) return product;
    }
    return null;
  }

  List<Product> productsFor({
    String? category,
    String query = '',
    bool onlyFavorites = false,
    String sort = 'Rekomendasi',
  }) {
    final normalizedQuery = query.trim().toLowerCase();
    final result = products.where((product) {
      final matchesCategory = category == null || product.category == category;
      final matchesQuery =
          normalizedQuery.isEmpty ||
          product.name.toLowerCase().contains(normalizedQuery) ||
          product.category.toLowerCase().contains(normalizedQuery);
      return matchesCategory &&
          matchesQuery &&
          (!onlyFavorites || _favorites.contains(product.id));
    }).toList();
    if (sort == 'Harga terendah') {
      result.sort((a, b) => a.price.compareTo(b.price));
    } else if (sort == 'Rating tertinggi') {
      result.sort((a, b) => b.rating.compareTo(a.rating));
    } else if (sort == 'Stok tersedia') {
      result.sort((a, b) => b.stock.compareTo(a.stock));
    } else {
      result.sort((a, b) => (b.featured ? 1 : 0).compareTo(a.featured ? 1 : 0));
    }
    return result;
  }

  bool login(String email, String password) {
    final normalizedEmail = email.trim().toLowerCase();
    if ((normalizedEmail == 'admin@electromart.com' &&
            password == 'admin123') ||
        (normalizedEmail == 'user@electromart.com' && password == 'user123')) {
      userEmail = normalizedEmail;
      userName = normalizedEmail.startsWith('admin')
          ? 'Admin ElectroMart'
          : 'Pelanggan';
      notifyListeners();
      return true;
    }
    return false;
  }

  void logout() {
    userEmail = null;
    userName = null;
    notifyListeners();
  }

  bool addToCart(String productId) {
    final product = productById(productId);
    if (product == null || product.stock <= quantityInCart(productId)) {
      return false;
    }
    _cart.update(productId, (quantity) => quantity + 1, ifAbsent: () => 1);
    notifyListeners();
    return true;
  }

  void changeCartQuantity(String productId, int quantity) {
    final product = productById(productId);
    if (quantity <= 0 || product == null) {
      _cart.remove(productId);
    } else {
      _cart[productId] = quantity.clamp(1, product.stock);
    }
    notifyListeners();
  }

  void toggleFavorite(String productId) {
    if (!_favorites.add(productId)) _favorites.remove(productId);
    notifyListeners();
  }

  bool checkout(String paymentMethod, {required String shippingAddress}) {
    if (_cart.isEmpty || shippingAddress.trim().isEmpty) return false;
    for (final entry in _cart.entries) {
      final product = productById(entry.key);
      if (product == null || product.stock < entry.value) return false;
    }
    final lines = _cart.entries.map((entry) {
      final product = productById(entry.key)!;
      product.stock -= entry.value;
      return OrderLine(
        productId: product.id,
        name: product.name,
        price: product.price,
        quantity: entry.value,
        imageUrl: product.imageUrl,
      );
    }).toList();
    orders.insert(
      0,
      ShopOrder(
        id: 'EM${DateTime.now().millisecondsSinceEpoch.toString().substring(7)}',
        customerName: userName ?? 'Pelanggan',
        createdAt: DateTime.now(),
        lines: lines,
        total: lines.fold(0, (sum, line) => sum + line.price * line.quantity),
        paymentMethod: paymentMethod,
        shippingAddress: shippingAddress.trim(),
      ),
    );
    _cart.clear();
    notifyListeners();
    return true;
  }

  void saveProduct(Product product) {
    final index = products.indexWhere((item) => item.id == product.id);
    if (index == -1) {
      products.insert(0, product);
    } else {
      products[index] = product;
    }
    if (!categories.contains(product.category)) {
      categories.add(product.category);
    }
    notifyListeners();
  }

  void deleteProduct(String productId) {
    products.removeWhere((product) => product.id == productId);
    _cart.remove(productId);
    _favorites.remove(productId);
    notifyListeners();
  }

  bool updateOrderStatus(String orderId, String status) {
    final index = orders.indexWhere((order) => order.id == orderId);
    if (index == -1) return false;
    final order = orders[index];
    if (order.status == status) return true;

    if (status == 'Dibatalkan' && order.status != 'Dibatalkan') {
      for (final line in order.lines) {
        final product = productById(line.productId);
        if (product != null) product.stock += line.quantity;
      }
    } else if (order.status == 'Dibatalkan' && status != 'Dibatalkan') {
      for (final line in order.lines) {
        final product = productById(line.productId);
        if (product == null || product.stock < line.quantity) return false;
      }
      for (final line in order.lines) {
        productById(line.productId)!.stock -= line.quantity;
      }
    }

    order.status = status;
    notifyListeners();
    return true;
  }

  bool addCategory(String category) {
    final value = category.trim();
    if (value.isEmpty ||
        categories.any((item) => item.toLowerCase() == value.toLowerCase())) {
      return false;
    }
    categories.add(value);
    notifyListeners();
    return true;
  }

  bool removeCategory(String category) {
    if (products.any((product) => product.category == category)) return false;
    categories.remove(category);
    notifyListeners();
    return true;
  }

  int get totalStock => products.fold(0, (sum, product) => sum + product.stock);
  int get lowStockCount =>
      products.where((product) => product.stock <= 5).length;
  int get totalRevenue => orders
      .where((order) => order.status != 'Dibatalkan')
      .fold(0, (sum, order) => sum + order.total);
}

List<Product> _initialProducts() {
  const phone =
      'https://images.unsplash.com/photo-1511707171634-5f897ff02aa9?auto=format&fit=crop&w=800&q=85';
  const laptop =
      'https://images.unsplash.com/photo-1496181133206-80ce9b88a853?auto=format&fit=crop&w=800&q=85';
  const tablet =
      'https://images.unsplash.com/photo-1544244015-0df4b3ffc6b0?auto=format&fit=crop&w=800&q=85';
  const cooling =
      'https://images.unsplash.com/photo-1631545806609-4b2f3f5b5e0d?auto=format&fit=crop&w=800&q=85';
  const fan =
      'https://images.unsplash.com/photo-1618941716939-553df3c6c278?auto=format&fit=crop&w=800&q=85';
  const tv =
      'https://images.unsplash.com/photo-1593359677879-a4bb92f829d1?auto=format&fit=crop&w=800&q=85';
  const accessories =
      'https://images.unsplash.com/photo-1505740420928-5e560c06d30e?auto=format&fit=crop&w=800&q=85';
  const descriptions = {
    'HP': 'Nikmati performa cepat, layar jernih, dan kamera tajam untuk aktivitas sehari-hari.',
    'Laptop': 'Laptop andal dengan performa responsif untuk produktivitas, belajar, dan hiburan.',
    'Tablet': 'Tablet ringan dengan layar luas yang nyaman untuk bekerja dan menikmati konten.',
    'AC': 'Pendingin ruangan hemat energi dengan kesejukan merata dan operasi senyap.',
    'Kipas Angin': 'Sirkulasi udara sejuk dengan desain modern dan pengaturan kecepatan fleksibel.',
    'TV': 'Pengalaman menonton imersif dengan gambar tajam dan warna yang lebih hidup.',
    'Aksesori':
        'Aksesori berkualitas dengan desain nyaman dan konektivitas praktis.',
  };
  final entries = <(String, String, int, String, double, int, String, bool)>[
    ('HP', 'Galaxy S24 Ultra', 19999000, phone, 4.9, 12, 'Samsung', true),
    ('HP', 'iPhone 15', 13999000, phone, 4.8, 18, 'Apple', true),
    ('HP', 'Xiaomi 14T', 6499000, phone, 4.7, 24, 'Xiaomi', false),
    ('HP', 'OPPO Reno 12', 5999000, phone, 4.6, 9, 'OPPO', false),
    ('Laptop', 'MacBook Air M3', 19999000, laptop, 4.9, 8, 'Apple', true),
    ('Laptop', 'ASUS Vivobook 14', 8999000, laptop, 4.7, 16, 'ASUS', true),
    (
      'Laptop',
      'Lenovo IdeaPad Slim 3',
      7499000,
      laptop,
      4.6,
      13,
      'Lenovo',
      false,
    ),
    ('Laptop', 'Acer Aspire 5', 8299000, laptop, 4.5, 6, 'Acer', false),
    ('Tablet', 'iPad Air 11', 10999000, tablet, 4.9, 10, 'Apple', true),
    ('Tablet', 'Galaxy Tab S9 FE', 7499000, tablet, 4.7, 14, 'Samsung', true),
    ('Tablet', 'Xiaomi Pad 6', 4999000, tablet, 4.6, 20, 'Xiaomi', false),
    ('Tablet', 'Lenovo Tab M11', 2799000, tablet, 4.4, 17, 'Lenovo', false),
    ('AC', 'Daikin 1 PK Inverter', 5999000, cooling, 4.8, 7, 'Daikin', true),
    ('AC', 'LG DualCool 1 PK', 5299000, cooling, 4.7, 11, 'LG', true),
    ('AC', 'Panasonic 1/2 PK', 3899000, cooling, 4.5, 8, 'Panasonic', false),
    ('AC', 'Sharp AH-A5', 3499000, cooling, 4.4, 5, 'Sharp', false),
    ('Kipas Angin', 'Miyako KAS-1627', 389000, fan, 4.5, 32, 'Miyako', true),
    ('Kipas Angin', 'Cosmos 16-SDB', 429000, fan, 4.6, 21, 'Cosmos', false),
    (
      'Kipas Angin',
      'Krisbow Tower Fan',
      1199000,
      fan,
      4.4,
      9,
      'Krisbow',
      false,
    ),
    (
      'Kipas Angin',
      'Panasonic F-EP404',
      899000,
      fan,
      4.7,
      4,
      'Panasonic',
      false,
    ),
    ('TV', 'Samsung Crystal UHD 55"', 8499000, tv, 4.8, 10, 'Samsung', true),
    ('TV', 'LG OLED evo 48"', 14999000, tv, 4.9, 5, 'LG', true),
    ('TV', 'Sony Bravia 4K 50"', 9999000, tv, 4.7, 7, 'Sony', false),
    ('TV', 'TCL QLED 43"', 4999000, tv, 4.5, 15, 'TCL', false),
    (
      'Aksesori',
      'Sony WH-1000XM5',
      4999000,
      accessories,
      4.9,
      12,
      'Sony',
      true,
    ),
    ('Aksesori', 'JBL Tune 510BT', 699000, accessories, 4.6, 28, 'JBL', false),
    (
      'Aksesori',
      'Logitech MX Master 3S',
      1699000,
      accessories,
      4.8,
      16,
      'Logitech',
      true,
    ),
    (
      'Aksesori',
      'Anker PowerCore 20K',
      599000,
      accessories,
      4.5,
      23,
      'Anker',
      false,
    ),
  ];
  return List.generate(entries.length, (index) {
    final entry = entries[index];
    return Product(
      id: 'EM${(index + 1).toString().padLeft(3, '0')}',
      category: entry.$1,
      name: entry.$2,
      price: entry.$3,
      imageUrl: entry.$4,
      rating: entry.$5,
      stock: entry.$6,
      description:
          '${entry.$7}. ${descriptions[entry.$1]} Garansi resmi dan layanan purna jual terpercaya.',
      featured: entry.$8,
    );
  });
}
