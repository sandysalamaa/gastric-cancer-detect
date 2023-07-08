import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:gastric_cancer_detection/core/constant/colors/colors.dart';

Widget ratingBar({required double value, Color? color}) {
  return RatingBar(
    initialRating: value,
    minRating: 1,
    direction: Axis.horizontal,
    allowHalfRating: true,
    unratedColor: mainColor.withOpacity(.5),
    ignoreGestures: true,
    itemCount: 5,
    itemSize: 18,
    itemPadding: const EdgeInsets.symmetric(horizontal: 1.0),
    ratingWidget: RatingWidget(
      full: Icon(
        Icons.star,
        color: color ?? Colors.yellow,
      ),
      empty: Icon(
        Icons.star_outline,
        color: color ?? Colors.yellow,
      ),
      half: Icon(
        Icons.star,
        color: color ?? Colors.yellow,
      ),
    ),
    onRatingUpdate: (rating) {},
    updateOnDrag: true,
  );
}
