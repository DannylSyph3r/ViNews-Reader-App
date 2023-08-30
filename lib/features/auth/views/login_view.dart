import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:vinews_news_reader/features/auth/controllers/auth_action_controllers.dart';
import 'package:vinews_news_reader/features/auth/states/login_state.dart';
import 'package:vinews_news_reader/routes/route_constants.dart';
import 'package:vinews_news_reader/themes/color_pallete.dart';
import 'package:vinews_news_reader/utils/banner_util.dart';
import 'package:vinews_news_reader/utils/keyboard_utils.dart';
import 'package:vinews_news_reader/utils/string_validator.dart';
import 'package:vinews_news_reader/utils/vinews_images_path.dart';
import 'package:vinews_news_reader/utils/widget_extensions.dart';
import 'package:vinews_news_reader/widgets/vinews_image_icon_button.dart';
import 'package:vinews_news_reader/widgets/vinews_text_form_field.dart';
import 'package:vinews_news_reader/widgets/vinews_textfield.dart';
import 'package:vinews_news_reader/widgets/custom_divider.dart';

class UserLoginView extends ConsumerStatefulWidget {
  const UserLoginView({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _UserLoginViewState();
}

class _UserLoginViewState extends ConsumerState<UserLoginView> {
  final _loginFormKey = GlobalKey<FormState>();
  final _emailAddressFieldController = TextEditingController();
  final _passwordFieldController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _passwordFieldController.addListener(updateLoginButtonState);
    _emailAddressFieldController.addListener(updateLoginButtonState);
    _emailAddressFieldController.addListener(updateEmailValidationState);
  }

  @override
  void dispose() {
    _emailAddressFieldController.dispose();
    _passwordFieldController.dispose();
    super.dispose();
  }

  void updateLoginButtonState() {
    final activeloginButtonNotifier =
        ref.read(activeButtonStateProvider.notifier);
    activeloginButtonNotifier.updateButtonState(
        [_emailAddressFieldController, _passwordFieldController]);
  }

  void resetButtonState() {
    final resetButtonState = ref.read(activeButtonStateProvider.notifier);
    resetButtonState.resetButtonState();
  }

  void updateEmailValidationState() {
    final emailValidationNotifier = ref.read(emailValidatorProvider.notifier);
    emailValidationNotifier
        .updateEmailValidatorState(_emailAddressFieldController);
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<UserAuthenticationState>(authNotifierProvider,
        (previous, state) {
      if (state is UserAuthenticationStateError) {
        showMaterialBanner(
            context, "Sign In Error :(", state.error, Pallete.appButtonColor);
      } else if (state is UserAuthenticationStateSuccess) {
        context
            .pushReplacementNamed(ViNewsAppRouteConstants.authIntializer);
      }
    });
    final isLoginButtonActive = ref.watch(activeButtonStateProvider);
    final isEmailValid = ref.watch(emailValidatorProvider);
    final isPasswordObscured = ref.watch(showLoginPasswordProvider);
    return Scaffold(
      body: GestureDetector(
        onTap: () {
          dropKeyboard();
        },
        child: SafeArea(
          child: SingleChildScrollView(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.only()
                    .padSpec(left: 25, top: 30, right: 25, bottom: 50),
                child: Form(
                  key: _loginFormKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      "Sign In"
                          .txtStyled(fontSize: 25, fontWeight: FontWeight.bold),
                      10.sbH,
                      "Enter your Email to sign into the ViNews App".txtStyled(
                          fontSize: 14.sp, textAlign: TextAlign.center),
                      40.sbH,
                      SizedBox(
                        height: 95,
                        child: ViNewsAppTextFormField(
                            controller: _emailAddressFieldController,
                            hintText: "Your Email",
                            obscureText: false,
                            validator: emailValidator,
                            prefixIconString: ViNewsAppImagesPath.emailIcon,
                            prefixIconColor: Pallete.appButtonColor,
                            suffixIconString:
                                _emailAddressFieldController.text.isNotEmpty &&
                                        isEmailValid
                                    ? ViNewsAppImagesPath.validIcon
                                    : ViNewsAppImagesPath.invalidIcon,
                            suffixIconColor: Pallete.appButtonColor),
                      ),
                      5.sbH,
                      ViNewsAppTextField(
                        controller: _passwordFieldController,
                        hintText: "Password",
                        obscureText: isPasswordObscured,
                        prefixIconString: ViNewsAppImagesPath.passwordIcon,
                        suffixIconString: isPasswordObscured == true
                            ? ViNewsAppImagesPath.passwordShowIcon
                            : ViNewsAppImagesPath.passwordHideIcon,
                        onIconTap: () {
                          ref
                              .read(showLoginPasswordProvider.notifier)
                              .update((state) => !state);
                          dropKeyboard();
                        },
                      ),
                      15.sbH,
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          GestureDetector(
                            onTap: () {
                              context.pushNamed(ViNewsAppRouteConstants
                                  .forgotPasswordScreenRouteName);
                            },
                            child: "Forgot Password?".txtStyled(
                                fontSize: 13.sp, color: Pallete.blueColor),
                          )
                        ],
                      ),
                      30.sbH,
                      ViNewsAppImageIconButton(
                          onButtonPress: () {
                            dropKeyboard();
                            if (_loginFormKey.currentState?.validate() ==
                                true) {
                              ref.read(authNotifierProvider.notifier).userLogin(
                                  email:
                                      _emailAddressFieldController.text.trim(),
                                  password:
                                      _passwordFieldController.text.trim());
                              ref.read(resendTimerProvider.notifier).startTimer;
                              resetButtonState();

                            }
                          },
                          buttonPlaceholderText: "Sign In",
                          isEnabled: isLoginButtonActive),
                      18.sbH,
                      const CustomDivider(dividerText: "or"),
                      18.sbH,
                      ViNewsAppImageIconButton(
                        onButtonPress: () {
                          dropKeyboard();
                          ref.read(authNotifierProvider.notifier).continueAuthWithGoogle(isSignUp: false);
                        },
                        prefixIcon: ViNewsAppImagesPath.googleSignInIcon,
                        buttonPlaceholderText: "Sign In with Google",
                        buttonColor: Pallete.whiteColor,
                        textColor: Pallete.blackColor,
                        isEnabled: true,
                      ),
                      200.sbH,
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          "New to ViNews?".txtStyled(fontSize: 14.sp),
                          2.sbW,
                          GestureDetector(
                            onTap: () {
                              context.goNamed(ViNewsAppRouteConstants
                                  .userSignUpcreenRouteName);
                              resetButtonState();
                            },
                            child: "Sign Up".txtStyled(
                                color: Pallete.blueColor, fontSize: 14.sp),
                          )
                        ],
                      ),
                      10.sbH
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
