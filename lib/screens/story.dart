import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../frontendComponents/topBar.dart';
import '../../frontendComponents/popUp.dart';

class Story extends StatefulWidget {
  final User user;

  const Story({Key? key, required this.user}) : super(key: key);

  @override
  State<Story> createState() => _StoryState();
}

class _StoryState extends State<Story> {
  int fitniPoints = 0;
  int fitopians = 0;
  int proteinBars = 0;
  List<String> claimedIds = [];
  int bossesDefeated = 0;

  @override
  void initState() {
    super.initState();
    fetchFitniPoints();
    fetchClaimedIds();
  }

  Future<void> fetchFitniPoints() async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('fitniQuest')
          .where('userId', isEqualTo: widget.user.uid)
          .limit(1)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        int fitniScore = querySnapshot.docs.first['questScore'];
        int fitniProteinBars = querySnapshot.docs.first['proteinBars'];
        int fitniFitopians = querySnapshot.docs.first['fitopians'];
        setState(() {
          fitniPoints = fitniScore;
          proteinBars = fitniProteinBars;
          fitopians = fitniFitopians;
        });
        print('FitniPoints: $fitniPoints');
      }
    } catch (e) {
      print('Error fetching fitniPoints: $e');
    }
  }

  Future<void> fetchClaimedIds() async {
    try {
      DocumentSnapshot docSnapshot = await FirebaseFirestore.instance
          .collection('storyCollection')
          .doc(widget.user.uid)
          .get();

      if (docSnapshot.exists) {
        List<String> ids = List<String>.from(docSnapshot['claimedDays'] ?? []);
        setState(() {
          claimedIds = ids;
        });
        print('Claimed IDs: $claimedIds');
      }
    } catch (e) {
      print('Error fetching claimed IDs: $e');
    }
  }

  void saveClaimedId(String id) async {
    try {
      List<String> updatedIds = List<String>.from(claimedIds);
      updatedIds.add(id);

      await FirebaseFirestore.instance
          .collection('storyCollection')
          .doc(widget.user.uid)
          .update({'claimedDays': updatedIds});

      setState(() {
        claimedIds = updatedIds;
      });
      print('Saved claimed ID: $id');
    } catch (e) {
      print('Error saving claimed ID: $e');
    }
  }

  void saveBossesDefeated() async {
    try {
      await FirebaseFirestore.instance
          .collection('storyCollection')
          .doc(widget.user.uid)
          .set({
        'claimedDays': claimedIds, // Add claimedDays to the document
        'bossesDefeated': bossesDefeated,
      });
      print('Saved bosses defeated: $bossesDefeated');
    } catch (e) {
      print('Error saving bosses defeated: $e');
    }
  }

  void incrementBossesDefeated() {
    setState(() {
      bossesDefeated++;
    });
    saveBossesDefeated();
  }

  void showSuccessPopup() {
    incrementFitniQuestBoss();
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return const CustomPopupDialog(
          title: 'Boss Defeated!',
          content: 'Protein bars \t +5 \nFitopians \t +100',
          iconPath: 'icons/avatar.png', // Ensure this is the correct path
        );
      },
    );
  }

  void showFailurePopup() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return CustomPopupDialog(
          title: 'Not Enough Fitni Score',
          content: 'Stick to Your Goals to be Able to Defeat this Boss',
          iconPath: 'icons/avatar.png', // Ensure this is the correct path
        );
      },
    );
    print('Failed to defeat the boss');
  }

  void showDayPopup(String dayTitle) {
    incrementFitniQuestNormal();
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return CustomPopupDialog(
            title: "Milestone Reached!",
            content: 'Protein bars \t +1 \nFitopians \t +20',
            iconPath: 'icons/popupicon.png');
      },
    );
  }

  void incrementFitniQuestNormal() async {
    int updatedFitopians = fitopians + 20;
    int updatedProteinBars = proteinBars + 1;
    try {
      // Increment fitniPoints by 20
      await FirebaseFirestore.instance
          .collection('fitniQuest')
          .doc(widget.user.uid)
          .update({
        'fitopians': updatedFitopians,
        'proteinBars': updatedProteinBars
      });

      setState(() {
        fitopians = updatedFitopians;
        proteinBars = updatedProteinBars;
      });
      print('Updated fitopians for normal day: $updatedFitopians');
    } catch (e) {
      print('Error updating fitniPoints for normal day: $e');
    }
  }

  void incrementFitniQuestBoss() async {
    int updatedFitopians = fitopians + 100;
    int updatedProteinBars = proteinBars + 5;
    try {
      // Increment fitniPoints by 100
      await FirebaseFirestore.instance
          .collection('fitniQuest')
          .doc(widget.user.uid)
          .update({
        'fitopians': updatedFitopians,
        'proteinBars': updatedProteinBars
      });

      setState(() {
        fitopians = updatedFitopians;
        proteinBars = updatedProteinBars;
      });
      print('Updated fitopians for boss day: $updatedFitopians');
    } catch (e) {
      print('Error updating fitniPoints for boss day: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          TopBar(
            barColor: const Color.fromARGB(255, 136, 219, 119),
            shadowColor: const Color.fromARGB(255, 90, 182, 72),
            item1Label: fitniPoints.toString(),
            item1Color: Colors.white,
            item1Icon: Icons.star_rounded,
            item2Label: proteinBars.toString(),
            item2Color: Colors.white,
            item2Icon: Icons.food_bank_rounded,
            item3Label: fitopians.toString(),
            item3Color: Colors.white,
            item3Icon: Icons.emoji_people_rounded,
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(10),
              children: [
                const SizedBox(height: 10),
                buildChapter('Chapter 1', fitniPoints, 5, 1),
                const SizedBox(height: 20),
                buildChapter('Chapter 2', fitniPoints, 6, 2),
                // Add more chapters as needed
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildChapter(
    String title,
    int fitniPoints,
    int numIcons,
    int chapter,
  ) {
    Color dividerColor = Color.fromARGB(255, 136, 219, 119);
    if (chapter == 1) {
      dividerColor = Color.fromARGB(255, 255, 255, 255);
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: double.infinity,
          height: 2,
          margin: const EdgeInsets.only(top: 5),
          padding: const EdgeInsets.all(20.0),
          color: dividerColor,
        ),
        const SizedBox(height: 10),
        Column(
          children: List.generate(numIcons, (index) {
            String dayTitle = '${index + 1}';
            String id = '$chapter${index + 1}'; // Generate the id
            bool isAchieved = fitniPoints >= (index + 1) * 50 * chapter;
            bool isClaimed = claimedIds.contains(id);

            return Column(
              children: [
                if (index > 0)
                  Container(
                    width: 2,
                    height: 10, // Connector line color
                  ),
                GestureDetector(
                  onTap: () {
                    if (!isClaimed && isAchieved && index != numIcons - 1) {
                      // Regular day, check if achieved and not claimed
                      showDayPopup(dayTitle);
                      saveClaimedId(id);
                      print(
                          'Day $dayTitle, Chapter $chapter, id: $id'); // Print the id
                    } else if (index == numIcons - 1 && !isClaimed) {
                      // Boss day for chapter 1
                      print('Boss condition run');
                      if (isAchieved) {
                        showSuccessPopup();
                        saveClaimedId(id);
                      } else {
                        showFailurePopup();
                      }
                    }
                  },
                  child: buildDayCircle(
                    index,
                    fitniPoints,
                    chapter,
                    index == numIcons - 1,
                    id, // Pass id to buildDayCircle
                    isClaimed,
                  ),
                ),
              ],
            );
          }),
        ),
      ],
    );
  }

  Widget buildDayCircle(
    int index,
    int fitniPoints,
    int chapter,
    bool isLast,
    String id, // Added id parameter
    bool isClaimed,
  ) {
    bool isAchieved = fitniPoints >= (index + 1) * 50 * chapter;
    String iconPath = isLast
        ? 'icons/bossbg.png'
        : isAchieved
            ? 'icons/achievedstory.png'
            : 'icons/unachievedstory.png';

    if (isClaimed && !isLast) {
      iconPath = 'icons/claimed.png';
    }
    if (isLast && isClaimed) {
      iconPath = 'icons/defeated.png';
    }

    return Align(
      alignment: index % 2 == 0 ? Alignment.centerLeft : Alignment.centerRight,
      child: Container(
        width: 110,
        height: 80,
        margin: const EdgeInsets.only(top: 0, right: 130, left: 130),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
        ),
        child: Center(
          child: Image.asset(
            iconPath,
            width: 110,
            height: 110,
          ),
        ),
      ),
    );
  }
}
