//import 'dart:html';

import 'package:cloud_firestore/cloud_firestore.dart';
//import 'package:geolocator/geolocator.dart';
// ignore: depend_on_referenced_packages
import 'package:rxdart/rxdart.dart';
import 'package:tinderscola_final/config/constants.dart';

import '/models/models.dart';
import '/repositories/repositories.dart';

class DatabaseRepository extends BaseDatabaseRepository {
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

  @override
  Stream<User> getUser(String userId) {
    return _firebaseFirestore
        .collection('users')
        .doc(userId)
        .snapshots()
        .map((snap) => User.fromSnapshot(snap));
  }

  @override
  Stream<List<User>> getRomanticUsers(User usertr) {
    return _firebaseFirestore
        .collection('users')
        .where('gender', whereIn: _selectGender(usertr))
        .limit(AppConstants.limitQuery)
        .snapshots()
        .map((snap) {
      return snap.docs.map((doc) => User.fromSnapshot(doc)).toList();
    });
  }

  @override
  Stream<List<User>> getFriendshipUsers(User usertr) {
    if (usertr.searchesForFriends) {
      return _firebaseFirestore
          .collection('users')
          .where('searchesForFriends', isEqualTo: true)
          .limit(AppConstants.limitQuery)
          .snapshots()
          .map((snap) {
        return snap.docs.map((doc) => User.fromSnapshot(doc)).toList();
      });
    } else {
      return Stream.fromIterable([]);
    }
  }

  @override
  Stream<List<User>> getUsers(User usertr) {
    return Rx.combineLatest2(
        getFriendshipUsers(usertr), getRomanticUsers(usertr), (
      List<User> friends,
      List<User> romantic,
    ) {
      Set<User> users = friends.toSet();
      users.addAll(romantic.toSet());
      return users.toList();
    });
  }

  @override
  Stream<List<User>> getUsersToSwipe(User user) {
    return Rx.combineLatest2(
      getUser(user.id),
      getUsers(user),
      (
        User currentUser,
        List<User> users,
      ) {
        return users.where(
          (user) {
            bool isCurrentUser = user.id == currentUser.id;
            bool wasSwipedLeft = currentUser.swipeLeft.contains(user.id);
            bool wasSwipedRight = currentUser.swipeRight.contains(user.id);
            bool isMatch = currentUser.matches.contains(user.id);

            // bool isWithinAgeRange =
            //     user.age >= currentUser.ageRangePreference![0] &&
            //         user.age <= currentUser.ageRangePreference![1];

            // bool isWithinDistance = _getDistance(currentUser, user) <=
            //     currentUser.distancePreference;

            if (isCurrentUser) return false;
            if (wasSwipedLeft) return false;
            if (wasSwipedRight) return false;
            if (isMatch) return false;
            // if (!isWithinAgeRange) return false;
            // if (!isWithinDistance) return false;

            return true;
          },
        ).toList();
      },
    );
  }

  @override
  Stream<List<Match>> getMatches(User user) {
    return Rx.combineLatest2(
      getUser(user.id),
      getUsers(user),
      (
        User currentUser,
        List<User> users,
      ) {
        String id = user.id;
        List<Match> matches = users
            .where((user) => currentUser.matches.contains(user.id))
            .map((user) => Match(userId: id, matchedUser: user))
            .toList();
        return matches;
      },
    );
  }

  Stream<List<Chat>> getChatsUser1(User user) {
    return _firebaseFirestore
        .collection('chats')
        .where('userId', isEqualTo: user.id)
        .snapshots()
        .map((snap) {
      return snap.docs.map((doc) => Chat.fromSnapshot(doc)).toList();
    });
  }

  Stream<List<Chat>> getChats(User user) {
    return Rx.combineLatest2(
      getChatsUser1(user),
      getChatsUser2(user),
      (
        List<Chat> chat1,
        List<Chat> chat2,
      ) {
        List<Chat> chats = chat1;
        chats.addAll(chat2);
        return chats;
      },
    );
  }

  Stream<List<Chat>> getChatsUser2(User user) {
    return _firebaseFirestore
        .collection('chats')
        //.where('messages', isNotEqualTo: [])
        .where('matchedUserId', isEqualTo: user.id)
        //.orderBy('dateTime', descending: true)
        .snapshots()
        .map((snap) {
      return snap.docs.map((doc) => Chat.fromSnapshot(doc)).toList();
    });
  }

  @override
  Future<void> updateUserSwipe(
    String userId,
    String matchId,
    bool isSwipeRight,
  ) async {
    if (isSwipeRight) {
      await _firebaseFirestore.collection('users').doc(userId).update({
        'swipeRight': FieldValue.arrayUnion([matchId])
      });
    } else {
      await _firebaseFirestore.collection('users').doc(userId).update({
        'swipeLeft': FieldValue.arrayUnion([matchId])
      });
    }
  }

