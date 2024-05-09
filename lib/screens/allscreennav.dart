import 'package:flutter/material.dart';
import './authscreen.dart';
import './home.dart';
import './story.dart';
import './goals.dart';
import './profile.dart';
import '../components/account_creation/account_creator_index.dart';

class AllPages extends StatefulWidget {
  const AllPages({super.key});

  @override
  State<AllPages> createState() => _AllPagesState();
}

class _AllPagesState extends State<AllPages> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => HomePage()),
              );
            },
            child: Text('Page 1'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Goals()),
              );
            },
            child: Text('Page 2'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Profile()),
              );
            },
            child: Text('Page 3'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Story()),
              );
            },
            child: Text('Page 4'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => GoogleSignInPage()),
              );
            },
            child: Text('Page 5'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => CreatorIndex()),
              );
            },
            child: Text('Acc'),
          )
        ],
      ),
    );
  }
}
