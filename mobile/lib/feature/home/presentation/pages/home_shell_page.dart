import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../authentication/presentation/bloc/authentication_bloc.dart';

/// Root of the authenticated area of the app.
///
/// Owns the [BottomNavigationBar] and delegates the actual page rendering to
/// the [StatefulNavigationShell] provided by go_router. Each branch keeps its
/// own navigation stack so switching tabs preserves scroll position and
/// pushed routes.
class HomeShellPage extends StatelessWidget {
  const HomeShellPage({super.key, required this.navigationShell});

  final StatefulNavigationShell navigationShell;

  static const List<_ShellTab> _tabs = [
    _ShellTab(
      icon: Icons.assignment_outlined,
      activeIcon: Icons.assignment,
      label: 'Commandes',
    ),
    _ShellTab(
      icon: Icons.medication_outlined,
      activeIcon: Icons.medication,
      label: 'Médicaments',
    ),
    _ShellTab(
      icon: Icons.qr_code_scanner_outlined,
      activeIcon: Icons.qr_code_scanner,
      label: 'Scan',
    ),
  ];

  void _onTabTapped(int index) {
    // `initialLocation: true` re-runs the branch's initial route when the
    // user taps the already-active tab — expected UX for reset-to-root.
    navigationShell.goBranch(
      index,
      initialLocation: index == navigationShell.currentIndex,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_tabs[navigationShell.currentIndex].label),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Se déconnecter',
            onPressed: () => context
                .read<AuthenticationBloc>()
                .add(const AuthLogoutRequested()),
          ),
        ],
      ),
      body: navigationShell,
      bottomNavigationBar: NavigationBar(
        selectedIndex: navigationShell.currentIndex,
        onDestinationSelected: _onTabTapped,
        destinations: [
          for (final tab in _tabs)
            NavigationDestination(
              icon: Icon(tab.icon),
              selectedIcon: Icon(tab.activeIcon),
              label: tab.label,
            ),
        ],
      ),
    );
  }
}

class _ShellTab {
  const _ShellTab({
    required this.icon,
    required this.activeIcon,
    required this.label,
  });

  final IconData icon;
  final IconData activeIcon;
  final String label;
}
