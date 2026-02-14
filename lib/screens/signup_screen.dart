import 'package:chat_app/constants.dart';
import 'package:chat_app/cubits/signup_cubit/signup_cubit.dart';
import 'package:chat_app/helper/show_snack_bar.dart';
import 'package:chat_app/screens/chat_screen.dart';
import 'package:chat_app/screens/login_screen.dart';
import 'package:chat_app/widgets/custom_button.dart';
import 'package:chat_app/widgets/custom_textformfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class SignupScreen extends StatelessWidget {
  SignupScreen({super.key});
  static String id = 'SignupPage';

  String? password, email;
  bool isLoading = false;

  // عملت GlobalKey شغال مع FormState واسمه formKey واستدعيت ال constructor GlobalKey()
  GlobalKey<FormState> formKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    // بعد معملنا validate هنحط ال Loading indicator بتاعنا اللي اسمه ModalProgressHUD فوق الاسكرين كلها يعني فوق ال Scaffold
    return BlocConsumer<SignupCubit, SignupState>(
      listener: (context, state) {
        if (state is SignupLoadingState) {
          isLoading = true;
        } else if (state is SignupSuccessState) {
          isLoading = false;
          Navigator.pushNamed(context, ChatScreen.id, arguments: email);
        } else if (state is SignupFailureState) {
          isLoading = false;
          showSnackBar(context, message: state.errMessage);
        }
      },
      builder: (context, state) {
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
                          // Triggering the cubit here:
                          BlocProvider.of<SignupCubit>(
                            context,
                          ).registerUser(email: email!, password: password!);
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
      },
    );
  }
}
