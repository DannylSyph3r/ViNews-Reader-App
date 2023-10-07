import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:go_router/go_router.dart';
import 'package:vinews_news_reader/features/auth/controllers/auth_action_controllers.dart';
import 'package:vinews_news_reader/features/auth/states/login_state.dart';
import 'package:vinews_news_reader/routes/route_constants.dart';
import 'package:vinews_news_reader/themes/color_Palette.dart';
import 'package:vinews_news_reader/utils/banner_util.dart';
import 'package:vinews_news_reader/widgets/frosted_glass_box.dart';
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
  // Declerations
  final _loginFormKey = GlobalKey<FormState>();
  final _emailAddressFieldController = TextEditingController();
  final _passwordFieldController = TextEditingController();
  final ValueNotifier<bool> loadingOverlayActive = false.notifier;

  @override
  void initState() {
    // Call the updateLoginButtonState function whenever either of the text fields changes via listeners.
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
    // Update the Login Button inactivity state based on conditions
    final activeloginButtonNotifier =
        ref.read(activeButtonStateProvider.notifier);
    // Only update the state if there is a change to avoid unnecessary rebuilds.
    activeloginButtonNotifier.updateButtonState(
        [_emailAddressFieldController, _passwordFieldController]);
  }

  void resetButtonState() {
    // Reset the "Sign In" button inactivity state
    final resetButtonState = ref.read(activeButtonStateProvider.notifier);
    resetButtonState.resetButtonState();
  }

  void updateEmailValidationState() {
    // Email Validator status updater via suffix icon
    final emailValidationNotifier = ref.read(emailValidatorProvider.notifier);
    emailValidationNotifier
        .updateEmailValidatorState(_emailAddressFieldController);
  }

  @override
  Widget build(BuildContext context) {
    // Auth State Changes logic handler
    final ValueNotifier<bool> loadingOverlayActive = false.notifier;

    ref.listen<UserAuthenticationState>(authNotifierProvider,
        (previous, state) {
      if (state is UserAuthenticationStateLoading) {
        loadingOverlayActive.value = true;
      } else {
        loadingOverlayActive.value = false;
      }

      if (state is UserAuthenticationStateError) {
        loadingOverlayActive.value = false;
        showMaterialBanner(
          context,
          "Sign In Error :(",
          state.error,
          Palette.blackColor,
        );
      } else if (state is UserAuthenticationStateSuccess) {
        loadingOverlayActive.value = false;
        context.pushReplacementNamed(ViNewsAppRouteConstants.authIntializer);
      }
    });

    final isLoginButtonActive = ref.watch(activeButtonStateProvider);
    final isEmailValid = ref.watch(emailValidatorProvider);
    final isPasswordObscured = ref.watch(showLoginPasswordProvider);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        constraints: const BoxConstraints.expand(),
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage(
              ViNewsAppImagesPath.appBackgroundImage,
            ),
            opacity: 0.15,
            fit: BoxFit.cover,
          ),
        ),
        child: GestureDetector(
          onTap: () {
            dropKeyboard();
          },
          child: Stack(children: [
            SafeArea(
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
                          // Screen Headers
                          "Sign In".txtStyled(
                              fontSize: 28.sp, fontWeight: FontWeight.bold),
                          10.sbH,
                          "Enter your Email to sign into the ViNews App"
                              .txtStyled(
                                  fontSize: 18.sp, textAlign: TextAlign.center),
                          40.sbH,
                          // Sign In screen TextFields
                          ViNewsAppTextFormField(
                              controller: _emailAddressFieldController,
                              hintText: "Your Email",
                              obscureText: false,
                              validator: emailValidator,
                              prefixIconString: ViNewsAppImagesPath.emailIcon,
                              prefixIconColor: Palette.blackColor,
                              suffixIconString: _emailAddressFieldController
                                          .text.isNotEmpty &&
                                      isEmailValid
                                  ? ViNewsAppImagesPath.validIcon
                                  : ViNewsAppImagesPath.invalidIcon,
                              suffixIconColor: Palette.blackColor),
                          8.sbH,
                          ViNewsAppTextField(
                            controller: _passwordFieldController,
                            hintText: "Passsword",
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
                          // Forgot Password Button!
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  context.pushNamed(ViNewsAppRouteConstants
                                      .forgotPasswordScreenRouteName);
                                },
                                child: "Forgot Password?".txtStyled(
                                    fontSize: 16.sp, color: Palette.blueColor),
                              )
                            ],
                          ),
                          30.sbH,
                          // Sign In Button
                          ViNewsAppImageIconButton(
                              onButtonPress: () {
                                // "Sign In" buttton press to handle 3 processs
                                dropKeyboard(); //1. Drop the keyboard
                                if (_loginFormKey.currentState?.validate() ==
                                    true) {
                                  //2. Perform User Sign Up Process
                                  ref
                                      .read(authNotifierProvider.notifier)
                                      .userLogin(
                                          email:
                                              _emailAddressFieldController
                                                  .text
                                                  .trim(),
                                          password: _passwordFieldController
                                              .text
                                              .trim());
                                  resetButtonState(); //3. Reset the SIgn Up Button State
                                }
                              },
                              buttonPlaceholderText: "Sign In",
                              isEnabled: isLoginButtonActive),
                          18.sbH,
                          const CustomDivider(dividerText: "or"),
                          18.sbH,
                          // Sign In with Google Button
                          ViNewsAppImageIconButton(
                            onButtonPress: () {
                              dropKeyboard();
                              ref
                                  .read(authNotifierProvider.notifier)
                                  .continueAuthWithGoogle(isSignUp: false);
                            },
                            prefixIcon: ViNewsAppImagesPath.googleSignInIcon,
                            buttonPlaceholderText: "Sign In with Google",
                            buttonColor: Palette.whiteColor,
                            textColor: Palette.blackColor,
                            isEnabled: true,
                          ),
                          220.sbH,
                          // Switch to Sign Up Screen
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              "New to ViNews?".txtStyled(fontSize: 17.sp),
                              2.sbW,
                              GestureDetector(
                                onTap: () {
                                  context.goNamed(ViNewsAppRouteConstants
                                      .userSignUpcreenRouteName);
                                  resetButtonState();
                                },
                                child: "Sign Up".txtStyled(
                                    color: Palette.blueColor, fontSize: 17.sp),
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
            // Fancy Frosted Glass Loader ;)
            loadingOverlayActive.sync(
              builder: (context, isVisible, child) {
                return Visibility(
                  visible: isVisible,
                  child: Positioned.fill(
                    child: FrostedGlassBox(
                      theWidth: MediaQuery.of(context).size.width,
                      theHeight: MediaQuery.of(context).size.height,
                      theChild: SpinKitFadingCircle(
                        color: Palette.blackColor.withOpacity(0.3),
                      ),
                    ),
                  ),
                );
              },
            )
          ]),
        ),
      ),
    );
  }
}
