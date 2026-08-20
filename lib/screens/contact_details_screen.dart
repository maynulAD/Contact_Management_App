// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';

import '../database/database_helper.dart';
import '../models/contact.dart';
import '../widgets/contact_avatar.dart';
import 'add_edit_contact_screen.dart';

class ContactDetailsScreen extends StatefulWidget {
  final Contact contact;

  const ContactDetailsScreen({super.key, required this.contact});

  @override
  State<ContactDetailsScreen> createState() => _ContactDetailsScreenState();
}

class _ContactDetailsScreenState extends State<ContactDetailsScreen> {
  late Contact _contact;

  @override
  void initState() {
    super.initState();
    _contact = widget.contact;
  }

  Future<void> _edit() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => AddEditContactScreen(contact: _contact),
      ),
    );

    if (result == true && mounted) {
      final contacts = await DatabaseHelper.instance.getContacts();
      final updated = contacts.where((c) => c.id == _contact.id);
      if (updated.isEmpty) {
        Navigator.pop(context, true);
        return;
      }
      setState(() => _contact = updated.first);
    }
  }

  Future<void> _toggleFavorite() async {
    await DatabaseHelper.instance.toggleFavorite(_contact);
    setState(() {
      _contact = _contact.copyWith(isFavorite: !_contact.isFavorite);
    });
  }

  Future<void> _delete() async {
    final confirmed = await showDialog<bool>(
      context: context,
      barrierColor: Colors.black54,
      builder: (dialogContext) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        contentPadding: const EdgeInsets.fromLTRB(18, 16, 18, 16),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 46,
              height: 46,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Color(0xFFFFE2E2),
              ),
              child: const Icon(Icons.delete, color: Colors.red),
            ),
            const SizedBox(height: 12),
            const Text(
              'Delete Contact',
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 8),
            Text(
              'Are you sure you want to delete\n${_contact.name}?',
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 11, color: Colors.black54),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(dialogContext, false),
                    child: const Text('Cancel'),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => Navigator.pop(dialogContext, true),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white,
                    ),
                    child: const Text('Delete'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );

    if (confirmed == true && _contact.id != null) {
      await DatabaseHelper.instance.deleteContact(_contact.id!);
      if (!mounted) return;
      Navigator.pop(context, true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Contact Details',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
        ),
        actions: [
          IconButton(
            tooltip: 'Favorite',
            onPressed: _toggleFavorite,
            icon: Icon(
              _contact.isFavorite ? Icons.star : Icons.star_border,
              color: _contact.isFavorite ? Colors.amber : Colors.white,
            ),
          ),
          IconButton(
            tooltip: 'Edit',
            onPressed: _edit,
            icon: const Icon(Icons.edit),
          ),
          IconButton(
            tooltip: 'Delete',
            onPressed: _delete,
            icon: const Icon(Icons.delete_outline),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(12, 28, 12, 30),
        children: [
          Center(child: ContactAvatar(name: _contact.name, radius: 30)),
          const SizedBox(height: 10),
          Center(
            child: Text(
              _contact.name,
              style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
            ),
          ),
          if (_contact.isFavorite) ...[
            const SizedBox(height: 5),
            const Center(
              child: Text(
                'Favorite Contact',
                style: TextStyle(
                  fontSize: 10,
                  color: Colors.amber,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
          const SizedBox(height: 26),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 8),
            decoration: BoxDecoration(
              border: Border.all(color: const Color(0xFFE3E3E3)),
              borderRadius: BorderRadius.circular(11),
            ),
            child: Column(
              children: [
                _detailRow(
                  icon: Icons.phone,
                  value: _contact.phone,
                  label: 'Mobile',
                ),
                _detailRow(
                  icon: Icons.email,
                  value: _contact.email,
                  label: 'Email',
                ),
                _detailRow(
                  icon: Icons.location_on,
                  value: _contact.address,
                  label: 'Address',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _detailRow({
    required IconData icon,
    required String value,
    required String label,
  }) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20, color: Colors.blueGrey.shade700),
          const SizedBox(width: 13),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 11.5,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  label,
                  style: const TextStyle(fontSize: 10, color: Colors.grey),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
