import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:womanista/screens/Home.dart';
import 'package:womanista/screens/Signup.dart';
import 'package:womanista/screens/forgotpassword.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  bool isPassShow = true;
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  final formKey = GlobalKey<FormState>();

  userLogin() async {
    if (!formKey.currentState!.validate()) {
      return;
    }
    log("${email.text}  ${password.text}");
    try {
      UserCredential user = await FirebaseAuth.instance
          .signInWithEmailAndPassword(
              email: email.text, password: password.text);
      log("${user.user!.email}");
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(
          builder: (context) => const Home(),
        ),
        (route) => false,
      );
    } on FirebaseAuthException catch (e) {
      log("${e.code} ${e.message}");
      String value = "";
      if (e.code == "invalid-email" || e.code == "wrong-password") {
        value = "You Have Entered Wrong Credentials";
      } else if (e.code == "user-disabled") {
        value = "Your Account is Disabled.";
      } else if (e.code == "user-not-found") {
        value = "Your Account is not Created";
      }

      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            content: Text(value),
            actions: [
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text("Ok"),
              ),
            ],
          );
        },
      );
    }
    log("after");
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Container(
        padding: EdgeInsets.only(
          top: MediaQuery.of(context).padding.top,
          bottom: MediaQuery.of(context).padding.bottom,
        ),
        color: Colors.yellow,
        child: SizedBox(
          height: height,
          width: width,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: height * 0.05,
              ),
              CircleAvatar(
                child: Icon(
                  Icons.person,
                  size: height * 0.15,
                ),
                radius: height * 0.1,
              ),
              SizedBox(
                height: height * 0.05,
              ),
              Text(
                "Sign In",
                style: GoogleFonts.ptSerif(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(
                height: height * 0.03,
              ),
              Expanded(
                child: Container(
                  decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(40),
                        topRight: Radius.circular(40),
                      )),
                  width: width,
                  child: SingleChildScrollView(
                    child: Form(
                      key: formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(
                            height: height * 0.1,
                          ),
                          SizedBox(
                            width: width * 0.8,
                            child: TextFormField(
                              validator: (value) {
                                if (value!.isEmpty || value == "") {
                                  return "Please Enter a Valid Email";
                                }
                                return null;
                              },
                              controller: email,
                              decoration: const InputDecoration(
                                hintText: "Email",
                                label: Text("Email"),
                                icon: Icon(Icons.mail),
                                contentPadding: EdgeInsets.all(0),
                              ),
                              keyboardType: TextInputType.emailAddress,
                            ),
                          ),
                          SizedBox(
                            width: width * 0.8,
                            child: TextFormField(
                              validator: (value) {
                                if (value!.isEmpty || value == "") {
                                  return "Please Enter a Valid Password";
                                }
                                return null;
                              },
                              controller: password,
                              decoration: InputDecoration(
                                hintText: "Password",
                                label: const Text("Password"),
                                icon: const Icon(Icons.key),
                                suffixIcon: IconButton(
                                  onPressed: () {
                                    isPassShow = !isPassShow;
                                    setState(() {});
                                  },
                                  icon: Icon(
                                    isPassShow
                                        ? Icons.remove_red_eye_outlined
                                        : Icons.remove_red_eye,
                                  ),
                                ),
                              ),
                              obscureText: isPassShow,
                            ),
                          ),
                          SizedBox(
                            height: height * 0.02,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (context) => const Recover(),
                                    ),
                                  );
                                },
                                child: Text(
                                  "Forgot Password?",
                                  style: GoogleFonts.ptSerif(
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: width * 0.1,
                              )
                            ],
                          ),
                          SizedBox(
                            height: height * 0.02,
                          ),
                          ElevatedButton(
                            onPressed: userLogin,
                            child: const Text("Sign in"),
                          ),
                          SizedBox(
                            height: height * 0.03,
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => const Signup(),
                                ),
                              );
                            },
                            child: Text(
                              "Create New Account?",
                              style: GoogleFonts.ptSerif(
                                fontSize: 14,
                              ),
                            ),
                          ),
                          SizedBox(
                            height: height * 0.03,
                          ),
                          ElevatedButton.icon(
                            onPressed: () {},
                            icon: const FaIcon(FontAwesomeIcons.google),
                            label: Text(
                              "Signin with google",
                              style: GoogleFonts.ptSerif(
                                fontSize: 14,
                              ),
                            ),
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all(
                                const Color.fromARGB(207, 255, 235, 59),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
