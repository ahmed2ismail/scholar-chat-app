part of 'chat_cubit.dart';

@immutable
sealed class ChatState {}

final class ChatInitialState extends ChatState {}

final class ChatSuccessState extends ChatState {
  final List<Message> messages;

  ChatSuccessState({required this.messages});
}
