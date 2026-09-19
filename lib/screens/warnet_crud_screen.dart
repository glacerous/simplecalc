import 'package:flutter/material.dart';
import '../helpers/database_helper.dart';
import '../helpers/tarif_warnet.dart';
import '../theme/app_theme.dart';

class WarnetCrudScreen extends StatefulWidget {
  const WarnetCrudScreen({super.key});

  @override
  State<WarnetCrudScreen> createState() => _WarnetCrudScreenState();
}

class _WarnetCrudScreenState extends State<WarnetCrudScreen> {
  List<Map<String, dynamic>> _rentals = [];
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _refreshData();
  }

  Future<void> _refreshData() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });
    try {
      final data = await DatabaseHelper.instance.getRentals();
      if (!mounted) return;
      setState(() {
        _rentals = data;
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _isLoading = false;
        _errorMessage = 'Gagal memuat data: $e';
      });
    }
  }

  Future<void> _showForm({Map<String, dynamic>? item}) async {
    final saved = await showDialog<bool>(
      context: context,
      builder: (ctx) => _SesiFormDialog(item: item),
    );
    if (saved == true) _refreshData();
  }

  Future<void> _konfirmasiHapus(Map<String, dynamic> item) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Hapus Sesi?'),
        content: Text('Data sesi "${item['nama']}" (${item['nomor_pc']}) akan dihapus permanen.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Batal')),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: const Color(0xFFE11D48)),
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Hapus'),
          ),
        ],
      ),
    );

    if (ok != true) return;
    try {
      await DatabaseHelper.instance.deleteRental(item['id']);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Data berhasil dihapus')));
      _refreshData();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Gagal menghapus: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Kelola Sesi (CRUD)')),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showForm(),
        backgroundColor: AppTheme.cobalt,
        foregroundColor: Colors.white,
        child: const Icon(Icons.add),
      ),
      body: RefreshIndicator(
        onRefresh: _refreshData,
        child: _buildBody(),
      ),
    );
  }

  Widget _buildBody() {
    if (_isLoading) return const Center(child: CircularProgressIndicator());
    if (_errorMessage != null) {
      return ListView(
        children: [
          const SizedBox(height: 80),
          const Icon(Icons.error_outline, color: Color(0xFFE11D48), size: 48),
          const SizedBox(height: 12),
          Text(_errorMessage!, textAlign: TextAlign.center, style: const TextStyle(color: Color(0xFFE11D48))),
          const SizedBox(height: 12),
          Center(child: OutlinedButton(onPressed: _refreshData, child: const Text('Coba Lagi'))),
        ],
      );
    }
    if (_rentals.isEmpty) {
      return ListView(
        children: const [
          SizedBox(height: 120),
          Center(child: Text('Belum ada data sesi.', style: TextStyle(color: AppTheme.fog))),
        ],
      );
    }
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _rentals.length,
      itemBuilder: (context, index) {
        final item = _rentals[index];
        final tipe = TipePc.values.firstWhere((t) => t.name == item['tipe_pc'], orElse: () => TipePc.reguler);

        return Container(
          margin: const EdgeInsets.symmetric(vertical: 6),
          decoration: BoxDecoration(
            color: AppTheme.snow,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppTheme.cloud),
          ),
          child: ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            leading: Container(
              width: 38,
              height: 38,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: AppTheme.cobalt.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: AppTheme.cobalt.withValues(alpha: 0.2)),
              ),
              child: Text('${index + 1}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: AppTheme.cobalt)),
            ),
            title: Text('${item['nama']} (${item['nomor_pc']})', style: const TextStyle(fontWeight: FontWeight.bold, color: AppTheme.obsidian)),
            subtitle: Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Text(
                '${tipe.label} • ${item['tanggal']} ${item['jam_mulai']} • Durasi: ${item['durasi']} Jam • Total: Rp ${item['total']}',
                style: const TextStyle(color: AppTheme.fog, fontSize: 13),
              ),
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.edit_outlined, color: AppTheme.cobalt),
                  tooltip: 'Edit Sesi',
                  onPressed: () => _showForm(item: item),
                ),
                IconButton(
                  icon: const Icon(Icons.delete_outline, color: Color(0xFFE11D48)),
                  tooltip: 'Hapus Sesi',
                  onPressed: () => _konfirmasiHapus(item),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _SesiFormDialog extends StatefulWidget {
  final Map<String, dynamic>? item;
  const _SesiFormDialog({this.item});

  @override
  State<_SesiFormDialog> createState() => _SesiFormDialogState();
}

class _SesiFormDialogState extends State<_SesiFormDialog> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _namaController;
  late final TextEditingController _pcController;
  late final TextEditingController _durasiController;
  late TipePc _tipePc;
  late DateTime _tanggal;
  late TimeOfDay _jamMulai;
  bool _isSaving = false;
  String? _errorValidasi;

  bool get _isEdit => widget.item != null;

  @override
  void initState() {
    super.initState();
    final item = widget.item;
    _namaController = TextEditingController(text: item?['nama'] ?? '');
    _pcController = TextEditingController(text: item?['nomor_pc'] ?? 'PC-01');
    _durasiController = TextEditingController(text: (item?['durasi'] ?? 2).toString());
    _tipePc = TipePc.values.firstWhere((t) => t.name == item?['tipe_pc'], orElse: () => TipePc.reguler);
    _tanggal = item?['tanggal'] != null ? DateTime.parse(item!['tanggal']) : DateTime.now();

    if (item?['jam_mulai'] != null) {
      final p = (item!['jam_mulai'] as String).split(':');
      _jamMulai = TimeOfDay(hour: int.parse(p[0]), minute: int.parse(p[1]));
    } else {
      _jamMulai = const TimeOfDay(hour: 10, minute: 0);
    }
  }

  @override
  void dispose() {
    _namaController.dispose();
    _pcController.dispose();
    _durasiController.dispose();
    super.dispose();
  }

  String get _tanggalIso => _tanggal.toIso8601String().substring(0, 10);
  String get _tanggalTampil => '${_tanggal.day.toString().padLeft(2, '0')}/${_tanggal.month.toString().padLeft(2, '0')}/${_tanggal.year}';
  int get _jamMulaiMenit => _jamMulai.hour * 60 + _jamMulai.minute;
  String get _jamMulaiIso => '${_jamMulai.hour.toString().padLeft(2, '0')}:${_jamMulai.minute.toString().padLeft(2, '0')}';

  String _jamSelesaiTampil(int durasi) {
    final m = _jamMulaiMenit + durasi * 60;
    final jam = '${((m ~/ 60) % 24).toString().padLeft(2, '0')}:${(m % 60).toString().padLeft(2, '0')}';
    return m >= 1440 ? '$jam (besok)' : jam;
  }

  Future<void> _simpan() async {
    if (!_formKey.currentState!.validate()) return;
    final durasi = int.parse(_durasiController.text.trim());

    if (_jamMulaiMenit + durasi * 60 > 24 * 60) {
      setState(() {
        _errorValidasi = 'Sesi jam $_jamMulaiIso ($durasi jam) akan lewat tengah malam. Sesi harus selesai di hari yang sama.';
      });
      return;
    }

    setState(() { _isSaving = true; _errorValidasi = null; });
    final nomorPc = _pcController.text.trim();

    try {
      final bentrok = await DatabaseHelper.instance.adaBentrokJadwal(
        nomorPc: nomorPc,
        tipePc: _tipePc.name,
        tanggal: _tanggalIso,
        jamMulaiMenit: _jamMulaiMenit,
        durasiJam: durasi,
        excludeId: _isEdit ? widget.item!['id'] as int : null,
      );

      if (bentrok) {
        setState(() {
          _isSaving = false;
          _errorValidasi = 'PC "$nomorPc" (${_tipePc.label}) sudah dipesan pada waktu yang bertabrakan ($_jamMulaiIso - ${_jamSelesaiTampil(durasi)}).';
        });
        return;
      }

      final row = {
        'nama': _namaController.text.trim(),
        'nomor_pc': nomorPc,
        'tipe_pc': _tipePc.name,
        'tanggal': _tanggalIso,
        'jam_mulai': _jamMulaiIso,
        'durasi': durasi,
        'total': TipePc.hitungTotal(tipe: _tipePc, durasiJam: durasi),
        'status': _isEdit ? widget.item!['status'] : 'Aktif',
      };

      if (_isEdit) {
        await DatabaseHelper.instance.updateRental(widget.item!['id'], row);
      } else {
        await DatabaseHelper.instance.insertRental(row);
      }
      if (!mounted) return;
      Navigator.pop(context, true);
    } catch (e) {
      if (!mounted) return;
      setState(() => _isSaving = false);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Gagal menyimpan: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(_isEdit ? 'Edit Sesi' : 'Tambah Sesi'),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _namaController,
                decoration: const InputDecoration(labelText: 'Nama Pelanggan'),
                validator: (v) => (v == null || v.trim().isEmpty) ? 'Wajib diisi' : null,
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _pcController,
                decoration: const InputDecoration(labelText: 'Nomor PC'),
                validator: (v) => (v == null || v.trim().isEmpty) ? 'Wajib diisi' : null,
              ),
              const SizedBox(height: 8),
              DropdownButtonFormField<TipePc>(
                initialValue: _tipePc,
                decoration: const InputDecoration(labelText: 'Tipe PC'),
                items: TipePc.values.map((t) => DropdownMenuItem(value: t, child: Text(t.labelDenganTarif))).toList(),
                onChanged: (v) => v != null ? setState(() => _tipePc = v) : null,
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: InkWell(
                      onTap: () async {
                        final pick = await showDatePicker(
                          context: context,
                          initialDate: _tanggal,
                          firstDate: DateTime(1000),
                          lastDate: DateTime(2500),
                        );
                        if (pick != null) setState(() => _tanggal = pick);
                      },
                      child: InputDecorator(
                        decoration: const InputDecoration(labelText: 'Tanggal', suffixIcon: Icon(Icons.calendar_today, size: 18, color: AppTheme.cobalt)),
                        child: Text(_tanggalTampil),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: InkWell(
                      onTap: () async {
                        final pick = await showTimePicker(context: context, initialTime: _jamMulai);
                        if (pick != null) setState(() => _jamMulai = pick);
                      },
                      child: InputDecorator(
                        decoration: const InputDecoration(labelText: 'Jam Mulai', suffixIcon: Icon(Icons.access_time, size: 18, color: AppTheme.cobalt)),
                        child: Text(_jamMulaiIso),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _durasiController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Durasi (Jam)'),
                onChanged: (_) => setState(() {}),
                validator: (v) {
                  final n = int.tryParse((v ?? '').trim());
                  if (n == null || n <= 0 || n > 24) return 'Durasi 1 - 24 jam';
                  return null;
                },
              ),
              if (_errorValidasi != null) ...[
                const SizedBox(height: 10),
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFF1F2),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: const Color(0xFFFECDD3)),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.error_outline, color: Color(0xFFE11D48), size: 18),
                      const SizedBox(width: 8),
                      Expanded(child: Text(_errorValidasi!, style: const TextStyle(color: Color(0xFFE11D48), fontSize: 13))),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
      actions: [
        TextButton(onPressed: _isSaving ? null : () => Navigator.pop(context, false), child: const Text('Batal')),
        ElevatedButton(
          style: ElevatedButton.styleFrom(backgroundColor: AppTheme.cobalt, foregroundColor: Colors.white),
          onPressed: _isSaving ? null : _simpan,
          child: _isSaving
              ? const SizedBox(height: 16, width: 16, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
              : const Text('Simpan'),
        ),
      ],
    );
  }
}
