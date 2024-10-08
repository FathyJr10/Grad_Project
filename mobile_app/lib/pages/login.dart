// ignore_for_file: prefer_const_literals_to_create_immutables, unused_field, use_build_context_synchronously
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mobile_app/colors.dart';
import 'package:mobile_app/configure.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:provider/provider.dart';
import 'package:mobile_app/api/user.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _formKey = GlobalKey<FormState>();
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();

  void openSignUpScreen() {
    Navigator.of(context).pushReplacementNamed('signup');
  }

  Future<void> _loginButton() async {
    if (_formKey.currentState!.validate()) {
      final url = Uri.parse('${AppUrl.Base_Url}/patient/login');
      final response = await http.post(
        url,
        headers: {
    'Content-Type': 'application/json',},
      body:  json.encode( {
        'username': usernameController.text,
        'password': passwordController.text,
      },)
    );

    if (response.statusCode == 201) {
      final responseData = json.decode(response.body);
      final int id = responseData['id'];
      final String gender = responseData['gender'] ?? '';
      final String phoneNumber = responseData['phone'] ?? '';
      final String username = responseData['username'] ?? '';
      final String fullname = responseData['name'] ?? '';      
      final String email = responseData['email'] ?? '';
      final String bloodType = responseData['blood_type'] ?? '';
      final String emergencyNumber = responseData['emergency_contact'] ?? '';
      final String address = responseData['address'] ?? '';
      final String identityNumber = responseData['national_id_number'] ?? '';
      final String dob = responseData['birth_date'] ?? '';
      final String maritalStatus = responseData['marital_status'] ?? '';
      final String chronicDisease = responseData['chronic'] ?? '';
      final String allergies = responseData['allergies'] ?? '';
      //final List chronicDisease = responseData['medicalConditions'] ?? '';



      final userIdProvider = Provider.of<UserIdProvider>(context, listen: false);
      userIdProvider.setId(id);
      userIdProvider.setNames(username,fullname);
      userIdProvider.setData(dob,email, address, gender, bloodType, emergencyNumber, identityNumber,phoneNumber,maritalStatus,chronicDisease,allergies);

      Navigator.of(context).pushReplacementNamed(
        'home', 
      );

      // Navigator.pushReplacementNamed(context, 'home',
      //     arguments: {'username': usernameController.text});
      print(maritalStatus);
      print(id);
      print(username);
      print(phoneNumber);
      print(gender);
      print(fullname);

    } else {    
    final responseBody = response.body;
    if (responseBody.isNotEmpty) {
      try {
        final responseData = json.decode(responseBody);
        final errorMessage = responseData['error'] ?? 'User not found';
        showDialog(
          context: context,
          builder: (_) => AlertDialog(
            title: Text('Error'),
            content: Text(errorMessage),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('OK'),
              ),
            ],
          ),
        );

          } catch (e) {
            print('Error parsing response: $e');
          }
        } else {
          print('Empty response body');
        }
      }
    }
  }


  @override
  void dispose() {
    usernameController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
           onWillPop: () async {
        return false; // Returning false prevents the user from going back
      },
      child: Scaffold(
        backgroundColor: Colors.grey[200],
        body: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // image
                    Image.asset(
                      'assets/loggo.png',
                      height: 100,
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    // title
                    Text(
                      'SIGN IN',
                      style: GoogleFonts.robotoCondensed(
                          fontSize: 40, fontWeight: FontWeight.bold),
                    ),
    
                    // subtitle
                    Text(
                      'Welcome back! Nice to see you again',
                      style: GoogleFonts.robotoCondensed(
                        fontSize: 18,
                      ),
                    ),
                    SizedBox(
                      height: 50,
                    ),
    
                    // userName Text field
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 25),
                      child: Container(
                        decoration: BoxDecoration(
                            border: Border.all(color: primary),
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12)),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: TextFormField(
                            controller: usernameController,
                            decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: 'Username',
                                icon: Icon(Icons.person_pin_rounded)),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please write your username ';
                              } else if (value.length < 4) {
                                return "Too short write your username";
                              }
                              return null;
                            },
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
    
                    // password text field
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 25),
                      child: Container(
                        decoration: BoxDecoration(
                            border: Border.all(color: primary),
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12)),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: TextFormField(
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter a password ';
                              }
                              return null;
                            },
                            controller: passwordController,
                            obscureText: true,
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: 'Password',
                              icon: Icon(Icons.lock),
                            ),
                          ),
                        ),
                      ),
                    ),
    
                    SizedBox(
                      height: 15,
                    ),
    
                    // sign in button
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 25),
                      child: GestureDetector(
                        onTap:_loginButton,
                        child: Container(
                          padding: EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Color(0XFF66CA98),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Center(
                              child: Text(
                            'Sign in',
                            style: GoogleFonts.robotoCondensed(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 18),
                          )),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 25,
                    ),
    
                    // sign up text
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('Not yet a member? ',
                            style: GoogleFonts.robotoCondensed(
                                fontWeight: FontWeight.bold)),
                        GestureDetector(
                          onTap: openSignUpScreen,
                          child: Text(
                            ' Sign up now',
                            style: GoogleFonts.robotoCondensed(
                                color: Color(0XFF66CA98),
                                fontWeight: FontWeight.bold),
                          ),
                        )
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  
  }

}