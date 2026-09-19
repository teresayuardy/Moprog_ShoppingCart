import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

// Widget yang tidak punya state atau perubahan
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  // Method untuk menentukan widget yang ditampilkan di layar
  Widget build(BuildContext context) {
    // MaterialApp = fondasi aplikasi Flutter yang menggunakan Material Design
    return MaterialApp(
      debugShowCheckedModeBanner: false, // Menghilangkan tulisan DEBUG
      title: 'My Cart',
      home: const CartPage(), // Halaman pertama yang dibuka adalah CartPage
    );
  }
}

// Class untuk menyimpan informasi produk
class Product {
  String name;
  String brand;
  int price;
  IconData icon;
  String? imagePath;
  int quantity;
  int likes;
  bool isLiked;
  bool isSelected;

  // Constructor
  Product({
    required this.name,
    required this.brand,
    required this.price,
    required this.icon,
    this.imagePath,
    this.quantity = 1,
    this.likes = 0,
    this.isLiked = false,
    this.isSelected = false,
  });
}

// Widget yang bisa berubah
// StatefulWidget karena isinya bisa berubah, misal like yang bertambah
class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState(); // Data yang bisa berubah disimpan di _CartPageState
}

// Class state untuk CartPage
// _ artinya private
class _CartPageState extends State<CartPage> {

  // ArrayList untuk menyimpan object-object produk, konsepnya mirip Java
  final List<Product> _products = [
    Product( // Object 1: Headphone
      name: 'Wireless Headphone',
      brand: 'Sony WH-CH520',
      price: 350000,
      icon: Icons.headphones,
      imagePath: 'assets/images/headphone.jpg',
      likes: 12,
    ),
    Product( // Object 2: Laptop
      name: 'Laptop ASUS Vivobook',
      brand: 'ASUS',
      price: 7500000,
      icon: Icons.laptop_mac,
      imagePath: 'assets/images/laptop.png',
      likes: 8,
    ),
    Product( // Object 3: Mouse
      name: 'Wireless Mouse',
      brand: 'Logitech M330',
      price: 250000,
      icon: Icons.mouse,
      imagePath: 'assets/images/mouse.jpg',
      likes: 5,
    ),
  ];

  int _selectedNavIndex = 0; // Bottom Navigation, index mulai dari 0
  bool _showBanner = false; // Untuk menampilkan banner
  String _bannerProductName = ''; // Menyimpan nama produk yang akan ditampilkan di banner

  // Getter untuk menghitung total quantity semua produk
  int get _totalItem {
    int total = 0;
    for (var p in _products) { // Ambil setiap produk dari _products
      total += p.quantity;
    }
    return total;
  }

  // Getter untuk menghitung total harga
  int get _totalHarga {
    int total = 0;
    for (var p in _products) {
      total += p.price * p.quantity;
    }
    return total;
  }

  // Method untuk mengubah angka biasa menjadi format Rupiah
  String _formatRupiah(int number) {
    String str = number.toString(); // Angka diganti menjadi String
    String result = '';
    int count = 0;
    // Looping untuk memasukkan titik di setiap 3 angka, mulai dari belakang
    for (int i = str.length - 1; i >= 0; i--) {
      result = str[i] + result;
      count++;
      if (count % 3 == 0 && i != 0) {
        result = '.$result';
      }
    }
    return 'Rp $result';
  }

  // Method untuk menambah item apabila tombol + diklik
  void _tambahQuantity(int index) {
    setState(() { // Data berubah, pakai setState untuk mengatur ulang tampilan
      _products[index].quantity++;
    });
  }

  // Method untuk mengurangi item apabila tombol - diklik
  void _kurangQuantity(int index) {
    setState(() {
      // Quantity tidak boleh turun sampai 0
      if (_products[index].quantity > 1) {
        _products[index].quantity--;
      }
    });
  }

  // Method untuk like dan unlike (double tap)
  void _toggleLike(int index) {
    setState(() {
      Product p = _products[index]; // Ambil produk pada index tersebut, simpan sementara dalam variabel p
      // Jika sebelumnya sudah dilike, kurangi jumlah like
      if (p.isLiked) {
        p.likes--;
      } else {
        p.likes++;
      }
      p.isLiked = !p.isLiked; // ! artinya NOT atau kebalikan
    });
  }

