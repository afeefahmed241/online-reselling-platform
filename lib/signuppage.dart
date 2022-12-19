import 'package:flutter/material.dart';
import 'package:flutter_project/auth_service.dart';
import 'package:provider/src/provider.dart';

class SignUpPage extends StatelessWidget {


  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmController = TextEditingController();

  final ButtonStyle raisedButtonClickedStyle = ElevatedButton.styleFrom(
      primary: Colors.blueGrey,
      fixedSize: const Size(120, 40),

      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(50)));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body : Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text("Sign Up",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 25)),
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
            Container(
              width: 300,

              child: TextField(
                textAlign: TextAlign.center,
                controller: confirmController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: "Confirm Password",
                ),
              ),
            ),
            const SizedBox(height: 10,),
            ElevatedButton(
                style: raisedButtonClickedStyle,
                onPressed: (){
                  if(confirmController.text==passwordController.text)
                    {
                      context.read<AuthService>().signUp(
                          email: emailController.text.trim(),
                          password: passwordController.text.trim()
                      );
                      Navigator.pop(context);
                    }

                },
                child: const Text("Sign Up")),
            const SizedBox(height: 5,),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("Already have an account?"),
                GestureDetector(
                  onTap: (){
                    Navigator.pop(context);
                  },
                  child: const Text("Sign In",style: TextStyle(color: Colors.blueGrey),),
                )
              ],
            ),

          ],
        )
    );
  }
}