import 'package:example/components/color_picker_dialog.dart';
import 'package:example/screens/buttons/back_button_screen.dart';
import 'package:example/screens/buttons/main_button_screen.dart';
import 'package:example/screens/buttons/settings_button_screen.dart';
import 'package:example/screens/other/cloud_storage_screen.dart';
import 'package:example/screens/util/string_snackbar_extension.dart';
import 'package:example/widgets/expandable_tile.dart';
import 'package:example/widgets/expandable_tile_with_widget.dart';
import 'package:example/widgets/list_button.dart';
import 'package:example/widgets/one_color_widget.dart';
import 'package:flutter/material.dart';
import 'package:telegram_web_app/telegram_web_app.dart';

import '../widgets/theme_params_widget.dart';
import 'other/haptic_feedback_screen.dart';

// ignore_for_file: use_build_context_synchronously
class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final TelegramWebApp telegram = TelegramWebApp.instance;

  bool? isDefinedVersion;

  @override
  void initState() {
    super.initState();
    TelegramWebApp.instance.ready();

    check();
  }

  void check() async {
    await Future.delayed(const Duration(seconds: 2));
    isDefinedVersion = await telegram.isVersionAtLeast('Bot API 6.1');
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: telegram.backgroundColor,
      body: ListView(
        padding: const EdgeInsets.all(8),
        children: [
          InfoExpandableTile('Init Data', telegram.initData),
          InfoExpandableTile(
            'Init Data Unsafe',
            telegram.initDataUnsafe.toReadableString(),
          ),
          InfoExpandableTile('Version', telegram.version),
          InfoExpandableTile('Platform', telegram.platform),
          InfoExpandableTile('Color Scheme', telegram.colorScheme.name),
          ThemeParamsWidget(telegram.themeParams),
          InfoExpandableTile('isExpanded', telegram.isExpanded.toString()),
          InfoExpandableTile('viewportHeight', telegram.viewportHeight.toString()),
          InfoExpandableTile('viewportStableHeight', telegram.viewportStableHeight.toString()),
          OneColorExpandableTile('headerColor', telegram.headerColor),
          OneColorExpandableTile('backgroundColor', telegram.backgroundColor),
          InfoExpandableTileWithWidget(
            'Closing confirmation',
            expanded: false,
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text('isClosingConfirmationEnabled'),
                  const SizedBox(height: 8),
                  Text(telegram.isClosingConfirmationEnabled.toString(),
                      style: const TextStyle(fontSize: 16)),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      ElevatedButton(
                          onPressed: () async {
                            await telegram.enableClosingConfirmation();
                            setState(() {});
                          },
                          child: const Text('Enable')),
                      const SizedBox(width: 16),
                      ElevatedButton(
                          onPressed: () async {
                            await telegram.disableClosingConfirmation();
                            setState(() {});
                          },
                          child: const Text('Disable')),
                    ],
                  ),
                ],
              ),
            ),
          ),
          ListButton(
            'BackButton',
            onPress: () {
              Navigator.of(context)
                  .push(MaterialPageRoute(builder: (context) => const BackButtonScreen()));
            },
          ),
          ListButton(
            'MainButton',
            onPress: () {
              Navigator.of(context)
                  .push(MaterialPageRoute(builder: (context) => const MainButtonScreen()));
            },
          ),
          ListButton(
            'SettingsButton',
            onPress: () {
              Navigator.of(context)
                  .push(MaterialPageRoute(builder: (context) => const SettingsButtonScreen()));
            },
          ),
          ListButton(
            'HapticFeedback',
            onPress: () {
              Navigator.of(context)
                  .push(MaterialPageRoute(builder: (context) => const HapticFeedbackScreen()));
            },
          ),
          ListButton(
            'CloudStorage',
            onPress: () {
              Navigator.of(context)
                  .push(MaterialPageRoute(builder: (context) => const CloudStorageScreen()));
            },
          ),
          InfoExpandableTile('isVersionAtLeast(6.1)', isDefinedVersion.toString()),
          ListButton(
            'setHeaderColor(color)',
            onPress: () async {
              Color? color = await selectColor(context);
              if (color != null) {
                await telegram.setHeaderColor(color);
                'Setting color: ${color.hexString}'.showSnackbar(context);
                await Future.delayed(const Duration(seconds: 2));
                setState(() {});
              } else {
                'Selected color is null'.showSnackbar(context);
              }
            },
          ),
          ListButton(
            'setBackgroundColor(color)',
            onPress: () async {
              Color? color = await selectColor(context);
              if (color != null) {
                await telegram.setBackgroundColor(color);
                'Setting color: ${color.hexString}'.showSnackbar(context);
                await Future.delayed(const Duration(seconds: 2));
                setState(() {});
              } else {
                'Selected color is null'.showSnackbar(context);
              }
            },
          ),
          ListButton(
            'Open link',
            onPress: () async {
              telegram.openLink(
                'https://telegram.org/blog/new-saved-messages-and-9-more',
                tryInstantView: true,
              );
            },
          ),
          ListButton(
            'Open telegram link',
            onPress: () async {
              telegram.openTelegramLink('https://t.me/flutter_telegram');
            },
          ),
          ListButton(
            'Show pop',
            onPress: () async {
              try {
                telegram.showPopup(
                  title: 'Title',
                  message: "Message",
                  buttons: [
                    PopupButton.defaultType('default', 'Yes'),
                    PopupButton.cancel('cancel'),
                  ],
                  callback: (String id) {
                    'Button pressed. Id: $id'.showSnackbar(context);
                  },
                );
              } catch (ex) {
                'error happened showing popup: $ex'.showSnackbar(context);
              }
            },
          ),
          ListButton(
            'Show alert',
            onPress: () async {
              try {
                telegram.showAlert(
                  'Sample Alert',
                  () => 'Alert closed'.showSnackbar(context),
                );
              } catch (ex) {
                'error happened showing alert: $ex'.showSnackbar(context);
              }
            },
          ),
        ],
      ),
    );
  }
}

/// onEvent(eventType, eventHandler)
/// offEvent(eventType, eventHandler)
/// sendData(data)
/// switchInlineQuery(query[, choose_chat_types])
/// openInvoice(url[, callback])

/// showAlert(message[, callback])
/// showConfirm(message[, callback])
/// showScanQrPopup(params[, callback])
/// closeScanQrPopup()
/// readTextFromClipboard([callback])
/// requestWriteAccess([callback])
/// requestContact([callback])
/// ready()
/// expand()
/// close()
