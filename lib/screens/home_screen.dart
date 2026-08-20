import 'package:flutter/material.dart';

import '../database/database_helper.dart';
import '../models/contact.dart';
import '../widgets/contact_avatar.dart';
import 'add_edit_contact_screen.dart';
import 'contact_details_screen.dart';
import 'favorites_screen.dart';
import 'settings_screen.dart';

class HomeScreen extends StatefulWidget {
  final bool isDarkMode;
  final ValueChanged<bool> onThemeChanged;

  const HomeScreen({
    super.key,
    required this.isDarkMode,
    required this.onThemeChanged,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final DatabaseHelper _db = DatabaseHelper.instance;
  final TextEditingController _searchController = TextEditingController();

  List<Contact> _contacts = [];
  bool _isLoading = true;
  bool _searching = false;

  static const Color primary = Color(0xFF4B4BEA);

  @override
  void initState() {
    super.initState();
    _loadContacts();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadContacts() async {
    final contacts = await _db.getContacts();
    if (!mounted) return;
    setState(() {
      _contacts = contacts;
      _isLoading = false;
    });
  }

  Future<void> _search(String value) async {
    if (value.trim().isEmpty) {
      _loadContacts();
      return;
    }
    final contacts = await _db.searchContacts(value.trim());
    if (!mounted) return;
    setState(() => _contacts = contacts);
  }

  Future<void> _openAdd() async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const AddEditContactScreen()),
    );
    _loadContacts();
  }

