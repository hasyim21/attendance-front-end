import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/core.dart';
import '../../../auth/presentation/bloc/logout/logout_bloc.dart';
import '../../../auth/presentation/pages/login_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('This is home page'),
            BlocConsumer<LogoutBloc, LogoutState>(
              listener: (context, state) {
                if (state is LogoutSuccess) {
                  context.pushAndRemoveUntil(
                    const LoginPage(),
                    (route) => false,
                  );
                }

                if (state is LogoutError) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(state.failure.message),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              },
              builder: (context, state) {
                if (state is LogoutLoading) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
                return Button.filled(
                  onPressed: () {
                    context.read<LogoutBloc>().add(
                          const LogoutEvent(),
                        );
                  },
                  label: 'Sign Out',
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
