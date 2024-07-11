import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../components/dietlogger/foodLog.dart';
import 'package:fitnessquest_v1/components/IbrahimsStuff/lib/exercise.dart';
import '../../screens/profile.dart';
import '../../screens/goals.dart';
import '../../screens/settings.dart';
import '../timer/beginningofTime.dart';
import '../../screens/shop.dart';
import '../../screens/story.dart';
// Import the AvatarService

class BottomNavBar extends StatefulWidget {
  final User user;

  const BottomNavBar({super.key, required this.user});

  @override
  _BottomNavBarState createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  int _currentIndex = 0;

  late final List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    _pages = [
      HomePage(user: widget.user),
      Story(user: widget.user),
      Profile(user: widget.user),
      Goals(user: widget.user),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        selectedItemColor: const Color.fromARGB(255, 225, 120, 0),
        unselectedItemColor: const Color.fromARGB(255, 255, 179, 121),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.book),
            label: 'Story',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.flag),
            label: 'Goals',
          ),
        ],
      ),
    );
  }
}

class HomePage extends StatefulWidget {
  final User user;

  const HomePage({super.key, required this.user});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String? displayName;
  final AvatarService _avatarService =
      AvatarService(); // Initialize the AvatarService

  @override
  void initState() {
    super.initState();
    fetchDisplayName();
  }

  Future<void> fetchDisplayName() async {
    // await widget.user.reload();
    User? updatedUser = FirebaseAuth.instance.currentUser;

    String? name = updatedUser?.displayName;

    setState(() {
      displayName = name;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Column(
            children: [
              Container(
                width: double.infinity,
                margin: const EdgeInsets.only(top: 60, left: 18, right: 18),
                padding: const EdgeInsets.all(20.0),
                decoration: BoxDecoration(
                  color: Color.fromARGB(255, 255, 154, 39),
                  borderRadius: BorderRadius.circular(15.0),
                ),
                child: Text(
                  'Welcome, ${displayName ?? 'User'}!',
                  style: const TextStyle(fontSize: 24, color: Colors.white),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 20),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: GridView.count(
                    crossAxisCount: 2,
                    crossAxisSpacing: 16.0,
                    mainAxisSpacing: 16.0,
                    children: [
                      Card(
                        elevation: 4.0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                        child: InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => Diet(widget.user)),
                            );
                          },
                          child: const Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.restaurant,
                                  size: 50,
                                  color: Color.fromARGB(255, 225, 120, 0)),
                              SizedBox(height: 10),
                              Text(
                                'Log Diet',
                                style: TextStyle(fontSize: 18),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Card(
                        elevation: 4.0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                        child: InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      ExerciseScreen(widget.user)),
                            );
                          },
                          child: const Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.fitness_center_rounded,
                                  size: 50,
                                  color: Color.fromARGB(255, 225, 120, 0)),
                              SizedBox(height: 10),
                              Text(
                                'Log Workout',
                                style: TextStyle(fontSize: 18),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
          Positioned(
            top: 5,
            right: 5,
            child: IconButton(
              icon: const Icon(Icons.settings,
                  color: Color.fromARGB(255, 225, 120, 0), size: 30),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => Settings(user: widget.user)),
                );
              },
            ),
          ),
          Positioned(
            top: 5,
            left: 5,
            child: IconButton(
              icon: const Icon(Icons.shop_rounded,
                  color: Color.fromARGB(255, 225, 120, 0), size: 30),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => Shop(user: widget.user)),
                );
              },
            ),
          ),
          Positioned(
            bottom: 20,
            left: 20,
            right: 20,
            child: ElevatedButton(
              onPressed: () async {
                await _avatarService.initializeAll();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Initialization complete')),
                );
              },
              child: const Text('Initialize All'),
            ),
          ),
        ],
      ),
    );
  }
}
