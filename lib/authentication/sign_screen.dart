import 'package:cabongo/authentication/car_info.dart';
import 'package:cabongo/authentication/login_screen.dart';
import 'package:cabongo/global/global.dart';
import 'package:cabongo/widgets/progress_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen>
{

  TextEditingController nameTextEditingController = TextEditingController();
  TextEditingController emailTextEditingController = TextEditingController();
  TextEditingController phoneTextEditingController = TextEditingController();
  TextEditingController passwordTextEditingController = TextEditingController();

  validateForm()
  {
    if(nameTextEditingController.text.length < 3)
  {
      Fluttertoast.showToast(msg: "Name must be atleast 3 characters.");
  }
    else if(!emailTextEditingController.text.contains("@"))
      {
        Fluttertoast.showToast(msg: "Email address is not valid.");
      }
    else if(phoneTextEditingController.text.isEmpty)
      {
        Fluttertoast.showToast(msg: "Phone Number is required.");
      }
    else if(passwordTextEditingController.text.length < 6)
    {
      Fluttertoast.showToast(msg: "Password must be atleast 6 Characters.");
    }
    else
      {
        saveDriverInfoNow();

      }
}


saveDriverInfoNow() async
{
  showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext c)
  {
    return ProgressDialog(message: "Processing, Please wait. . .",);
  }
  );

  final User? firebaseUser =(
    await fAuth.createUserWithEmailAndPassword(
      email: emailTextEditingController.text.trim(),              //trim used for removing extra space
      password: passwordTextEditingController.text.trim(),
    ).catchError((msg){
        Navigator.pop(context);
        Fluttertoast.showToast(msg: "Error: " + msg.toString() );
      })
  ).user;

  if(firebaseUser !=null)
    {
      Map driverMap =
      {
        "id": firebaseUser.uid,
        "name": nameTextEditingController.text.trim(),
        "email": emailTextEditingController.text.trim(),
        "phone": phoneTextEditingController.text.trim(),
      };

       DatabaseReference driverRef =  FirebaseDatabase.instance.ref().child("drivers");   //drivers is the parent node
        driverRef.child(firebaseUser.uid).set(driverMap);

        currentFirebaseUser= firebaseUser;
        Fluttertoast.showToast(msg: "Account has  been created. "  );
        Navigator.push(context, MaterialPageRoute(builder: (c)=> CarInfoScreen()));

    }
  else
  {
    Navigator.pop(context);
    Fluttertoast.showToast(msg: "Account has not been created. "  );
  }
}



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              const SizedBox(height: 10,),

              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Image.asset("images/Driver.png"),
              ),

              const SizedBox(height: 10,),
              const Text(
                "Register as a Driver",
                style: TextStyle(
                  fontSize: 24,
                  color: Colors.grey,
                  fontWeight: FontWeight.bold,
                )
              ),

              TextField(
                controller: nameTextEditingController,
                style: const TextStyle(
                  color: Colors.white,
                ),
                decoration: const InputDecoration(
                  labelText: "Name",
                  hintText: "Name",

                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey)
                  ),
                  focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey)
                  ),

                  hintStyle: TextStyle(
                    color: Colors.grey,
                    fontSize: 20,
                  ),
                  labelStyle: TextStyle(
                    color: Colors.grey,
                    fontSize: 20,
                  ),
                ),

              ),

              TextField(
                controller: emailTextEditingController,
                style: const TextStyle(
                  color: Colors.white,
                ),
                decoration: const InputDecoration(
                  labelText: "Email",
                  hintText: "Email",

                  enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey)
                  ),
                  focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey)
                  ),

                  hintStyle: TextStyle(
                    color: Colors.grey,
                    fontSize: 20,
                  ),
                  labelStyle: TextStyle(
                    color: Colors.grey,
                    fontSize: 20,
                  ),
                ),

              ),

              TextField(
                controller: phoneTextEditingController,
                keyboardType: TextInputType.phone,
                style: const TextStyle(
                  color: Colors.white,
                ),
                decoration: const InputDecoration(
                  labelText: "Phone Number",
                  hintText: "Phone Number ",

                  enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey)
                  ),
                  focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey)
                  ),

                  hintStyle: TextStyle(
                    color: Colors.grey,
                    fontSize: 20,
                  ),
                  labelStyle: TextStyle(
                    color: Colors.grey,
                    fontSize: 20,
                  ),
                ),

              ),

              TextField(
                controller: passwordTextEditingController,
                keyboardType: TextInputType.text,
                obscureText: true,
                style: const TextStyle(
                  color: Colors.white,
                ),
                decoration: const InputDecoration(
                  labelText: "Password",
                  hintText: "Password",

                  enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey)
                  ),
                  focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey)
                  ),

                  hintStyle: TextStyle(
                    color: Colors.grey,
                    fontSize: 20,
                  ),
                  labelStyle: TextStyle(
                    color: Colors.grey,
                    fontSize: 20,
                  ),
                ),

              ),

              const SizedBox(height: 20,),

              ElevatedButton(
                  onPressed: ()
                  {
                    validateForm();
                  },
                  style: ElevatedButton.styleFrom(
                    primary: Colors.green,
                  ),
                  child: const Text(
                'Create Account',
                 style: TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                  ),

              )),

              TextButton(
                child: const Text(
                  "Already have an Account? LOGIN HERE",
                  style: TextStyle(color: Colors.grey),
                ),
                onPressed: ()
                {
                  Navigator.push(context, MaterialPageRoute(builder: (c)=> LoginScreen()));

                },
              ),
            ],
          ),
        ),

      ),
    );
  }
}
