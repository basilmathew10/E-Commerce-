import 'dart:convert';
import 'dart:developer';

import 'package:ecommerceapp/homepage.dart';
import 'package:ecommerceapp/registration.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key, required this.title});
  final String title;

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
   final GlobalKey<FormState> _key = GlobalKey<FormState>();
  late bool _obscurePassword;
  late bool _autovalidate;
   TextEditingController usernameController= TextEditingController();
  TextEditingController userpasswordController= TextEditingController();
  late bool username_validate = false;
   late bool userpassword_validate = false;
  @override
  void initState() {
    super.initState();
    _obscurePassword = true;
    _autovalidate = false;
    usernameController = TextEditingController();
    userpasswordController = TextEditingController();
        _loadCounter();

  }
  void _loadCounter() async {
    final prefs = await SharedPreferences.getInstance();
    bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
    log("isloggedin = " + isLoggedIn.toString());
    if (isLoggedIn) {
      Navigator.push(context, MaterialPageRoute(builder: (_) => MyHomePage(title: '',)));
    }
  }
  login(String username, password) async{
    try{
      print(username);
      print(password);
      var result;
      final Map<String,dynamic> Data = {

        'username': username,
        'password': password,
      };
        final response = await http.post(Uri.parse('http://bootcamp.cyralearnings.com/login.php'),
        body: Data,
        );
        // print(response.statusCode);
        
       if (response.statusCode == 200) {
        if (response.body.contains("success")) {
          log("login successfully completed");
          final prefs = await SharedPreferences.getInstance();
          prefs.setBool("isLoggedIn", true);
          prefs.setString("username", username);
          Navigator.push(context, MaterialPageRoute(
            builder: (context) {
              return MyHomePage(title: '');
            },
          ));
          }
          else{
           ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Login Failed"))); 
          }
        }
        else{
          result = {log(json.decode(response.body)['error'].toString())};
          return result;
        }
    }
    catch (e) {
      log(e.toString());
    }
  }
  @override
  Widget build(BuildContext context) {

 child: SafeArea(minimum: EdgeInsets.all(16),
     child: Text(''),
 );

    return Scaffold(
     body: Center(
     
      child:_buildLoginForm(),
     ),
     );
       
  }  
     Widget _buildLoginForm() {
          

    return Form(
      key: _key,
    
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Text(
                  'WELCOME BACK',
                  textAlign: TextAlign.center,
                  style:
                      GoogleFonts.openSans(color: Colors.black, fontSize: 35,fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 20),
                Text(
                  'Login with your username and password',
                  textAlign: TextAlign.center,
                  style:
                      GoogleFonts.openSans(color: Colors.grey, fontSize: 18,fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 50,
                ),

            TextFormField(
              decoration: InputDecoration(
                labelText: 'Username',
                filled: true,
                isDense: true,
              ),
              controller: usernameController,
              keyboardType: TextInputType.emailAddress,
              autocorrect: false,
               validator: (val) => _validateRequired(val!, 'Username'),

            ),
            SizedBox(
              height: 12,
            ),
            TextFormField(
              decoration: InputDecoration(
                labelText: 'Password',
                filled: true,
                isDense: true,
              ),
              obscureText: _obscurePassword,
              controller: userpasswordController,
              validator: (val) => _validateRequired(val!, 'Password'),
            ),
            const SizedBox(
              height: 16,
            ),
             
            TextButton(
            
                onPressed:()async{
                  final bool isvalid= _key.currentState!.validate();
                  if(isvalid){
                    print('form is valid');
                    _key.currentState!.save();
                    String username=usernameController.text;
                    String userpassword=userpasswordController.text;

                    print("username="+username);
                    print("userpassword="+ userpassword);

                    //  SharedPreferences pref =await SharedPreferences.getInstance();
                    // pref.setString("username",username);
                    // String sessionUsername=pref.getString("username").toString();
                    // print(sessionUsername);

                    // if(usernameController.text.isNotEmpty&&userpasswordController.text.isNotEmpty){

login(username, userpassword);
                      //  Navigator.push(
                      //   context,
                      //   MaterialPageRoute(
                      //       builder: (context) =>
                      //         MyHomePage(title:'HomePage',)));
                  // }
                  };
                }, 
                child: const Text('Login'),
    style: TextButton.styleFrom(
      primary: Colors.white,
      backgroundColor: Color.fromARGB(255, 1, 4, 36),
      textStyle: const TextStyle(fontSize: 20,fontWeight: FontWeight.bold),
    ),

                ),

               Row(
              children: <Widget>[
                const Text('Dont have an account?'),
                TextButton(
                  child: Text(
                    'Go to Register',
                    style: TextStyle(fontSize: 20,color: Color.fromARGB(255, 1, 4, 36)),
                    
                  ),
                  onPressed: () {

                     Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                              RegistrationPage()));
                              
                  },
                )
              ],
              mainAxisAlignment: MainAxisAlignment.center,
            ),
          ],
        ),
      ),
    );
     }

         
  String? _validateRequired(String val, fieldName) {
    if (val == null ||  val == '') {
      return '$fieldName is required';
    }
    
    return null;
  }

  String? _validateEmail(String value) {
    if (value == null || value == '') {
      return 'Email is required';
    }
  

    var regex;
    if (!regex.hasMatch(value)) {
      return 'Enter valid email address';
    }
    return null;
  }

  void _validateFormAndLogin() {
    // Get form state from the global key
    var formState = _key.currentState;

    // check if form is valid
    if (formState!.validate()) {
      print('Form is valid');
    } else {
      // show validation errors
      // setState forces our [State] to rebuild
      setState(() {
        _autovalidate = true;
      });
    }
  }
}
