import 'package:flutter/material.dart';
import 'package:letstrail/utils/utils_exporter.dart';

class ForgetPassword extends StatefulWidget {
  const ForgetPassword({Key? key}) : super(key: key);

  @override
  State<ForgetPassword> createState() => _ForgetPasswordState();
}

class _ForgetPasswordState extends State<ForgetPassword> {
  final TextEditingController _emailController = TextEditingController();
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
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
                          style: const TextStyle(
                            fontWeight: FontWeight.w900,
                            fontSize: 22.0,
                            color: AppColors.appWhiteColor,
                          ),
                        ),
                        const SizedBox(height: 2.5),
                        Text(
                          "Provide the Email-Address and we'll send confirmation link to you.",
                          style: TextStyle(
                            fontSize: 14.0,
                            fontWeight: FontWeight.w600,
                            color: AppColors.appWhiteColor.withOpacity(0.75),
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Expanded(
                flex: 5,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  decoration:
                      const BoxDecoration(color: AppColors.appWhiteColor),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "We Got you covered !!",
                        style: TextStyle(
                          color: AppColors.appBlackColor,
                          fontSize: 20.0,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 5.0),
                      const Text(
                        "We will send a password reset link to your associated account after confirmation so you can operate application again 🙂",
                        style: TextStyle(
                          color: AppColors.textColor,
                          fontSize: 13.0,
                        ),
                      ),
                      const SizedBox(height: 20.0),
                      LabelAndInputField(
                        label: "Email-Address",
                        fieldController: _emailController,
                        inputType: TextInputType.emailAddress,
                      ),
                      const SizedBox(height: 25.0),
                      PrimaryButton(
                        onPressed: () => _processForgetPassword(),
                        buttonText: 'Recover Password',
                      ),
                    ],
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

  void _processForgetPassword() async {
    String email = _emailController.text.trim();
    if (email.isEmpty ||
        !RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
            .hasMatch(email)) {
      Common.showErrorTopSnack(
          context, "Please provide valid Email Address and try again");
    } else {
      print("In here");
      _isLoading = true;
      print(_isLoading);
      setState(() {});

      await ApiRequests.sendResetPasswordCode(context, email);
      _isLoading = false;
      setState(() {});
    }
  }
}
