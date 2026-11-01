import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'store.dart';

const _navy = Color(0xFF102345);
const _blue = Color(0xFF2563EB);
const _muted = Color(0xFF718096);
const _line = Color(0xFFE9EDF3);

String rupiah(int amount) {
  final digits = amount.toString();
  final grouped = digits.replaceAllMapped(
    RegExp(r'\B(?=(\d{3})+(?!\d))'),
    (_) => '.',
  );
  return 'Rp$grouped';
}

String dateLabel(DateTime date) =>
    '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _email = TextEditingController();
  final _password = TextEditingController();
  bool _obscure = true;
  String? _error;

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  void _login({String? email, String? password}) {
    final chosenEmail = email ?? _email.text;
    final chosenPassword = password ?? _password.text;
    if (context.read<StoreState>().login(chosenEmail, chosenPassword)) {
      setState(() => _error = null);
    } else {
      setState(() => _error = 'Email atau kata sandi tidak sesuai.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<StoreState>(
      builder: (context, store, _) {
        if (store.isLoggedIn) {
          return store.isAdmin ? const AdminShell() : const ShopShell();
        }
        return Scaffold(
          body: SafeArea(
            child: LayoutBuilder(
              builder: (context, constraints) {
                final content = Center(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(24),
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 430),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: 58,
                            height: 58,
                            decoration: BoxDecoration(
                              color: _navy,
                              borderRadius: BorderRadius.circular(18),
                            ),
                            child: const Icon(
                              Icons.bolt_rounded,
                              color: Colors.white,
                              size: 34,
                            ),
                          ),
                          const SizedBox(height: 27),
                          const Text(
                            'Belanja elektronik,\nlebih mudah.',
                            style: TextStyle(
                              fontSize: 30,
                              height: 1.18,
                              fontWeight: FontWeight.w800,
                              color: _navy,
                            ),
                          ),
                          const SizedBox(height: 10),
                          const Text(
                            'Temukan perangkat favoritmu di ElectroMart.',
                            style: TextStyle(color: _muted, fontSize: 15),
                          ),
                          const SizedBox(height: 30),
                          const Text(
                            'Masuk ke akun',
                            style: TextStyle(
                              fontSize: 18,
                              color: _navy,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: 15),
                          TextField(
                            controller: _email,
                            keyboardType: TextInputType.emailAddress,
                            decoration: const InputDecoration(
                              labelText: 'Email',
                              prefixIcon: Icon(Icons.email_outlined),
                            ),
                          ),
                          const SizedBox(height: 12),
                          TextField(
                            controller: _password,
                            obscureText: _obscure,
                            decoration: InputDecoration(
                              labelText: 'Kata sandi',
                              prefixIcon: const Icon(Icons.lock_outline),
                              suffixIcon: IconButton(
                                onPressed: () =>
                                    setState(() => _obscure = !_obscure),
                                icon: Icon(
                                  _obscure
                                      ? Icons.visibility_outlined
                                      : Icons.visibility_off_outlined,
                                ),
                              ),
                            ),
                            onSubmitted: (_) => _login(),
                          ),
                          if (_error != null) ...[
                            const SizedBox(height: 10),
                            Text(
                              _error!,
                              style: const TextStyle(color: Colors.red),
                            ),
                          ],
                          const SizedBox(height: 18),
                          SizedBox(
                            width: double.infinity,
                            height: 52,
                            child: FilledButton(
                              onPressed: _login,
                              style: FilledButton.styleFrom(
                                backgroundColor: _navy,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(14),
                                ),
                              ),
                              child: const Text(
                                'Masuk',
                                style: TextStyle(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 15,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 23),
                          const Row(
                            children: [
                              Expanded(child: Divider()),
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 12),
                                child: Text(
                                  'AKUN DEMO',
                                  style: TextStyle(
                                    color: _muted,
                                    fontSize: 11,
                                    fontWeight: FontWeight.w700,
                                    letterSpacing: 1,
                                  ),
                                ),
                              ),
                              Expanded(child: Divider()),
                            ],
                          ),
                          const SizedBox(height: 14),
                          Row(
                            children: [
                              Expanded(
                                child: _DemoButton(
                                  label: 'Masuk sebagai User',
                                  icon: Icons.person_outline,
                                  onPressed: () => _login(
                                    email: 'user@electromart.com',
                                    password: 'user123',
                                  ),
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: _DemoButton(
                                  label: 'Masuk sebagai Admin',
                                  icon: Icons.admin_panel_settings_outlined,
                                  onPressed: () => _login(
                                    email: 'admin@electromart.com',
                                    password: 'admin123',
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                );
                return constraints.maxWidth > 700
                    ? Row(
                        children: [
                          Expanded(
                            child: Container(
                              color: _navy,
                              padding: const EdgeInsets.all(54),
                              child: const Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Icon(
                                    Icons.bolt_rounded,
                                    color: Colors.white,
                                    size: 54,
                                  ),
                                  SizedBox(height: 24),
                                  Text(
                                    'Teknologi terbaik\nuntuk setiap hari.',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 38,
                                      height: 1.15,
                                      fontWeight: FontWeight.w800,
                                    ),
                                  ),
                                  SizedBox(height: 14),
                                  Text(
                                    'Pilihan elektronik tepercaya, harga bersahabat.',
                                    style: TextStyle(
                                      color: Color(0xFFCFD9EA),
                                      fontSize: 16,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Expanded(child: content),
                        ],
                      )
                    : content;
              },
            ),
          ),
        );
      },
    );
  }
}

class _DemoButton extends StatelessWidget {
  const _DemoButton({
    required this.label,
    required this.icon,
    required this.onPressed,
  });

  final String label;
  final IconData icon;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return OutlinedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon, size: 17),
      label: Text(label, style: const TextStyle(fontSize: 11)),
      style: OutlinedButton.styleFrom(
        foregroundColor: _navy,
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 13),
        side: const BorderSide(color: _line),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }
}

class ShopShell extends StatefulWidget {
  const ShopShell({super.key});

  @override
  State<ShopShell> createState() => _ShopShellState();
}

class _ShopShellState extends State<ShopShell> {
  int _tab = 0;
  String _query = '';
  String? _category;

  void _openCategory(String category) {
    setState(() {
      _category = category;
      _tab = 1;
    });
  }

  @override
  Widget build(BuildContext context) {
    final titles = ['ElectroMart', 'Jelajahi produk', 'Favorit saya', 'Profil'];
    return Scaffold(
      appBar: AppBar(
        title: _tab == 0
            ? Row(
                children: [
                  const Icon(Icons.bolt_rounded, color: _blue),
                  const SizedBox(width: 5),
                  Text(
                    titles[_tab],
                    style: const TextStyle(fontWeight: FontWeight.w800),
                  ),
                ],
              )
            : Text(
                titles[_tab],
                style: const TextStyle(fontWeight: FontWeight.w800),
              ),
        actions: [
          Consumer<StoreState>(
            builder: (context, store, _) => IconButton(
              tooltip: 'Keranjang',
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const CartScreen()),
              ),
              icon: Badge(
                isLabelVisible: store.cartItemCount > 0,
                label: Text('${store.cartItemCount}'),
                child: const Icon(Icons.shopping_bag_outlined),
              ),
            ),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SafeArea(
        child: IndexedStack(
          index: _tab,
          children: [
            HomeTab(
              query: _query,
              onQuery: (value) => setState(() => _query = value),
              onCategory: _openCategory,
              onBrowse: () => setState(() => _tab = 1),
            ),
            CatalogTab(
              query: _query,
              category: _category,
              onQuery: (value) => setState(() => _query = value),
              onCategory: (value) => setState(() => _category = value),
            ),
            const FavoritesTab(),
            ProfileTab(onFavorites: () => setState(() => _tab = 2)),
          ],
        ),
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _tab,
        onDestinationSelected: (index) => setState(() => _tab = index),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home_rounded),
            label: 'Beranda',
          ),
          NavigationDestination(
            icon: Icon(Icons.grid_view_outlined),
            selectedIcon: Icon(Icons.grid_view_rounded),
            label: 'Jelajah',
          ),
          NavigationDestination(
            icon: Icon(Icons.favorite_border),
            selectedIcon: Icon(Icons.favorite),
            label: 'Favorit',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline),
            selectedIcon: Icon(Icons.person),
            label: 'Profil',
          ),
        ],
      ),
    );
  }
}

class HomeTab extends StatelessWidget {
  const HomeTab({
    required this.query,
    required this.onQuery,
    required this.onCategory,
    required this.onBrowse,
    super.key,
  });

  final String query;
  final ValueChanged<String> onQuery;
  final ValueChanged<String> onCategory;
  final VoidCallback onBrowse;

  @override
  Widget build(BuildContext context) {
    return Consumer<StoreState>(
      builder: (context, store, _) => ListView(
        padding: const EdgeInsets.fromLTRB(18, 8, 18, 24),
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [_navy, Color(0xFF21467B)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(22),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'PROMO SPESIAL',
                  style: TextStyle(
                    color: Color(0xFF9FC4FF),
                    fontSize: 11,
                    letterSpacing: 1.5,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 9),
                const Text(
                  'Upgrade teknologi,\nnikmati lebih banyak.',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 23,
                    height: 1.2,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Temukan perangkat pilihan untukmu.',
                  style: TextStyle(color: Color(0xFFD8E5F8), fontSize: 13),
                ),
                const SizedBox(height: 15),
                FilledButton(
                  onPressed: onBrowse,
                  style: FilledButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: _navy,
                    minimumSize: const Size(120, 40),
                  ),
                  child: const Text('Belanja sekarang'),
                ),
              ],
            ),
          ),
          const SizedBox(height: 19),
          SearchField(value: query, onChanged: onQuery),
          const SizedBox(height: 23),
          SectionHeading(
            title: 'Kategori',
            action: 'Lihat semua',
            onAction: onBrowse,
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 92,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: store.categories.length,
              separatorBuilder: (_, _) => const SizedBox(width: 12),
              itemBuilder: (context, index) {
                final category = store.categories[index];
                return CategoryTile(
                  category: category,
                  onTap: () => onCategory(category),
                );
              },
            ),
          ),
          const SizedBox(height: 22),
          SectionHeading(
            title: query.isEmpty ? 'Pilihan untukmu' : 'Hasil pencarian',
            action: 'Lihat semua',
            onAction: onBrowse,
          ),
          const SizedBox(height: 12),
          ProductGrid(
            products: store.productsFor(query: query).take(6).toList(),
          ),
        ],
      ),
    );
  }
}

