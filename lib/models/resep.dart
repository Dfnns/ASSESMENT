import 'detail_resep.dart';

class Resep {
  final String idResep;
  final String idPeriksa;
  final DateTime tglResep;
  final String statusResep;
  final List<DetailResep> detail;

  const Resep({
    required this.idResep,
    required this.idPeriksa,
    required this.tglResep,
    required this.statusResep,
    required this.detail,
  });

  int get totalBiayaObat =>
      detail.fold(0, (total, item) => total + item.subtotal);
}
