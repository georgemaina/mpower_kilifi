import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'defaulters.dart';
import 'mappingVisitType.dart';


/// A class for consolidating the definition of menu entries.
///
/// This sort of class is not required, but illustrates one way that defining
/// menus could be done.
class MenuEntry {
  const MenuEntry(
      {required this.label, this.shortcut, this.onPressed, this.menuChildren})
      : assert(menuChildren == null || onPressed == null,
  'onPressed is ignored if menuChildren are provided');
  final String label;

  final MenuSerializableShortcut? shortcut;
  final VoidCallback? onPressed;
  final List<MenuEntry>? menuChildren;

  static List<Widget> build(List<MenuEntry> selections) {
    Widget buildSelection(MenuEntry selection) {
      if (selection.menuChildren != null) {
        return SubmenuButton(
          menuChildren: MenuEntry.build(selection.menuChildren!),
          child: Text(selection.label),
        );
      }
      return MenuItemButton(
        shortcut: selection.shortcut,
        onPressed: selection.onPressed,
        child: Text(selection.label),
      );
    }

    return selections.map<Widget>(buildSelection).toList();
  }

  static Map<MenuSerializableShortcut, Intent> shortcuts(
      List<MenuEntry> selections) {
    final Map<MenuSerializableShortcut, Intent> result =
    <MenuSerializableShortcut, Intent>{};
    for (final MenuEntry selection in selections) {
      if (selection.menuChildren != null) {
        result.addAll(MenuEntry.shortcuts(selection.menuChildren!));
      } else {
        if (selection.shortcut != null && selection.onPressed != null) {
          result[selection.shortcut!] =
              VoidCallbackIntent(selection.onPressed!);
        }
      }
    }
    return result;
  }
}

class MyMenuBar extends StatefulWidget {
  const MyMenuBar({
    super.key,
    required this.message,
  });

  final String message;

  @override
  State<MyMenuBar> createState() => _MyMenuBarState();
}

class _MyMenuBarState extends State<MyMenuBar> {
  ShortcutRegistryEntry? _shortcutsEntry;
  String? _lastSelection;

  Color get backgroundColor => _backgroundColor;
  Color _backgroundColor = Colors.red;
  set backgroundColor(Color value) {
    if (_backgroundColor != value) {
      setState(() {
        _backgroundColor = value;
      });
    }
  }

  bool get showingMessage => _showMessage;
  bool _showMessage = false;
  set showingMessage(bool value) {
    if (_showMessage != value) {
      setState(() {
        _showMessage = value;
      });
    }
  }

  @override
  void dispose() {
    _shortcutsEntry?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Expanded(
              child: MenuBar(
                children: MenuEntry.build(_getMenus()),
              ),
            ),
          ],
        ),
      ],
    );
  }

  List<MenuEntry> _getMenus() {
    final List<MenuEntry> result = <MenuEntry>[
      MenuEntry(
        label: 'mPower',
        menuChildren: <MenuEntry>[
          MenuEntry(
            label: 'Defaulter Tracing',
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context)=>Defaulters())
              );
              setState(() {
                _lastSelection = 'Defaulter';
              });
            },
          ),
          MenuEntry(
            label: 'Household Mapping',
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context)=>MappingVisitType())
              );
            },
            shortcut:
            const SingleActivator(LogicalKeyboardKey.keyS, control: true),
          ),
          // Hides the message, but is only enabled if the message isn't
          // already hidden.
          MenuEntry(
            label: 'Notifications',
            onPressed: showingMessage
                ? () {
              setState(() {
                _lastSelection = 'Notifications';
                showingMessage = false;
              });
            }
                : null,
            shortcut: const SingleActivator(LogicalKeyboardKey.escape),
          ),
          MenuEntry(
            label: 'Profile',
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context)=>MappingVisitType())
                );
              }
          ),
          MenuEntry(
              label: 'Settings',
              // icons: "assets/icons/menu_setting.svg",
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context)=>MappingVisitType())
                );
              }
          ),
        ],
      ),
    ];
    // (Re-)register the shortcuts with the ShortcutRegistry so that they are
    // available to the entire application, and update them if they've changed.
    _shortcutsEntry?.dispose();
    _shortcutsEntry =
        ShortcutRegistry.of(context).addAll(MenuEntry.shortcuts(result));
    return result;
  }
}

// class MenuBarApp extends StatelessWidget {
//   const MenuBarApp({super.key});
//
//   static const String kMessage = '"Talk less. Smile more." - A. Burr';
//
//   @override
//   Widget build(BuildContext context) {
//     return const MaterialApp(
//       home: Scaffold(body: MyMenuBar(message: kMessage)),
//     );
//   }
// }
