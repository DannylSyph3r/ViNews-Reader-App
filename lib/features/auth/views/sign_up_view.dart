import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:go_router/go_router.dart';
import 'package:vinews_news_reader/features/auth/controllers/auth_action_controllers.dart';
import 'package:vinews_news_reader/features/auth/states/login_state.dart';
import 'package:vinews_news_reader/routes/route_constants.dart';
import 'package:vinews_news_reader/themes/color_pallete.dart';
import 'package:vinews_news_reader/utils/banner_util.dart';
import 'package:vinews_news_reader/utils/frosted_glass_box.dart';
import 'package:vinews_news_reader/utils/keyboard_utils.dart';
import 'package:vinews_news_reader/utils/string_validator.dart';
import 'package:vinews_news_reader/utils/vinews_images_path.dart';
import 'package:vinews_news_reader/utils/widget_extensions.dart';
import 'package:vinews_news_reader/widgets/vinews_image_icon_button.dart';
import 'package:vinews_news_reader/widgets/vinews_text_form_field.dart';
import 'package:vinews_news_reader/widgets/custom_divider.dart';

class UserSignUpView extends ConsumerStatefulWidget {
  const UserSignUpView({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _UserSignUpViewState();
}

class _UserSignUpViewState extends ConsumerState<UserSignUpView> {
  // Declerations 
  final _signUpFormKey = GlobalKey<FormState>();
  final _firstNameSignUpController = TextEditingController();
  final _lastNameSignUpController = TextEditingController();
  final _emailSignUpAddressFieldController = TextEditingController();
  final _passwordSignUpFieldController = TextEditingController();
  final _confirmPasswordSignUpFieldController = TextEditingController();
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    // Call the updateSignUpButtonState function whenever either of the text fields changes via listeners.
    _firstNameSignUpController.addListener(updateSignupButton);
    _lastNameSignUpController.addListener(updateSignupButton);
    _emailSignUpAddressFieldController.addListener(updateSignupButton);
    _passwordSignUpFieldController.addListener(updateSignupButton);
    _confirmPasswordSignUpFieldController.addListener(updateSignupButton);
    _emailSignUpAddressFieldController.addListener(updateEmailValidationState);
  }

  @override
  void dispose() {
    _emailSignUpAddressFieldController.dispose();
    _passwordSignUpFieldController.dispose();
    super.dispose();
  }

  void updateSignupButton() {
    // Update the Login Button inactivity state based on conditions 
    final activesignUpButtonNotifier =
        ref.read(activeButtonStateProvider.notifier);
    // Only update the state if there is a change to avoid unnecessary rebuilds.
    activesignUpButtonNotifier.updateButtonState([
      _firstNameSignUpController,
      _lastNameSignUpController,
      _emailSignUpAddressFieldController,
      _passwordSignUpFieldController,
      _confirmPasswordSignUpFieldController
    ]);
  }

  void resetButtonState() {
    // Reset the "Sign Up" button inactivity state
    final resetButtonState = ref.read(activeButtonStateProvider.notifier);
    resetButtonState.resetButtonState();
  }

  void updateEmailValidationState() {
    // Email Validator status updater via suffix icon
    final emailValidationNotifier = ref.read(emailValidatorProvider.notifier);
    emailValidationNotifier
        .updateEmailValidatorState(_emailSignUpAddressFieldController);
  }

  bool passwordConfirmed() {
    // Confirm Pasword validator logic
    return _passwordSignUpFieldController.text.trim() ==
        _confirmPasswordSignUpFieldController.text.trim();
  }

  @override
  Widget build(BuildContext context) {
    // Auth State Changes logic handler
    ref.listen<UserAuthenticationState>(authNotifierProvider,
        (previous, state) {
      setState(() {
        if (state is UserAuthenticationStateLoading) {
          isLoading = true;
        } else {
          isLoading = false;
        }
      });
      if (state is UserAuthenticationStateError) {
        isLoading = false;
        showMaterialBanner(
            context, "Sign Up Error :(", state.error, Pallete.appButtonColor);
      } else if (state is UserAuthenticationStateSuccess) {
        isLoading = false;
        context.pushReplacementNamed(ViNewsAppRouteConstants.authIntializer);
      }
    });
    final isSignUpButtonActive = ref.watch(activeButtonStateProvider);
    final isEmailValid = ref.watch(emailValidatorProvider);
    final passwordFieldObscured = ref.watch(showSignUpPasswordProvider);
    final confirmPasswordFieldObscured =
        ref.watch(showSignUpConfirmPasswordProvider);
    return Scaffold(
      body: GestureDetector(
        onTap: () => dropKeyboard(),
        child: Stack(
          children: [
            SafeArea(
              child: SingleChildScrollView(
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.only()
                        .padSpec(left: 25, top: 30, right: 25, bottom: 50),
                    child: Form(
                      key: _signUpFormKey,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // Screen Headers
                          "Sign Up".txtStyled(
                              fontSize: 35.sp, fontWeight: FontWeight.bold),
                          15.sbH,
                          "Enter your Email to Register to the ViNews App"
                              .txtStyled(
                                  fontSize: 20.sp, textAlign: TextAlign.center),
                          40.sbH,
                          // Sign Up Screen TextFields
                          ViNewsAppTextFormField(
                            controller: _firstNameSignUpController,
                            hintText: "Firstname",
                            obscureText: false,
                            prefixIconString: ViNewsAppImagesPath.userIcon,
                            prefixIconColor: Pallete.appButtonColor,
                            validator: firstNameValidator,
                          ),
                          8.sbH,
                          ViNewsAppTextFormField(
                            controller: _lastNameSignUpController,
                            hintText: "Lastname",
                            obscureText: false,
                            prefixIconString: ViNewsAppImagesPath.userIcon,
                            prefixIconColor: Pallete.appButtonColor,
                            validator: lastNameValidator,
                          ),
                          8.sbH,
                          ViNewsAppTextFormField(
                              controller: _emailSignUpAddressFieldController,
                              hintText: "Your Email",
                              obscureText: false,
                              prefixIconString: ViNewsAppImagesPath.emailIcon,
                              prefixIconColor: Pallete.appButtonColor,
                              validator: emailValidator,
                              suffixIconString:
                                  _emailSignUpAddressFieldController
                                              .text.isNotEmpty &&
                                          isEmailValid
                                      ? ViNewsAppImagesPath.validIcon
                                      : ViNewsAppImagesPath.invalidIcon,
                              suffixIconColor: Pallete.appButtonColor),
                          8.sbH,
                          ViNewsAppTextFormField(
                            controller: _passwordSignUpFieldController,
                            hintText: "Password",
                            obscureText: passwordFieldObscured,
                            validator: passwordValidator,
                            prefixIconString: ViNewsAppImagesPath.passwordIcon,
                            suffixIconString: passwordFieldObscured == true
                                ? ViNewsAppImagesPath.passwordShowIcon
                                : ViNewsAppImagesPath.passwordHideIcon,
                            onIconTap: () {
                              ref
                                  .read(showSignUpPasswordProvider.notifier)
                                  .update((state) => !state);
                              dropKeyboard();
                            },
                          ),
                          8.sbH,
                          ViNewsAppTextFormField(
                            controller: _confirmPasswordSignUpFieldController,
                            hintText: "Confirm Password",
                            obscureText: confirmPasswordFieldObscured,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return '⚠ Please confirm your password';
                              }
                              if (value !=
                                  _passwordSignUpFieldController.text) {
                                return '⚠ Passwords do not match';
                              }
                              return null;
                            },
                            prefixIconString: ViNewsAppImagesPath.passwordIcon,
                            suffixIconString:
                                confirmPasswordFieldObscured == true
                                    ? ViNewsAppImagesPath.passwordShowIcon
                                    : ViNewsAppImagesPath.passwordHideIcon,
                            onIconTap: () {
                              ref
                                  .read(showSignUpConfirmPasswordProvider
                                      .notifier)
                                  .update((state) => !state);
                              dropKeyboard();
                            },
                          ),
                          50.sbH,
                          //  Sign Up Button
                          ViNewsAppImageIconButton(
                            onButtonPress: () {
                              // "Sign Up" buttton press to handle 3 processs
                              dropKeyboard(); //1. Drop the keyboard
                              if (_signUpFormKey.currentState?.validate() ==
                                  true) {
                                //2. Perform User Sign Up Process
                                ref
                                    .read(authNotifierProvider.notifier)
                                    .userSignup(
                                      email: _emailSignUpAddressFieldController
                                          .text
                                          .trim(),
                                      password: _passwordSignUpFieldController
                                          .text
                                          .trim(),
                                      firstName: _firstNameSignUpController.text
                                          .trim(),
                                      lastName:
                                          _lastNameSignUpController.text.trim(),
                                    );
                                resetButtonState(); //3. Reset the SIgn Up Button State
                              }
                            },
                            buttonPlaceholderText: "Sign Up",
                            isEnabled: isSignUpButtonActive,
                          ),
                          18.sbH,
                          const CustomDivider(dividerText: "or"),
                          18.sbH,
                          // Sign Up with Google Button
                          ViNewsAppImageIconButton(
                            onButtonPress: () {
                              dropKeyboard();
                              ref
                                  .read(authNotifierProvider.notifier)
                                  .continueAuthWithGoogle(isSignUp: true);
                            },
                            prefixIcon: ViNewsAppImagesPath.googleSignInIcon,
                            buttonPlaceholderText: "Sign Up with Google",
                            buttonColor: Pallete.whiteColor,
                            textColor: Pallete.blackColor,
                            isEnabled: true,
                          ),
                          200.sbH,
                          // Switch to Sign In Screen
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              "Joined us before already?"
                                  .txtStyled(fontSize: 18.sp),
                              2.sbW,
                              GestureDetector(
                                onTap: () {
                                  context.goNamed(ViNewsAppRouteConstants
                                      .userLoginScreenRouteName);
                                  resetButtonState();
                                },
                                child: "Sign In".txtStyled(
                                    color: Pallete.blueColor, fontSize: 18.sp),
                              )
                            ],
                          ),
                          15.sbH
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
            // Fancy Frosted Glass Loader ;)
            Visibility(
              visible: isLoading,
              child: FrostedGlassBox(
                  theWidth: MediaQuery.of(context).size.width,
                  theHeight: MediaQuery.of(context).size.height,
                  theChild: const SpinKitThreeBounce(
                    color: Pallete.appButtonColor,
                    size: 20,
                  )),
            ),
          ],
        ),
      ),
    );
  }
}
