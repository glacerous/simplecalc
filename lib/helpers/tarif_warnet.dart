/// Satu-satunya sumber kebenaran untuk tarif Warnet Pojok.
/// Dipakai bareng oleh [KasirScreen] dan [WarnetCrudScreen]
/// supaya total biaya yang dihitung selalu konsisten di semua layar.
enum TipePc {
  reguler(label: 'Reguler', tarifPerJam: 4000),
  vip(label: 'VIP', tarifPerJam: 7000);

  const TipePc({required this.label, required this.tarifPerJam});

  final String label;
  final int tarifPerJam;

  String get labelDenganTarif => '$label (Rp $tarifPerJam/jam)';

  static const int hargaEsTeh = 4000;

  /// Total biaya sesi: tarif per jam * durasi, ditambah es teh kalau dipilih.
  static int hitungTotal({
    required TipePc tipe,
    required int durasiJam,
    bool tambahEsTeh = false,
  }) {
    final total = tipe.tarifPerJam * durasiJam;
    return tambahEsTeh ? total + hargaEsTeh : total;
  }
}
