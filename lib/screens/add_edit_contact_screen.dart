import 'package:flutter/material.dart';

import '../database/database_helper.dart';
import '../models/contact.dart';

class AddEditContactScreen extends StatefulWidget {
  final Contact? contact;

  const AddEditContactScreen({super.key, this.contact});

  bool get isEditing => contact != null;

  @override
  State<AddEditContactScreen> createState() => _AddEditContactScreenState();
}

class _AddEditContactScreenState extends State<AddEditContactScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _addressController = TextEditingController();

  bool _saving = false;
  static const primary = Color(0xFF4B4BEA);

  @override
  void initState() {
    super.initState();
    final contact = widget.contact;
    if (contact != null) {
      _nameController.text = contact.name;
      _phoneController.text = contact.phone;
      _emailController.text = contact.email;
      _addressController.text = contact.address;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _saving = true);

    final contact = Contact(
      id: widget.contact?.id,
      name: _nameController.text.trim(),
      phone: _phoneController.text.trim(),
      email: _emailController.text.trim(),
      address: _addressController.text.trim(),
      isFavorite: widget.contact?.isFavorite ?? false,
    );

    if (widget.isEditing) {
      await DatabaseHelper.instance.updateContact(contact);
    } else {
      await DatabaseHelper.instance.insertContact(contact);
    }

    if (!mounted) return;
    Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    final editing = widget.isEditing;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          editing ? 'Edit Contact' : 'Add Contact',
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
        ),
        actions: [
          if (editing)
            IconButton(
              icon: const Icon(Icons.check),
              onPressed: _saving ? null : _save,
            )
          else
            Padding(
              padding: const EdgeInsets.only(right: 8),
              child: CircleAvatar(
                radius: 17,
                backgroundColor: const Color(0xFF3928CE),
                child: IconButton(
                  padding: EdgeInsets.zero,
                  iconSize: 21,
                  color: Colors.white,
                  onPressed: _saving ? null : _save,
                  icon: const Icon(Icons.check),
                ),
              ),
            ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(12, 28, 12, 30),
          children: [
            Center(
              child: Container(
                width: 70,
                height: 70,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Color(0xFFEAE8FF),
                ),
                child: const Icon(
                  Icons.camera_alt,
                  color: primary,
                  size: 29,
                ),
              ),
            ),
            const SizedBox(height: 28),
            _field(
              controller: _nameController,
              label: 'Name',
              icon: Icons.person_outline,
              validator: (value) =>
                  value == null || value.trim().isEmpty ? 'Enter name' : null,
            ),
            _field(
              controller: _phoneController,
              label: 'Phone Number',
              icon: Icons.phone,
              keyboardType: TextInputType.phone,
              validator: (value) => value == null || value.trim().isEmpty
                  ? 'Enter phone number'
                  : null,
            ),
            _field(
              controller: _emailController,
              label: 'Email',
              icon: Icons.email_outlined,
              keyboardType: TextInputType.emailAddress,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Enter email';
                }
                if (!value.contains('@')) return 'Enter a valid email';
                return null;
              },
            ),
            _field(
              controller: _addressController,
              label: 'Address',
              icon: Icons.location_on_outlined,
              maxLines: 2,
              validator: (value) => value == null || value.trim().isEmpty
                  ? 'Enter address'
                  : null,
            ),
            const SizedBox(height: 8),
            SizedBox(
              height: 46,
              child: ElevatedButton(
                onPressed: _saving ? null : _save,
                style: ElevatedButton.styleFrom(
                  backgroundColor: primary,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(9),
                  ),
                ),
                child: Text(
                  _saving
                      ? 'Saving...'
                      : editing
                          ? 'Update Contact'
                          : 'Save Contact',
                  style: const TextStyle(fontSize: 13),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _field({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType? keyboardType,
    int maxLines = 1,
    String? Function(String?)? validator,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 9),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        maxLines: maxLines,
        validator: validator,
        style: const TextStyle(fontSize: 13),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(fontSize: 11, color: Colors.grey),
          prefixIcon: Icon(icon, size: 20, color: Colors.grey.shade600),
          alignLabelWithHint: maxLines > 1,
        ),
      ),
    );
  }
}
