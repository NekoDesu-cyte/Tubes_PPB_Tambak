import 'package:flutter/material.dart';
import 'services/auth_service.dart';

class EditProfilePage extends StatefulWidget {
  // Kita terima data awal dari halaman sebelumnya
  final Map<String, dynamic> userData;

  const EditProfilePage({super.key, required this.userData});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final _formKey = GlobalKey<FormState>();
  final AuthService _authService = AuthService();
  bool _isLoading = false;

  // Controller untuk input text
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;
  late TextEditingController _addressController;
  late TextEditingController _passwordController;

  @override
  void initState() {
    super.initState();
    // Isi form dengan data yang sudah ada (Pre-fill)
    _nameController = TextEditingController(text: widget.userData['name'] ?? '');
    _emailController = TextEditingController(text: widget.userData['email'] ?? '');

    // Cek nama kolom di database kamu (phone/no_hp/telepon) sesuaikan di sini
    _phoneController = TextEditingController(text: widget.userData['phone'] ?? widget.userData['no_hp'] ?? '');
    _addressController = TextEditingController(text: widget.userData['address'] ?? widget.userData['alamat'] ?? '');

    // Password kosongkan saja, diisi hanya jika ingin ganti password
    _passwordController = TextEditingController();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _saveProfile() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);

      // Siapkan data yang mau dikirim
      Map<String, String> dataToSend = {
        'name': _nameController.text,
        'email': _emailController.text,
        'phone': _phoneController.text, // Pastikan di Laravel request->phone
        'address': _addressController.text, // Pastikan di Laravel request->address
      };

      // Hanya kirim password jika diisi
      if (_passwordController.text.isNotEmpty) {
        dataToSend['password'] = _passwordController.text;
      }

      bool success = await _authService.updateProfile(dataToSend);

      setState(() => _isLoading = false);

      if (success) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Profil berhasil diperbarui!'), backgroundColor: Colors.green),
          );
          // Kembali ke halaman profil dengan membawa pesan sukses
          Navigator.pop(context, true);
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Gagal memperbarui profil. Cek koneksi atau data.'), backgroundColor: Colors.red),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit Profil"),
        backgroundColor: const Color(0xFF005A9C),
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              _buildTextField("Nama Lengkap", _nameController, Icons.person),
              const SizedBox(height: 16),
              _buildTextField("Email", _emailController, Icons.email, isEmail: true),
              const SizedBox(height: 16),
              _buildTextField("Nomor Telepon", _phoneController, Icons.phone, isNumber: true),
              const SizedBox(height: 16),
              _buildTextField("Alamat", _addressController, Icons.location_on, maxLines: 3),
              const SizedBox(height: 16),

              const Divider(),
              const SizedBox(height: 8),
              const Text("Kosongkan jika tidak ingin mengganti password", style: TextStyle(color: Colors.grey, fontSize: 12)),
              const SizedBox(height: 8),
              _buildTextField("Password Baru (Opsional)", _passwordController, Icons.lock, isPassword: true),

              const SizedBox(height: 32),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _saveProfile,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue[800],
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  child: _isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text("SIMPAN PERUBAHAN", style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller, IconData icon,
      {bool isPassword = false, bool isNumber = false, bool isEmail = false, int maxLines = 1}) {
    return TextFormField(
      controller: controller,
      obscureText: isPassword,
      keyboardType: isNumber ? TextInputType.phone : (isEmail ? TextInputType.emailAddress : TextInputType.text),
      maxLines: maxLines,
      validator: (value) {
        if (!isPassword && (value == null || value.isEmpty)) {
          return '$label tidak boleh kosong';
        }
        return null;
      },
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: Colors.blue[700]),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        filled: true,
        fillColor: Colors.grey[50],
      ),
    );
  }
}