class CatalogTab extends StatefulWidget {
  const CatalogTab({
    required this.query,
    required this.category,
    required this.onQuery,
    required this.onCategory,
    super.key,
  });

  final String query;
  final String? category;
  final ValueChanged<String> onQuery;
  final ValueChanged<String?> onCategory;

  @override
  State<CatalogTab> createState() => _CatalogTabState();
}

class _CatalogTabState extends State<CatalogTab> {
  String _sort = 'Rekomendasi';

  @override
  Widget build(BuildContext context) {
    return Consumer<StoreState>(
      builder: (context, store, _) {
        final products = store.productsFor(
          category: widget.category,
          query: widget.query,
          sort: _sort,
        );
        return ListView(
          padding: const EdgeInsets.fromLTRB(18, 8, 18, 22),
          children: [
            SearchField(value: widget.query, onChanged: widget.onQuery),
            const SizedBox(height: 14),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: ChoiceChip(
                      label: const Text('Semua'),
                      selected: widget.category == null,
                      onSelected: (_) => widget.onCategory(null),
                    ),
                  ),
                  ...store.categories.map(
                    (category) => Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: ChoiceChip(
                        label: Text(category),
                        selected: widget.category == category,
                        onSelected: (_) => widget.onCategory(category),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Text(
                  '${products.length} produk',
                  style: const TextStyle(color: _muted, fontSize: 13),
                ),
                const Spacer(),
                PopupMenuButton<String>(
                  initialValue: _sort,
                  onSelected: (value) => setState(() => _sort = value),
                  itemBuilder: (_) => const [
                    PopupMenuItem(
                      value: 'Rekomendasi',
                      child: Text('Rekomendasi'),
                    ),
                    PopupMenuItem(
                      value: 'Harga terendah',
                      child: Text('Harga terendah'),
                    ),
                    PopupMenuItem(
                      value: 'Rating tertinggi',
                      child: Text('Rating tertinggi'),
                    ),
                    PopupMenuItem(
                      value: 'Stok tersedia',
                      child: Text('Stok tersedia'),
                    ),
                  ],
                  child: const Padding(
                    padding: EdgeInsets.symmetric(vertical: 8),
                    child: Row(
                      children: [
                        Icon(Icons.tune_rounded, size: 18, color: _navy),
                        SizedBox(width: 5),
                        Text('Urutkan', style: TextStyle(color: _navy)),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            ProductGrid(products: products),
          ],
        );
      },
    );
  }
}

class FavoritesTab extends StatelessWidget {
  const FavoritesTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<StoreState>(
      builder: (context, store, _) {
        final products = store.productsFor(onlyFavorites: true);
        if (products.isEmpty) {
          return const EmptyState(
            icon: Icons.favorite_border,
            title: 'Belum ada produk favorit',
            subtitle: 'Tekan ikon hati pada produk yang kamu suka.',
          );
        }
        return ListView(
          padding: const EdgeInsets.all(18),
          children: [ProductGrid(products: products)],
        );
      },
    );
  }
}

class ProductGrid extends StatelessWidget {
  const ProductGrid({required this.products, super.key});

  final List<Product> products;

  @override
  Widget build(BuildContext context) {
    if (products.isEmpty) {
      return const Padding(
        padding: EdgeInsets.only(top: 60),
        child: EmptyState(
          icon: Icons.search_off_rounded,
          title: 'Produk tidak ditemukan',
          subtitle: 'Coba kata kunci atau kategori lain.',
        ),
      );
    }
    return LayoutBuilder(
      builder: (context, constraints) {
        final columns = constraints.maxWidth > 700 ? 4 : 2;
        return GridView.builder(
          itemCount: products.length,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: columns,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            mainAxisExtent: 252,
          ),
          itemBuilder: (context, index) =>
              ProductCard(product: products[index]),
        );
      },
    );
  }
}

class ProductCard extends StatelessWidget {
  const ProductCard({required this.product, super.key});

  final Product product;

  @override
  Widget build(BuildContext context) {
    return Consumer<StoreState>(
      builder: (context, store, _) => InkWell(
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => ProductDetailScreen(productId: product.id),
          ),
        ),
        borderRadius: BorderRadius.circular(17),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(17),
            border: Border.all(color: _line),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(17),
                    ),
                    child: ProductImage(
                      product: product,
                      height: 132,
                      width: double.infinity,
                    ),
                  ),
                  Positioned(
                    top: 8,
                    right: 8,
                    child: Material(
                      color: Colors.white.withValues(alpha: .94),
                      shape: const CircleBorder(),
                      child: IconButton(
                        visualDensity: VisualDensity.compact,
                        onPressed: () => store.toggleFavorite(product.id),
                        icon: Icon(
                          store.isFavorite(product.id)
                              ? Icons.favorite
                              : Icons.favorite_border,
                          color: store.isFavorite(product.id)
                              ? Colors.red
                              : _navy,
                          size: 19,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(11, 9, 11, 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      product.category.toUpperCase(),
                      maxLines: 1,
                      style: const TextStyle(
                        color: _muted,
                        fontSize: 9,
                        letterSpacing: .7,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      product.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: _navy,
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      rupiah(product.price),
                      style: const TextStyle(
                        color: _blue,
                        fontWeight: FontWeight.w800,
                        fontSize: 13,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Row(
                      children: [
                        const Icon(
                          Icons.star_rounded,
                          color: Color(0xFFF4AE36),
                          size: 14,
                        ),
                        const SizedBox(width: 2),
                        Text(
                          '${product.rating}  ·  Stok ${product.stock}',
                          style: const TextStyle(color: _muted, fontSize: 10),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ProductImage extends StatelessWidget {
  const ProductImage({
    required this.product,
    this.height,
    this.width,
    super.key,
  });

  final Product product;
  final double? height;
  final double? width;

  @override
  Widget build(BuildContext context) {
    return Image.network(
      product.imageUrl,
      height: height,
      width: width,
      fit: BoxFit.cover,
      errorBuilder: (_, _, _) => _fallback(),
      loadingBuilder: (context, child, progress) {
        if (progress == null) return child;
        return Container(
          height: height,
          width: width,
          color: const Color(0xFFF0F4FA),
          alignment: Alignment.center,
          child: const SizedBox(
            width: 22,
            height: 22,
            child: CircularProgressIndicator(strokeWidth: 2),
          ),
        );
      },
    );
  }

  Widget _fallback() => Container(
    height: height,
    width: width,
    color: const Color(0xFFF0F4FA),
    alignment: Alignment.center,
    child: Icon(
      _categoryIcon(product.category),
      size: 48,
      color: const Color(0xFF9AAAC0),
    ),
  );
}

class ProductDetailScreen extends StatelessWidget {
  const ProductDetailScreen({required this.productId, super.key});

  final String productId;

  @override
  Widget build(BuildContext context) {
    return Consumer<StoreState>(
      builder: (context, store, _) {
        final product = store.productById(productId);
        if (product == null) {
          return Scaffold(
            appBar: AppBar(),
            body: const EmptyState(
              icon: Icons.inventory_2_outlined,
              title: 'Produk tidak tersedia',
              subtitle: 'Produk ini mungkin telah dihapus.',
            ),
          );
        }
        return Scaffold(
          appBar: AppBar(
            title: const Text('Detail produk'),
            actions: [
              IconButton(
                onPressed: () => store.toggleFavorite(product.id),
                icon: Icon(
                  store.isFavorite(product.id)
                      ? Icons.favorite
                      : Icons.favorite_border,
                  color: store.isFavorite(product.id) ? Colors.red : _navy,
                ),
              ),
            ],
          ),
          body: ListView(
            padding: const EdgeInsets.fromLTRB(18, 0, 18, 24),
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(22),
                child: ProductImage(
                  product: product,
                  width: double.infinity,
                  height: 290,
                ),
              ),
              const SizedBox(height: 19),
              Text(
                product.category.toUpperCase(),
                style: const TextStyle(
                  color: _blue,
                  letterSpacing: 1,
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                product.name,
                style: const TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.w800,
                  color: _navy,
                ),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  const Icon(
                    Icons.star_rounded,
                    size: 19,
                    color: Color(0xFFF4AE36),
                  ),
                  Text(' ${product.rating}  ·  Tersedia ${product.stock}'),
                  const Spacer(),
                  Text(
                    rupiah(product.price),
                    style: const TextStyle(
                      fontSize: 21,
                      color: _blue,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 22),
              const Text(
                'Deskripsi produk',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 8),
              Text(
                product.description,
                style: const TextStyle(
                  color: _muted,
                  height: 1.6,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                height: 52,
                child: FilledButton.icon(
                  onPressed: product.stock <= store.quantityInCart(product.id)
                      ? null
                      : () {
                          store.addToCart(product.id);
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Produk ditambahkan ke keranjang.'),
                            ),
                          );
                        },
                  icon: const Icon(Icons.shopping_bag_outlined),
                  label: Text(
                    product.stock <= store.quantityInCart(product.id)
                        ? 'Stok tidak tersedia'
                        : 'Tambah ke keranjang',
                  ),
                  style: FilledButton.styleFrom(
                    backgroundColor: _navy,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<StoreState>(
      builder: (context, store, _) => Scaffold(
        appBar: AppBar(title: const Text('Keranjang')),
        body: store.cartLines.isEmpty
            ? const EmptyState(
                icon: Icons.shopping_bag_outlined,
                title: 'Keranjang masih kosong',
                subtitle: 'Yuk, temukan produk elektronik favoritmu.',
              )
            : ListView(
                padding: const EdgeInsets.fromLTRB(18, 8, 18, 120),
                children: [
                  ...store.cartLines.map((line) {
                    final product = store.productById(line.productId);
                    if (product == null) return const SizedBox.shrink();
                    return CartProductTile(
                      product: product,
                      quantity: line.quantity,
                    );
                  }),
                  const SizedBox(height: 10),
                  Container(
                    padding: const EdgeInsets.all(17),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: _line),
                    ),
                    child: Column(
                      children: [
                        SummaryRow(
                          label: 'Subtotal',
                          value: rupiah(store.cartTotal),
                        ),
                        const SizedBox(height: 10),
                        const SummaryRow(
                          label: 'Ongkos kirim',
                          value: 'Gratis',
                        ),
                        const Divider(height: 23),
                        SummaryRow(
                          label: 'Total pembayaran',
                          value: rupiah(store.cartTotal),
                          strong: true,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
        bottomSheet: store.cartLines.isEmpty
            ? null
            : SafeArea(
                child: Container(
                  padding: const EdgeInsets.fromLTRB(18, 12, 18, 14),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    border: Border(top: BorderSide(color: _line)),
                  ),
                  child: SizedBox(
                    height: 50,
                    width: double.infinity,
                    child: FilledButton(
                      onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const CheckoutScreen(),
                        ),
                      ),
                      style: FilledButton.styleFrom(backgroundColor: _navy),
                      child: Text(
                        'Lanjut checkout · ${rupiah(store.cartTotal)}',
                      ),
                    ),
                  ),
                ),
              ),
      ),
    );
  }
}

class CartProductTile extends StatelessWidget {
  const CartProductTile({
    required this.product,
    required this.quantity,
    super.key,
  });

  final Product product;
  final int quantity;

  @override
  Widget build(BuildContext context) {
    final store = context.read<StoreState>();
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(11),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: _line),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(11),
            child: ProductImage(product: product, width: 76, height: 76),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product.name,
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    color: _navy,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  rupiah(product.price),
                  style: const TextStyle(
                    color: _blue,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    _QuantityButton(
                      icon: Icons.remove,
                      onPressed: () =>
                          store.changeCartQuantity(product.id, quantity - 1),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 13),
                      child: Text(
                        '$quantity',
                        style: const TextStyle(fontWeight: FontWeight.w700),
                      ),
                    ),
                    _QuantityButton(
                      icon: Icons.add,
                      onPressed: quantity >= product.stock
                          ? null
                          : () => store.changeCartQuantity(
                              product.id,
                              quantity + 1,
                            ),
                    ),
                    const Spacer(),
                    IconButton(
                      visualDensity: VisualDensity.compact,
                      onPressed: () => store.changeCartQuantity(product.id, 0),
                      icon: const Icon(
                        Icons.delete_outline,
                        color: Colors.redAccent,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _QuantityButton extends StatelessWidget {
  const _QuantityButton({required this.icon, required this.onPressed});

  final IconData icon;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 27,
      height: 27,
      child: IconButton.filledTonal(
        padding: EdgeInsets.zero,
        visualDensity: VisualDensity.compact,
        onPressed: onPressed,
        icon: Icon(icon, size: 16),
      ),
    );
  }
}

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  String _payment = 'Transfer bank';
  final _address = TextEditingController();
  bool _busy = false;

  @override
  void dispose() {
    _address.dispose();
    super.dispose();
  }

  Future<void> _pay() async {
    if (_address.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Lengkapi alamat pengiriman terlebih dahulu.'),
        ),
      );
      return;
    }
    setState(() => _busy = true);
    final success = context.read<StoreState>().checkout(
      _payment,
      shippingAddress: _address.text,
    );
    if (!mounted) return;
    setState(() => _busy = false);
    if (!success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Checkout gagal. Periksa stok produk di keranjang.'),
        ),
      );
      return;
    }
    await showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        icon: const Icon(
          Icons.check_circle,
          color: Color(0xFF16A36A),
          size: 44,
        ),
        title: const Text('Pesanan berhasil!'),
        content: Text(
          'Pembayaran simulasi melalui $_payment berhasil. Pesananmu sedang diproses.',
        ),
        actions: [
          FilledButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Selesai'),
          ),
        ],
      ),
    );
    if (mounted) {
      Navigator.popUntil(context, (route) => route.isFirst);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<StoreState>(
      builder: (context, store, _) => Scaffold(
        appBar: AppBar(title: const Text('Checkout')),
        body: ListView(
          padding: const EdgeInsets.fromLTRB(18, 8, 18, 24),
          children: [
            const _FormSectionTitle(
              icon: Icons.location_on_outlined,
              title: 'Alamat pengiriman',
            ),
            const SizedBox(height: 11),
            TextField(
              controller: _address,
              maxLines: 3,
              decoration: const InputDecoration(
                hintText: 'Nama jalan, nomor rumah, kecamatan, kota',
                alignLabelWithHint: true,
              ),
            ),
            const SizedBox(height: 24),
            const _FormSectionTitle(
              icon: Icons.account_balance_wallet_outlined,
              title: 'Metode pembayaran',
            ),
            const SizedBox(height: 10),
            RadioGroup<String>(
              groupValue: _payment,
              onChanged: (value) => setState(() => _payment = value!),
              child: Column(
                children:
                    [
                          ('Transfer bank', Icons.account_balance_outlined),
                          ('E-wallet', Icons.wallet_outlined),
                          ('COD', Icons.local_shipping_outlined),
                        ]
                        .map(
                          (method) => RadioListTile<String>(
                            value: method.$1,
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 12,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                              side: const BorderSide(color: _line),
                            ),
                            title: Text(
                              method.$1,
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            secondary: Icon(method.$2, color: _blue),
                          ),
                        )
                        .toList(),
              ),
            ),
            const SizedBox(height: 22),
            const _FormSectionTitle(
              icon: Icons.receipt_long_outlined,
              title: 'Ringkasan pesanan',
            ),
            const SizedBox(height: 11),
            ...store.cartLines.map((line) {
              final product = store.productById(line.productId);
              if (product == null) return const SizedBox.shrink();
              return SummaryRow(
                label: '${product.name} × ${line.quantity}',
                value: rupiah(product.price * line.quantity),
              );
            }),
            const Divider(height: 26),
            SummaryRow(
              label: 'Total pembayaran',
              value: rupiah(store.cartTotal),
              strong: true,
            ),
            const SizedBox(height: 22),
            SizedBox(
              height: 52,
              child: FilledButton(
                onPressed: _busy ? null : _pay,
                style: FilledButton.styleFrom(backgroundColor: _navy),
                child: _busy
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : Text('Bayar ${rupiah(store.cartTotal)}'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ProfileTab extends StatelessWidget {
  const ProfileTab({required this.onFavorites, super.key});

  final VoidCallback onFavorites;

  @override
  Widget build(BuildContext context) {
    return Consumer<StoreState>(
      builder: (context, store, _) => ListView(
        padding: const EdgeInsets.all(18),
        children: [
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: _navy,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              children: [
                const CircleAvatar(
                  radius: 27,
                  backgroundColor: Color(0xFF294774),
                  child: Icon(Icons.person, color: Colors.white, size: 27),
                ),
                const SizedBox(width: 13),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      store.userName ?? 'Pelanggan',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      store.userEmail ?? '',
                      style: const TextStyle(
                        color: Color(0xFFCBD8ED),
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 21),
          const Text(
            'Akun saya',
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w700,
              color: _navy,
            ),
          ),
          const SizedBox(height: 10),
          _ProfileAction(
            icon: Icons.receipt_long_outlined,
            title: 'Riwayat pesanan',
            subtitle: '${store.orders.length} pesanan',
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const OrderHistoryScreen()),
            ),
          ),
          _ProfileAction(
            icon: Icons.favorite_border,
            title: 'Produk favorit',
            subtitle: '${store.favoriteIds.length} produk',
            onTap: onFavorites,
          ),
          _ProfileAction(
            icon: Icons.info_outline,
            title: 'Tentang ElectroMart',
            subtitle: 'Belanja elektronik tepercaya',
            onTap: () => showAboutDialog(
              context: context,
              applicationName: 'ElectroMart',
              applicationVersion: '1.0.0',
              children: const [
                Text(
                  'Aplikasi demo toko elektronik untuk tugas akhir Mobile Programming.',
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          OutlinedButton.icon(
            onPressed: store.logout,
            icon: const Icon(Icons.logout),
            label: const Text('Keluar dari akun'),
            style: OutlinedButton.styleFrom(
              foregroundColor: Colors.redAccent,
              padding: const EdgeInsets.symmetric(vertical: 14),
              side: const BorderSide(color: Color(0xFFFFD8D8)),
            ),
          ),
        ],
      ),
    );
  }
}

class OrderHistoryScreen extends StatelessWidget {
  const OrderHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<StoreState>(
      builder: (context, store, _) => Scaffold(
        appBar: AppBar(title: const Text('Riwayat pesanan')),
        body: store.orders.isEmpty
            ? const EmptyState(
                icon: Icons.receipt_long_outlined,
                title: 'Belum ada pesanan',
                subtitle: 'Pesanan yang berhasil dibuat akan tampil di sini.',
              )
            : ListView.separated(
                padding: const EdgeInsets.all(18),
                itemCount: store.orders.length,
                separatorBuilder: (_, _) => const SizedBox(height: 12),
                itemBuilder: (context, index) =>
                    OrderCard(order: store.orders[index]),
              ),
      ),
    );
  }
}

class OrderCard extends StatelessWidget {
  const OrderCard({required this.order, super.key});

  final ShopOrder order;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: _line),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  'Pesanan #${order.id}',
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    color: _navy,
                  ),
                ),
              ),
              StatusPill(status: order.status),
            ],
          ),
          const SizedBox(height: 7),
          Text(
            dateLabel(order.createdAt),
            style: const TextStyle(color: _muted, fontSize: 12),
          ),
          const SizedBox(height: 4),
          Text(
            'Pelanggan: ${order.customerName}',
            style: const TextStyle(color: _muted, fontSize: 12),
          ),
          const SizedBox(height: 4),
          Text(
            order.shippingAddress,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(color: _muted, fontSize: 12),
          ),
          const Divider(height: 22),
          ...order.lines.map(
            (line) => Padding(
              padding: const EdgeInsets.only(bottom: 7),
              child: SummaryRow(
                label: '${line.name} × ${line.quantity}',
                value: rupiah(line.price * line.quantity),
              ),
            ),
          ),
          const Divider(height: 17),
          SummaryRow(
            label: order.paymentMethod,
            value: rupiah(order.total),
            strong: true,
          ),
        ],
      ),
    );
  }
}

class AdminShell extends StatefulWidget {
  const AdminShell({super.key});

  @override
  State<AdminShell> createState() => _AdminShellState();
}

class _AdminShellState extends State<AdminShell> {
  int _tab = 0;

  @override
  Widget build(BuildContext context) {
    final titles = ['Dashboard Admin', 'Produk', 'Kategori', 'Pesanan'];
    return Scaffold(
      appBar: AppBar(
        title: Text(
          titles[_tab],
          style: const TextStyle(fontWeight: FontWeight.w800),
        ),
        actions: [
          IconButton(
            tooltip: 'Keluar',
            onPressed: context.read<StoreState>().logout,
            icon: const Icon(Icons.logout),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SafeArea(
        child: IndexedStack(
          index: _tab,
          children: const [
            AdminDashboard(),
            AdminProductsTab(),
            AdminCategoriesTab(),
            AdminOrdersTab(),
          ],
        ),
      ),
      floatingActionButton: _tab == 1
          ? FloatingActionButton.extended(
              backgroundColor: _navy,
              foregroundColor: Colors.white,
              onPressed: () => showProductForm(context),
              icon: const Icon(Icons.add),
              label: const Text('Tambah produk'),
            )
          : null,
      bottomNavigationBar: NavigationBar(
        selectedIndex: _tab,
        onDestinationSelected: (index) => setState(() => _tab = index),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.dashboard_outlined),
            label: 'Dashboard',
          ),
          NavigationDestination(
            icon: Icon(Icons.inventory_2_outlined),
            label: 'Produk',
          ),
          NavigationDestination(
            icon: Icon(Icons.category_outlined),
            label: 'Kategori',
          ),
          NavigationDestination(
            icon: Icon(Icons.receipt_long_outlined),
            label: 'Pesanan',
          ),
        ],
      ),
    );
  }
}

class AdminDashboard extends StatelessWidget {
  const AdminDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<StoreState>(
      builder: (context, store, _) => ListView(
        padding: const EdgeInsets.all(18),
        children: [
          Container(
            padding: const EdgeInsets.all(19),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [_navy, Color(0xFF244A7F)],
              ),
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Selamat datang, Admin!',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                SizedBox(height: 5),
                Text(
                  'Pantau performa toko ElectroMart hari ini.',
                  style: TextStyle(color: Color(0xFFCFD9EA)),
                ),
              ],
            ),
          ),
          const SizedBox(height: 17),
          LayoutBuilder(
            builder: (context, constraints) {
              final columns = constraints.maxWidth > 650 ? 4 : 2;
              final metrics = [
                (
                  'Total produk',
                  '${store.products.length}',
                  Icons.inventory_2_outlined,
                  const Color(0xFFEAF1FF),
                ),
                (
                  'Total stok',
                  '${store.totalStock}',
                  Icons.warehouse_outlined,
                  const Color(0xFFE7F8F0),
                ),
                (
                  'Pesanan',
                  '${store.orders.length}',
                  Icons.receipt_long_outlined,
                  const Color(0xFFFFF4E2),
                ),
                (
                  'Pendapatan',
                  rupiah(store.totalRevenue),
                  Icons.payments_outlined,
                  const Color(0xFFF3EBFF),
                ),
              ];
              return GridView.builder(
                itemCount: metrics.length,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: columns,
                  crossAxisSpacing: 11,
                  mainAxisSpacing: 11,
                  mainAxisExtent: 112,
                ),
                itemBuilder: (context, index) {
                  final item = metrics[index];
                  return Container(
                    padding: const EdgeInsets.all(13),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: _line),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(7),
                          decoration: BoxDecoration(
                            color: item.$4,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Icon(item.$3, size: 18, color: _navy),
                        ),
                        Text(
                          item.$2,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: _navy,
                            fontSize: 17,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        Text(
                          item.$1,
                          style: const TextStyle(color: _muted, fontSize: 11),
                        ),
                      ],
                    ),
                  );
                },
              );
            },
          ),
          const SizedBox(height: 22),
          Row(
            children: [
              const Expanded(
                child: Text(
                  'Stok menipis',
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                    color: _navy,
                  ),
                ),
              ),
              Text(
                '${store.lowStockCount} produk',
                style: const TextStyle(color: _muted, fontSize: 12),
              ),
            ],
          ),
          const SizedBox(height: 10),
          if (store.lowStockCount == 0)
            const _AdminEmptyCard(
              message: 'Semua produk memiliki stok yang cukup.',
            )
          else
            ...store.products
                .where((product) => product.stock <= 5)
                .map((product) => _StockWarningTile(product: product)),
          const SizedBox(height: 19),
          const Text(
            'Pesanan terbaru',
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w700,
              color: _navy,
            ),
          ),
          const SizedBox(height: 10),
          if (store.orders.isEmpty)
            const _AdminEmptyCard(
              message: 'Pesanan pelanggan akan tampil di sini.',
            )
          else
            ...store.orders
                .take(3)
                .map(
                  (order) => Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: OrderCard(order: order),
                  ),
                ),
        ],
      ),
    );
  }
}

class _StockWarningTile extends StatelessWidget {
  const _StockWarningTile({required this.product});

  final Product product;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(11),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: _line),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(9),
            child: ProductImage(product: product, width: 44, height: 44),
          ),
          const SizedBox(width: 11),
          Expanded(
            child: Text(
              product.name,
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
          Text(
            '${product.stock} tersisa',
            style: const TextStyle(
              color: Colors.deepOrange,
              fontWeight: FontWeight.w700,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}

class AdminProductsTab extends StatelessWidget {
  const AdminProductsTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<StoreState>(
      builder: (context, store, _) => ListView.separated(
        padding: const EdgeInsets.fromLTRB(16, 10, 16, 90),
        itemCount: store.products.length,
        separatorBuilder: (_, _) => const SizedBox(height: 9),
        itemBuilder: (context, index) {
          final product = store.products[index];
          return Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: _line),
              borderRadius: BorderRadius.circular(15),
            ),
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: ProductImage(product: product, width: 64, height: 64),
                ),
                const SizedBox(width: 11),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        product.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontWeight: FontWeight.w700,
                          color: _navy,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        product.category,
                        style: const TextStyle(color: _muted, fontSize: 11),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        rupiah(product.price),
                        style: const TextStyle(
                          color: _blue,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
                Column(
                  children: [
                    Text(
                      'Stok ${product.stock}',
                      style: TextStyle(
                        fontSize: 11,
                        color: product.stock <= 5 ? Colors.deepOrange : _muted,
                      ),
                    ),
                    PopupMenuButton<String>(
                      tooltip: 'Kelola produk',
                      icon: const Icon(Icons.more_vert),
                      onSelected: (action) {
                        if (action == 'edit') {
                          showProductForm(context, product: product);
                        } else {
                          showDialog<void>(
                            context: context,
                            builder: (dialogContext) => AlertDialog(
                              title: const Text('Hapus produk?'),
                              content: Text(
                                '${product.name} akan dihapus dari katalog.',
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(dialogContext),
                                  child: const Text('Batal'),
                                ),
                                FilledButton(
                                  onPressed: () {
                                    store.deleteProduct(product.id);
                                    Navigator.pop(dialogContext);
                                  },
                                  child: const Text('Hapus'),
                                ),
                              ],
                            ),
                          );
                        }
                      },
                      itemBuilder: (_) => const [
                        PopupMenuItem(
                          value: 'edit',
                          child: Text('Edit produk'),
                        ),
                        PopupMenuItem(
                          value: 'delete',
                          child: Text('Hapus produk'),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

Future<void> showProductForm(BuildContext context, {Product? product}) async {
  final name = TextEditingController(text: product?.name ?? '');
  final price = TextEditingController(
    text: product == null ? '' : '${product.price}',
  );
  final stock = TextEditingController(
    text: product == null ? '' : '${product.stock}',
  );
  final description = TextEditingController(text: product?.description ?? '');
  final image = TextEditingController(text: product?.imageUrl ?? '');
  var category = product?.category ?? productCategories.first;
  final formKey = GlobalKey<FormState>();
  final store = context.read<StoreState>();
  await showDialog<void>(
    context: context,
    builder: (dialogContext) => StatefulBuilder(
      builder: (context, setDialogState) => AlertDialog(
        title: Text(product == null ? 'Tambah produk' : 'Edit produk'),
        content: SizedBox(
          width: 420,
          child: Form(
            key: formKey,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    controller: name,
                    decoration: const InputDecoration(labelText: 'Nama produk'),
                    validator: _requiredValidator,
                  ),
                  const SizedBox(height: 10),
                  DropdownButtonFormField<String>(
                    initialValue: category,
                    decoration: const InputDecoration(labelText: 'Kategori'),
                    items: store.categories
                        .map(
                          (value) => DropdownMenuItem(
                            value: value,
                            child: Text(value),
                          ),
                        )
                        .toList(),
                    onChanged: (value) =>
                        setDialogState(() => category = value!),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: price,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            labelText: 'Harga (Rp)',
                          ),
                          validator: _positiveIntegerValidator,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: TextFormField(
                          controller: stock,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(labelText: 'Stok'),
                          validator: _nonNegativeIntegerValidator,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: description,
                    maxLines: 2,
                    decoration: const InputDecoration(labelText: 'Deskripsi'),
                    validator: _requiredValidator,
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: image,
                    decoration: const InputDecoration(labelText: 'URL gambar'),
                  ),
                ],
              ),
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Batal'),
          ),
          FilledButton(
            onPressed: () {
              if (!formKey.currentState!.validate()) return;
              final parsedPrice = int.tryParse(price.text.trim());
              final parsedStock = int.tryParse(stock.text.trim());
              if (parsedPrice == null || parsedStock == null) return;
              store.saveProduct(
                Product(
                  id:
                      product?.id ??
                      'EM${DateTime.now().millisecondsSinceEpoch}',
                  name: name.text.trim(),
                  category: category,
                  price: parsedPrice,
                  description: description.text.trim(),
                  rating: product?.rating ?? 5,
                  stock: parsedStock,
                  imageUrl: image.text.trim().isEmpty
                      ? _categoryImage(category)
                      : image.text.trim(),
                  featured: product?.featured ?? false,
                ),
              );
              Navigator.pop(dialogContext);
            },
            child: const Text('Simpan'),
          ),
        ],
      ),
    ),
  );
  name.dispose();
  price.dispose();
  stock.dispose();
  description.dispose();
  image.dispose();
}

String? _requiredValidator(String? value) =>
    value == null || value.trim().isEmpty ? 'Wajib diisi' : null;

String? _positiveIntegerValidator(String? value) {
  final parsed = int.tryParse(value?.trim() ?? '');
  return parsed == null || parsed <= 0 ? 'Masukkan angka lebih dari 0' : null;
}

String? _nonNegativeIntegerValidator(String? value) {
  final parsed = int.tryParse(value?.trim() ?? '');
  return parsed == null || parsed < 0 ? 'Masukkan angka 0 atau lebih' : null;
}

class AdminCategoriesTab extends StatelessWidget {
  const AdminCategoriesTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<StoreState>(
      builder: (context, store, _) => ListView(
        padding: const EdgeInsets.all(18),
        children: [
          const Text(
            'Kelola kategori toko. Kategori yang masih digunakan produk tidak dapat dihapus.',
            style: TextStyle(color: _muted, height: 1.5),
          ),
          const SizedBox(height: 14),
          ...store.categories.map((category) {
            final count = store.products
                .where((product) => product.category == category)
                .length;
            return Container(
              margin: const EdgeInsets.only(bottom: 9),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: _line),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(9),
                    decoration: BoxDecoration(
                      color: const Color(0xFFEAF1FF),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(
                      _categoryIcon(category),
                      color: _navy,
                      size: 19,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      category,
                      style: const TextStyle(
                        fontWeight: FontWeight.w700,
                        color: _navy,
                      ),
                    ),
                  ),
                  Text(
                    '$count produk',
                    style: const TextStyle(color: _muted, fontSize: 12),
                  ),
                  IconButton(
                    tooltip: 'Hapus kategori',
                    onPressed: () {
                      if (!store.removeCategory(category)) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Kategori masih digunakan produk.'),
                          ),
                        );
                      }
                    },
                    icon: const Icon(
                      Icons.delete_outline,
                      color: Colors.redAccent,
                    ),
                  ),
                ],
              ),
            );
          }),
          const SizedBox(height: 8),
          OutlinedButton.icon(
            onPressed: () => _showAddCategory(context, store),
            icon: const Icon(Icons.add),
            label: const Text('Tambah kategori'),
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 13),
            ),
          ),
        ],
      ),
    );
  }
}

Future<void> _showAddCategory(BuildContext context, StoreState store) async {
  final controller = TextEditingController();
  await showDialog<void>(
    context: context,
    builder: (dialogContext) => AlertDialog(
      title: const Text('Tambah kategori'),
      content: TextField(
        controller: controller,
        autofocus: true,
        decoration: const InputDecoration(labelText: 'Nama kategori'),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(dialogContext),
          child: const Text('Batal'),
        ),
        FilledButton(
          onPressed: () {
            if (!store.addCategory(controller.text)) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Nama kategori kosong atau sudah tersedia.'),
                ),
              );
              return;
            }
            Navigator.pop(dialogContext);
          },
          child: const Text('Tambah'),
        ),
      ],
    ),
  );
  controller.dispose();
}

