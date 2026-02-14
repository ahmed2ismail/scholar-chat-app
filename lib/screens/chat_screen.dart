import 'package:chat_app/constants.dart';
import 'package:chat_app/cubits/chat_cubit/chat_cubit.dart';
import 'package:chat_app/widgets/chat_bubble.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ChatScreen extends StatelessWidget {
  ChatScreen({super.key});

  static String id = 'ChatPage';

  final TextEditingController controller = TextEditingController();
  final ScrollController _scrollControler = ScrollController();

  @override
  Widget build(BuildContext context) {
    // عشان نجيب ال email اللي بعتناه من ال SignupScreen or LoginScreen هنستخدم ModalRoute.of(context)!.settings.arguments
    String? email = ModalRoute.of(context)!.settings.arguments as String?;
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading:
            false, // Hides the back button(of Navigator.pushNamed) from appbar
        centerTitle: true,
        backgroundColor: kPrimaryColor,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(kLogo, height: 50),
            const Text('Scholar Chat', style: TextStyle(color: Colors.white)),
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            // حطينا ال ListView جوه Expanded عشان تاخد المساحة المتاحة من ال Column وميحصلش error بسس ان ال Column بياخد مساحة ال screen فبالتالي ال ListView تعمل scroll عادي جوه ال Column
            child: BlocConsumer<ChatCubit, ChatState>(
              listener: (context, state) {
                if (state is ChatSuccessState) {
                  // لما ييجي state جديد من نوع ChatSuccessState يعني ان فيه رسالة جديدة اتضافت فبالتالي نعمل scroll لل ListView عشان نشوف الرسالة الجديدة دي
                  _scrollControler.animateTo(
                    0.0, // عشان احنا عاملين reverse: true في ال ListView.builder فبالتالي اخر رسالة هتكون في ال top
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeIn,
                  );
                }
              },
              builder: (context, state) {
                var messagesList = BlocProvider.of<ChatCubit>(context).messagesList;
                return ListView.builder(
                  // عشان نعرض اخر رسالة في الاخر
                  reverse: true,
                  // ال ListView بتجبر ال width بتاع ال Container انها تاخد ال width بتاع ال screen المتاح ليها والحل هو استخدام ويدجت Align علي ال Container
                  // controller دي بتاخد ال ScrollController اللي احنا انشأناه عشان نتحكم في ال ListView دي زي ما هنشوف بعدين في ال onSubmitted بتاع ال TextField عشان نحرك ال ListView لتحت عشان نشوف الرسالة الجديدة اللي اتضافت
                  controller: _scrollControler,
                  itemCount: messagesList.length,
                  itemBuilder: (context, index) {
                    return messagesList[index].id == email
                        ? ChatBubble(message: messagesList[index])
                        : ChatBubbleForFriend(message: messagesList[index]);
                  },
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              // هننشاء TextEditingController عشان نتحكم في ال TextField
              controller: controller,
              // هنستخدم ال onSubmitted بدل ال onChanged عشان لما المستخدم يضغط علي زرار ال send في الكيبورد بس الرسالة تتبعت مش مع كل حرف بيتكتب بمعني ان الرسالة هتتبعت لما تتكتب كاملة وليس كل حرف هيتبعت لوحده
              onSubmitted: (data) {
                // هناخد ال data اللي هي الرسالة اللي المستخدم كتبها ونضيفها ك document جديد جوه ال messages collection في ال Firestore
                BlocProvider.of<ChatCubit>(
                  context,
                ).sendMessage(message: data, email: email!);
                // بعد ما نضيف الرسالة نفضي ال TextField عشان المستخدم يقدر يكتب رسالة جديدة
                controller.clear();
              },
              decoration: InputDecoration(
                hintText: 'Send Message',
                hintStyle: const TextStyle(color: Colors.grey),
                suffixIcon: const Icon(Icons.send),
                suffixIconColor: kPrimaryColor,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: const BorderSide(color: kPrimaryColor),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
