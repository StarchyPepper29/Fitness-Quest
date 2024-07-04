import 'package:flutter/material.dart';
import './avatarView.dart';

class TopSection extends StatelessWidget {
  final Function() onEditPressed;

  TopSection({
    Key? key,
    required this.onEditPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.0),
      alignment: Alignment.topCenter,
      height: 120.0,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SizedBox(
            width: 70.0,
            height: 70.0,
            child: IconButton(
              icon: Image.asset('icons/edit.png'),
              iconSize: 30.0,
              onPressed: onEditPressed,
            ),
          ),
          // SizedBox(
          //   width: 70.0,
          //   height: 70.0,
          //   child: IconButton(
          //     icon: Image.asset('icons/avatar.png'),
          //     iconSize: 30.0,
          //     onPressed: onAvatarPressed,
          //   ),
          // ),
        ],
      ),
    );
  }
}
