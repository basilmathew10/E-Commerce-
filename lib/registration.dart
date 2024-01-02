import 'dart:convert';
import 'dart:developer';

import 'package:ecommerceapp/login.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;



class RegistrationPage extends StatefulWidget {
  const RegistrationPage({super.key});

  @override
  State<RegistrationPage> createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
   final GlobalKey<FormState> _key = GlobalKey<FormState>();
   late bool _obscurePassword;
  late bool _autovalidate;
   TextEditingController nameController= TextEditingController();
   TextEditingController phoneController= TextEditingController();
      TextEditingController addressController= TextEditingController();
   TextEditingController usernameController= TextEditingController();
      TextEditingController passwordController= TextEditingController();

   bool name_validate=false;
   bool phone_validate=false;
   bool address_validate=false;
   bool username_validate=false;
      bool password_validate=false;

   @override
 void dispose() {
  super.initState();
    _obscurePassword = true;
    _autovalidate = false;
    nameController.dispose();
    phoneController.dispose();
    addressController.dispose();
    usernameController.dispose();
    passwordController.dispose();

    super.dispose();
  }
  registration(String name, phone, address, username, password) async{
    try{
      print(username);
      print(password);
      var result;
      final Map<String,dynamic> Data = {
        'name': name,
        'phone': phone,
        'address': address,
        'username': username,
        'password': password,
      };
        final response = await http.post(Uri.parse('https://bootcamp.cyralearnings.com/registration.php'),
        body: Data
        );
        print(response.statusCode);
        
        if(response.statusCode==200){
          if(response.body.contains("success")){
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Registration Success")));
            Navigator.push(context, MaterialPageRoute(builder: (context){
              return LoginPage(title: '',);
            },
            ));
          }
          else{
           ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Registration Failed"))); 
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
     
      child:_buildRegForm(),
     ),
     );
  }
      Widget _buildRegForm() {
      
    return Form(
      key: _key,
    
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
             Text(
                  'REGISTER ACCOUNT ',
                  textAlign: TextAlign.center,
                  style:
                      GoogleFonts.openSans(color: Colors.black, fontSize: 35,fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 20),
                Text(
                  'Complete your Details',
                  textAlign: TextAlign.center,
                  style:
                      GoogleFonts.openSans(color: Colors.grey, fontSize: 18,fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 50,
                ),
              TextFormField(
              decoration: InputDecoration(
                labelText: 'Name',
                filled: true,
                isDense: true,
              ),
              controller: nameController,
              keyboardType: TextInputType.emailAddress,
              autocorrect: false,
               validator: (val) => _validateRequired(val!, 'Name'),
            ),
            SizedBox(
              height: 12,
            ),
          
                            TextFormField(
              decoration: InputDecoration(
                labelText: 'Phone No',
                filled: true,
                isDense: true,
              ),
              controller: phoneController,
              keyboardType: TextInputType.emailAddress,
              autocorrect: false,
               validator: (val) => _validateRequired(val!, 'Phone No'),
            ),
            SizedBox(
              height: 12,
            ),

                  TextFormField(
              decoration: InputDecoration(
                labelText: 'Address',
                filled: true,
                isDense: true,
              ),
              controller: addressController,
              keyboardType: TextInputType.emailAddress,
              autocorrect: false,
               validator: (val) => _validateRequired(val!, 'Address'),
            ),
            SizedBox(
              height: 12,
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
              controller: passwordController,
              keyboardType: TextInputType.emailAddress,
              autocorrect: false,
               validator: (val) => _validateRequired(val!, 'Password'),
            ),
            SizedBox(
              height: 12,
            ),
              //     Padding(padding: const EdgeInsets.all(10),
              //     child: CupertinoRadioChoice(
              // choices: genderMap,
              // onChange: onGenderSelected,
              // initialKeyValue: _selectedGender)
              //     ),    
                  
            
            TextButton(
                onPressed: () async{
                  
                    setState(() {
                      nameController.text.isEmpty ? name_validate = true : name_validate = false;
                      phoneController.text.isEmpty ? phone_validate = true : phone_validate = false;
                      addressController.text.isEmpty ? address_validate = true : address_validate = false;
                      usernameController.text.isEmpty ? username_validate = true : username_validate = false;
                      passwordController.text.isEmpty ? password_validate = true : password_validate = false;

                    });
                     final bool isvalid= _key.currentState!.validate();
                  if(isvalid){
                    print('form is valid');
                    _key.currentState!.save();
                   String name=nameController.text; 
                   String phone=phoneController.text; 
                   String address=addressController.text; 
                   String username=usernameController.text; 
                   String password=passwordController.text;   

                    print("name ="+name);
                    print("phone ="+phone);
                   print("address ="+address);
                   print("username ="+username);
                   print("password ="+password);
registration(name, phone, address, username, password);
                     }
                },
          

                //  Navigator.push(
                //         context,
                //         MaterialPageRoute (builder: (context) =>
                //                 LoginPage(title: 'Login Page',)));
                //           },
                child: const Text('Register'),
    style: TextButton.styleFrom(
      primary: Colors.white,
      backgroundColor: Color.fromARGB(255, 1, 4, 36),
      textStyle: const TextStyle(fontSize: 20,fontWeight: FontWeight.bold),
    ),
              ),
              Row(
              children: <Widget>[
                const Text('Dont you have an Account?'),
                TextButton(
                  child: Text(
                    'Login',
                  style: TextStyle(fontSize: 20,color: Color.fromARGB(255, 1, 4, 36)),
                  ),
                  onPressed: () {

                     Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                              LoginPage(title: 'Login')));
                              
                  },
                )
              ],
              mainAxisAlignment: MainAxisAlignment.center,
            ),

          ],
        ),
      ),
      // This trailing comma makes auto-formatting nicer for build methods.
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
      return 'Enter valid username';
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