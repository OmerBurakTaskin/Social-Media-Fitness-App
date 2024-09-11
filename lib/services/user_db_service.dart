import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gym_application/models/user.dart';

const String USER_COLLECTION_REF = "users";

class UserDbService {
  final _firestore = FirebaseFirestore.instance;
  late final CollectionReference _usersRef;

  UserDbService() {
    initializeUserCollection();
  }

  void initializeUserCollection() {
    // call when signing up an user
    _usersRef = _firestore.collection(USER_COLLECTION_REF).withConverter<User>(
        fromFirestore: (snapshots, _) => User.fromJson(snapshots.data()!),
        toFirestore: (user, _) => user.toJson());
  }

  void addUser(User user) async {
    await _usersRef.doc(user.userId).set(user);
  }

  Stream<QuerySnapshot> getUsers() {
    return _usersRef.snapshots();
  }

  Future<User?> getSpecificUser(String userId) async {
    try {
      final user = await _firestore.collection("users").doc(userId).get();
      return User.fromJson(user.data()!);
    } catch (e) {
      //throw Exception("Cant get specific user!");
      return null;
    }
  }

  Future<List<User>> getSearchedUsers(String userName) async {
    try {
      final querySnapshot =
          await _usersRef.where("username", isEqualTo: userName).get();
      final users =
          querySnapshot.docs.map((doc) => doc.data() as User).toList();
      return users;
    } catch (e) {
      print("GET SEARCHED USERS ERROR: $e");
      return [];
    }
  }

  Future<List<String>> getUserFriends(String userId) async {
    // get friends userId
    try {
      final userDoc = await _usersRef.doc(userId).get();
      if (userDoc.exists) {
        return List<String>.from(userDoc["friends"] ?? []);
      } else {
        return [];
      }
    } catch (e) {
      print("GET USER FRIENDS HATASI");
      return [];
    }
  }

  Future<void> addFriendToUsers(String senderId, String receiverId) async {
    try {
      final userDoc = await _usersRef.doc(senderId).get();
      if (userDoc.exists) {
        List<String> userFriends = List<String>.from(userDoc["friends"] ?? []);
        userFriends.add(receiverId);
        await _usersRef.doc(senderId).update({"friends": userFriends});
      }
    } catch (e) {
      print("ADD FRIEND TO USER HATASI");
    }
  }

  Future<List<String>> getChattingFriendIdsOfUser(String senderId) async {
    try {
      final userDoc = await _usersRef.doc(senderId).get();
      final user = userDoc.data() as User?;
      return user == null ? [] : user.chattingFriends;
    } catch (e) {
      print("GET CHATTING FRIENDS OF USER HATASI");
      return [];
    }
  }

  Future<void> addChattingFriendToUser(
      String senderId, String receiverId) async {
    try {
      final senderDoc = await _usersRef.doc(senderId).get();
      final sender = senderDoc.data() as User?;
      final receiverDoc = await _usersRef.doc(receiverId).get();
      final receiver = receiverDoc.data() as User?;
      if (sender != null && receiver != null) {
        // adding their ids for one another
        List<String> chattingFriendsOfSender = sender.chattingFriends;
        chattingFriendsOfSender.add(receiverId);
        await _usersRef
            .doc(senderId)
            .update({"chattingFriends": chattingFriendsOfSender});
        List<String> chattingFriendsOfReceiver = receiver.chattingFriends;
        chattingFriendsOfReceiver.add(senderId);
        await _usersRef
            .doc(receiverId)
            .update({"chattingFriends": chattingFriendsOfReceiver});
      }
    } catch (e) {
      print("ADD CHATROOM TO USER HATASI");
    }
  }

  Future<void> sendFriendRequest(String senderId, String receiverId) async {
    _usersRef
        .doc(receiverId)
        .collection("pending-friend-requests")
        .doc(senderId)
        .set({"senderId": senderId});
  }

  void acceptFriendRequest(String senderId, String receiverId) async {
    _usersRef
        .doc(receiverId)
        .collection("pending-friend-requests")
        .doc(senderId)
        .delete();
    // adding their ids for one another
    addFriendToUsers(senderId, receiverId);
    addFriendToUsers(receiverId, senderId);
    _usersRef
        .doc(receiverId)
        .collection("pending-friend-requests")
        .doc(senderId)
        .delete(); // delete the request from the receiver
  }

  void declineFriendRequest(String senderId, String receiverId) async {
    _usersRef
        .doc(receiverId)
        .collection("pending-friend-requests")
        .doc(senderId)
        .delete();
  }
}
