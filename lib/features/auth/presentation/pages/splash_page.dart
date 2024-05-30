import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/core.dart';
import '../../../home/presentation/pages/main_page.dart';
import '../bloc/auth/auth_bloc.dart';
import 'login_page.dart';

class SplashPage extends StatelessWidget {
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context) {
    Future.delayed(
      const Duration(seconds: 2),
      () => context.pushReplacement(
        BlocBuilder<AuthBloc, AuthState>(
          builder: (context, state) {
            if (state is Authenticated) {
              return const MainPage();
            }
            return const LoginPage();
          },
        ),
      ),
    );
    return Scaffold(
      backgroundColor: MyColors.primary,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(50.0),
          child: Assets.images.logoWhite.image(),
        ),
      ),
    );
  }
}
