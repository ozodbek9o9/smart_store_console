import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'firebase_options.dart';
import 'pages/dashboard_page.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const SmartStoreConsole());
}

class SmartStoreConsole extends StatelessWidget {
  const SmartStoreConsole({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SmartStore Console',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF137C70),
          surface: const Color(0xFFF7F8F5),
        ),
        scaffoldBackgroundColor: const Color(0xFFF7F8F5),
        useMaterial3: true,
      ),
      home: const StartupPage(),
    );
  }
}

class StartupPage extends StatefulWidget {
  const StartupPage({super.key, this.loadData});

  final Future<void> Function()? loadData;

  @override
  State<StartupPage> createState() => _StartupPageState();
}

class _StartupPageState extends State<StartupPage> {
  late Future<void> _startup;

  @override
  void initState() {
    super.initState();
    _startup = _loadData();
  }

  Future<void> _loadData() => widget.loadData?.call() ?? _loadFirebaseData();

  Future<void> _loadFirebaseData() async {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    await FirebaseFirestore.instance.collection('customers').limit(1).get();
  }

  void _retry() {
    setState(() => _startup = _loadData());
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<void>(
      future: _startup,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done &&
            !snapshot.hasError) {
          return const DashboardPage();
        }

        return Scaffold(
          body: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFF202426), Color(0xFF090B0C)],
              ),
            ),
            child: SafeArea(
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(32),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 124,
                        height: 124,
                        padding: const EdgeInsets.all(5),
                        decoration: BoxDecoration(
                          color: const Color(0xFF0A0C0D),
                          borderRadius: BorderRadius.circular(31),
                          border: Border.all(
                            color: const Color(0xFFC9A64B),
                            width: 1.5,
                          ),
                          boxShadow: const [
                            BoxShadow(
                              color: Color(0x445D4A1C),
                              blurRadius: 28,
                              spreadRadius: 2,
                            ),
                          ],
                        ),
                        clipBehavior: Clip.antiAlias,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(25),
                          child: Image.asset(
                            'assets/logo.png',
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                      Text(
                        'SmartStore Console',
                        style: Theme.of(context).textTheme.headlineSmall
                            ?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                            ),
                      ),
                      const SizedBox(height: 28),
                      if (snapshot.hasError) ...[
                        const Text(
                          'Firebase ma’lumotlarini yuklab bo‘lmadi.',
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Color(0xFFD5D8D9)),
                        ),
                        const SizedBox(height: 12),
                        FilledButton.icon(
                          onPressed: _retry,
                          icon: const Icon(Icons.refresh),
                          label: const Text('Qayta urinish'),
                        ),
                      ] else ...[
                        const SizedBox(
                          width: 26,
                          height: 26,
                          child: CircularProgressIndicator(
                            strokeWidth: 2.5,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              Color(0xFFC9A64B),
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'Firebase ma’lumotlari yuklanmoqda...',
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(color: const Color(0xFFB8BDC0)),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
