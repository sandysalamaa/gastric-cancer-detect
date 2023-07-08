import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gastric_cancer_detection/core/constant/colors/colors.dart';
import 'package:gastric_cancer_detection/core/widgets/comman/app_bar/default_app_bar.dart';
import 'package:gastric_cancer_detection/core/widgets/comman/buttons/master_textfield/master_textfield.dart';
import 'package:gastric_cancer_detection/core/widgets/comman/side_padding/side_padding.dart';
import 'package:gastric_cancer_detection/core/widgets/comman/space/space.dart';
import 'package:gastric_cancer_detection/core/widgets/loading.dart';

import '../../../../core/firebase/auth_stream.dart';
import '../../../patient_features/patient_home/presentation/widgets/home_card.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: mainColor,
      appBar: DefaultAppBar(
          title: tr("my_profile"), context: context, iconColor: white),
      body: SidePadding(
        sidePadding: 20,
        child: FrostedGlassBox(
          theHeight: double.infinity,
          borderRasius: 10.r,
          theChild: Padding(
            padding: const EdgeInsets.all(8.0),
            child: StreamBuilder<DocumentSnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('users')
                    .doc(currentFirebaseUser()!.uid)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting &&
                      !snapshot.hasData) {
                    return const Loading();
                  }
                  if (snapshot.hasError) {
                    return const Center(child: Text('An error Occured !'));
                  }
                  final user = snapshot.data!;
                  return Column(
                    children: [
                      CircleAvatar(
                        backgroundColor: whiteOpacityColor,
                        radius: 65,
                        child: CircleAvatar(
                          radius: 60,
                          backgroundImage: CachedNetworkImageProvider(
                            user['image'] != ""
                                ? user['image']
                                : "https://s3-eu-west-1.amazonaws.com/intercare-web-public/wysiwyg-uploads%2F1569586526901-doctor.jpg",
                          ),
                        ),
                      ),
                      const Space(
                        boxHeight: 30,
                      ),
                      MasterTextField(
                        prefixIcon: Icons.person,
                        borderRadius: 10,
                        hintText: user['first_name'] + user['last_name'],
                        readOnly: true,
                        label: false,
                        keyboardType: TextInputType.text,
                      ),
                      const Space(
                        boxHeight: 25,
                      ),
                      MasterTextField(
                        prefixIcon: Icons.phone,
                        borderRadius: 10,
                        hintText: user['phone'],
                        readOnly: true,
                        label: false,
                        keyboardType: TextInputType.text,
                      ),
                      const Space(
                        boxHeight: 25,
                      ),
                      MasterTextField(
                        prefixIcon: Icons.email,
                        borderRadius: 10,
                        hintText: user['email'],
                        readOnly: true,
                        label: false,
                        keyboardType: TextInputType.text,
                      ),
                      const Space(
                        boxHeight: 25,
                      ),
                    ],
                  );
                }),
          ),
        ),
      ),
    );
  }
}