  // Method untuk memilih produk (one tap)
  void _toggleSelect(int index) {
    setState(() {
      _products[index].isSelected = !_products[index].isSelected;
    });
  }

  // Method untuk menampilkan banner (long press)
  void _tampilkanInfo(Product p) {
    setState(() {
      _showBanner = true;
      _bannerProductName = p.name;
    });
  }

  // Method untuk menutup banner jika pengguna klik tanda silang
  void _tutupBanner() {
    setState(() {
      _showBanner = false;
    });
  }

  // Widget untuk membuat tampilan banner
  Widget _buildBanner() {
    return Container(
      width: double.infinity, // Lebar memenuhi ruang yang tersedia
      margin: const EdgeInsets.fromLTRB(12, 12, 12, 0),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.green,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          const Icon(Icons.check_circle, color: Colors.white, size: 26),
          const SizedBox(width: 12),

          // Expanded: mengambil sisa ruang yang tersedia
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Produk dipilih!',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                Text(
                  '$_bannerProductName telah dipilih.',
                  style: const TextStyle(color: Colors.white, fontSize: 12),
                ),
              ],
            ),
          ),

          // Mendeteksi tindakan pengguna
          // Jika tombol silang diklik, banner akan tertutup
          GestureDetector(
            onTap: _tutupBanner,
            child: const Icon(Icons.close, color: Colors.white, size: 20),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Scaffold: kerangka halaman aplikasi
    return Scaffold(
      backgroundColor: Colors.grey.shade100,

      // AppBar: header
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        automaticallyImplyLeading: false, // Mencegah Flutter menambahkan tombol back secara otomatis
        title: const Text(
          'My Cart',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        // actions: tempat widget di sebelah kanan AppBar, dalam hal ini tombol search
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 16),
            child: Icon(Icons.search, color: Colors.white),
          ),
        ],
      ),

      body: Column(
        children: [
          // Jika pengguna melakukan long press, tampilkan banner
          if (_showBanner) _buildBanner(),

          Expanded(
            child: ListView.builder( // Membuat list yang bisa discroll
              padding: const EdgeInsets.all(12),
              itemCount: _products.length, // Jumlah produk
              itemBuilder: (context, index) { // Function untuk membuat setiap item
                Product p = _products[index]; // Mengambil produk yang ada di index tertentu

                // Mengatur apa yang akan terjadi jika pengguna one tap, double tap, dan long press
                return GestureDetector(
                  onTap: () => _toggleSelect(index),
                  onDoubleTap: () => _toggleLike(index),
                  onLongPress: () => _tampilkanInfo(p),

                  child: Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      // Jika one tap, background produk akan berubah menjadi biru muda
                      color: p.isSelected ? Colors.blue.shade50 : Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      // Jika one tap, border produk akan berubah menjadi biru
                      border: Border.all(
                        color: p.isSelected
                            ? Colors.blueAccent
                            : Colors.grey.shade300,
                        width: p.isSelected ? 2 : 1,
                      ),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          // Mengatur ukuran foto
                          width: 60,
                          height: 60,
                          decoration: BoxDecoration(
                            color: Colors.grey.shade100,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          // Membuat gambar punya sudut rounded
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            // Jika ada gambar, ambil dari assets, lalu tamoilkan
                            child: p.imagePath != null
                                ? Image.asset(
                              p.imagePath!, // Meyakinkan bahwa gambar tidak null
                              fit: BoxFit.cover,
                            )
                            // Jika tidak ada gambar (null), tampilkan icon
                                : Icon(p.icon,
                                size: 30, color: Colors.grey.shade700),
                          ),
                        ),
                        const SizedBox(width: 12),

                        // Bagian yang menampilkan informasi produk
                        // Supaya informasi produk mengambil ruang yang tersedia, tidak overflow
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                p.name,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15,
                                ),
                              ),
                              Text(
                                p.brand,
                                style: TextStyle(
                                    color: Colors.grey.shade600,
                                    fontSize: 12),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                _formatRupiah(p.price),
                                style: const TextStyle(
                                  color: Colors.blueAccent,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 4),

                              // Bagian yang menampilkan icon like dan jumlahnya
                              Row(
                                children: [
                                  // Untuk icon like, jika double tap warna icon berubah menjadi merah
                                  Icon(
                                    p.isLiked
                                        ? Icons.favorite
                                        : Icons.favorite_border,
                                    size: 16,
                                    color: p.isLiked
                                        ? Colors.red
                                        : Colors.grey,
                                  ),
                                  const SizedBox(width: 4),
                                  // Untuk menampilkan jumlah like
                                  Text(
                                    '${p.likes}',
                                    style: TextStyle(
                                        color: Colors.grey.shade600,
                                        fontSize: 12),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),

                        // Bagian yang menampilkan tombol - (quantity) +
                        Row(
                          children: [
                            // Untuk tombol - (mengurangi jumlah item)
                            _kotakTombol(
                              icon: Icons.remove,
                              color: Colors.grey.shade300,
                              iconColor: Colors.black,
                              onTap: () => _kurangQuantity(index), // Memanggil method _kurangQuantity
                            ),
                            Padding(
                              padding:
                              const EdgeInsets.symmetric(horizontal: 8),
                              // Menampilkan quantity
                              child: Text(
                                '${p.quantity}',
                                style:
                                const TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                            // Untuk tombol + (menambah jumlah item)
                            _kotakTombol(
                              icon: Icons.add,
                              color: Colors.blueAccent,
                              iconColor: Colors.white,
                              onTap: () => _tambahQuantity(index), // Memanggil method _tambahQuantity
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),

          // Bagian yang menampilkan total produk, total harga, dan tombol checkout
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              // Untuk memberikan bayangan
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 4,
                  offset: const Offset(0, -2),
                ),
              ],
            ),

            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Menghitung total harga dengan getter _totalItem
                    Text(
                      'Total ($_totalItem produk)',
                      style:
                      TextStyle(color: Colors.grey.shade600, fontSize: 12),
                    ),
                    Text(
                      _formatRupiah(_totalHarga),
                      style: const TextStyle(
                        color: Colors.blueAccent,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
                // Widget untuk tombol 'Checkout'
                ElevatedButton(
                  onPressed: () {}, // Tombolnya ada, tetapi saat ditekan tidak terjadi apa-apa
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueAccent,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8)),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 24, vertical: 12),
                  ),
                  child: const Text('Checkout'),
                ),
              ],
            ),
          ),
        ],
      ),

      // Bagian yang menampilkan Bottom Navigation
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedNavIndex, // Memberi tahu Flutter menu apa yang sedang aktif
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.blueAccent,
        unselectedItemColor: Colors.grey,
        // Jika pengguna menekan salah satu menu, Flutter akan memberikan index
        onTap: (index) {
          setState(() { // Memperbarui tampilan
            _selectedNavIndex = index;
          });
        },
        // Berisi menu yang ada di Bottom Navigation
        items: [
          const BottomNavigationBarItem(
              icon: Icon(Icons.home), label: 'Beranda'),
          const BottomNavigationBarItem(
              icon: Icon(Icons.category), label: 'Kategori'),
          BottomNavigationBarItem(
            icon: Stack(
              clipBehavior: Clip.none,
              children: [
                const Icon(Icons.shopping_cart),
                // Menampilkan badge merah di pojok kanan atas jika item lebih dari 0
                if (_totalItem > 0)
                  Positioned(
                    right: -6,
                    top: -4,
                    child: Container(
                      padding: const EdgeInsets.all(3),
                      decoration: const BoxDecoration(
                          color: Colors.red, shape: BoxShape.circle),
                      // Menampilkan jumlah total item
                      child: Text(
                        '$_totalItem',
                        style:
                        const TextStyle(color: Colors.white, fontSize: 9),
                      ),
                    ),
                  ),
              ],
            ),
            label: 'Keranjang',
          ),
          const BottomNavigationBarItem(
              icon: Icon(Icons.person), label: 'Akun'),
        ],
      ),
    );
  }

  // Method yang mengembalikan Widget
  // Ini adalah method yang reusable, mudahnya ini adalah cetakan tombol
  Widget _kotakTombol({
    required IconData icon,
    required Color color,
    required Color iconColor,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 28,
        height: 28,
        decoration:
        BoxDecoration(color: color, borderRadius: BorderRadius.circular(6)),
        child: Icon(icon, size: 16, color: iconColor),
      ),
    );
  }
}