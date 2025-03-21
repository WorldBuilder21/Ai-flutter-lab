/// This class will be used to be define and distinguish the type of messages
/// being sent in the system
enum MessageType {
  /// Message sent by the user
  user,

  /// Message received from the AI
  bot,

  /// System message (e.g., error notifications)
  system,
}
