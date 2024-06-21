import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../core/core.dart';
import '../../../home/presentation/pages/main_page.dart';
import '../bloc/login/login_bloc.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  late TextEditingController emailController;
  late TextEditingController passwordController;
  bool isShowPassword = false;

  @override
  void initState() {
    super.initState();
    emailController = TextEditingController();
    passwordController = TextEditingController();
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 0.0,
        backgroundColor: MyColors.background,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              Assets.images.logo.path,
              width: MediaQuery.of(context).size.width,
              height: 100,
            ),
            const SpaceHeight(50.0),
            Container(
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: MyColors.white,
                borderRadius: const BorderRadius.all(
                  Radius.circular(16.0),
                ),
                border: Border.all(
                  width: 1.0,
                  color: Colors.grey.shade200,
                ),
              ),
              child: Column(
                children: [
                  MyTextField(
                    controller: emailController,
                    label: 'Email Address',
                    showLabel: false,
                    fillColor: Colors.grey.shade50,
                    prefixIcon: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: SvgPicture.asset(
                        Assets.icons.email.path,
                        height: 20,
                        width: 20,
                      ),
                    ),
                  ),
                  const SpaceHeight(12.0),
                  MyTextField(
                    controller: passwordController,
                    label: 'Password',
                    showLabel: false,
                    obscureText: !isShowPassword,
                    fillColor: Colors.grey.shade50,
                    prefixIcon: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: SvgPicture.asset(
                        Assets.icons.password.path,
                        height: 20,
                        width: 20,
                      ),
                    ),
                    suffixIcon: IconButton(
                      icon: Icon(
                        isShowPassword
                            ? Icons.visibility_off
                            : Icons.visibility,
                        color: MyColors.grey,
                      ),
                      onPressed: () {
                        setState(() {
                          isShowPassword = !isShowPassword;
                        });
                      },
                    ),
                  ),
                  const SpaceHeight(32.0),
                  BlocConsumer<LoginBloc, LoginState>(
                    listener: (context, state) {
                      if (state is LoginSuccess) {
                        context.pushAndRemoveUntil(
                          const MainPage(),
                          (route) => false,
                        );
                      }

                      if (state is LoginError) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(state.failure.message),
                            backgroundColor: Colors.red,
                          ),
                        );
                      }
                    },
                    builder: (context, state) {
                      if (state is LoginLoading) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                      return MyButton.filled(
                        onPressed: () {
                          context.read<LoginBloc>().add(
                                LoginEvent(
                                  email: emailController.text,
                                  password: passwordController.text,
                                ),
                              );
                        },
                        label: 'Login',
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
