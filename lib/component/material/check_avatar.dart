import 'package:flutter/material.dart';

checkAvatar(BuildContext context, String image) {
  return image != ''
      ? CircleAvatar(
          backgroundColor: Colors.transparent,
          backgroundImage: NetworkImage(image),
        )
      : Container(
          padding: EdgeInsets.all(10.0),
          child: Image.asset(
            'assets/images/user_not_found.png',
            color: Theme.of(context).primaryColorLight,
          ),
        );
}
