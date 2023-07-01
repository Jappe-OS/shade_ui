import 'package:flutter/material.dart';
import 'package:shade_ui/shade_theme.dart';

void main() {
  runApp(
    ShadeApp(
      themeMode: ThemeMode.dark,
      home: Scaffold(
          body: Row(children: [
            NavigationRail(destinations: const [
              NavigationRailDestination(icon: Icon(Icons.mail), label: Text("Mail")),
              NavigationRailDestination(icon: Icon(Icons.history), label: Text("History")),
              NavigationRailDestination(icon: Icon(Icons.account_circle), label: Text("Account"))
            ],
            selectedIndex: 0,
            onDestinationSelected: (value) {
              
            },
            //labelType: NavigationRailLabelType.all,
            extended: true,
            ),
            const VerticalDivider(),
            Column(
              children: [
                TextButton(onPressed: () {}, child: const Text("data")),
                OutlinedButton(onPressed: () {}, child: const Text("data")),
                FilledButton(onPressed: () {}, child: const Text("data")),
                ElevatedButton(onPressed: () {}, child: const Text("data")),
                IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.abc),
                ),
              ],
            )
          ]),
          floatingActionButton: FloatingActionButton.large(onPressed: () {})),
    ),
  );
}
