import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  CollectionReference<Map<String, dynamic>> get _customers =>
      FirebaseFirestore.instance.collection('customers');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 88,
        elevation: 0,
        backgroundColor: const Color(0xFF101315),
        foregroundColor: Colors.white,
        surfaceTintColor: Colors.transparent,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(28)),
        ),
        centerTitle: true,
        titleSpacing: 0,
        title: Center(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  color: const Color(0xFF090B0C),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: const Color(0xFFC9A64B),
                    width: 1.4,
                  ),
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0x336D5720),
                      blurRadius: 14,
                      spreadRadius: 1,
                    ),
                  ],
                ),
                clipBehavior: Clip.antiAlias,
                padding: const EdgeInsets.all(3),
                child: Image.asset('assets/logo.png', fit: BoxFit.cover),
              ),
              const SizedBox(width: 11),
              const Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'SmartStore',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontSize: 19, fontWeight: FontWeight.w700),
                  ),
                  SizedBox(height: 2),
                  Text(
                    'Console',
                    style: TextStyle(fontSize: 14, color: Color(0xFFB8BDC0)),
                  ),
                ],
              ),
            ],
          ),
        ),
        flexibleSpace: DecoratedBox(
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xFF1A1D1F), Color(0xFF080A0B)],
            ),
            borderRadius: const BorderRadius.vertical(
              bottom: Radius.circular(28),
            ),
          ),
        ),
      ),
      body: SafeArea(
        top: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 30, 20, 26),
              child: Row(
                children: [
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Xush kelibsiz! 👋',
                          style: TextStyle(
                            fontSize: 18,
                            color: Color(0xFF65717D),
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          'SmartStore Console',
                          style: TextStyle(
                            fontSize: 25,
                            height: 1.15,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF111820),
                          ),
                        ),
                        SizedBox(height: 10),
                        Text(
                          'Savdo jarayonini boshqarish endi yanada oson!',
                          style: TextStyle(
                            fontSize: 16,
                            height: 1.4,
                            color: Color(0xFF65717D),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    width: 76,
                    height: 76,
                    decoration: const BoxDecoration(
                      color: Color(0xFFF4F1E8),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.shopping_bag_outlined,
                      size: 42,
                      color: Color(0xFFC3A567),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: FilledButton.icon(
                onPressed: () => _showAddCustomerSheet(context),
                icon: const Icon(Icons.person_add_alt_1),
                label: const Text('Mijoz qo‘shish'),
                style: FilledButton.styleFrom(
                  minimumSize: const Size.fromHeight(52),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.fromLTRB(20, 28, 20, 12),
              child: Text(
                'Mijozlar',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
              ),
            ),
            Expanded(
              child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                stream: _customers
                    .orderBy('createdAt', descending: true)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return _refreshableMessage(
                      context,
                      const Text('Mijozlar ro‘yxatini yuklab bo‘lmadi.'),
                    );
                  }
                  if (!snapshot.hasData) {
                    return _refreshableMessage(
                      context,
                      const CircularProgressIndicator(),
                    );
                  }

                  final customers = snapshot.data!.docs;
                  return RefreshIndicator(
                    onRefresh: () => _refreshCustomers(context),
                    child: ListView.separated(
                      physics: const AlwaysScrollableScrollPhysics(),
                      padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                      itemCount: customers.isEmpty ? 1 : customers.length,
                      separatorBuilder: (context, index) =>
                          const SizedBox(height: 10),
                      itemBuilder: (context, index) {
                        if (customers.isEmpty) {
                          return const SizedBox(
                            height: 300,
                            child: Center(
                              child: Text('Hozircha mijozlar yo‘q.'),
                            ),
                          );
                        }

                        final customerDocument = customers[index];
                        final customer = customerDocument.data();
                        final name =
                            customer['name'] as String? ?? 'Nomsiz mijoz';
                        final username = customer['username'] as String? ?? '';
                        final isBlocked =
                            customer['status'] == 'Blocked' ||
                            customer['isBlocked'] == true;
                        return ListTile(
                          tileColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                            side: const BorderSide(color: Color(0xFFE6EAE6)),
                          ),
                          leading: CircleAvatar(
                            backgroundColor: isBlocked
                                ? const Color(0xFFFCE8E6)
                                : const Color(0xFFE5F2EF),
                            foregroundColor: isBlocked
                                ? const Color(0xFFB23A32)
                                : const Color(0xFF137C70),
                            child: isBlocked
                                ? const Icon(Icons.lock_rounded)
                                : Text(name.characters.first.toUpperCase()),
                          ),
                          title: Text(
                            name,
                            style: const TextStyle(fontWeight: FontWeight.w600),
                          ),
                          subtitle: Text('@$username'),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                tooltip: 'Ma’lumotlar',
                                onPressed: () => _showCustomerInfo(
                                  context,
                                  customerDocument,
                                ),
                                icon: const Icon(Icons.info_outline_rounded),
                              ),
                              IconButton(
                                tooltip: isBlocked
                                    ? 'Blokdan chiqarish'
                                    : 'Bloklash',
                                onPressed: () => _toggleCustomerBlock(
                                  context,
                                  customerDocument,
                                  isBlocked,
                                ),
                                color: isBlocked
                                    ? const Color(0xFF137C70)
                                    : const Color(0xFFB23A32),
                                icon: Icon(
                                  isBlocked
                                      ? Icons.lock_open_rounded
                                      : Icons.block_rounded,
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _refreshableMessage(BuildContext context, Widget message) {
    return RefreshIndicator(
      onRefresh: () => _refreshCustomers(context),
      child: ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        children: [SizedBox(height: 300, child: Center(child: message))],
      ),
    );
  }

  Future<void> _refreshCustomers(BuildContext context) async {
    try {
      await _customers.orderBy('createdAt', descending: true).get();
    } on FirebaseException catch (error) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(_firebaseErrorText('Yangilash', error))),
      );
    }
  }

  void _showCustomerInfo(
    BuildContext context,
    QueryDocumentSnapshot<Map<String, dynamic>> customerDocument,
  ) {
    showDialog<void>(
      context: context,
      builder: (context) => Dialog(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
            stream: customerDocument.reference.snapshots(),
            builder: (context, snapshot) {
              final customer = snapshot.data?.data() ?? customerDocument.data();
              final name = customer['name'] as String? ?? 'Nomsiz mijoz';
              final username = customer['username'] as String? ?? '';
              final password = customer['password'] as String?;
              final passwordWasUpdated = customer['passwordUpdatedAt'] != null;

              return Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'Mijoz ma’lumotlari',
                    style: Theme.of(context).textTheme.titleLarge
                        ?.copyWith(fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: 20),
                  _CustomerInfoRow(label: 'Ism familiya', value: name),
                  _CustomerInfoRow(label: 'Username', value: username),
                  if (!passwordWasUpdated && password != null)
                    _CustomerInfoRow(label: 'Password', value: password)
                  else if (passwordWasUpdated)
                    const Text(
                      'Parol yangilangan va maxfiyligi sababli ko‘rsatilmaydi.',
                    ),
                  const SizedBox(height: 16),
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: const Text('Yopish'),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Future<void> _toggleCustomerBlock(
    BuildContext context,
    QueryDocumentSnapshot<Map<String, dynamic>> customerDocument,
    bool isBlocked,
  ) async {
    final action = isBlocked ? 'blokdan chiqarilsinmi?' : 'bloklansinmi?';
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(isBlocked ? 'Blokdan chiqarish' : 'Mijozni bloklash'),
        content: Text('${customerDocument.data()['name'] ?? 'Mijoz'} $action'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Bekor qilish'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text(isBlocked ? 'Chiqarish' : 'Bloklash'),
          ),
        ],
      ),
    );
    if (confirmed != true) return;

    try {
      await customerDocument.reference.update({
        'status': isBlocked ? 'Active' : 'Blocked',
        'isBlocked': !isBlocked,
      });
    } on FirebaseException catch (error) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(_firebaseErrorText('Holatni yangilash', error))),
      );
    }
  }

  String _firebaseErrorText(String action, FirebaseException error) {
    if (error.code == 'permission-denied') {
      return '$action: Firestore Rules bu amalga ruxsat bermadi '
          '(permission-denied). Firebase Console’dagi Rules’ni tekshiring.';
    }
    return '$action (${error.code}): '
        '${error.message ?? 'Firebase bilan bog‘lanib bo‘lmadi.'}';
  }

  Future<void> _showAddCustomerSheet(BuildContext context) async {
    final credentials = _generateCredentials();

    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (context) =>
          _AddCustomerSheet(customers: _customers, credentials: credentials),
    );
  }

  _CustomerCredentials _generateCredentials() {
    const alphabet = 'abcdefghjkmnpqrstuvwxyz23456789';
    const passwordDigits = '0123456789';
    final random = Random.secure();
    String generate(String characters, int length) => String.fromCharCodes(
      List.generate(
        length,
        (_) => characters.codeUnitAt(random.nextInt(characters.length)),
      ),
    );

    return _CustomerCredentials(
      username: 'm_${generate(alphabet, 4)}',
      password: generate(passwordDigits, 8),
    );
  }
}

class _AddCustomerSheet extends StatefulWidget {
  const _AddCustomerSheet({required this.customers, required this.credentials});

  final CollectionReference<Map<String, dynamic>> customers;
  final _CustomerCredentials credentials;

  @override
  State<_AddCustomerSheet> createState() => _AddCustomerSheetState();
}

class _AddCustomerSheetState extends State<_AddCustomerSheet> {
  final _nameController = TextEditingController();
  late final TextEditingController _usernameController;
  late final TextEditingController _passwordController;

  @override
  void initState() {
    super.initState();
    _usernameController = TextEditingController(
      text: widget.credentials.username,
    );
    _passwordController = TextEditingController(
      text: widget.credentials.password,
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(
        20,
        8,
        20,
        MediaQuery.viewInsetsOf(context).bottom + 24,
      ),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Yangi mijoz',
              style: Theme.of(context).textTheme.titleLarge
                  ?.copyWith(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _nameController,
              textCapitalization: TextCapitalization.words,
              decoration: const InputDecoration(
                labelText: 'Ism va familiya',
                prefixIcon: Icon(Icons.person_outline),
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 14),
            TextField(
              readOnly: true,
              controller: _usernameController,
              decoration: const InputDecoration(
                labelText: 'Username',
                prefixIcon: Icon(Icons.alternate_email),
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 14),
            TextField(
              readOnly: true,
              controller: _passwordController,
              decoration: const InputDecoration(
                labelText: 'Password',
                prefixIcon: Icon(Icons.lock_outline),
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            FilledButton(
              onPressed: _saveCustomer,
              style: FilledButton.styleFrom(
                minimumSize: const Size.fromHeight(50),
              ),
              child: const Text('Qo‘shish'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _saveCustomer() async {
    final name = _nameController.text.trim();
    if (name.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Ism va familiyani kiriting.')),
      );
      return;
    }

    try {
      await widget.customers.add({
        'name': name,
        'username': widget.credentials.username,
        'password': widget.credentials.password,
        'createdAt': FieldValue.serverTimestamp(),
      });
      if (mounted) Navigator.of(context).pop();
    } on FirebaseException catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(_firebaseErrorText('Saqlash', error))),
      );
    }
  }

  String _firebaseErrorText(String action, FirebaseException error) {
    if (error.code == 'permission-denied') {
      return '$action: Firestore Rules yozishga ruxsat bermadi '
          '(permission-denied). Firebase Console’dagi Rules’ni tekshiring.';
    }
    return '$action (${error.code}): '
        '${error.message ?? 'Firebase bilan bog‘lanib bo‘lmadi.'}';
  }
}

class _CustomerInfoRow extends StatelessWidget {
  const _CustomerInfoRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: Theme.of(context).textTheme.labelMedium
                ?.copyWith(color: const Color(0xFF65717D)),
          ),
          const SizedBox(height: 4),
          SelectableText(
            value,
            style: Theme.of(context).textTheme.bodyLarge
                ?.copyWith(fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}

class _CustomerCredentials {
  const _CustomerCredentials({required this.username, required this.password});

  final String username;
  final String password;
}
