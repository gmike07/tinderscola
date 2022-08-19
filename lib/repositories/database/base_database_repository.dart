import '/models/models.dart';

abstract class BaseDatabaseRepository {
  Stream<User> getUser(String userId);
  Stream<List<User>> getRomanticUsers(User usertr);
  Stream<List<User>> getFriendshipUsers(User usertr);
  Stream<List<User>> getUsers(User usertr);
  Stream<List<User>> getUsersToSwipe(User user);
  Stream<List<Match>> getMatches(User user);
  Future<void> createUser(User user);
  Future<void> updateUser(User user);
  Future<void> updateUserPictures(User user, String imageName, int index);
  Future<void> updateUserSwipe(
    String userId,
    String matchId,
    bool isSwipeRight,
  );
  Future<String> createChat(Chat chat);
  Stream<Chat> getChat(String id);
  Future<void> updateChat(Chat chat);
  Stream<Chat> getChatsForUsers(String userId1, String userId2);
}
