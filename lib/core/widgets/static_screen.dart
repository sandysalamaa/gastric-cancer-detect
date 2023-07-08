import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:gastric_cancer_detection/core/constant/styles/styles.dart';
import 'package:gastric_cancer_detection/core/firebase/auth_stream.dart';
import 'package:gastric_cancer_detection/features/doctor_features/report_model.dart';

import '../constant/colors/colors.dart';
import 'comman/app_bar/default_app_bar.dart';
import 'loading.dart';

class StaticScreen extends StatelessWidget {
  StaticScreen({super.key});
  final List<String> titles = [
    tr('title'),
    tr('description'),
    tr('hint'),
    tr('warning'),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: mainColor,
      appBar: DefaultAppBar(
          title: tr("Recive_Reports"), context: context, iconColor: white),
      body: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('users')
              .doc(currentFirebaseUser()!.uid)
              .collection('reports')
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting &&
                !snapshot.hasData) {
              return const LoadingWhite();
            }
            if (snapshot.hasError) {
              return const Center(child: Text('An error Occured !'));
            }
            final List<ReportModel> reportList = snapshot.data!.docs
                .map((doc) =>
                    ReportModel.fromJson(doc.data() as Map<String, dynamic>))
                .toList();
            log(reportList.length.toString());
            return reportList.isEmpty
                ? Center(
                    child: Text(tr('no_report_list'),
                        style:
                            TextStyles.textViewBold18.copyWith(color: white)))
                : Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: reportList.length,
                      itemBuilder: (context, index) {
                        return MyCard(title: titles, value: reportList[index]);
                      },
                    ),
                  );
          }),
    );
  }
}

class MyCard extends StatelessWidget {
  final List<String> title;
  final ReportModel value;

  const MyCard({super.key, required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              title[0],
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18.0,
              ),
            ),
            const SizedBox(height: 8.0),
            Text(value.title),
            const SizedBox(height: 12.0),
            Text(
              title[1],
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18.0,
              ),
            ),
            const SizedBox(height: 8.0),
            Text(value.description),
            const SizedBox(height: 12.0),
            Text(
              title[2],
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18.0,
              ),
            ),
            const SizedBox(height: 8.0),
            Text(value.hint),
            const SizedBox(height: 12.0),
            Text(
              title[3],
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18.0,
              ),
            ),
            const SizedBox(height: 8.0),
            Text(value.warning),
            const SizedBox(height: 12.0),
          ],
        ),
      ),
    );
  }
}
