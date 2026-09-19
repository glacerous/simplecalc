import 'package:flutter/material.dart';
import '../helpers/database_helper.dart';
import '../helpers/tarif_warnet.dart';

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
    await showDialog(
      context: context,
      builder: (ctx) => _SesiFormDialog(item: item),
    ).then((saved) {
      if (saved == true) _refreshData();
    });
  }

  Future<void> _konfirmasiHapus(Map<String, dynamic> item) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Hapus Sesi?'),
        content: Text(
          'Data sesi "${item['nama']}" (${item['nomor_pc']}) akan dihapus permanen.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Batal'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Hapus'),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    try {
      await DatabaseHelper.instance.deleteRental(item['id']);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Data berhasil dihapus')),
      );
      _refreshData();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal menghapus: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Kelola Sesi (CRUD)')),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showForm(),
        child: const Icon(Icons.add),
      ),
      body: RefreshIndicator(
        onRefresh: _refreshData,
        child: _buildBody(),
      ),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (_errorMessage != null) {
      return ListView(
        children: [
          const SizedBox(height: 80),
          Icon(Icons.error_outline, color: Colors.red.shade300, size: 48),
          const SizedBox(height: 12),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Text(
              _errorMessage!,
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.red.shade700),
            ),
          ),
          const SizedBox(height: 12),
          Center(
            child: OutlinedButton(
              onPressed: _refreshData,
              child: const Text('Coba Lagi'),
            ),
          ),
        ],
      );
    }
    if (_rentals.isEmpty) {
      return ListView(
        children: const [
          SizedBox(height: 120),
          Center(child: Text('Belum ada data sesi.')),
        ],
      );
    }
    return ListView.builder(
      padding: const EdgeInsets.all(12),
      itemCount: _rentals.length,
      itemBuilder: (context, index) {
        final item = _rentals[index];
        final tipe = TipePc.values.firstWhere(
          (t) => t.name == item['tipe_pc'],
          orElse: () => TipePc.reguler,
        );
        return Card(
          margin: const EdgeInsets.symmetric(vertical: 6),
          child: ListTile(
            leading: CircleAvatar(child: Text('${index + 1}')),
            title: Text(
              '${item['nama']} (${item['nomor_pc']})',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Text(
              '${tipe.label} • ${item['tanggal']} • Durasi: ${item['durasi']} Jam • '
              'Total: Rp ${item['total']} • Status: ${item['status']}',
            ),
            isThreeLine: false,
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.edit, color: Colors.blue),
                  onPressed: () => _showForm(item: item),
                ),
                IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
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

/// Form tambah/edit sebagai StatefulWidget terpisah supaya controller-nya
/// dibuat & di-dispose lewat lifecycle State, bukan dibuat ulang tiap
/// rebuild lalu bocor (leak) seperti sebelumnya.
class _SesiFormDialog extends StatefulWidget {
  const _SesiFormDialog({this.item});

  final Map<String, dynamic>? item;

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
  bool _isSaving = false;
  String? _errorBentrok;

  bool get _isEdit => widget.item != null;

  @override
  void initState() {
    super.initState();
    final item = widget.item;
    _namaController = TextEditingController(text: item?['nama'] ?? '');
    _pcController = TextEditingController(text: item?['nomor_pc'] ?? 'PC-01');
    _durasiController =
        TextEditingController(text: (item?['durasi'] ?? 2).toString());
    _tipePc = TipePc.values.firstWhere(
      (t) => t.name == item?['tipe_pc'],
      orElse: () => TipePc.reguler,
    );
    _tanggal = item?['tanggal'] != null
        ? DateTime.parse(item!['tanggal'])
        : DateTime.now();
  }

  @override
  void dispose() {
    _namaController.dispose();
    _pcController.dispose();
    _durasiController.dispose();
    super.dispose();
  }

  String get _tanggalIso => _tanggal.toIso8601String().substring(0, 10);

  String get _tanggalTampil =>
      '${_tanggal.day.toString().padLeft(2, '0')}/'
      '${_tanggal.month.toString().padLeft(2, '0')}/${_tanggal.year}';

  Future<void> _pilihTanggal() async {
    final hasil = await showDatePicker(
      context: context,
      initialDate: _tanggal,
      firstDate: DateTime.now().subtract(const Duration(days: 365)),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (hasil != null) setState(() => _tanggal = hasil);
  }

  Future<void> _simpan() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isSaving = true;
      _errorBentrok = null;
    });

    final nomorPc = _pcController.text.trim();

    try {
      final bentrok = await DatabaseHelper.instance.adaBentrokJadwal(
        nomorPc: nomorPc,
        tipePc: _tipePc.name,
        tanggal: _tanggalIso,
        excludeId: _isEdit ? widget.item!['id'] as int : null,
      );
      if (bentrok) {
        setState(() {
          _isSaving = false;
          _errorBentrok =
              'PC "$nomorPc" tipe ${_tipePc.label} sudah dipakai sesi lain '
              'pada tanggal $_tanggalTampil. Pilih PC lain atau ganti tanggal.';
        });
        return;
      }

      final durasi = int.parse(_durasiController.text.trim());
      final total = TipePc.hitungTotal(tipe: _tipePc, durasiJam: durasi);
      final row = {
        'nama': _namaController.text.trim(),
        'nomor_pc': nomorPc,
        'tipe_pc': _tipePc.name,
        'tanggal': _tanggalIso,
        'durasi': durasi,
        'total': total,
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
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal menyimpan: $e')),
      );
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
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _namaController,
                decoration: const InputDecoration(labelText: 'Nama Pelanggan'),
                validator: (v) =>
                    (v == null || v.trim().isEmpty) ? 'Wajib diisi' : null,
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _pcController,
                decoration: const InputDecoration(labelText: 'Nomor PC'),
                validator: (v) =>
                    (v == null || v.trim().isEmpty) ? 'Wajib diisi' : null,
              ),
              const SizedBox(height: 8),
              DropdownButtonFormField<TipePc>(
                initialValue: _tipePc,
                decoration: const InputDecoration(labelText: 'Tipe PC'),
                items: TipePc.values
                    .map((t) => DropdownMenuItem(
                          value: t,
                          child: Text(t.labelDenganTarif),
                        ))
                    .toList(),
                onChanged: (val) {
                  if (val != null) setState(() => _tipePc = val);
                },
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _durasiController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Durasi (Jam)'),
                validator: (v) {
                  final n = int.tryParse((v ?? '').trim());
                  if (n == null) return 'Harus berupa angka bulat';
                  if (n <= 0) return 'Durasi minimal 1 jam';
                  if (n > 24) return 'Durasi maksimal 24 jam';
                  return null;
                },
              ),
              const SizedBox(height: 8),
              InkWell(
                onTap: _pilihTanggal,
                child: InputDecorator(
                  decoration: const InputDecoration(
                    labelText: 'Tanggal Sewa',
                    suffixIcon: Icon(Icons.calendar_today, size: 18),
                  ),
                  child: Text(_tanggalTampil),
                ),
              ),
              if (_errorBentrok != null) ...[
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.red.shade50,
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(color: Colors.red.shade200),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(Icons.error_outline, color: Colors.red.shade700, size: 18),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          _errorBentrok!,
                          style: TextStyle(color: Colors.red.shade700, fontSize: 13),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: _isSaving ? null : () => Navigator.pop(context, false),
          child: const Text('Batal'),
        ),
        ElevatedButton(
          onPressed: _isSaving ? null : _simpan,
          child: _isSaving
              ? const SizedBox(
                  height: 16,
                  width: 16,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Text('Simpan'),
        ),
      ],
    );
  }
}
