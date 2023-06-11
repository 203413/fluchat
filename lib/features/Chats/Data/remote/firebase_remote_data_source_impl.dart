import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:proyecto_c2/features/AuthUsers/Domain/entities/engage_user_entity.dart';
import 'package:proyecto_c2/features/Chats/Data/models/group_model.dart';
import 'package:proyecto_c2/features/Chats/Data/models/my_chat_model.dart';
import 'package:proyecto_c2/features/Chats/Data/models/text_message_model.dart';
import 'package:proyecto_c2/features/Chats/Domain/entities/group_entity.dart';
import 'package:proyecto_c2/features/Chats/Domain/entities/my_chat_entity.dart';
import 'package:proyecto_c2/features/Chats/Domain/entities/text_messsage_entity.dart';
import 'firebase_remote_data_source.dart';

class FirebaseRemoteDataSourceImpl implements FirebaseRemoteDataSource {
  final FirebaseFirestore fireStore;
  final FirebaseAuth auth;
  final GoogleSignIn googleSignIn;

  String _verificationId = "";

  FirebaseRemoteDataSourceImpl(this.fireStore, this.auth, this.googleSignIn);

  @override
  Future<String> getCurrentUId() async => auth.currentUser!.uid;

  @override
  Future<String> getChannelId(EngageUserEntity engageUserEntity) {
    final userCollectionRef = fireStore.collection("users");
    print(
        "uid ${engageUserEntity.uid} - otherUid ${engageUserEntity.otherUid}");
    return userCollectionRef
        .doc(engageUserEntity.uid)
        .collection('chatChannel')
        .doc(engageUserEntity.otherUid)
        .get()
        .then((chatChannelId) {
      if (chatChannelId.exists) {
        return chatChannelId.get('channelId');
      } else
        return Future.value(null);
    });
  }

  // @override
  // Future<String> createOneToOneChatChannel(
  //     // TO DO
  //     EngageUserEntity engageUserEntity) async {
  //   //User Collection Reference
  //   final userCollectionRef = fireStore.collection("users");

  //   final oneToOneChatChannelRef = fireStore.collection("OneToOneChatChannel");
  //   //ChatChannelMap
  //   userCollectionRef
  //       .doc(engageUserEntity.uid)
  //       .collection("chatChannel")
  //       .doc(engageUserEntity.otherUid)
  //       .get()
  //       .then((chatChannelDoc) {
  //     //Chat Channel exists
  //     if (chatChannelDoc.exists) {
  //       return chatChannelDoc.get('channelId');
  //     }

  //     final _chatChannelId = oneToOneChatChannelRef.doc().id;

  //     var channel = {'channelId': _chatChannelId};
  //     var channel1 = {
  //       'channelId': _chatChannelId,
  //     };

  //     oneToOneChatChannelRef.doc(_chatChannelId).set(channel);

  //     //currentUser
  //     userCollectionRef
  //         .doc(engageUserEntity.uid)
  //         .collection('chatChannel')
  //         .doc(engageUserEntity.otherUid)
  //         .set(channel);

  //     //otherUser
  //     userCollectionRef
  //         .doc(engageUserEntity.otherUid)
  //         .collection('chatChannel')
  //         .doc(engageUserEntity.uid)
  //         .set(channel);

  //     return _chatChannelId;
  //   });
  //   return Future.value("");
  // }

  @override
  Future<void> sendTextMessage(
      TextMessageEntity textMessageEntity, String channelId) async {
    final messagesRef = fireStore
        .collection("groupChatChannel")
        .doc(channelId)
        .collection("messages");

    //MessageId
    final messageId = messagesRef.doc().id;

    final newMessage = TextMessageModel(
      content: textMessageEntity.content,
      messageId: messageId,
      receiverName: textMessageEntity.receiverName,
      recipientId: textMessageEntity.recipientId,
      senderId: textMessageEntity.senderId,
      senderName: textMessageEntity.senderName,
      time: textMessageEntity.time,
      type: textMessageEntity.type,
    ).toDocument();

    messagesRef.doc(messageId).set(newMessage);
  }