  Future<void> updateUserMatch(
    String userId,
    String matchId,
  ) async {
    // Add the match into the current user document.
    await _firebaseFirestore.collection('users').doc(userId).update({
      'matches': FieldValue.arrayUnion([matchId])
    });
    // Add the match into the other user document.
    await _firebaseFirestore.collection('users').doc(matchId).update({
      'matches': FieldValue.arrayUnion([userId])
    });
  }

  @override
  Future<void> createUser(User user) async {
    await _firebaseFirestore.collection('users').doc(user.id).set(user.toMap());
  }

  @override
  Future<void> updateUser(User user) async {
    return _firebaseFirestore
        .collection('users')
        .doc(user.id)
        .update(user.toMap())
        .then(
          // ignore: avoid_print
          (value) => print('User document updated.'),
        );
  }

  @override
  Future<void> updateUserPictures(
      User user, String imageName, int index) async {
    String downloadUrl =
        await StorageRepository().getDownloadURL(user, imageName);
    List<String?> urls = user.imageUrls.toList();
    urls[index] = downloadUrl;
    _firebaseFirestore.collection('users').doc(user.id)
        // ignore: unnecessary_cast
        .update({'imageUrls': urls as List<dynamic>});
  }

  Future<void> updateUserProfilePicture(User user, String imageName) async {
    String downloadUrl =
        await StorageRepository().getDownloadURL(user, imageName);
    _firebaseFirestore.collection('users').doc(user.id)
        // ignore: unnecessary_cast
        .update({'profilePicture': downloadUrl});
  }

  Future<void> updateUserCoverPicture(User user, String imageName) async {
    String downloadUrl =
        await StorageRepository().getDownloadURL(user, imageName);
    _firebaseFirestore.collection('users').doc(user.id)
        // ignore: unnecessary_cast
        .update({'coverPicture': downloadUrl});
  }

  _selectGender(User user) {
    return user.genderPreference;
  }

  // _getDistance(User currentUser, User user) {
  //   GeolocatorPlatform geolocator = GeolocatorPlatform.instance;
  //   var distanceInKm = geolocator.distanceBetween(
  //         currentUser.location!.lat.toDouble(),
  //         currentUser.location!.lon.toDouble(),
  //         user.location!.lat.toDouble(),
  //         user.location!.lon.toDouble(),
  //       ) ~/
  //       1000;
  //   print(
  //       'Distance in KM between ${currentUser.name} & ${user.name}: $distanceInKm');
  //   return distanceInKm;
  // }

  @override
  Future<String> createChat(Chat chat) async {
    DocumentReference docRef =
        await _firebaseFirestore.collection('chats').add(chat.toMap());
    return docRef.id;
  }

  @override
  Future<void> updateChat(Chat chat) async {
    await _firebaseFirestore
        .collection('chats')
        .doc(chat.id)
        .update(chat.toMap());
  }

  @override
  Stream<Chat> getChat(String id) {
    return _firebaseFirestore
        .collection('chats')
        .doc(id)
        .snapshots()
        .map((snap) => Chat.fromSnapshot(snap));
  }

  @override
  Future<void> sendMessage(Chat chat, Message message) async {
    await _firebaseFirestore.collection('chats').doc(chat.id).update({
      'messages': FieldValue.arrayUnion([message.toMap()])
    });
  }

  @override
  Stream<Chat> getChatsForUsers(String userId1, String userId2) {
    return Rx.combineLatest2(
      _firebaseFirestore
          .collection('chats')
          .where('userId', isEqualTo: userId1)
          .where('matchedUserId', isEqualTo: userId2)
          .snapshots()
          .map((snap) {
        return snap.docs.map((doc) => Chat.fromSnapshot(doc)).toList();
      }),
      _firebaseFirestore
          .collection('chats')
          .where('userId', isEqualTo: userId2)
          .where('matchedUserId', isEqualTo: userId1)
          .snapshots()
          .map((snap) {
        return snap.docs.map((doc) => Chat.fromSnapshot(doc)).toList();
      }),
      (
        List<Chat> chat1,
        List<Chat> chat2,
      ) {
        List<Chat> chats = chat1;
        chats.addAll(chat2);
        return chats[0];
      },
    );
  }

  @override
  Future<void> unmatchUsers(String currentUser, String matchedUser) async {
    await _firebaseFirestore.collection('users').doc(currentUser).update({
      'swipeLeft': FieldValue.arrayUnion([matchedUser]),
      'swipeRight': FieldValue.arrayRemove([matchedUser]),
      'matches': FieldValue.arrayRemove([matchedUser])
    });
    await _firebaseFirestore.collection('users').doc(matchedUser).update({
      'swipeLeft': FieldValue.arrayUnion([currentUser]),
      'swipeRight': FieldValue.arrayRemove([currentUser]),
      'matches': FieldValue.arrayRemove([currentUser])
    });
  }

  @override
  Future<void> reportUser(String currentUser, String matchedUser) async {
    await _firebaseFirestore
        .collection('reports')
        .add({'reportedUser': matchedUser, 'reporter': currentUser});
  }
}
