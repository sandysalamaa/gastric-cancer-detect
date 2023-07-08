import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:gastric_cancer_detection/core/constant/colors/colors.dart';
import 'package:gastric_cancer_detection/core/constant/styles/styles.dart';
import 'package:url_launcher/url_launcher.dart';

class ContactUsScreen extends StatelessWidget {
  const ContactUsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text(tr('Contact_Us'),
              style: TextStyles.textViewBold20.copyWith(color: mainColor))),
      body: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            InkWell(
              onTap: () => launchUrl(Uri.parse('https://www.facebook.com')),
              child: Padding(
                padding: const EdgeInsets.all(6.0),
                child: Image.asset(
                  'assets/images/facebook.png',
                  width: 35.0,
                  height: 35.0,
                ),
              ),
            ),
            InkWell(
              onTap: () => launchUrl(Uri.parse('https://twitter.com')),
              child: Padding(
                padding: const EdgeInsets.all(6.0),
                child: Image.asset(
                  'assets/images/twitter.png',
                  width: 35.0,
                  height: 35.0,
                ),
              ),
            ),
            InkWell(
              onTap: () => launchUrl(Uri.parse('https://www.instagram.com')),
              child: Padding(
                padding: const EdgeInsets.all(6.0),
                child: Image.asset(
                  'assets/images/instagram.png',
                  width: 35.0,
                  height: 35.0,
                ),
              ),
            ),
            InkWell(
              onTap: () => launchUrl(Uri.parse('https://www.tiktok.com')),
              child: Padding(
                padding: const EdgeInsets.all(6.0),
                child: Image.asset(
                  'assets/images/tiktok.png',
                  width: 35.0,
                  height: 35.0,
                ),
              ),
            ),
            InkWell(
              onTap: () => launchUrl(
                  Uri.parse('https://api.whatsapp.com/send?phone=123456789')),
              child: Padding(
                padding: const EdgeInsets.all(6.0),
                child: Image.asset(
                  'assets/images/whatsapp.png',
                  width: 35.0,
                  height: 35.0,
                ),
              ),
            ),
            InkWell(
              onTap: () => launchUrl(Uri.parse('https://www.linkedin.com')),
              child: Padding(
                padding: const EdgeInsets.all(6.0),
                child: Image.asset(
                  'assets/images/linkedin.png',
                  width: 35.0,
                  height: 35.0,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
