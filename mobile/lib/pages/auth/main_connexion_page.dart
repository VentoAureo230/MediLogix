import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class MainConnexionPage extends StatefulWidget {
  const MainConnexionPage({super.key});

  @override
  State<MainConnexionPage> createState() => _MainConnexionPageState();
}

class _MainConnexionPageState extends State<MainConnexionPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Connexion page'),
            const Text('This is the connexion page'),
            ElevatedButton(onPressed : () {
              context.go('/scanner'); 
            },
            child: const Text('Scanner un médicament'))
          ],
        ),
      )
    );
  }
}