class AdminOrdersTab extends StatelessWidget {
  const AdminOrdersTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<StoreState>(
      builder: (context, store, _) {
        if (store.orders.isEmpty) {
          return const EmptyState(
            icon: Icons.receipt_long_outlined,
            title: 'Belum ada pesanan',
            subtitle: 'Pesanan dari User akan muncul di halaman ini.',
          );
        }
        return ListView.separated(
          padding: const EdgeInsets.all(16),
          itemCount: store.orders.length,
          separatorBuilder: (_, _) => const SizedBox(height: 12),
          itemBuilder: (context, index) {
            final order = store.orders[index];
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                OrderCard(order: order),
                Align(
                  alignment: Alignment.centerRight,
                  child: PopupMenuButton<String>(
                    initialValue: order.status,
                    onSelected: (status) {
                      if (!store.updateOrderStatus(order.id, status)) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                              'Stok tidak cukup untuk mengaktifkan kembali pesanan.',
                            ),
                          ),
                        );
                      }
                    },
                    itemBuilder: (_) => const [
                      PopupMenuItem(value: 'Diproses', child: Text('Diproses')),
                      PopupMenuItem(value: 'Dikirim', child: Text('Dikirim')),
                      PopupMenuItem(value: 'Selesai', child: Text('Selesai')),
                      PopupMenuItem(
                        value: 'Dibatalkan',
                        child: Text('Dibatalkan'),
                      ),
                    ],
                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: Text(
                        'Ubah status  ${order.status}  ▾',
                        style: const TextStyle(
                          color: _blue,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }
}

class SearchField extends StatefulWidget {
  const SearchField({required this.value, required this.onChanged, super.key});

  final String value;
  final ValueChanged<String> onChanged;

  @override
  State<SearchField> createState() => _SearchFieldState();
}

class _SearchFieldState extends State<SearchField> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.value);
  }

