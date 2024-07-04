import 'package:flutter/material.dart';
import './avatarView.dart';

class TopSection extends StatelessWidget {
  final Function() onEditPressed;
  final Function() onAvatarPressed;

  TopSection({
    Key? key,
    required this.onEditPressed,
    required this.onAvatarPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.0),
      alignment: Alignment.topCenter,
      height: 200.0,
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
          AvatarView(),
          SizedBox(
            width: 70.0,
            height: 70.0,
            child: IconButton(
              icon: Image.asset('icons/avatar.png'),
              iconSize: 30.0,
              onPressed: onAvatarPressed,
            ),
          ),
        ],
      ),
    );
  }
}
