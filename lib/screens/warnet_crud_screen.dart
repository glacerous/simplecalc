import 'package:flutter/material.dart';
import '../helpers/database_helper.dart';

class WarnetCrudScreen extends StatefulWidget {
  const WarnetCrudScreen({super.key});

  @override
  State<WarnetCrudScreen> createState() => _WarnetCrudScreenState();
}

class _WarnetCrudScreenState extends State<WarnetCrudScreen> {
  List<Map<String, dynamic>> _rentals = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _refreshData();
  }

  Future<void> _refreshData() async {
    setState(() => _isLoading = true);
    final data = await DatabaseHelper.instance.getRentals();
    setState(() {
      _rentals = data;
      _isLoading = false;
    });
  }

  void _showForm({Map<String, dynamic>? item}) {
    final isEdit = item != null;
    final namaController = TextEditingController(text: isEdit ? item['nama'] : '');
    final pcController = TextEditingController(text: isEdit ? item['nomor_pc'] : 'PC-01');
    final durasiController = TextEditingController(text: isEdit ? item['durasi'].toString() : '2');

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(isEdit ? 'Edit Sesi' : 'Tambah Sesi'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: namaController,
              decoration: const InputDecoration(labelText: 'Nama Pelanggan'),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: pcController,
              decoration: const InputDecoration(labelText: 'Nomor PC'),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: durasiController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Durasi (Jam)'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () async {
              final nama = namaController.text.trim();
              final pc = pcController.text.trim();
              final durasi = int.tryParse(durasiController.text.trim()) ?? 1;
              final total = durasi * 5000; // Tarif flat Rp 5.000 / jam

              if (nama.isEmpty || pc.isEmpty) return;

              final row = {
                'nama': nama,
                'nomor_pc': pc,
                'durasi': durasi,
                'total': total,
                'status': isEdit ? item['status'] : 'Aktif',
              };

              if (isEdit) {
                await DatabaseHelper.instance.updateRental(item['id'], row);
              } else {
                await DatabaseHelper.instance.insertRental(row);
              }

              if (!mounted) return;
              Navigator.pop(ctx);
              _refreshData();
            },
            child: const Text('Simpan'),
          ),
        ],
      ),
    );
  }

  void _hapusData(int id) async {
    await DatabaseHelper.instance.deleteRental(id);
    _refreshData();
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Data berhasil dihapus')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Kelola Sesi (CRUD)'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showForm(),
        child: const Icon(Icons.add),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _rentals.isEmpty
              ? const Center(child: Text('Belum ada data sesi.'))
              : ListView.builder(
                  padding: const EdgeInsets.all(12),
                  itemCount: _rentals.length,
                  itemBuilder: (context, index) {
                    final item = _rentals[index];
                    return Card(
                      margin: const EdgeInsets.symmetric(vertical: 6),
                      child: ListTile(
                        leading: CircleAvatar(
                          child: Text('${index + 1}'),
                        ),
                        title: Text(
                          '${item['nama']} (${item['nomor_pc']})',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text(
                          'Durasi: ${item['durasi']} Jam • Total: Rp ${item['total']} • Status: ${item['status']}',
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.edit, color: Colors.blue),
                              onPressed: () => _showForm(item: item),
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () => _hapusData(item['id']),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}
