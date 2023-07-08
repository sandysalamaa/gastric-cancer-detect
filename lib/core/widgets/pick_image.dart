import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import 'package:gastric_cancer_detection/core/constant/colors/colors.dart';

class GetImageFromGallery extends StatelessWidget {
  final Function() galleryOnTap;
  final Function() cameraOnTap;
  const GetImageFromGallery(
      {super.key, required this.cameraOnTap, required this.galleryOnTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: mainColor,
      height: 250,
      padding: const EdgeInsets.all(20),
      child: Stack(
        alignment: AlignmentDirectional.topCenter,
        clipBehavior: Clip.none,
        children: [
          Positioned(
            top: -35,
            child: Container(
              width: 50,
              height: 6,
              margin: const EdgeInsets.only(bottom: 20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(2.5),
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Column(children: [
            SelectPhoto(
              onTap: galleryOnTap,
              icon: Icons.image,
              textLabel: tr('Browse_Gallery'),
            ),
            const SizedBox(height: 20),
            SelectPhoto(
              onTap: cameraOnTap,
              icon: Icons.camera_alt_outlined,
              textLabel: tr('camera'),
            ),
          ])
        ],
      ),
    );
  }
}

class SelectPhoto extends StatelessWidget {
  final String textLabel;
  final IconData icon;

  final void Function()? onTap;

  const SelectPhoto({
    Key? key,
    required this.textLabel,
    required this.icon,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onTap,
      style: ElevatedButton.styleFrom(
        elevation: 10,
        backgroundColor: Colors.grey.shade200,
        shape: const StadiumBorder(),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: 16,
          horizontal: 6,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          // crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Icon(
              icon,
              color: mainColor,
            ),
            const SizedBox(
              width: 14,
            ),
            Text(
              textLabel,
              style: const TextStyle(
                fontSize: 18,
                color: mainColor,
              ),
            )
          ],
        ),
      ),
    );
  }
}
