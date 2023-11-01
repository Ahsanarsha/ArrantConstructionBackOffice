import 'package:arrant_construction_bo/src/controllers/vendor_controller.dart';
import 'package:arrant_construction_bo/src/helpers/helper.dart';
import 'package:arrant_construction_bo/src/models/vendor.dart';
import 'package:arrant_construction_bo/src/models/vendor_category.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../helpers/app_constants.dart' as constants;

class AddVendor extends StatefulWidget {
  const AddVendor({Key? key}) : super(key: key);

  @override
  _AddVendorState createState() => _AddVendorState();
}

class _AddVendorState extends State<AddVendor> {
  VendorController _con = Get.put(VendorController());
  Vendor vendor = Vendor();
  String vendorCategoryId = '';
  late GlobalKey<FormState> _vendorFormKey;
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  @override
  void initState() {
    super.initState();
    _vendorFormKey = GlobalKey<FormState>();
  }

  @override
  Widget build(BuildContext context) {
    double sizedBoxHeight = MediaQuery.of(context).size.height * 0.025;

    Widget sizedBox = SizedBox(
      height: sizedBoxHeight,
    );
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add New Vendor"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 20,
        ),
        child: Form(
          key: _vendorFormKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                sizedBox,
                Row(
                  children: [
                    Flexible(
                      fit: FlexFit.tight,
                      child: TextFormField(
                        keyboardType: TextInputType.text,
                        onSaved: (input) => vendor.firstName = input,
                        validator: (input) => input != null && input.length > 1
                            ? null
                            : "Mandatory!",
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        decoration: _vendorInputDecoration(
                          labelText: constants.fname,
                        ),
                      ),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.05,
                    ),
                    Flexible(
                      fit: FlexFit.tight,
                      child: TextFormField(
                        keyboardType: TextInputType.text,
                        onSaved: (input) => vendor.lastName = input,
                        validator: (input) => input != null && input.length > 1
                            ? null
                            : "Mandatory!",
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        decoration: _vendorInputDecoration(
                          labelText: constants.lname,
                        ),
                      ),
                    ),
                  ],
                ),
                sizedBox,
                TextFormField(
                  keyboardType: TextInputType.phone,
                  onSaved: (input) => vendor.contactNumber = input,
                  validator: (input) => input != null &&
                          input.startsWith("+1") &&
                          input.length == 12
                      ? null
                      : "Not a valid number!",
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  decoration: _vendorInputDecoration(
                    labelText: constants.number,
                    hintText: "+16102347536",
                  ),
                ),
                sizedBox,
                _headingTextWidget("Business Details"),
                sizedBox,
                // _BussinessDetailsWidget(["Wood", "Paint"], sizedBox),
                _selectServiceDropDown(context),
                sizedBox,
                TextFormField(
                  maxLength: 70,
                  maxLines: null,
                  onSaved: (input) => vendor.shopAddress = input,
                  //  validator: (input) => input!.length > 1 ? null : "Mandatory!",
                  decoration: _vendorInputDecoration(
                    labelText: "Shop Address",
                  ),
                ),
                sizedBox,
                Container(
                  constraints: const BoxConstraints(
                    maxHeight: 150,
                  ),
                  child: TextFormField(
                    keyboardType: TextInputType.multiline,
                    onSaved: (input) => vendor.pastExperience = input,
                    validator: (input) =>
                        input != null && input.length > 1 ? null : "Mandatory!",
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    maxLength: 500,
                    maxLines: null,
                    decoration: _vendorInputDecoration(
                      labelText: "Past Experiances",
                    ),
                  ),
                ),
                sizedBox,
                _headingTextWidget("Account Details"),
                sizedBox,
                _AccountDetails(vendor, sizedBox, _passwordController,
                    _confirmPasswordController),
                sizedBox,
                Align(
                  alignment: Alignment.center,
                  child: _addVendorButton(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _addVendorButton() {
    return TextButton(
      onPressed: () {
        if (constants.connectionStatus.hasConnection) {
          FocusScope.of(context).requestFocus(FocusNode());
          if (!_vendorFormKey.currentState!.validate() &&
              vendorCategoryId.isEmpty) {
            return;
          } else {
            _vendorFormKey.currentState!.save();
            _con.registerVendor(context, vendor, vendorCategoryId);
          }
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
        "Add",
        style: TextStyle(
          color: Colors.white,
        ),
      ),
    );
  }

  Widget _selectServiceDropDown(BuildContext context) {
    return DropdownButtonFormField(
      validator: (input) => vendorCategoryId == '' ? "Select Service" : null,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      onChanged: (VendorCategory? _vendorCategory) {
        vendorCategoryId = _vendorCategory!.id ?? '';
      },
      items: constants.vendorCategories.map((VendorCategory _vendorCategory) {
        return DropdownMenuItem(
          value: _vendorCategory,
          child: Text(
            _vendorCategory.name ?? '',
          ),
        );
      }).toList(),
      icon: Icon(
        Icons.arrow_drop_down_circle,
        color: Theme.of(context).colorScheme.secondary,
      ),
      iconSize: 20.0,
      decoration: _vendorInputDecoration(
        labelText: "Select Service",
      ),
    );
  }

  Widget _headingTextWidget(String title) {
    return Text(
      title,
      style: TextStyle(
        color: Theme.of(context).primaryColor,
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}

// class _BussinessDetailsWidget extends StatelessWidget {
//   final List vendorcategory;
//   final Widget sizedbox;

//   const _BussinessDetailsWidget(this.vendorcategory, this.sizedbox, {Key? key})
//       : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         _selectServiceDropDown(context),
//         sizedbox,
//         TextFormField(
//           maxLength: 70,
//           maxLines: null,

//           validator: (input) =>
//               input != null && input.length > 1 ? null : "Mandatory!",
//           decoration: _vendorInputDecoration(
//             labelText: "Shop Address",
//           ),
//         ),
//         sizedbox,
//         Container(
//           constraints: const BoxConstraints(
//             maxHeight: 150,
//           ),
//           child: TextFormField(
//             keyboardType: TextInputType.multiline,
//             validator: (input) =>
//                 input != null && input.length > 1 ? null : "Mandatory!",
//             autovalidateMode: AutovalidateMode.onUserInteraction,
//             maxLength: 500,
//             maxLines: null,
//             decoration: _vendorInputDecoration(
//               labelText: "Past Experiances",
//             ),
//           ),
//         ),
//       ],
//     );
//   }

//   Widget _selectServiceDropDown(BuildContext context) {
//     return DropdownButtonFormField(
//       autovalidateMode: AutovalidateMode.onUserInteraction,
//       onChanged: (item) {},
//       items: vendorcategory.map((item) {
//         return DropdownMenuItem(
//           value: item,
//           child: Text(
//             item ?? '',
//           ),
//         );
//       }).toList(),
//       icon: Icon(
//         Icons.arrow_drop_down_circle,
//         color: Theme.of(context).colorScheme.secondary,
//       ),
//       iconSize: 20.0,
//       decoration: _vendorInputDecoration(
//         labelText: "Select Service",
//       ),
//     );
//   }
// }

InputDecoration _vendorInputDecoration({
  @required String? labelText,
  String hintText = '',
  double labelFontSize = 12.0,
}) {
  return InputDecoration(
    label: Text(labelText ?? ""),
    hintText: hintText,
    labelStyle: TextStyle(
      fontSize: labelFontSize,
    ),
    hintStyle: TextStyle(
      color: Colors.grey,
      fontSize: labelFontSize,
    ),
    floatingLabelBehavior: FloatingLabelBehavior.auto,
    contentPadding: const EdgeInsets.all(10),
    errorMaxLines: 2,
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

class _AccountDetails extends StatelessWidget {
  final Widget sizedbox;
  final Vendor vendor;
  final TextEditingController _passwordController;
  final TextEditingController _confirmPasswordController;
  _AccountDetails(this.vendor, this.sizedbox, this._passwordController,
      this._confirmPasswordController,
      {Key? key})
      : super(key: key);

  final _isPasswordVisible = false.obs;
  final _isConfirmPasswordVisible = false.obs;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextFormField(
          keyboardType: TextInputType.emailAddress,
          onSaved: (input) => vendor.email = input,
          validator: (input) =>
              GetUtils.isEmail(input ?? '') ? null : constants.notAValidEmail,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          decoration: _vendorAuthDecoration(
            labelText: constants.email,
            icon: Icons.mail_outline,
          ),
        ),
        sizedbox,
        Obx(() {
          return TextFormField(
            controller: _passwordController,
            keyboardType: TextInputType.visiblePassword,
            onSaved: (input) => vendor.password = input,
            onFieldSubmitted: (value) => vendor.password = value,
            validator: (input) {
              if (input != null) {
                if (input.length > 7 &&
                    input.contains(Helper.specialCharacterRegex()) &&
                    input.contains(Helper.alphanumericRegex())) {
                  return null;
                } else {
                  return constants.passwordContainSpecialChar;
                }
              }
            },
            autovalidateMode: AutovalidateMode.onUserInteraction,
            obscureText: _isPasswordVisible.value ? false : true,
            decoration: _vendorAuthDecoration(
                labelText: constants.password,
                icon: Icons.lock_outline,
                suffixIcon: _isPasswordVisible.value
                    ? Icons.visibility
                    : Icons.visibility_off,
                onSuffixIconPressed: () {
                  _changePasswordVisibility(_isPasswordVisible);
                }),
          );
        }),
        sizedbox,
        TextFormField(
          controller: _confirmPasswordController,
          keyboardType: TextInputType.text,
          validator: (input) {
            if (_passwordController.text == _confirmPasswordController.text) {
              return null;
            } else {
              return constants.passwordDoesNotMatch;
            }
          },
          autovalidateMode: AutovalidateMode.onUserInteraction,
          obscureText: _isConfirmPasswordVisible.value ? false : true,
          decoration: _vendorAuthDecoration(
            labelText: constants.confirmPassword,
            icon: Icons.lock_outline,
            // suffixIcon: _isConfirmPasswordVisible.value
            //     ? Icons.visibility
            //     : Icons.visibility_off,
            // onSuffixIconPressed: () {
            //   _changePasswordVisibility(_isConfirmPasswordVisible);
            // },
          ),
        ),
      ],
    );
  }

  void _changePasswordVisibility(RxBool _isPasswordVisible) {
    _isPasswordVisible.value = !_isPasswordVisible.value;
  }

  InputDecoration _vendorAuthDecoration({
    String? labelText,
    IconData? icon,
    IconData? suffixIcon,
    Function()? onSuffixIconPressed,
  }) {
    return InputDecoration(
      label: Text(labelText ?? ""),
      floatingLabelBehavior: FloatingLabelBehavior.auto,
      contentPadding: const EdgeInsets.all(0),
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
