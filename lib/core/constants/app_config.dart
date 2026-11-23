class AppConfig {
  // Ganti URL di bawah ini dengan base URL API backend proyek Anda
  // Contoh jika menjalankan Flutter Web di laptop yang sama dengan Laravel/backend lokal:
  static const String API_PATH = 'http://127.0.0.1:8000/api';

  // Opsional: jika di halaman lain (misal slider/produk) membutuhkan base URL gambar/storage
  static const String BASE_URL = 'http://127.0.0.1:8000';

  static const String STORAGE_IMAGES = 'http://127.0.0.1:8000/storage/';

  static Null get IMAGE_PATH => null;
}
