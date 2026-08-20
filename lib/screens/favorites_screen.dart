// ignore_for_file: unnecessary_underscores

import 'package:flutter/material.dart';

import '../database/database_helper.dart';
import '../models/contact.dart';
import '../widgets/contact_avatar.dart';
import 'add_edit_contact_screen.dart';
import 'contact_details_screen.dart';

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({super.key});

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  List<Contact> _contacts = [];
  bool _loading = true;

  static const primary = Color(0xFF4B4BEA);

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final contacts = await DatabaseHelper.instance.getFavoriteContacts();
    if (!mounted) return;
    setState(() {
      _contacts = contacts;
      _loading = false;
    });
  }

  Future<void> _add() async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const AddEditContactScreen()),
    );
    _load();
  }

  Future<void> _open(Contact contact) async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => ContactDetailsScreen(contact: contact)),
    );
    _load();
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
          'Favorites',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
        ),
        actions: [
          IconButton(onPressed: _load, icon: const Icon(Icons.refresh)),
        ],
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _contacts.isEmpty
          ? const Center(
              child: Text(
                'No favorite contacts yet',
                style: TextStyle(color: Colors.grey, fontSize: 13),
              ),
            )
          : ListView.separated(
              padding: const EdgeInsets.fromLTRB(12, 14, 12, 90),
              itemCount: _contacts.length,
              separatorBuilder: (_, __) => const Divider(height: 1),
              itemBuilder: (_, index) {
                final contact = _contacts[index];
                return ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 4),
                  leading: ContactAvatar(name: contact.name, radius: 19),
                  title: Text(
                    contact.name,
                    style: const TextStyle(
                      fontSize: 12.5,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  subtitle: Text(
                    contact.phone,
                    style: const TextStyle(fontSize: 10.5),
                  ),
                  trailing: const Icon(
                    Icons.star,
                    color: Colors.amber,
                    size: 19,
                  ),
                  onTap: () => _open(contact),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: primary,
        foregroundColor: Colors.white,
        onPressed: _add,
        child: const Icon(Icons.add, size: 30),
      ),
    );
  }
}
