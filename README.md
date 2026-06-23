# RS Sehat Sentosa — aplikasi pelayanan rawat jalan (Flutter)

Prototipe aplikasi Flutter yang mengimplementasikan **persis** alur pada flowchart
dan ERD yang sudah dirancang sebelumnya: pendaftaran -> antrean -> pemeriksaan ->
resep (opsional) -> pembayaran -> kwitansi.

## Cara menjalankan

```bash
flutter pub get
flutter run
```

Membutuhkan Flutter SDK 3.19+ / Dart 3.3+ (Material 3). Tidak ada dependency
eksternal selain `cupertino_icons`, jadi tidak perlu API key atau koneksi backend
apa pun — semua data tersimpan di memori (lihat catatan di bawah).

## Pemetaan ke flowchart (9 langkah)

| # | Layar (`lib/screens`)              | Sesuai langkah flowchart                         |
|---|-------------------------------------|---------------------------------------------------|
| 1 | `welcome_screen.dart`               | Pasien datang                                      |
| 2 | `cek_pasien_screen.dart`            | Keputusan: pasien baru?                            |
| 2a| `registrasi_screen.dart`            | Ya -> registrasi, sistem buat No. RM               |
| 2b| `cari_pasien_screen.dart`           | Tidak -> cari pasien via No. RM                    |
| 3 | `antrean_screen.dart`               | Ambil nomor antrean sesuai poli                    |
| 4 | `pemeriksaan_screen.dart`           | Pemeriksaan dokter, catat diagnosis & tindakan     |
| 5 | (keputusan di layar yang sama)      | Keputusan: perlu resep obat?                       |
| 5a| `resep_screen.dart`                 | Ya -> resep dikirim ke farmasi, hitung biaya obat  |
| 6 | `kasir_screen.dart`                 | Hitung total biaya (periksa + obat)                |
| 7 | `pembayaran_screen.dart`            | Pasien membayar                                    |
| 8 | (keputusan di layar yang sama)      | Keputusan: pembayaran berhasil? (disimulasikan dengan dua tombol demo) |
| 9 | `kwitansi_screen.dart`              | Sistem cetak kwitansi, pelayanan selesai           |

## Pemetaan ke ERD (`lib/models`)

Setiap entitas ERD jadi satu file model, field PK/FK persis seperti rancangan:

- `pasien.dart` — PK `noRkmMedis`
- `dokter.dart` — PK `idDokter`, FK `idPoli`
- `poli.dart` — PK `idPoli`
- `pemeriksaan.dart` — PK `idPeriksa`, FK `noRkmMedis` & `idDokter`
- `resep.dart` — PK `idResep`, FK `idPeriksa`
- `detail_resep.dart` — PK `idDetailResep`, FK `idResep` & `idObat` (tabel
  penghubung many-to-many Resep <-> Obat)
- `obat.dart` — PK `idObat`
- `pembayaran.dart` — PK `idPembayaran`, FK `idPeriksa`

`lib/data/hospital_data.dart` berperan sebagai "database" sementara: berisi
data master (poli, dokter, obat) dan data transaksi yang bertambah selama
aplikasi berjalan, plus generator nomor RM / antrean / kwitansi.

## Catatan

- **Data tidak persisten** — begitu aplikasi ditutup, data transaksi hilang
  (sesuai sifat prototipe). Untuk versi produksi, ganti isi
  `lib/data/hospital_data.dart` dengan panggilan ke REST API / SQLite
  (`sqflite`) / Firebase, tanpa perlu mengubah model maupun screen.
- **Pembayaran berhasil/gagal** disimulasikan lewat dua tombol di
  `pembayaran_screen.dart` (bukan payment gateway sungguhan) supaya cabang
  keputusan pada flowchart tetap bisa didemokan.
- State satu kunjungan pasien (`lib/state/kunjungan_state.dart`) dialirkan
  manual lewat constructor antar-screen — sengaja tanpa package state
  management tambahan agar project ringan dibaca untuk keperluan tugas/skripsi.
