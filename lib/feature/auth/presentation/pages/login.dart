import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meeting_app/core/constant/image_constant.dart';
import 'package:meeting_app/core/constant/string_constant.dart';
import 'package:meeting_app/core/helper/navigation_helper.dart';
import 'package:meeting_app/core/helper/shared_preference_helper.dart';
import 'package:meeting_app/core/helper/toast_helper.dart';
import 'package:meeting_app/core/widget/common_button.dart';
import 'package:meeting_app/core/widget/common_textfield.dart';
import 'package:meeting_app/feature/auth/presentation/bloc/auth_bloc.dart';
import 'package:meeting_app/feature/auth/presentation/bloc/auth_event.dart';
import 'package:meeting_app/feature/auth/presentation/bloc/auth_state.dart';
import 'package:meeting_app/feature/meeting/presentation/meeting.dart';

class Login extends StatefulWidget {
  Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController(
    text: "eve.holt@reqres.in",
  );
  TextEditingController passwordController = TextEditingController(
    text: "cityslicka",
  );
  TextEditingController userController = TextEditingController();
  bool isPasswordVisible = false;
  String emailError = "";
  String passwordError = "";
  String userError = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        Image.asset(ImageConstant.loginImg, height: 300),
                        Text(
                          StringConstant.welcomeBack,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 30,
                          ),
                        ),
                        const SizedBox(height: 10),

                        Text(
                          StringConstant.loginSubHeading,
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 15,
                            color: Colors.grey,
                          ),
                        ),
                        const SizedBox(height: 20),
                        CommonTextField(
                          controller: userController,
                          keyboardType: TextInputType.text,
                          suffixIcon: Icon(Icons.person),

                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Username cannot be empty";
                            }
                            return null;
                          },
                          hintText: StringConstant.userPlaceHolder,
                        ),
                        const SizedBox(height: 20),
                        CommonTextField(
                          controller: emailController,
                          keyboardType: TextInputType.emailAddress,
                          suffixIcon: Icon(Icons.email_outlined),

                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Email cannot be empty";
                            }
                            if (!RegExp(
                              r'^[^@]+@[^@]+\.[^@]+',
                            ).hasMatch(value)) {
                              return "Enter a valid email";
                            }
                            return null;
                          },
                          hintText: StringConstant.emailPlaceHolder,
                        ),
                        const SizedBox(height: 20),

                        CommonTextField(
                          controller: passwordController,
                          hintText: StringConstant.passwordPlaceHolder,
                          obscureText: isPasswordVisible,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Password cannot be empty";
                            }
                            if (value.length < 6) {
                              return "Password must be at least 6 characters";
                            }
                            return null;
                          },
                          suffixIcon: GestureDetector(
                            onTap: () {
                              setState(() {
                                isPasswordVisible = !isPasswordVisible;
                              });
                            },
                            child: Icon(
                              isPasswordVisible
                                  ? Icons.visibility_off_outlined
                                  : Icons.visibility_outlined,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              BlocConsumer<AuthBloc, AuthState>(
                builder: (context, state) {
                  return CommonButton(
                    buttonTitle: 'Login',
                    isLoading: state is AuthLoading,
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        final email = emailController.text.trim();
                        final password = passwordController.text.trim();
                        final username = userController.text.trim();

                        context.read<AuthBloc>().add(
                          LoginSubmitted(email, password, username),
                        );
                      }
                    },
                  );
                },
                listener: (context, state) {
                  if (state is AuthFailure) {
                    ToastHelper.error(context, state.error);
                  }
                  if (state is AuthSuccess) {
                    SharedPreferenceHelper.saveValue(
                      SharedPreferenceHelper.isLogin,
                      true,
                    );
                    ToastHelper.success(context, 'Login Successfully !');
                    NavigationHelper.pushRemoveUntil(context, Meeting());
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
