import 'package:ecommerce/features/home/presentation/views/home_screen.dart';
import 'package:ecommerce/features/login/presentation/views/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/widgets/app_text_button.dart';
import '../../../../core/widgets/app_text_from_field.dart';
import '../../../../core/widgets/show_snack_bar.dart';
import '../view_models/register_cubit/register_cubit.dart';

class SignUpScreen extends StatelessWidget {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  final GlobalKey<FormState> formKey = GlobalKey();

  SignUpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return BlocProvider(
      create: (context) => RegisterCubit(),
      child: BlocConsumer<RegisterCubit, RegisterState>(
        listener: (context, state) {
          if (state is RegisterLoading) {
            showDialog(
              context: context,
              barrierDismissible: false,
              builder: (context) =>
                  const Center(child: CircularProgressIndicator()),
            );
          } else if (state is RegisterSuccess) {
            Navigator.pop(context);
            showSnackBar(context, "Registration Success", Colors.green);
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => LoginScreen()),
            );
          } else if (state is RegisterFailure) {
            Navigator.pop(context);
            showSnackBar(context, state.errMessage, Colors.red);
          }
        },
        builder: (context, state) {
          final registerCubit = context.read<RegisterCubit>();

          return Scaffold(
            body: Padding(
              padding: EdgeInsets.all(screenWidth * 0.05),
              child: Center(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Padding(
                    padding: EdgeInsets.only(
                      top: screenHeight * 0.05,
                      left: screenWidth * 0.05,
                      right: screenWidth * 0.05,
                    ),
                    child: Form(
                      key: formKey,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Create an\naccount',
                            style: TextStyle(
                              fontSize: screenWidth * 0.1,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          SizedBox(height: screenHeight * 0.05),
                          AppTextFormField(
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: screenWidth * 0.05,
                              vertical: screenHeight * 0.02,
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                  color: Color(0xffA8A8A9), width: 1.3),
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            hintText: 'Username or Email',
                            hintStyle: TextStyle(
                              fontSize: screenWidth * 0.04,
                              fontWeight: FontWeight.bold,
                              fontFamily: "Montserrat",
                              color: const Color(0xff676767),
                            ),
                            prefixIcon:
                                Icon(Icons.person, size: screenWidth * 0.06),
                            controller: _usernameController,
                            backgroundColor: const Color(0xffF3F3F3),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "Your Email is empty";
                              }
                              bool emailValid = RegExp(
                                      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                  .hasMatch(value);
                              if (!emailValid) {
                                return "Please enter a valid email";
                              }
                              if (value.length < 19) {
                                return "Your email must be greater than 19 characters";
                              }
                              return null;
                            },
                          ),
                          SizedBox(height: screenHeight * 0.03),
                          BlocBuilder<RegisterCubit, RegisterState>(
                            builder: (context, state) {
                              return Column(
                                children: [
                                  AppTextFormField(
                                    contentPadding: EdgeInsets.symmetric(
                                      horizontal: screenWidth * 0.05,
                                      vertical: screenHeight * 0.02,
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: const BorderSide(
                                          color: Color(0xffA8A8A9), width: 1.3),
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                    hintText: 'Password',
                                    hintStyle: TextStyle(
                                      fontSize: screenWidth * 0.04,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: "Montserrat",
                                      color: const Color(0xff676767),
                                    ),
                                    prefixIcon: Icon(Icons.lock,
                                        size: screenWidth * 0.06),
                                    controller: _passwordController,
                                    isObscureText: registerCubit.obscureText,
                                    backgroundColor: const Color(0xffF3F3F3),
                                    suffixIcon: IconButton(
                                      icon: Icon(
                                        registerCubit.obscureText
                                            ? Icons.visibility_off
                                            : Icons.visibility,
                                        size: screenWidth * 0.06,
                                      ),
                                      onPressed: () {
                                        registerCubit.changeObscureText();
                                      },
                                    ),
                                    validator: (value) {
                                      if (value == null ||
                                          value.isEmpty ||
                                          value.length < 6) {
                                        return 'Password must be at least 6 characters';
                                      }
                                      return null;
                                    },
                                  ),
                                  SizedBox(height: screenHeight * 0.03),
                                  AppTextFormField(
                                    contentPadding: EdgeInsets.symmetric(
                                      horizontal: screenWidth * 0.05,
                                      vertical: screenHeight * 0.02,
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: const BorderSide(
                                          color: Color(0xffA8A8A9), width: 1.3),
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                    hintText: 'Confirm Password',
                                    hintStyle: TextStyle(
                                      fontSize: screenWidth * 0.04,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: "Montserrat",
                                      color: const Color(0xff676767),
                                    ),
                                    prefixIcon: Icon(Icons.lock,
                                        size: screenWidth * 0.06),
                                    controller: _confirmPasswordController,
                                    isObscureText: registerCubit.obscureText,
                                    backgroundColor: const Color(0xffF3F3F3),
                                    suffixIcon: IconButton(
                                      icon: Icon(
                                        registerCubit.obscureText
                                            ? Icons.visibility_off
                                            : Icons.visibility,
                                        size: screenWidth * 0.06,
                                      ),
                                      onPressed: () {
                                        registerCubit.changeObscureText();
                                      },
                                    ),
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Confirm password is required';
                                      }
                                      if (value != _passwordController.text) {
                                        return 'Passwords do not match';
                                      }
                                      return null;
                                    },
                                  ),
                                ],
                              );
                            },
                          ),
                          SizedBox(height: screenHeight * 0.03),
                          AppTextButton(
                            buttonText: 'Create Account',
                            textStyle: TextStyle(
                              color: Colors.white,
                              fontSize: screenWidth * 0.05,
                              fontWeight: FontWeight.w600,
                            ),
                            backgroundColor: const Color(0xffF83758),
                            onPressed: () {
                              if (formKey.currentState!.validate()) {
                                final email = _usernameController.text;
                                final password = _passwordController.text;
                                BlocProvider.of<RegisterCubit>(context)
                                    .resgisterUser(
                                        email: email, password: password);
                              }
                            },
                          ),
                          SizedBox(height: screenHeight * 0.07),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                '-OR Continue with-',
                                style: TextStyle(
                                  fontSize: screenWidth * 0.04,
                                  fontFamily: "Montserrat",
                                  color: const Color(0xff575757),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: screenHeight * 0.03),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  CircleAvatar(
                                    radius: screenWidth * 0.08,
                                    backgroundColor: const Color(0xffF83758),
                                    child: CircleAvatar(
                                      radius: screenWidth * 0.075,
                                      backgroundColor: const Color(0xffFCF3F6),
                                      child: Container(
                                        width: screenWidth * 0.065,
                                        height: screenWidth * 0.065,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(30),
                                          color: const Color(0xFFFCF3F6),
                                        ),
                                        child: Image.asset(
                                            "assets/images/google.png"),
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: screenWidth * 0.03),
                                  CircleAvatar(
                                    radius: screenWidth * 0.08,
                                    backgroundColor: const Color(0xffF83758),
                                    child: CircleAvatar(
                                      radius: screenWidth * 0.075,
                                      backgroundColor: const Color(0xffFCF3F6),
                                      child: Container(
                                        width: screenWidth * 0.065,
                                        height: screenWidth * 0.065,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(30),
                                          color: const Color(0xFFFCF3F6),
                                        ),
                                        child: Image.asset(
                                            "assets/images/apple.png"),
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: screenWidth * 0.03),
                                  CircleAvatar(
                                    radius: screenWidth * 0.08,
                                    backgroundColor: const Color(0xffF83758),
                                    child: CircleAvatar(
                                      radius: screenWidth * 0.075,
                                      backgroundColor: const Color(0xffFCF3F6),
                                      child: Container(
                                        width: screenWidth * 0.065,
                                        height: screenWidth * 0.065,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(30),
                                          color: const Color(0xFFFCF3F6),
                                        ),
                                        child:
                                            Image.asset("assets/images/fb.png"),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: screenHeight * 0.04),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "I Already Have an Account",
                                    style: GoogleFonts.montserrat(
                                      color: const Color(0xFF575757),
                                      fontWeight: FontWeight.w500,
                                      fontSize: screenWidth * 0.045,
                                    ),
                                  ),
                                  const SizedBox(width: 5),
                                  InkWell(
                                    onTap: () {
                                      _usernameController.clear();
                                      _passwordController.clear();
                                      Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => LoginScreen(),
                                        ),
                                      );
                                    },
                                    child: Text(
                                      "Login",
                                      style: GoogleFonts.montserrat(
                                        decoration: TextDecoration.underline,
                                        color: const Color(0xffF83758),
                                        fontWeight: FontWeight.w600,
                                        fontSize: screenWidth * 0.045,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: screenHeight * 0.05),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
