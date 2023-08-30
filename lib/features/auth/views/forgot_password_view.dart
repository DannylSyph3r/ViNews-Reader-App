import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vinews_news_reader/features/auth/controllers/auth_action_controllers.dart';
import 'package:vinews_news_reader/themes/color_pallete.dart';
import 'package:vinews_news_reader/utils/banner_util.dart';
import 'package:vinews_news_reader/utils/keyboard_utils.dart';
import 'package:vinews_news_reader/utils/string_validator.dart';
import 'package:vinews_news_reader/utils/vinews_app_texts.dart';
import 'package:vinews_news_reader/utils/vinews_icons.dart';
import 'package:vinews_news_reader/utils/vinews_images_path.dart';
import 'package:vinews_news_reader/utils/widget_extensions.dart';
import 'package:vinews_news_reader/widgets/vinews_icon_buttons_icons.dart';
import 'package:vinews_news_reader/widgets/vinews_text_form_field.dart';

class ForgotPasswordView extends ConsumerStatefulWidget {
  const ForgotPasswordView({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _ForgotPasswordViewState();
}

class _ForgotPasswordViewState extends ConsumerState<ForgotPasswordView> {
  final _forgotPasswordFormKey = GlobalKey<FormState>();
  final _forgotPasswordFieldController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _forgotPasswordFieldController.addListener(updateSendLinkButton);
    _forgotPasswordFieldController.addListener(updateEmailValidationState);
  }

  @override
  void dispose() {
    _forgotPasswordFieldController.dispose();
    super.dispose();
  }

  void updateSendLinkButton() {
    final sendLinkButtonNotifier = ref.read(activeButtonStateProvider.notifier);
    sendLinkButtonNotifier.updateButtonState([_forgotPasswordFieldController]);
  }

  void resetButtonState() {
    final resetButtonState = ref.read(activeButtonStateProvider.notifier);
    resetButtonState.resetButtonState();
  }

  void updateEmailValidationState() {
    final emailValidationNotifier = ref.read(emailValidatorProvider.notifier);
    emailValidationNotifier
        .updateEmailValidatorState(_forgotPasswordFieldController);
  }

  @override
  Widget build(BuildContext context) {
    final isSendLinkButtonActive = ref.watch(activeButtonStateProvider);
    final isEmailValid = ref.watch(emailValidatorProvider);
    return Scaffold(
      appBar: AppBar(
        title: "Back".txtStyled(fontSize: 16),
        elevation: 0,
        backgroundColor: Pallete.appButtonColor,
      ),
      body: GestureDetector(
        onTap: () => dropKeyboard(),
        child: SafeArea(
          child: SingleChildScrollView(
            child: SafeArea(
              child: Center(
                  child: Padding(
                padding: const EdgeInsets.only()
                    .padSpec(left: 25, top: 30, right: 25, bottom: 50),
                child: Form(
                  key: _forgotPasswordFormKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      "Forgot Password"
                          .txtStyled(fontSize: 20, fontWeight: FontWeight.bold),
                      15.sbH,
                      "Enter your Email to Reset your Password".txtStyled(
                          fontSize: 14.sp, textAlign: TextAlign.center),
                      20.sbH,
                      SizedBox(
                        height: 95,
                        child: ViNewsAppTextFormField(
                            controller: _forgotPasswordFieldController,
                            hintText: "Your Email",
                            obscureText: false,
                            validator: emailValidator,
                            prefixIconString: ViNewsAppImagesPath.emailIcon,
                            prefixIconColor: Pallete.appButtonColor,
                            suffixIconString: _forgotPasswordFieldController
                                        .text.isNotEmpty &&
                                    isEmailValid
                                ? ViNewsAppImagesPath.validIcon
                                : ViNewsAppImagesPath.invalidIcon,
                            suffixIconColor: Pallete.appButtonColor),
                      ),
                      ViNewsAppIconButton(
                          onButtonPress: () {
                            dropKeyboard();
                            if (_forgotPasswordFormKey.currentState
                                    ?.validate() ==
                                true) {
                              // ref
                              //     .read(authNotifierProvider.notifier)
                              //     .sendUserForgotPasswordLink(
                              //         emailAddress:
                              //             _forgotPasswordFieldController.text
                              //                 .trim());
                              showMaterialBanner(context, ViNewsAppTexts.passwordResetSuccessTitle, ViNewsAppTexts.passwordResetSuccessBody, Pallete.appButtonColor);
                              resetButtonState();
                            }
                          },
                          buttonPlaceholderText: "Send Link",
                          suffixIcon: ViNewsIcons.sendLinkIcon,
                          isEnabled: isSendLinkButtonActive),
                    ],
                  ),
                ),
              )),
            ),
          ),
        ),
      ),
    );
  }
}
