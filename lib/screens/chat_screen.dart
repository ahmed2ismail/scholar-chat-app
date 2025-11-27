import 'package:chat_app/constants.dart';
import 'package:chat_app/model/message.dart';
import 'package:chat_app/widgets/chat_bubble.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ChatScreen extends StatelessWidget {
  ChatScreen({super.key});

  static String id = 'ChatPage';
  // هنجيب ال Collection بتاعت ال messages من ال Firestore
  // السطر دا بيشاور علي ال Collection اللي اسمها messages الموجودة في ال Firestore عندي عشان اقرا او اضيف رسايل( او بيانات  او محتوي الرسالة documents) جواها
  final CollectionReference messages = FirebaseFirestore.instance.collection(
    // لو ملقاش ال Collection دي هينشئها اوتوماتيك لما اضيف اول document جواها فبالتالي نخلي اسم ال Collection في متغير ثابت في ملف ال constants عشان منتلخبطش واحنا بنكتبه فينشا كوليكشن جديدة وعشان لو احتجنا نغيره في المستقبل نغيره من مكان واحد بس
    kMessagesCollection,
  );

  final TextEditingController controller = TextEditingController();
  final ScrollController _scrollControler = ScrollController();

  @override
  Widget build(BuildContext context) {
    // عشان نجيب ال email اللي بعتناه من ال SignupScreen or LoginScreen هنستخدم ModalRoute.of(context)!.settings.arguments
    String? email = ModalRoute.of(context)!.settings.arguments as String?;
    // ال FutureBuilder هي ويدجت بتساعدنا في بناء ويدجت تانية بناء علي داتا بتجيلها من مصدر خارجي في المستقبل زي ال Firestore
    // عشان نقرا الداتا to read data هنستخدم ال FutureBuilder عشان  نجيب ال document اللي فيه ال messages من ال Firestore
    // ال FutureBuilder بيحتاج future و builder وبمجرد متعمل ال request بتقف يعني بتتنفذ مرة مواحدة بس
    // ال (Request)future دي هتكون ال document اللي فيه ال messages
    // ال builder دي هتكون ال Widget اللي هيتم عرضها لما الداتا تتجاب من ال Firestore وفي الحالة دي هتكون ال Scaffold اللي فيها ال AppBar وال Body بتاعت ال ChatScreen
    // ال FutureBuilder بيشتغل بطريقة انه بيجيب الداتا من ال future اللي احنا بنديها له وبعدين بيبني ال Widget اللي احنا بنديها له في ال builder لما الداتا تتجاب
    // ال AsyncSnapshot اللي بيجيلنا في ال builder بيحتوي علي الداتا اللي اتجاب من ال future
    // return FutureBuilder<QuerySnapshot>( هنستخدم بدالها StreamBuilder عشان نسمع لاي تغييرات بتحصل في ال messages collection في ال Firestore
    // future: messages.get(), هناخد كل ال documents اللي جوه ال messages collection ولكنها بتتاخد مرة واحدة فقط ومش بتسمع لاي حاجة جديدة بتنضاف جوا ال collection دي
    return StreamBuilder<QuerySnapshot>(
      // بنستخدمها لما نكون عايزين نعمل ui بيتغير بشكل لحظي مع اي تغييرات بتحصل في مصدر الداتا بتاعناودا اسمه Realtime changes
      // stream يعني حاجة بتفضل تجيلي كل ميحصل فيها تغيير
      // البيانات هتترتب حسب ال createdAt عشان الرسائل تظهر بالترتيب اللي اتكتبت بيه ودا اسمه ال query بمعني تنظيم البيانات زي منا عايز
      stream: messages.orderBy('createdAt', descending: true).snapshots(),
      // .snapshots() جي بترجعلي stream of QuerySnapshot
      builder: (context, snapshot) {
        // جوه ال builder اقدر ا check علي الداتا اللي راجعالي
        // هنعمل loading indicator لما الداتا بتاعت ال messages متكونش اتجاب لسه عشان ميرميش رسالة ب null
        if (snapshot.hasData) {
          // لما الداتا بتاعت ال messages تتجاب هنعمل ListView عشان نعرض ال messages دي
          List<Message> messagesList = [];
          for (int i = 0; i < snapshot.data!.docs.length; i++) {
            messagesList.add(Message.fromjson(snapshot.data!.docs[i]));
          }
          return Scaffold(
            appBar: AppBar(
              automaticallyImplyLeading:
                  false, // Hides the back button(of Navigatro.pushNamed) from appbar
              centerTitle: true,
              backgroundColor: kPrimaryColor,
              title: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(kLogo, height: 50),
                  Text('Scholar Chat', style: TextStyle(color: Colors.white)),
                ],
              ),
            ),
            body: Column(
              children: [
                Expanded(
                  // حطينا ال ListView جوه Expanded عشان تاخد المساحة المتاحة من ال Column وميحصلش error بسس ان ال Column بياخد مساحة ال screen فبالتالي ال ListView تعمل scroll عادي جوه ال Column
                  child: ListView.builder(
                    // عشان نعرض اخر رسالة في الاخر
                    reverse: true,
                    // ال ListView بتجبر ال width بتاع ال Container انها تاخد ال width بتاع ال screen المتاح ليها والحل هو استخدام ويدجت Align علي ال Container
                    controller: _scrollControler,
                    itemCount: messagesList.length,
                    itemBuilder: (context, index) {
                      return messagesList[index].id == email
                          ? ChatBubble(message: messagesList[index])
                          : ChatBubbleForFriend(message: messagesList[index]);
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
                      messages.add({
                        // this map represents the document data(Fields in FirestoreDatabase on My console website)
                        'message': data,
                        'createdAt': DateTime.now(), // to sort messages by time
                        'id': email,
                        // 'time': FieldValue.serverTimestamp(),
                      });
                      // بعد ما نضيف الرسالة نفضي ال TextField عشان المستخدم يقدر يكتب رسالة جديدة
                      controller.clear();
                      // عايزين نحرك الليست فيو لتحت عشان نشوف الرسالة الجديدة اللي اتضافت وفيه طريقتين
                      // _scrollControler.jumpTo(_scrollControler.position.maxScrollExtent); بتتحرك لاخر ال ListView فجأة من غير انيميشن
                      // animateTo بمعني اتحرك الي ... واعمل انيميشن معاك , وبتاخد قيمة double عن طريق ال position اللي هي ال maxScrollExtent اللي جت من ال ScrollController_ عشان اتحرك لاخر ال ListView
                      _scrollControler.animateTo(
                        // _scrollControler.position.maxScrollExtent,
                        // 0.0 بمعني اول ال ListView عملناها عشان نحل مشكلة ان البيانات تظهر بشكل طبيعي علي اكتر من جهاز مفتوح في نفس الوقت fixing chatting
                        0.0, // عشان احنا عاملين reverse: true في ال ListView.builder فبالتالي اخر رسالة هتكون في ال top
                        duration: Duration(milliseconds: 300),
                        curve: Curves.easeIn,
                      );
                    },
                    decoration: InputDecoration(
                      hintText: 'Send Message',
                      hintStyle: TextStyle(color: Colors.grey),
                      suffixIcon: Icon(Icons.send),
                      suffixIconColor: kPrimaryColor,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide(color: kPrimaryColor),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        } else {
          // اعمل انديكاتور في حالة الداتا دي  كانت ب null
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                CircularProgressIndicator(color: kPrimaryColor),
                Text(
                  'Loading ...',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          );
        }
      },
    );
  }
}
