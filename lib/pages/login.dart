import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:to_do_app/components/my_button.dart';
import 'package:to_do_app/components/my_textfield.dart';
import 'package:to_do_app/pages/create_user.dart';
import 'package:to_do_app/pages/home_page.dart';

class Login extends StatefulWidget {
  const Login({super.key});
  // final Function()? onTap;

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  //text editing Controllers
  final emailController = TextEditingController();

  final passwordController = TextEditingController();

  void routeSignUpUser() {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => const CreateUser()));
  }

  void logInUserIn() async {
    // showloadingcircle
    showDialog(
      context: context,
      builder: (context) {
        return const Center(
          child: CircularProgressIndicator(color: Color(0xFF928490)),
        );
      },
    );

    //Sign in

    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );
    } on FirebaseAuthException catch (e) {
      // Handle error
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(e.message ?? 'Unknown error')));
      }
    }
    //pop the loading circle
    Navigator.pop(context);

    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => const HomePage()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white60,
        body: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.lock,
                    size: 70,
                    color: Colors.black54,
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    "Welcome back you've been missed!",
                    style: TextStyle(
                      color: Colors.black54,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 25),
                  MyTextField(
                    controller: emailController,
                    hintText: 'Email',
                    obscureText: false,
                  ),
                  const SizedBox(height: 15),
                  MyTextField(
                    controller: passwordController,
                    hintText: 'Password',
                    obscureText: true,
                  ),
                  const SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        GestureDetector(
                          onTap: () {},
                          child: const Text(
                            'Forgot Password?',
                            style: TextStyle(
                                color: Colors.blueGrey,
                                fontWeight: FontWeight.w500),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 25),
                  MyButton(
                    buttonName: 'Login',
                    onTap: () {
                      logInUserIn();
                    },
                  ),
                  GestureDetector(
                    onTap: routeSignUpUser,
                    child: const Text(
                      'Not a member? Create User',
                      style: TextStyle(
                        color: Colors.deepOrange,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ));
  }
}
