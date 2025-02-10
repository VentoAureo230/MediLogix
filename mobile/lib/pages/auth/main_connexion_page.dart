import 'package:flutter/material.dart';

class MainConnexionPage extends StatefulWidget {
  const MainConnexionPage({super.key});

  @override
  State<MainConnexionPage> createState() => _MainConnexionPageState();
}

class _MainConnexionPageState extends State<MainConnexionPage> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Column(
          children: [
            Text('Connexion page'),
            Text('This is the connexion page'),
          ],
        ),
      )
    );
  }
}