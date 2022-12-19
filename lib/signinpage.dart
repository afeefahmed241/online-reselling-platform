import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_project/auth_service.dart';
import 'package:flutter_project/signuppage.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/src/provider.dart';

class SignInPage extends StatelessWidget {


  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  final ButtonStyle raisedButtonClickedStyle = ElevatedButton.styleFrom(
      primary: Colors.blueGrey,
      fixedSize: const Size(120, 40),

      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(50)));


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body : Container(
        
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,

          children: [
            const Text("Sign In",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 25)),
            const SizedBox(height: 25,),
            Container(
              width: 300,

              child: TextField(
                textAlign: TextAlign.center,
                controller: emailController,
                decoration: const InputDecoration(
                  labelText: "Email",
                ),
              ),
            ),
            Container(
              width: 300,

              child: TextField(
                textAlign: TextAlign.center,
                controller: passwordController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: "Password",
                ),
              ),
            ),
            const SizedBox(height: 10,),
            ElevatedButton(
              style: raisedButtonClickedStyle,
                onPressed: (){

                context.read<AuthService>().signIn(
                      email: emailController.text.trim(),
                      password: passwordController.text.trim()
                  );



                },
                child: const Text("Sign in")),
            const SizedBox(height: 5,),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("Don't have an account?"),
                GestureDetector(
                  onTap: (){
                    Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) =>  SignUpPage()));
                  },
                  child: const Text("Sign Up",style: TextStyle(color: Colors.blueGrey),),
                )
              ],
            ),


          ],
        ),
      )
    );
  }


}
