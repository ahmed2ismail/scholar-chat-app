import 'package:chat_app/constants.dart';
import 'package:chat_app/helper/show_snack_bar.dart';
import 'package:chat_app/screens/chat_screen.dart';
import 'package:chat_app/screens/login_screen.dart';
import 'package:chat_app/widgets/custom_button.dart';
import 'package:chat_app/widgets/custom_textformfield.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});
  static String id = 'SignupPage';

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  String? password;
  String? email;
  bool isLoading = false;

  // عملت GlobalKey شغال مع FormState واسمه formKey واستدعيت ال constructor GlobalKey()
  GlobalKey<FormState> formKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    // بعد معملنا validate هنحط ال Loading indicator بتاعنا اللي اسمه ModalProgressHUD فوق الاسكرين كلها يعني فوق ال Scaffold
    return ModalProgressHUD(
      // inAsyncCall بتاخد قيمة bool وبمعني هل ال indicator هيظهر ولا لا
      inAsyncCall: isLoading,
      child: Scaffold(
        backgroundColor: kPrimaryColor,
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          // احنا عملنا ال Form Widget كأب لل ListView لاننا هنعمل validate لل email , password اللي هما جواها لان ال Form لازم تكون اب لل TextFormField اللي هعمله validate
          child: Form(
            // ال key هو مفتاح للويدجت اللي اسمها Form وبيديني access لكل حاجة جواها يعني اقدر accessالحالة بتاعت ال Form عشان اعرف البيانات دي سليمة ولا لا
            key: formKey,
            child: ListView(
              padding: const EdgeInsets.only(top: 75),
              children: [
                Image.asset('assets/images/scholar.png', height: 100),
                const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Scholar Chat',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 35,
                        fontFamily: "Pacifico",
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 60),
                const Row(
                  children: [
                    Text(
                      'Sign Up',
                      style: TextStyle(color: Colors.white, fontSize: 24),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                CustomTextFormField(
                  onChanged: (data) {
                    email = data;
                  },
                  hintText: 'Email',
                ),
                const SizedBox(height: 10),
                CustomTextFormField(
                  onChanged: (data) {
                    password = data;
                  },
                  hintText: 'Password',
                ),
                CustomButton(
                  textButton: "Sign Up",
                  onTap: () async {
                    // من خلال ال formKey هاتلي ال currentState الحالة الحالية للمدخلات واعملي ليها validate يعني شوف هل هي بتطابق المواصفات اللي انا حددتها في خاصية ال validator: الموجودة جوه ال TextFormField ولا لا
                    if (formKey.currentState!.validate()) {
                      // اول مبدا واعمل ال request هغير قيمة isLoading لترو عشان اظهر ال indicator
                      isLoading = true;
                      // هنعمل update for ui by setState عشان غيرنا في حالة الانديكاتور
                      setState(() {});
                      try {
                        await registerUser();
                        // if email & password entered and the process succeeded move to chat_screen
                        Navigator.pushNamed(context, ChatScreen.id,arguments: email);
                      } on FirebaseAuthException catch (e) {
                        if (e.code == 'weak-password') {
                          // ScaffoldMessenger,SnackBar ==> it used to show a beautiful message for user from button
                          showSnackBar(
                            context,
                            message: 'The password provided is too weak.',
                          );
                        } else if (e.code == 'email-already-in-use') {
                          showSnackBar(
                            context,
                            message:
                                'The account already exists for that email.',
                          );
                        }
                      } catch (e) {
                        showSnackBar(context, message: e.toString());
                      }
                      // بعد لما ال request خلص وال try & catch خلصوا هوقف ال indicator
                      isLoading = false;
                      // هنعمل update for ui by setState عشان غيرنا في حالة الانديكاتور
                      setState(() {});
                    }
                  },
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'already have an account ?',
                      style: TextStyle(color: Colors.white),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context, LoginScreen.id);
                      },
                      child: const Text(
                        'Login',
                        style: TextStyle(color: Color(0xffC7EDE6)),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> registerUser() async {
    await FirebaseAuth.instance.createUserWithEmailAndPassword(email: email!, password: password!);
  }
}
