class Pembayaran {
  final String idPembayaran;
  final String idPeriksa;
  final DateTime tglBayar;
  final int biayaPeriksa;
  final int biayaObat;
  final String metodeBayar;
  final String noKwitansi;

  const Pembayaran({
    required this.idPembayaran,
    required this.idPeriksa,
    required this.tglBayar,
    required this.biayaPeriksa,
    required this.biayaObat,
    required this.metodeBayar,
    required this.noKwitansi,
  });

  int get totalBayar => biayaPeriksa + biayaObat;
}
