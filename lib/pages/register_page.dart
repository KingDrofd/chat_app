import 'package:chat_app/components/custom_button.dart';
import 'package:chat_app/components/custom_text_field.dart';
import 'package:chat_app/services/auth/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:provider/provider.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key, required this.onTap});
  final Function()? onTap;
  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  TextEditingController nameController = TextEditingController();

  void signUp() async {
    if (passwordController.text != passwordController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Passwords don't mathc"),
        ),
      );
      return;
    }
    final authService = Provider.of<AuthService>(context, listen: false);

    try {
      await authService.signUpWithEmailAndPassword(
          emailController.text, passwordController.text, nameController.text);
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.toString()),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.grey[300],
        body: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Gap(50),
                Icon(
                  Icons.message_outlined,
                  color: Colors.grey[800],
                  size: 100,
                ),
                const Gap(50),
                const Text(
                  "Let's create an account for you!",
                  style: TextStyle(color: Colors.black45, fontSize: 18),
                ),
                const Gap(25),
                CustomTextField(controller: nameController, hintText: "Name"),
                const Gap(10),
                CustomTextField(controller: emailController, hintText: "Email"),
                const Gap(10),
                CustomTextField(
                    controller: passwordController,
                    obscureText: true,
                    hintText: "Password"),
                const Gap(10),
                CustomTextField(
                    controller: confirmPasswordController,
                    obscureText: true,
                    hintText: "Confirm password"),
                const Gap(25),
                CustomButton(
                  text: "Sign Up",
                  onTap: signUp,
                ),
                Gap(30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Already a member?"),
                    Gap(5),
                    GestureDetector(
                      onTap: widget.onTap,
                      child: Text(
                        "Sign In",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