  Future<void> _openDetails(Contact contact) async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => ContactDetailsScreen(contact: contact)),
    );
    _loadContacts();
  }

  Future<void> _openFavorites() async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const FavoritesScreen()),
    );
    _loadContacts();
  }

  void _openSettings() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => SettingsScreen(
          isDarkMode: widget.isDarkMode,
          onThemeChanged: widget.onThemeChanged,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      drawer: _buildDrawer(),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _contacts.isEmpty
          ? _buildEmptyState()
          : _buildContactList(),
      floatingActionButton: FloatingActionButton(
        backgroundColor: primary,
        foregroundColor: Colors.white,
        elevation: 3,
        onPressed: _openAdd,
        child: const Icon(Icons.add, size: 30),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    if (_searching) {
      return AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            setState(() {
              _searching = false;
              _searchController.clear();
            });
            _loadContacts();
          },
        ),
        title: Container(
          height: 38,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
          ),
          child: TextField(
            controller: _searchController,
            autofocus: true,
            onChanged: _search,
            style: const TextStyle(color: Colors.black87, fontSize: 14),
            decoration: const InputDecoration(
              hintText: 'Search contacts...',
              hintStyle: TextStyle(color: Colors.grey, fontSize: 13),
              prefixIcon: Icon(Icons.search, color: Colors.grey, size: 19),
              contentPadding: EdgeInsets.symmetric(vertical: 0),
              border: InputBorder.none,
              enabledBorder: InputBorder.none,
              focusedBorder: InputBorder.none,
            ),
          ),
        ),
      );
    }

    return AppBar(
      title: const Text(
        'My Contacts',
        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
      ),
      actions: [
        IconButton(
          tooltip: 'Search',
          onPressed: () => setState(() => _searching = true),
          icon: const Icon(Icons.search),
        ),
        PopupMenuButton<String>(
          onSelected: (value) {
            if (value == 'favorites') _openFavorites();
            if (value == 'settings') _openSettings();
          },
          itemBuilder: (_) => const [
            PopupMenuItem(
              value: 'favorites',
              child: ListTile(
                contentPadding: EdgeInsets.zero,
                leading: Icon(Icons.star),
                title: Text('Favorites'),
              ),
            ),
            PopupMenuItem(
              value: 'settings',
              child: ListTile(
                contentPadding: EdgeInsets.zero,
                leading: Icon(Icons.settings),
                title: Text('Settings'),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildContactList() {
    return RefreshIndicator(
      onRefresh: _loadContacts,
      child: ListView(
        padding: const EdgeInsets.fromLTRB(12, 10, 12, 90),
        children: [
          if (!_searching)
            Container(
              height: 42,
              margin: const EdgeInsets.only(bottom: 8),
              child: TextField(
                onChanged: _search,
                decoration: const InputDecoration(
                  hintText: 'Search contacts...',
                  prefixIcon: Icon(Icons.search, size: 19),
                  suffixIcon: Icon(Icons.search, size: 18, color: Colors.grey),
                  contentPadding: EdgeInsets.symmetric(vertical: 8),
                ),
              ),
            ),
          ..._contacts.map(_contactTile),
        ],
      ),
    );
  }

  Widget _contactTile(Contact contact) {
    return InkWell(
      borderRadius: BorderRadius.circular(10),
      onTap: () => _openDetails(contact),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
        child: Row(
          children: [
            ContactAvatar(name: contact.name, radius: 19),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    contact.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 13,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    contact.email,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 10.5,
                      color: Theme.of(context).textTheme.bodySmall?.color
                          // ignore: deprecated_member_use
                          ?.withOpacity(.65),
                    ),
                  ),
                  Text(
                    contact.phone,
                    style: TextStyle(
                      fontSize: 10.5,
                      color: Theme.of(context).textTheme.bodySmall?.color
                          // ignore: deprecated_member_use
                          ?.withOpacity(.65),
                    ),
                  ),
                ],
              ),
            ),
            if (contact.isFavorite)
              const Padding(
                padding: EdgeInsets.only(right: 5),
                child: Icon(Icons.star, color: Colors.amber, size: 18),
              ),
            const Icon(Icons.chevron_right, color: Colors.grey, size: 22),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.only(bottom: 50),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 150,
              height: 125,
              decoration: BoxDecoration(
                color: const Color(0xFFF1EFFF),
                borderRadius: BorderRadius.circular(28),
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    width: 70,
                    height: 88,
                    decoration: BoxDecoration(
                      color: const Color(0xFFD9D5FF),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(
                      Icons.person_outline,
                      color: Color(0xFF9C95F1),
                      size: 44,
                    ),
                  ),
                  const Positioned(
                    right: 18,
                    bottom: 18,
                    child: Icon(
                      Icons.person,
                      size: 38,
                      color: Color(0xFF4B4BEA),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'No contacts yet',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 6),
            const Text(
              'Add your first contact by tapping\n'
              'the + button below.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDrawer() {
    return Drawer(
      child: SafeArea(
        child: Column(
          children: [
            Container(
              height: 155,
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(22, 22, 22, 18),
              decoration: const BoxDecoration(color: primary),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Icon(Icons.groups, color: Colors.white, size: 42),
                  SizedBox(height: 8),
                  Text(
                    'My Contacts',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 17,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 3),
                  Text(
                    'Manage your friends easily',
                    style: TextStyle(color: Colors.white70, fontSize: 11),
                  ),
                ],
              ),
            ),
            _drawerItem(
              icon: Icons.contacts,
              title: 'My Contacts',
              selected: true,
              onTap: () => Navigator.pop(context),
            ),
            _drawerItem(
              icon: Icons.star,
              title: 'Favorites',
              onTap: () {
                Navigator.pop(context);
                _openFavorites();
              },
            ),
            _drawerItem(
              icon: Icons.person_add,
              title: 'Add Contact',
              onTap: () {
                Navigator.pop(context);
                _openAdd();
              },
            ),
            const Divider(height: 12),
            _drawerItem(
              icon: Icons.info_outline,
              title: 'About App',
              onTap: () => Navigator.pop(context),
            ),
            _drawerItem(
              icon: Icons.settings,
              title: 'Settings',
              onTap: () {
                Navigator.pop(context);
                _openSettings();
              },
            ),
            _drawerItem(
              icon: Icons.logout,
              title: 'Logout',
              onTap: () => Navigator.pop(context),
            ),
          ],
        ),
      ),
    );
  }

  Widget _drawerItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    bool selected = false,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: selected ? const Color(0xFFEDEBFF) : null,
        borderRadius: BorderRadius.circular(6),
      ),
      child: ListTile(
        dense: true,
        leading: Icon(
          icon,
          size: 19,
          color: selected ? primary : Colors.black54,
        ),
        title: Text(
          title,
          style: TextStyle(
            fontSize: 13,
            color: selected ? primary : null,
            fontWeight: selected ? FontWeight.w600 : FontWeight.w500,
          ),
        ),
        trailing: const Icon(Icons.chevron_right, size: 18, color: Colors.grey),
        onTap: onTap,
      ),
    );
  }
}
