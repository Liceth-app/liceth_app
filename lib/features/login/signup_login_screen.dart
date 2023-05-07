import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/widgets.dart';
import 'package:liceth_app/features/basic_info/screen_basic_info.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';

class SignUpLogInScreen extends SignInScreen {
  static const routeName = '/SignUpLogInScreen';

  SignUpLogInScreen({super.key})
      : super(
          showAuthActionSwitch: false,
          actions: [
            AuthStateChangeAction<SignedIn>((context, state) {
              FirebaseAnalytics.instance.setUserId(id: state.user?.uid ?? "");
              Navigator.pushReplacementNamed(
                  context, BasicInfoScreen.routeName);
            }),
          ],
          footerBuilder: (ctx, action) {
            return Container(
              margin: EdgeInsets.symmetric(vertical: 20),
              child: Text.rich(
                TextSpan(
                  // text: "By logging in or signing up, you agree to our ",
                  // spanish:
                  text: "Al registrarse aceptas nuestros ",
                  children: [
                    TextSpan(
                      // text: "Terms of Service",
                      // spanish:
                      text: "Términos de servicio",
                      style: TextStyle(
                        decoration: TextDecoration.underline,
                      ),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () => launchUrlString(
                              "https://liceth.page.link/terms-of-service",
                              mode: LaunchMode.externalApplication,
                            ),
                    ),
                    // TextSpan(text: " and "),
                    TextSpan(text: " y "),
                    TextSpan(
                      // text: "Privacy Policy",
                      // spanish:
                      text: "Política de privacidad",
                      style: TextStyle(
                        decoration: TextDecoration.underline,
                      ),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () => launchUrlString(
                              "https://liceth.page.link/privacy-policy",
                              mode: LaunchMode.externalApplication,
                            ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
}
