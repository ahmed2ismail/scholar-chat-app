import 'package:bloc/bloc.dart';
import 'package:chat_app/constants.dart';
import 'package:chat_app/model/message.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meta/meta.dart';

part 'chat_state.dart';

class ChatCubit extends Cubit<ChatState> {
  ChatCubit() : super(ChatInitialState());

  final CollectionReference messages = FirebaseFirestore.instance.collection(kMessagesCollection);

    sendMessage({required String message, required String email}) {
    messages.add({
      'message': message,
      'createdAt': DateTime.now(),
      'id': email,
    });
  }

    List<Message> messagesList = [];
    getmessages() {
    messages.orderBy('createdAt', descending: true).snapshots().listen((snapshot) {
      // messagesList.clear() لازم نحطها جوه ال listen عشان كل مرة ييجي snapshot جديد نفضي ال messagesList ونحط فيه البيانات الجديدة اللي جت في ال snapshot عشان لما نعمل emit لل ChatSuccessState ونبعت ال messagesList دي تبقى محدثة بكل الرسائل اللي في ال Firestore
      messagesList.clear();
      for (QueryDocumentSnapshot doc in snapshot.docs) {
        messagesList.add(Message.fromjson(doc.data() as Map<String, dynamic>));
      }
      emit(ChatSuccessState(messages: messagesList));
    });
  }

  // void editMessage({required String messageId, required String newMessage}) {
  //   messages.doc(messageId).update({'message': newMessage});
  // }

  // void deleteMessage({required String messageId}) {
  //   messages.doc(messageId).delete();
  // }

  // void deleteAllMessages() {
  //   messages.get().then((snapshot) {
  //     for (DocumentSnapshot ds in snapshot.docs) {
  //       ds.reference.delete();
  //     }
  //   });
  // }
}
