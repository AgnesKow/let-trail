import 'package:flutter/material.dart';
import 'package:letstrail/utils/utils_exporter.dart';
import 'package:letstrail/views/views_exporter.dart';

class Register extends StatefulWidget {
  const Register({Key? key}) : super(key: key);

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _uidController = TextEditingController();

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
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
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
                        style: const TextStyle(
                          fontWeight: FontWeight.w900,
                          fontSize: 22.0,
                          color: AppColors.appWhiteColor,
                        ),
                      ),
                      const SizedBox(height: 2.5),
                      Text(
                        "A journey of thousand miles begins with a single step",
                        style: TextStyle(
                          fontSize: 16.0,
                          fontWeight: FontWeight.w600,
                          color: AppColors.appWhiteColor.withOpacity(0.75),
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                flex: 6,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20.0,
                    vertical: 30.0,
                  ),
                  decoration:
                      const BoxDecoration(color: AppColors.appWhiteColor),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        LabelAndInputField(
                          label: "Username",
                          fieldController: _usernameController,
                        ),
                        const SizedBox(height: 12.0),
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
                        const SizedBox(height: 25.0),
                        PrimaryButton(
                          onPressed: () => _processRegister(),
                          buttonText: "Let's Start",
                        ),
                        const SizedBox(height: 8.0),
                        InkWell(
                          onTap: () => Navigator.of(context).pop(),
                          child: const Text(
                            "Already Have an account? Login Now!",
                            style: TextStyle(
                              color: AppColors.textColor,
                              fontSize: 13.0,
                              fontWeight: FontWeight.w600,
                            ),
                            textAlign: TextAlign.center,
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

  Future<void> _processRegister() async {
    String username = _usernameController.text.trim();
    String email = _emailController.text.trim();
    String uid = _uidController.text.trim();

    if (username.isEmpty) {
      Common.showErrorTopSnack(
          context, "Please provide Username and try again");
    } else if (email.isEmpty ||
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

      await ApiRequests.registerUser(context, username, email, uid)
          .then(
        (value) => Common.pushAndRemoveUntil(
          context,
          DashboardScreen(),
        ),
      )
          .onError((error, stackTrace) {
        _isLoading = false;
        setState(() {});
        Common.showErrorTopSnack(context, error.toString());
      });
    }
  }
}
