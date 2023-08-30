import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vinews_news_reader/utils/widget_extensions.dart';

class UserProfileSettingsView extends ConsumerStatefulWidget {
  const UserProfileSettingsView({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _UserProfileSettingsViewState();
}

class _UserProfileSettingsViewState extends ConsumerState<UserProfileSettingsView> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.only()
                    .padSpec(left: 25, top: 30, right: 25, bottom: 50),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("User Profile Settings Screen"),
                15.sbH,
              ],
            ),
          ),
        ),
      )),
    );
  }
}