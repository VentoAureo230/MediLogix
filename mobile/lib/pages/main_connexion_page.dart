import 'package:flutter/material.dart';

class MainConnexionPage extends StatefulWidget {
  const MainConnexionPage({super.key});

  @override
  State<MainConnexionPage> createState() => _MainConnexionPageState();
}

class _MainConnexionPageState extends State<MainConnexionPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Connexion'),
      ),
      body: const SingleChildScrollView(
        child: Column(
          children: [
            Text('Hello !'),
          ],
        ),
      ),
    );
  }
}