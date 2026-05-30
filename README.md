# Al-Quran Offline Mobile App 📖

Aplikasi mobile Al-Quran interaktif dan responsif yang dibangun menggunakan **Flutter** dengan mengimplementasikan prinsip **Clean Architecture**. Aplikasi ini dirancang untuk dapat digunakan secara offline (tanpa koneksi internet) dengan fitur-fitur lengkap seperti pemutaran audio, bookmark surah, manajemen tema, dan pengaturan preferensi membaca.

## ✨ Fitur Utama (Features)

*   **Daftar Surah & Detail:** Menampilkan daftar 114 Surah beserta terjemahan dan detail ayat demi ayat.
*   **Offline Capable:** Data Al-Quran disimpan secara lokal menggunakan Hive Database sehingga dapat diakses tanpa internet setelah inisialisasi awal.
*   **Pemutar Audio (Audio Player):** Memutar murottal per ayat maupun per surah dengan sticky audio player dan interactive progress bar.
*   **Sistem Bookmark/Favorit:** Menyimpan surah ke halaman "Tersimpan" (Saved) untuk akses cepat.
*   **Preferensi Pengguna (User Settings):**
    *   Pengaturan Tema (Light, Dark, System).
    *   Pengaturan ukuran font bahasa Arab.
    *   Menampilkan atau menyembunyikan Terjemahan & Transliterasi.
*   **Performa Stabil & Bersih:** Menggunakan BLoC pattern untuk manajemen state yang reaktif dan mudah di-maintain.

## 🛠️ Teknologi & Packages (Tech Stack)

*   **Framework:** Flutter SDK
*   **Bahasa:** Dart
*   **State Management:** `flutter_bloc`, `equatable`
*   **Local Storage/Database:** `hive`, `hive_flutter`
*   **Networking:** `dio` (untuk inisialisasi/sync data jika diperlukan)
*   **Dependency Injection:** `get_it`
*   **Audio Player:** `just_audio`
*   **Functional Programming (Error Handling):** `dartz`
*   **Routing:** Native Flutter Navigation / GoRouter (tergantung implementasi)

## 🏗️ Arsitektur Aplikasi (Clean Architecture)

Proyek ini sangat mematuhi prinsip Clean Architecture yang membagi kode ke dalam beberapa layer terpisah untuk memastikan skalabilitas, kemudahan pengujian (testability), dan pemeliharaan:

1.  **Domain Layer:** Pusat dari aplikasi (Core Business Logic). Independen dari semua framework dan layer lainnya.
    *   `Entities`: Objek data inti (e.g., Surah, Ayat).
    *   `Repositories`: Kontrak (Abstract classes) untuk pengambilan data.
    *   `Use Cases`: Aturan bisnis spesifik (e.g., `GetSurahListUseCase`, `SaveBookmarkUseCase`).
2.  **Data Layer:** Bertanggung jawab atas pengelolaan data, dari dan ke dalam aplikasi.
    *   `Models`: Ekstensi dari Entitas yang menyertakan fungsi parsing JSON (e.g., `SurahModel`).
    *   `Data Sources`: Sumber data aktual (`LocalDataSource` dengan Hive, `RemoteDataSource` dengan Dio).
    *   `Repositories Impl`: Implementasi konkret dari kontrak Domain layer.
3.  **Presentation Layer:** Mengurus UI dan interaksi pengguna.
    *   `Pages/Screens`: Halaman UI utama.
    *   `Widgets`: Komponen UI yang dapat digunakan kembali.
    *   `State Management (BLoC/Cubit)`: Menghubungkan UI dengan Use Cases.
4.  **Core:** Berisi utilitas, konstanta, tema, dan konfigurasi umum yang digunakan di seluruh aplikasi (Network Info, Error/Failures, Themes, Constants).

## 📂 Blueprint Struktur Folder (Directory Structure)

```text
lib/
│
├── core/                       # Utilitas, Error Handling, Network info, dsb.
│   ├── constants/              # String, warna, dan dimensi konstan
│   ├── errors/                 # Exception dan Failure classes
│   ├── network/                # Pengecekan koneksi internet
│   └── theme/                  # Konfigurasi App Theme (Light/Dark)
│
├── data/                       # Implementasi pengambilan dan penyimpanan data
│   ├── datasources/            # Sumber data
│   │   ├── local/              # Hive Storage (hive_storage.dart, dll)
│   │   └── remote/             # Dio API Calls
│   ├── models/                 # Data model (JSON Serialization)
│   └── repositories_impl/      # Implementasi dari repository interface (Domain)
│
├── domain/                     # Inti bisnis logika aplikasi
│   ├── entities/               # Objek inti (Surah, Ayat, dll)
│   ├── repositories/           # Interface/Kontrak untuk Data layer
│   └── usecases/               # Logika bisnis per fitur (GetSurahs, SaveFavorite)
│
├── presentation/               # Antarmuka pengguna dan state management
│   ├── bloc/                   # BLoC / Cubit files (SurahBloc, SettingsCubit, AudioBloc)
│   ├── pages/                  # Layar aplikasi utama (Home, Detail, Bookmark, Settings)
│   └── widgets/                # Reusable UI components (SurahCard, PlayerWidget, dll)
│
├── injection.dart              # Setup GetIt (Dependency Injection container)
└── main.dart                   # Entry point aplikasi & Setup Providers
```

## 🚀 Panduan Memulai (Getting Started)

### Prasyarat (Prerequisites)
Pastikan Anda telah menginstal Flutter SDK di mesin Anda.
*   Flutter versi `>= 3.0.0`
*   Dart versi `>= 2.17.0`

### Instalasi & Menjalankan Proyek

1. **Clone repository ini:**
   ```bash
   git clone <repository_url>
   cd alquran_apps
   ```

2. **Dapatkan dependencies:**
   ```bash
   flutter pub get
   ```

3. **Generate file yang diperlukan (jika menggunakan build_runner/hive_generator):**
   ```bash
   flutter pub run build_runner build --delete-conflicting-outputs
   ```

4. **Jalankan aplikasi:**
   ```bash
   flutter run
   ```

## 🔄 State Management Flow (BLoC)

1. **Event Ditembak (Fired):** Pengguna berinteraksi dengan UI (contoh: Membuka halaman Detail Surah).
2. **BLoC Menerima Event:** `SurahDetailBloc` menerima event `GetSurahDetailEvent(surahId)`.
3. **Use Case Dipanggil:** BLoC memanggil `GetSurahDetailUseCase`.
4. **Repository Bekerja:** Use Case meminta data ke `SurahRepository`.
5. **Data Source Dieksekusi:** Repository mengecek `LocalDataSource` (Hive). Jika ada, data langsung dikembalikan. Jika tidak, data diambil via API, disimpan ke Hive, lalu dikembalikan.
6. **State Diperbarui:** BLoC memancarkan (emits) state baru (`SurahDetailLoading` -> `SurahDetailLoaded`).
7. **UI Re-build:** `BlocBuilder` pada UI merespons `SurahDetailLoaded` dan merender data ke layar.

## 📝 Catatan Tambahan

* **Database (Hive):** Hive digunakan karena performanya yang sangat cepat untuk key-value storage dan sangat cocok untuk aplikasi offline seperti Al-Quran. Semua pengaturan preferensi pengguna juga disimpan secara persisten di Hive.
* **Audio:** `just_audio` menangani buffering dan stream audio latar belakang.

---
Dibuat dengan ❤️ untuk mempermudah akses membaca Al-Quran dimana saja dan kapan saja.