  @override
  Stream<List<TextMessageEntity>> getMessages(String channelId) {
    final oneToOneChatChannelRef = fireStore.collection("groupChatChannel");
    final messagesRef =
        oneToOneChatChannelRef.doc(channelId).collection("messages");

    return messagesRef.orderBy('time').snapshots().map((querySnap) => querySnap
        .docs
        .map((queryDoc) => TextMessageModel.fromSnapshot(queryDoc))
        .toList());
  }

  // @override
  // Future<void> addToMyChat(MyChatEntity myChatEntity) async {
  //   // TO DO
  //   final myChatRef = fireStore
  //       .collection("users")
  //       .doc(myChatEntity.senderUID)
  //       .collection("myChat");
  //   final otherChatRef = fireStore
  //       .collection("users")
  //       .doc(myChatEntity.recipientUID)
  //       .collection("myChat");

  //   final myNewChatCurrentUser = MyChatModel(
  //     channelId: myChatEntity.channelId,
  //     senderName: myChatEntity.senderName,
  //     time: myChatEntity.time,
  //     recipientName: myChatEntity.recipientName,
  //     recipientPhoneNumber: myChatEntity.recipientPhoneNumber,
  //     recipientUID: myChatEntity.recipientUID,
  //     senderPhoneNumber: myChatEntity.senderPhoneNumber,
  //     senderUID: myChatEntity.senderUID,
  //     profileUrl: myChatEntity.profileUrl,
  //     isArchived: myChatEntity.isArchived,
  //     isRead: myChatEntity.isRead,
  //     recentTextMessage: myChatEntity.recentTextMessage,
  //     subjectName: myChatEntity.subjectName,
  //   ).toDocument();
  //   final myNewChatOtherUser = MyChatModel(
  //     channelId: myChatEntity.channelId,
  //     senderName: myChatEntity.recipientName,
  //     time: myChatEntity.time,
  //     recipientName: myChatEntity.senderName,
  //     recipientPhoneNumber: myChatEntity.senderPhoneNumber,
  //     recipientUID: myChatEntity.senderUID,
  //     senderPhoneNumber: myChatEntity.recipientPhoneNumber,
  //     senderUID: myChatEntity.recipientUID,
  //     profileUrl: myChatEntity.profileUrl,
  //     isArchived: myChatEntity.isArchived,
  //     isRead: myChatEntity.isRead,
  //     recentTextMessage: myChatEntity.recentTextMessage,
  //     subjectName: myChatEntity.subjectName,
  //   ).toDocument();
  //   myChatRef.doc(myChatEntity.recipientUID).get().then((myChatDoc) {
  //     if (!myChatDoc.exists) {
  //       myChatRef.doc(myChatEntity.recipientUID).set(myNewChatCurrentUser);
  //       otherChatRef.doc(myChatEntity.senderUID).set(myNewChatOtherUser);
  //       return;
  //     } else {
  //       print("update");
  //       myChatRef.doc(myChatEntity.recipientUID).update(myNewChatCurrentUser);
  //       otherChatRef.doc(myChatEntity.senderUID).set(myNewChatOtherUser);

  //       return;
  //     }
  //   });
  // }

  // @override
  // Stream<List<MyChatEntity>> getMyChat(String uid) {
  //   // TO DO
  //   final myChatRef =
  //       fireStore.collection("users").doc(uid).collection("myChat");

  //   return myChatRef.orderBy('time', descending: true).snapshots().map(
  //     (querySnapshot) {
  //       return querySnapshot.docs.map((queryDocumentSnapshot) {
  //         return MyChatModel.fromSnapshot(queryDocumentSnapshot);
  //       }).toList();
  //     },
  //   );
  // }

