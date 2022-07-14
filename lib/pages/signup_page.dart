import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:travend/pages/login_page.dart';
import 'package:travend/pages/tab_management.dart';
import 'package:travend/models/user.dart' as model;

class SignupPage extends StatefulWidget {
  const SignupPage({Key? key}) : super(key: key);

  @override
  _SignupPageState createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final _formKey = GlobalKey<FormState>();
  bool acceptTerms = false;
  var username = TextEditingController();
  var email = TextEditingController();
  var password = TextEditingController();
  var reTypePassword = TextEditingController();
  var about = TextEditingController();

  String genderValue = 'Male';
  String date = '';
  DateTime selectedAge = DateTime(2000, 1, 1);
  late int age = 0;
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    username.dispose();
    email.dispose();
    password.dispose();
    reTypePassword.dispose();
    about.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {


    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        brightness: Brightness.light,
        backgroundColor: Colors.white,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.arrow_back_ios,
            size: 20,
            color: Colors.black,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 40),
          height: MediaQuery.of(context).size.height + 200,
          width: double.infinity,
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Column(children: <Widget>[
                  const Text(
                    "Sign up",
                    style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold, color: Colors.orange),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Text(
                    "Create an account, It's free",
                    style: TextStyle(fontSize: 15, color: Colors.grey[700]),
                  ),
                ]),
                Column(
                  children: <Widget>[
                    getInput(
                        label: "*User Name", obscureText: false, stateText: username),
                    getInput(label: "*Email", stateText: email),
                    getInput(
                        label: "*Password",
                        obscureText: true,
                        stateText: password),
                    getInput(
                        label: "*Re-type Password",
                        obscureText: true,
                        stateText: reTypePassword),
                    getInput(
                        label: "*About yourself",
                        obscureText: false,
                        stateText: about),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        const Text(
                          "*Birthdate",
                          style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w400,
                              color: Colors.black87),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        GestureDetector(
                          onTap: () {
                            _selectAge(context);
                          },
                          child: Container(
                              width: double.infinity,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                    color: Colors.grey,
                                    style: BorderStyle.solid),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Text(selectedAge.day.toString() +
                                    "/" +
                                    selectedAge.month.toString() +
                                    "/" +
                                    selectedAge.year.toString()),
                              )),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        const Text(
                          "*Gender",
                          style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w400,
                              color: Colors.black87),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                                color: Colors.grey, style: BorderStyle.solid),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.only(left: 10, right: 10),
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton<String>(
                                value: genderValue,
                                icon: const Icon(Icons.arrow_downward),
                                elevation: 16,
                                style: const TextStyle(color: Colors.black),
                                underline: Container(
                                  height: 2,
                                  color: Colors.deepPurpleAccent,
                                ),
                                onChanged: (String? newValue) {
                                  setState(() {
                                    genderValue = newValue!;
                                  });
                                },
                                items: <String>[
                                  'Male',
                                  'Female'
                                ].map<DropdownMenuItem<String>>((String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(value),
                                  );
                                }).toList(),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                      ],
                    ),
                  ],
                ),
                Row(
                  children: [
                    Checkbox(
                      value: acceptTerms,
                      onChanged: (bool? value) {
                        setState(() {
                          acceptTerms = !acceptTerms;
                        });
                      },
                    ),
                    const Text("I agree to the ",
                        style: TextStyle(fontSize: 12)),
                    GestureDetector(
                      child: const Text("Terms of Use",
                          style: TextStyle(
                              decoration: TextDecoration.underline,
                              color: Colors.blue,
                              fontSize: 12)),
                      onTap: () async {
                        const url = 'https://www.google.com';
                        //if (await canLaunch(url)) launch(url);
                      },
                    ),
                    const Text(" and "),
                    GestureDetector(
                      child: const Text("Privacy",
                          style: TextStyle(
                              decoration: TextDecoration.underline,
                              color: Colors.blue,
                              fontSize: 12)),
                      onTap: () async {
                        const url = 'https://www.google.com';
                        //if (await canLaunch(url)) launch(url);
                      },
                    ),
                  ],
                ),
                MaterialButton(
                  minWidth: double.infinity,
                  height: 40,
                  onPressed: () {
                    setState(() {
                      if (_formKey.currentState!.validate() && acceptTerms == true) {
                        signUp(
                            username: username.text,
                            email: email.text,
                            about: about.text,
                            age: 2022 - selectedAge.year,
                            gender: genderValue
                        );
                      }
                      else if (acceptTerms == false) {
                        ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text("You must accept the Terms of Use")));
                      }
                    });
                  },
                  color: Colors.greenAccent,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                      side: const BorderSide(color: Colors.black),
                      borderRadius: BorderRadius.circular(50)),
                  child: const Text(
                    "Sign up",
                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    const Text("Already have an account?"),
                    GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const LoginPage()));
                        },
                        child: const Text(
                          " Login",
                          style: TextStyle(
                              fontWeight: FontWeight.w600, fontSize: 18),
                        )),
                  ],
                ),
                const Text(
                  "If you are a business owner who wants to be on",
                  style: TextStyle(fontSize: 13, color: Colors.grey),
                ),
                const Text(
                  "TRAVEND",
                  style: TextStyle(fontSize: 15, color: Colors.grey),
                ),
                GestureDetector(
                  child: const Text("Contact Us!",
                      style: TextStyle(
                          decoration: TextDecoration.underline,
                          color: Colors.blue)),
                  onTap: () async {
                    const url = 'https://www.google.com';
                    //if (await canLaunch(url)) launch(url);
                  },
                )
              ],
            ),
          ),
        ),
      ),
    );
  }


  _selectAge(BuildContext context) async {
    final DateTime? selected = await showDatePicker(
      context: context,
      initialDate: selectedAge,
      firstDate: DateTime(1930),
      lastDate: DateTime(2023),
    );
    if (selected != null && selected != selectedAge) {
      setState(() {
        selectedAge = selected;
      });
    }
  }

  Column getInput({label, obscureText = false, stateText}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          label,
          style: const TextStyle(
              fontSize: 15, fontWeight: FontWeight.w400, color: Colors.black87),
        ),
        const SizedBox(
          height: 5,
        ),
        TextFormField(
          controller: stateText,
          obscureText: obscureText,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return "You cannot leave this blank";
            }
            if (stateText == password) {
              if (value.length < 6) {
                return "Please enter at least 6 characters";
              }
            }
            if (stateText == reTypePassword) {
              if (value != password.text) {
                return "Passwords should match";
              }
            }
            return null;
          },
          decoration: InputDecoration(
            contentPadding:
                const EdgeInsets.symmetric(vertical: 0, horizontal: 10),
            enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
                borderSide: const BorderSide(color: Colors.grey)),
            border: const OutlineInputBorder(
                borderSide: BorderSide(color: Colors.grey)),
          ),
        ),
        const SizedBox(
          height: 10,
        ),
      ],
    );
  }

  Future signUp({
    required String username,
    required String email,
    required String about,
    required int age,
    required String gender,
  }) async {
    String res = "Some error occured";
    try {
      UserCredential credential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: this.email.text.trim(),
        password: this.password.text.trim(),
      );

      model.User user = model.User(
        username: username,
        uid: credential.user!.uid,
        email: email,
        about: about,
        age: age,
        gender: gender,
        photoUrl: '',
        followers: [],
        following: [],
      );

      await FirebaseFirestore.instance.collection('users').doc(credential.user!.uid)
      .set(user.toJson());

      Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => const TabManagement()
      ));
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        res = 'The password provided is too weak.';
      } else if (e.code == 'email-already-in-use') {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("The account already exists for that email.")));
      }
    } catch (e) {
      print(e);
    }
  }

  // Future<bool> usernameCheck(String username) async {
  //   final result = await FirebaseFirestore.instance.collection('users').
  //   where('username', isEqualTo: username).getDocuments();
  //   return result.documents.isEmpty;
  // }
}

