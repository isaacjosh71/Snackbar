
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:snack_bar/helpers/custom_loader.dart';
import 'package:snack_bar/helpers/router.dart';
import 'package:snack_bar/validations/logIn.dart';

import '../data/controllers/auth_ctlr.dart';
import '../models/auth_models/signup_body.dart';
import '../screens/Home/root_app.dart';

class SignIn extends StatefulWidget {
  const SignIn({Key? key}) : super(key: key);

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _mailController = TextEditingController();
  final TextEditingController _passController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();

  bool _obscureText = true;
  bool buttonIsActive = false;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    var _onPressed;
    if(buttonIsActive){
      _onPressed=() async{
        try {
          var authController = Get.find<AuthController>();
          String name = _nameController.text.trim();
          String phone = _phoneController.text.trim();
          String mail = _mailController.text.trim();
          String password = _passController.text.trim();

          if(name.isEmpty){Get.snackbar('Name', 'Please type in your name');}
          else if(phone.isEmpty || !GetUtils.isPhoneNumber(phone)) {
            Get.snackbar('Phone', 'Please type in a valid phone number');}
          else if(mail.isEmpty || !GetUtils.isEmail(mail)){
            Get.snackbar('Email', 'Please type in a valid email');}
          else if(password.length < 6){
            Get.snackbar('Password', 'Password can\'t be less than 6 characters');}
          else{
            SignUpBody signUpBody = SignUpBody(name: name, phone: phone, mail: mail, password: password);
            print(signUpBody);
            authController.signUpUser(signUpBody).then((status){
              if(status.isSuccess){
                print('successful registration');
                Get.offNamed(RouteHelper.getInitial());
              } else{Get.snackbar('Error', 'Wrong Authentication');}
            });
          }
        }
        catch(e){
          final snackBar = SnackBar(content: Text(e.toString()));
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
        }
      };
    }
    return Scaffold(
      body:
      GetBuilder<AuthController>(builder: (authController){
        return !authController.isLoading?
        SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: size.height * 0.08,),
              Image.asset('assets/images/25.png', height: size.height*0.125,
                color: Colors.brown.shade700,),
              SizedBox(
                height: size.height * 0.035,
              ),
              Padding(
                padding:  EdgeInsets.symmetric(horizontal: size.width*0.1),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('Full Name',
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w400,
                            color: Color(0xFF767676)
                        ),),
                      TextFieldContainer(
                        child: TextFormField(
                          controller: _nameController,
                          textInputAction: TextInputAction.next,
                          keyboardType: TextInputType.name,
                          onSaved: (value){},
                          decoration: const InputDecoration(
                            hintText: 'Input name',
                            hintStyle: TextStyle(
                              color: Colors.grey,
                              fontSize: 15,
                            ),
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      const Text('Email',
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w400,
                            color: Color(0xFF767676)
                        ),),
                      TextFieldContainer(
                        child: TextFormField(
                          textInputAction: TextInputAction.next,
                          keyboardType: TextInputType.emailAddress,
                          controller: _mailController,
                          onSaved: (value){},
                          decoration: const InputDecoration(
                            hintText: 'Input email',
                            hintStyle: TextStyle(
                              color: Colors.grey,
                              fontSize: 15,
                            ),
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      const Text('Phone number',
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w400,
                            color: Color(0xFF767676)
                        ),),
                      TextFieldContainer(
                        child: TextFormField(
                          textInputAction: TextInputAction.next,
                          keyboardType: TextInputType.phone,
                          controller: _phoneController,
                          onSaved: (value){},
                          decoration: const InputDecoration(
                            hintText: 'Input phone number',
                            hintStyle: TextStyle(
                              color: Colors.grey,
                              fontSize: 15,
                            ),
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      const Text('Password',
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w400,
                            color: Color(0xFF767676)
                        ),),
                      TextFieldContainer(
                        child: TextFormField(
                          textInputAction: TextInputAction.next,
                          controller: _passController,
                          obscureText: _obscureText,
                          onChanged: (value){
                            setState((){
                              buttonIsActive = value.isNotEmpty?true:false;
                            });
                          },
                          key: const ValueKey('password'),
                          decoration: InputDecoration(
                            hintText: 'Input password',
                            hintStyle: const TextStyle(
                              color: Colors.grey,
                              fontSize: 15,
                            ),
                            border: InputBorder.none,
                            suffixIcon:GestureDetector(
                              onTap: (){
                                setState(() {
                                  _obscureText =!_obscureText;
                                });
                              },
                              child: Icon(_obscureText ? Icons.visibility_off
                                  : Icons.visibility,
                                  size: 20,color: const Color(0xFFB4B4B4)),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      ElevatedButton(
                          style: ButtonStyle(
                            elevation: MaterialStateProperty.all<double>(
                              1.5,),
                            shadowColor: MaterialStateProperty.all<Color>(
                                Colors.grey),
                            backgroundColor: MaterialStateProperty.all(
                                buttonIsActive ? Colors.orangeAccent : null
                            ),
                          ),
                          child: const Text('Create Account',
                            style: TextStyle(color: Colors.white,
                                fontSize: 20),),
                          onPressed: _onPressed),
                      const SizedBox(
                        height: 20,
                      ),
                      Wrap(
                        children: [
                          const Text('If you already have an account',
                            textAlign: TextAlign.justify,
                            style: TextStyle(
                                color: Color(0xFF767676),
                                fontSize: 15,
                                fontWeight: FontWeight.w300
                            ),),
                          GestureDetector(
                            onTap: (){
                              Get.toNamed(RouteHelper.getLogInPage());
                            },
                            child: const Text('  log in',
                              textAlign: TextAlign.justify,
                              style: TextStyle(
                                  color: Colors.orangeAccent,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w300
                              ),),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        )
            : const CustomLoader();
      })
    );
  }
}

class TextFieldContainer extends StatelessWidget {
  final Widget child;

  const TextFieldContainer({
    Key? key,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      width: 250,
      decoration: BoxDecoration(
        border: Border.all(
          width: 2,
          color: Colors.orangeAccent,
        ),
        borderRadius: BorderRadius.circular(30),
      ),
      margin: const EdgeInsets.symmetric(vertical: 10),
      padding: const EdgeInsets.symmetric(
        horizontal: 15, vertical: 2,
      ),
      child: child,
    );
  }
}
