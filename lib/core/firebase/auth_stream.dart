import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../features/auth/firebase_routes.dart';
import '../../features/auth/model/user.dart';
import '../../injection_container.dart';

User? currentFirebaseUser() => FirebaseAuth.instance.currentUser;

Stream<BaseUser> getUserData(String uid) => sl<FirebaseFirestore>()
    .doc(FirebaseRoute.userRoute(uid))
    .snapshots()
    .map((event) => userFromJson(event.data()!));
