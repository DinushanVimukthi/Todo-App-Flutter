// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';


import 'Data/loginData.dart';



// ignore: must_be_immutable
class LoginApp extends StatefulWidget {
  LoginApp({Key? key}) : super(key: key);
  late bool isLoading = false;

  void setLoading(bool value){
    isLoading = value;
  }

  @override
  State<LoginApp> createState() => _LoginAppState();
}

class _LoginAppState extends State<LoginApp> {
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    setState(() {
      Future.delayed(const Duration(seconds: 1),(){
        setState(() {
          isLoading = false;
        });
      });
    });
  }

  void setLoading(bool value){
    setState(() {
      isLoading = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    LoginData loginData = LoginData.createEmptyLoginData();
    return Scaffold(
      body: Center(
          child:Stack(
            children: [
              Padding(
                padding: const EdgeInsets.all(30),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Title(
                        color: Colors.black,
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.lock, size: 50,),
                            SizedBox(width: 10,),
                            Text('Sign In', style: TextStyle(fontSize: 50, fontWeight: FontWeight.bold),)
                          ],
                        )
                    ),
                    const SizedBox(height: 20,),
                    Image(image: Image.asset('images/login.png').image, height: 200,),
                    const SizedBox(height: 20,),
                    TextField(
                      keyboardType: TextInputType.emailAddress,
                      onChanged: (value){
                        loginData.email = value;
                      },
                      controller: TextEditingController(text: loginData.email),
                      textAlign: TextAlign.center,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Email',
                        alignLabelWithHint: true,
                        prefixIcon: Icon(Icons.email),
                        floatingLabelAlignment: FloatingLabelAlignment.center,
                        labelStyle: TextStyle(
                          fontSize: 20,
                        ),
                      ),

                    ),
                    const SizedBox(height: 20,),
                    TextField(
                      onChanged: (value){
                        loginData.password = value;
                      },
                      controller: TextEditingController(text: loginData.password),
                      obscureText: true,
                      textAlign: TextAlign.center,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Password',
                        counter: Text('Forgot Password?'),
                        alignLabelWithHint: true,
                        prefixIcon: Icon(Icons.password),
                        floatingLabelAlignment: FloatingLabelAlignment.center,
                        labelStyle: TextStyle(
                          fontSize: 20,
                        ),

                      ),
                    ),
                    const SizedBox(height: 20,),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton(
                            onPressed: () async {
                              isLoading = true;
                              setLoading(true);
                              // show CircularProgressIndicator

                              // hide CircularProgressIndicator
                              if (await loginData.loginUser(context)){
                                const snackBar = SnackBar(
                                  backgroundColor: Colors.green,
                                    content: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Icon(Icons.account_circle,
                                        color: Colors.white,
                                        ),
                                        SizedBox(width: 20,),
                                        Text('Login Successful',
                                          style: TextStyle
                                            (
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        )
                                      ],
                                    )
                                );
                                ScaffoldMessenger.of(context).showSnackBar(snackBar);
                                Navigator.pushNamed(context, '/home');
                              }
                              else{
                                ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      backgroundColor: Colors.red,
                                      content: Text('Invalid Credentials'),
                                    )
                                );
                              }
                              setLoading(false);
                            },
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(horizontal: 100, vertical: 20),
                              backgroundColor: Colors.blue,
                            ),
                            child: const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.login_sharp),
                                SizedBox(width: 20,),
                                Text('Login',
                                  style: TextStyle
                                    (
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                )
                              ],
                            )

                        ),
                        const SizedBox(height: 20,),
                        ElevatedButton(
                            onPressed: (){
                              Navigator.pushNamed(context, '/register');
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green,
                              padding: const EdgeInsets.symmetric(horizontal: 100, vertical: 20),
                            ),
                            child: const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.app_registration_outlined),
                                SizedBox(width: 20,),
                                Text('Register',
                                  style: TextStyle
                                    (
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                )
                              ],
                            )

                        ),
                      ],
                    )
                  ],
                ),

              ),
              if(isLoading)
                Container(
                  color: Colors.black.withOpacity(0.5),
                  child: const Center(
                    child: CircularProgressIndicator(
                      color: Colors.white,
                    ),
                  ),
                )
            ],
          )
      ),
    );
  }
}