  @override
  Future<void> createNewGroup(
      MyChatEntity myChatEntity, List<String> selectUserList) async {
    print("createNewGroup ${myChatEntity.channelId}");
    print(myChatEntity.senderUID);
    await _createGroup(myChatEntity, selectUserList);
    return;
  }

  _createGroup(MyChatEntity myChatEntity, List<String> selectUserList) async {
    final myNewChatCurrentUser = MyChatModel(
      channelId: myChatEntity.channelId,
      senderName: myChatEntity.senderName,
      time: myChatEntity.time,
      recipientName: myChatEntity.recipientName,
      recipientPhoneNumber: myChatEntity.recipientPhoneNumber,
      recipientUID: myChatEntity.recipientUID,
      senderPhoneNumber: myChatEntity.senderPhoneNumber,
      senderUID: myChatEntity.senderUID,
      profileUrl: myChatEntity.profileUrl,
      isArchived: myChatEntity.isArchived,
      isRead: myChatEntity.isRead,
      recentTextMessage: myChatEntity.recentTextMessage,
      subjectName: myChatEntity.subjectName,
    ).toDocument();
    print("sender Id ${myChatEntity.senderUID}");
    await fireStore
        .collection("users")
        .doc(myChatEntity.senderUID)
        .collection("myChat")
        .doc(myChatEntity.channelId)
        .set(myNewChatCurrentUser)
        .then((value) {
      print("data created");
    }).catchError((error) {
      print("dataError $error");
    });
  }

  @override
  Future<void> getCreateGroup(GroupEntity groupEntity) async {
    final groupCollection = fireStore.collection("groups");

    final groupId = groupCollection.doc().id;

    groupCollection.doc(groupId).get().then((groupDoc) {
      final newGroup = GroupModel(
        groupId: groupId,
        limitUsers: groupEntity.limitUsers,
        joinUsers: groupEntity.joinUsers,
        groupProfileImage: groupEntity.groupProfileImage,
        creationTime: groupEntity.creationTime,
        groupName: groupEntity.groupName,
        lastMessage: groupEntity.lastMessage,
      ).toDocument();

      if (!groupDoc.exists) {
        groupCollection.doc(groupId).set(newGroup);

        return;
      }
      return;
    }).catchError((error) {
      print(error);
    });
  }

  @override
  Stream<List<GroupEntity>> getGroups() {
    final groupCollection = fireStore.collection("groups");
    return groupCollection
        .orderBy("creationTime", descending: true)
        .snapshots()
        .map((querySnapshot) =>
            querySnapshot.docs.map((e) => GroupModel.fromSnapshot(e)).toList());
  }

  @override
  Future<void> joinGroup(GroupEntity groupEntity) async {
    final groupChatChannelCollection = fireStore.collection("groupChatChannel");

    groupChatChannelCollection
        .doc(groupEntity.groupId)
        .get()
        .then((groupChannel) {
      Map<String, dynamic> groupMap = {"groupChannelId": groupEntity.groupId};
      if (!groupChannel.exists) {
        groupChatChannelCollection.doc(groupEntity.groupId).set(groupMap);
        return;
      }
      return;
    });
  }

  @override
  Future<void> updateGroup(GroupEntity groupEntity) async {
    Map<String, dynamic> groupInformation = Map();

    final userCollection = fireStore.collection("groups");

    if (groupEntity.groupProfileImage != null &&
        groupEntity.groupProfileImage != "")
      groupInformation['groupProfileImage'] = groupEntity.groupProfileImage;
    if (groupEntity.groupName != null && groupEntity.groupName != "")
      groupInformation["groupName"] = groupEntity.groupName;
    if (groupEntity.lastMessage != null && groupEntity.lastMessage != "")
      groupInformation["lastMessage"] = groupEntity.lastMessage;
    if (groupEntity.creationTime != null)
      groupInformation["creationTime"] = groupEntity.creationTime;

    userCollection.doc(groupEntity.groupId).update(groupInformation);
  }
}
