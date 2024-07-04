import 'package:flutter/material.dart';

class CustomPopupDialog extends StatelessWidget {
  final String title;
  final String iconPath;
  final String content;

  const CustomPopupDialog({
    Key? key,
    required this.title,
    required this.content,
    required this.iconPath,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(60.0),
        side: BorderSide(color: Colors.green, width: 4.0),
      ),
      elevation: 0.0,
      backgroundColor: Colors.transparent,
      child: StatefulBuilder(
        builder: (context, setState) {
          return ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: 300.0, // Set the maximum width
              maxHeight: 300.0, // Set the maximum height
            ),
            child: Container(
              padding: EdgeInsets.all(20.0),
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.circular(60.0),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Image.asset(
                    iconPath,
                    width: 80.0,
                    height: 80.0,
                  ),
                  SizedBox(height: 16.0),
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 24.0,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Pines',
                    ),
                  ),
                  SizedBox(height: 16.0),
                  Text(
                    content,
                    style: TextStyle(
                      fontSize: 18.0,
                      fontFamily: 'Pines',
                    ),
                  ),
                  SizedBox(height: 10.0),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: IconButton(
                      icon: Icon(Icons.close),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
