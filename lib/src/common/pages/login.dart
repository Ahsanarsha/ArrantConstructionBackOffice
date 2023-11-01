import 'package:arrant_construction_bo/src/controllers/user_controller.dart';
import 'package:arrant_construction_bo/src/helpers/helper.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
// import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import '../../helpers/app_constants.dart' as constants;

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final UserController _con = Get.put(UserController());
  late GlobalKey<FormState> _loginFormKey;

  final _isPasswordVisible = false.obs;
  final TextEditingController _passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loginFormKey = GlobalKey<FormState>();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 20,
        ),
        child: Form(
          key: _loginFormKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  height: size.height * 0.1,
                ),
                const Image(
                  image: AssetImage("assets/img/ac_logo_orange.png"),
                  width: 200,
                  height: 200,
                ),
                SizedBox(
                  height: size.height * 0.06,
                ),
                TextFormField(
                  keyboardType: TextInputType.emailAddress,
                  onSaved: (input) => _con.user.email = input ?? '',
                  validator: (input) => GetUtils.isEmail(input ?? '')
                      ? null
                      : constants.notAValidEmail,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  decoration: _loginFormInputDecoration(
                    labelText: constants.email,
                    icon: Icons.mail_outline,
                  ),
                ),
                SizedBox(height: size.height * 0.025),
                Obx(() {
                  return TextFormField(
                    controller: _passwordController,
                    keyboardType: TextInputType.text,
                    onSaved: (input) => _con.user.password = input ?? '',
                    validator: (input) {
                      if (input != null) {
                        if (input.length > 7 &&
                            input.contains(
                              Helper.specialCharacterRegex(),
                            ) &&
                            input.contains(
                              Helper.alphanumericRegex(),
                            )) {
                          return null;
                        } else {
                          return constants.passwordContainSpecialChar;
                        }
                      }
                    },
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    obscureText: _isPasswordVisible.value ? false : true,
                    decoration: _loginFormInputDecoration(
                      labelText: constants.password,
                      icon: Icons.lock_outline,
                      suffixIcon: _isPasswordVisible.value
                          ? Icons.visibility
                          : Icons.visibility_off,
                      onSuffixIconPressed: _changePasswordVisibility,
                    ),
                  );
                }),
                // const SizedBox(
                //   height: 10,
                // ),
                Align(
                  alignment: Alignment.centerRight,
                  child: _forgotPasswordButton(),
                ),
                SizedBox(
                  height: size.height * 0.05,
                ),
                _loginButton(),
                SizedBox(
                  height: size.height * 0.015,
                ),
                // const Text("OR"),
                // _createNewAccountButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _changePasswordVisibility() {
    _isPasswordVisible.value = !_isPasswordVisible.value;
  }

  Widget _loginButton() {
    return TextButton(
      onPressed: () {
        if (constants.connectionStatus.hasConnection) {
          FocusScope.of(context).requestFocus(FocusNode());
          if (!_loginFormKey.currentState!.validate()) {
            return;
          } else {
            _loginFormKey.currentState!.save();
            _con.login(context);
          }
        } else {
          Fluttertoast.showToast(msg: constants.noInternetConnection);
        }
      },
      style: ButtonStyle(
        padding: MaterialStateProperty.all(
          const EdgeInsets.symmetric(horizontal: 50.0),
        ),
        backgroundColor:
            MaterialStateProperty.all(Theme.of(context).primaryColor),
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
          const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(5.0)),
          ),
        ),
      ),
      child: const Text(
        constants.login,
        style: TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _forgotPasswordButton() {
    return TextButton(
      onPressed: () {},
      child: Text(
        constants.forgotPassword,
        style: TextStyle(
          color: Theme.of(context).primaryColor,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _createNewAccountButton() {
    return TextButton(
      onPressed: () {
        // Get.to(
        //   const SingupPage(),
        //   transition: Transition.rightToLeft,
        // );
      },
      child: const Text(
        constants.createNewAccount,
        style: TextStyle(
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  InputDecoration _loginFormInputDecoration({
    @required String? labelText,
    @required IconData? icon,
    IconData? suffixIcon,
    // Function() is function without any params
    Function()? onSuffixIconPressed,
  }) {
    return InputDecoration(
      label: Text(labelText ?? ""),
      floatingLabelBehavior: FloatingLabelBehavior.never,
      contentPadding: const EdgeInsets.all(10),
      errorMaxLines: 2,
      prefixIcon: Icon(icon),
      suffixIcon: IconButton(
        onPressed: onSuffixIconPressed ?? () {},
        icon: Icon(suffixIcon),
      ),
      border: const OutlineInputBorder(
        borderSide: BorderSide(
          width: 2.0,
          color: Colors.grey,
        ),
        borderRadius: BorderRadius.all(
          Radius.circular(5.0),
        ),
      ),
    );
  }
}