  @override
  void didUpdateWidget(covariant SearchField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.value != _controller.text) {
      _controller.value = TextEditingValue(
        text: widget.value,
        selection: TextSelection.collapsed(offset: widget.value.length),
      );
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: _controller,
      onChanged: widget.onChanged,
      decoration: InputDecoration(
        hintText: 'Cari HP, laptop, aksesori...',
        prefixIcon: const Icon(Icons.search_rounded),
        suffixIcon: widget.value.isEmpty
            ? const Icon(Icons.tune_rounded, color: _muted)
            : IconButton(
                onPressed: () => widget.onChanged(''),
                icon: const Icon(Icons.close),
              ),
      ),
    );
  }
}

class CategoryTile extends StatelessWidget {
  const CategoryTile({required this.category, required this.onTap, super.key});

  final String category;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(15),
      child: Container(
        width: 78,
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: _line),
          borderRadius: BorderRadius.circular(15),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(_categoryIcon(category), color: _blue, size: 24),
            const SizedBox(height: 6),
            Text(
              category,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
    );
  }
}

class SectionHeading extends StatelessWidget {
  const SectionHeading({
    required this.title,
    this.action,
    this.onAction,
    super.key,
  });

  final String title;
  final String? action;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            title,
            style: const TextStyle(
              color: _navy,
              fontWeight: FontWeight.w800,
              fontSize: 17,
            ),
          ),
        ),
        if (action != null)
          TextButton(
            onPressed: onAction,
            style: TextButton.styleFrom(
              visualDensity: VisualDensity.compact,
              padding: EdgeInsets.zero,
            ),
            child: Text(
              action!,
              style: const TextStyle(color: _blue, fontSize: 12),
            ),
          ),
      ],
    );
  }
}

