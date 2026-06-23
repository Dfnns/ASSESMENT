class DetailResep {
  final String idDetailResep;
  final String idResep;
  final String idObat;
  final String namaObat;
  final int hargaSatuan;
  final int jumlah;

  const DetailResep({
    required this.idDetailResep,
    required this.idResep,
    required this.idObat,
    required this.namaObat,
    required this.hargaSatuan,
    required this.jumlah,
  });

  int get subtotal => hargaSatuan * jumlah;
}
