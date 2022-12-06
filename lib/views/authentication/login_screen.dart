import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:letstrail/utils/utils_exporter.dart';
import 'package:letstrail/views/views_exporter.dart';

class Login extends StatefulWidget {
  const Login({
    Key? key,
  }) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _uidController = TextEditingController();
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.appWhiteColor,
      body: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                flex: 3,
                child: Container(
                  decoration: const BoxDecoration(
                    color: AppColors.primaryColor,
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(60.0),
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        "${Common.assetsIcons}application_icon.jpg",
                        width: 120,
                        height: 120,
                      ),
                      const SizedBox(width: 10.0),
                      Text(
                        Common.applicationName,
                        style: GoogleFonts.ptSans(
                          fontWeight: FontWeight.w900,
                          fontSize: 22.0,
                          color: AppColors.appWhiteColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                flex: 5,
                child: SingleChildScrollView(
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20.0,
                      vertical: 0.0,
                    ),
                    decoration:
                        const BoxDecoration(color: AppColors.appWhiteColor),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const SizedBox(height: 30.0),
                        LabelAndInputField(
                          label: "Email Address",
                          fieldController: _emailController,
                          inputType: TextInputType.emailAddress,
                        ),
                        const SizedBox(height: 12.0),
                        LabelAndInputField(
                          label: "Password",
                          fieldController: _uidController,
                          obscureText: true,
                        ),
                        const SizedBox(height: 10.0),
                        InkWell(
                          onTap: () => Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => ForgetPassword(),
                            ),
                          ),
                          child: const Text(
                            "Forget Password?",
                            style: TextStyle(
                              color: AppColors.primaryColor,
                              fontSize: 15.0,
                              fontWeight: FontWeight.w600,
                            ),
                            textAlign: TextAlign.right,
                          ),
                        ),
                        const SizedBox(height: 25.0),
                        PrimaryButton(
                          onPressed: () => _processLogin(),
                          buttonText: 'Login',
                        ),
                        const SizedBox(height: 20.0),
                        InkWell(
                          onTap: () => Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => Register(),
                            ),
                          ),
                          child: RichText(
                            textAlign: TextAlign.center,
                            text: TextSpan(
                              style: TextStyle(
                                color: AppColors.textColor,
                                fontSize: 15.0,
                                fontWeight: FontWeight.w700,
                              ),
                              children: [
                                TextSpan(
                                  text: "Don't have an account? ",
                                  style: TextStyle(color: AppColors.textColor),
                                ),
                                TextSpan(
                                  text: "Register",
                                  style:
                                      TextStyle(color: AppColors.primaryColor),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          _isLoading ? const LoadingOverlay() : const SizedBox.shrink(),
        ],
      ),
    );
  }

  void _processLogin() {
    String email = _emailController.text.trim();
    String uid = _uidController.text.trim();

    if (email.isEmpty ||
        !RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
            .hasMatch(email)) {
      Common.showErrorTopSnack(
          context, "Please provide valid Email Address and try again");
    } else if (uid.isEmpty) {
      Common.showErrorTopSnack(
          context, "Please provide strong password and try-again");
    } else {
      _isLoading = true;
      setState(() {});

      ApiRequests.loginUser(context, email, uid).then(
        (loginSuccess) {
          if (loginSuccess)
            Common.pushAndRemoveUntil(
              context,
              const DashboardScreen(),
            );
          else {
            _isLoading = false;
            setState(() {});
            Common.showErrorTopSnack(
              context,
              "Unable to login. please try again by double checking your email-address and password.",
            );
          }
        },
      );
    }
  }

  void _processGoogleLogin() {
    setState(() {
      _isLoading = true;
    });

    // todo: add api request
    // ApiRequests.googleLogin().then((value) async {
    //   final user = await ApiRequests.getLoggedInUser();
    //   setState(() {
    //     _isLoading = false;
    //   });
    //
    //   Common.pushAndRemoveUntil(context, Dashboard());
    // }).onError((error, stackTrace) {
    //   setState(() {
    //     _isLoading = false;
    //   });
    //   Common.showOnePrimaryButtonDialog(
    //     context: context,
    //     dialogMessage: error.toString(),
    //   );
    // });
  }
}