class SummaryRow extends StatelessWidget {
  const SummaryRow({
    required this.label,
    required this.value,
    this.strong = false,
    super.key,
  });

  final String label;
  final String value;
  final bool strong;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            label,
            style: TextStyle(
              color: strong ? _navy : _muted,
              fontSize: strong ? 14 : 13,
              fontWeight: strong ? FontWeight.w700 : FontWeight.normal,
            ),
          ),
        ),
        Text(
          value,
          style: TextStyle(
            color: strong ? _navy : _muted,
            fontSize: strong ? 15 : 13,
            fontWeight: strong ? FontWeight.w800 : FontWeight.w500,
          ),
        ),
      ],
    );
  }
}

class _FormSectionTitle extends StatelessWidget {
  const _FormSectionTitle({required this.icon, required this.title});

  final IconData icon;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: _blue),
        const SizedBox(width: 8),
        Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: _navy,
          ),
        ),
      ],
    );
  }
}

class _ProfileAction extends StatelessWidget {
  const _ProfileAction({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 2),
      leading: Container(
        width: 42,
        height: 42,
        decoration: BoxDecoration(
          color: const Color(0xFFEAF1FF),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(icon, color: _navy, size: 20),
      ),
      title: Text(
        title,
        style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14),
      ),
      subtitle: Text(
        subtitle,
        style: const TextStyle(color: _muted, fontSize: 12),
      ),
      trailing: const Icon(Icons.chevron_right, color: _muted),
    );
  }
}

