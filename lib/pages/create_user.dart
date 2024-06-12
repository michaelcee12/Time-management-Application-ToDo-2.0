import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:to_do_app/components/my_button.dart';
import 'package:to_do_app/components/my_textfield.dart';
import 'package:to_do_app/pages/login.dart';

class CreateUser extends StatefulWidget {
  const CreateUser({super.key});

  // final Function()? onTap;

  @override
  State<CreateUser> createState() => _CreateUseState();
}

class _CreateUseState extends State<CreateUser> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmpasswordController = TextEditingController();

  void routeSignInUser() {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => const Login()));
  }

  //sign user up
  void signUserUp() async {
    // showloadingcircle
    showDialog(
      context: context,
      builder: (context) {
        return const Center(
          child: CircularProgressIndicator(color: Color(0xFF928490)),
        );
      },
    );

    //Create new user
    try {
      //vheck if confirm password == password
      if (passwordController.text == confirmpasswordController.text) {
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: emailController.text.trim(),
          password: passwordController.text.trim(),
        );
      } else {
        //show error message, passwords don't match
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("passwords don't match!")));
      }
      // you need to create an email verification

      await FirebaseAuth.instance.signOut();
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => const Login()));
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("User Registered Successfully. You can now Login")));
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text("The password provided is too weak!")));
      } //else if (e.code == 'email-already-in-use') {
      //   ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      //       content: Text("the account already exists for that e-mail!")));
      // }
      // Handle error
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(e.message ?? 'Unknown error')));
      }
    }
    //pop the loading circle
    if (mounted) {
      Navigator.pop(context);
    }
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
                    size: 50,
                    color: Colors.black54,
                  ),
                  // Image.asset(
                  //   'images/mini-lock.png',
                  //   height: 70,
                  //   width: 70,
                  // ),
                  const SizedBox(height: 20),
                  const Text(
                    "Let's create an account for you!",
                    style: TextStyle(
                      color: Colors.black54,
                      fontSize: 18,
                    ),
                  ),

                  const SizedBox(height: 15),
                  MyTextField(
                    controller: emailController,
                    hintText: 'Enter Email',
                    obscureText: false,
                  ),

                  const SizedBox(height: 15),
                  MyTextField(
                    controller: passwordController,
                    hintText: 'Enter Password',
                    obscureText: true,
                  ),
                  const SizedBox(height: 15),
                  MyTextField(
                    controller: confirmpasswordController,
                    hintText: 'Confirm Password',
                    obscureText: true,
                  ),
                  const SizedBox(height: 15),
                  MyButton(
                    buttonName: 'Create User',
                    onTap: () {
                      signUserUp();
                    },
                  ),

                  const SizedBox(height: 15),
                  GestureDetector(
                    onTap: routeSignInUser,
                    child: const Text(
                      'Already a Member? Login now',
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