class StatusPill extends StatelessWidget {
  const StatusPill({required this.status, super.key});

  final String status;

  @override
  Widget build(BuildContext context) {
    final color = switch (status) {
      'Selesai' => const Color(0xFF14804A),
      'Dikirim' => const Color(0xFF2563EB),
      'Dibatalkan' => const Color(0xFFB42318),
      _ => const Color(0xFFB87500),
    };
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
      decoration: BoxDecoration(
        color: color.withValues(alpha: .1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        status,
        style: TextStyle(
          color: color,
          fontSize: 10,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

class EmptyState extends StatelessWidget {
  const EmptyState({
    required this.icon,
    required this.title,
    required this.subtitle,
    super.key,
  });

  final IconData icon;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 52, color: const Color(0xFF9AAAC0)),
            const SizedBox(height: 14),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: _navy,
                fontWeight: FontWeight.w700,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              subtitle,
              textAlign: TextAlign.center,
              style: const TextStyle(color: _muted, fontSize: 13, height: 1.5),
            ),
          ],
        ),
      ),
    );
  }
}

class _AdminEmptyCard extends StatelessWidget {
  const _AdminEmptyCard({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: _line),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Text(message, style: const TextStyle(color: _muted)),
    );
  }
}

IconData _categoryIcon(String category) => switch (category) {
  'HP' => Icons.smartphone_rounded,
  'Laptop' => Icons.laptop_mac_rounded,
  'Tablet' => Icons.tablet_mac_rounded,
  'AC' => Icons.ac_unit_rounded,
  'Kipas Angin' => Icons.toys_rounded,
  'TV' => Icons.tv_rounded,
  _ => Icons.headphones_rounded,
};

String _categoryImage(String category) => switch (category) {
  'HP' => 'https://images.unsplash.com/photo-1511707171634-5f897ff02aa9?auto=format&fit=crop&w=800&q=85',
  'Laptop' => 'https://images.unsplash.com/photo-1496181133206-80ce9b88a853?auto=format&fit=crop&w=800&q=85',
  'Tablet' => 'https://images.unsplash.com/photo-1544244015-0df4b3ffc6b0?auto=format&fit=crop&w=800&q=85',
  'AC' => 'https://images.unsplash.com/photo-1631545806609-4b2f3f5b5e0d?auto=format&fit=crop&w=800&q=85',
  'Kipas Angin' => 'https://images.unsplash.com/photo-1618941716939-553df3c6c278?auto=format&fit=crop&w=800&q=85',
  'TV' => 'https://images.unsplash.com/photo-1593359677879-a4bb92f829d1?auto=format&fit=crop&w=800&q=85',
  _ => 'https://images.unsplash.com/photo-1505740420928-5e560c06d30e?auto=format&fit=crop&w=800&q=85',
};
