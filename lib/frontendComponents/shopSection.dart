import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ProductBox extends StatefulWidget {
  final String title;
  final String type;
  final List<Map<String, String>> products;
  final User user;
  final Function(int) updateFitopians;
  const ProductBox({
    Key? key,
    required this.title,
    required this.type,
    required this.products,
    required this.user,
    required this.updateFitopians,
  }) : super(key: key);

  @override
  _ProductBoxState createState() => _ProductBoxState();
}

class _ProductBoxState extends State<ProductBox> {
  late int userFitopians;
  bool isAlreadyOwned = false;

  @override
  void initState() {
    super.initState();
    getUserFitopians();
  }

  Future<void> getUserFitopians() async {
    DocumentSnapshot userSnapshot = await FirebaseFirestore.instance
        .collection('fitniQuest')
        .doc(widget.user.uid)
        .get();
    Map<String, dynamic>? data = userSnapshot.data() as Map<String, dynamic>?;
    setState(() {
      userFitopians = data?['fitopians'] ?? 0;
    });
  }

  Future<bool> checkOwnership(String imagePath) async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('ownedAssets')
          .where('userId', isEqualTo: widget.user.uid)
          .get();

      if (querySnapshot.docs.isEmpty) {
        return false;
      }

      DocumentSnapshot ownedAssetsSnapshot = querySnapshot.docs.first;
      Map<String, dynamic>? data =
          ownedAssetsSnapshot.data() as Map<String, dynamic>?;

      if (data != null && data.containsKey(widget.type)) {
        List<dynamic> items = data[widget.type];
        return items.contains(imagePath);
      } else {
        return false;
      }
    } catch (e) {
      print('Error checking ownership: $e');
      return false;
    }
  }

  void buyItem(String imagePath, int productPrice) async {
    try {
      DocumentSnapshot userSnapshot = await FirebaseFirestore.instance
          .collection('fitniQuest')
          .doc(widget.user.uid)
          .get();
      Map<String, dynamic>? data = userSnapshot.data() as Map<String, dynamic>?;

      if (data != null) {
        int updatedFitopians = data['fitopians'] - productPrice;

        await FirebaseFirestore.instance
            .collection('fitniQuest')
            .doc(widget.user.uid)
            .update({'fitopians': updatedFitopians});

        QuerySnapshot querySnapshot = await FirebaseFirestore.instance
            .collection('ownedAssets')
            .where('userId', isEqualTo: widget.user.uid)
            .get();

        if (querySnapshot.docs.isEmpty) {
          await FirebaseFirestore.instance.collection('ownedAssets').add({
            'userId': widget.user.uid,
            widget.type: [imagePath],
          });
        } else {
          DocumentSnapshot ownedAssetsSnapshot = querySnapshot.docs.first;
          Map<String, dynamic>? ownedAssetsData =
              ownedAssetsSnapshot.data() as Map<String, dynamic>?;

          if (ownedAssetsData != null &&
              ownedAssetsData.containsKey(widget.type)) {
            List<dynamic> items = ownedAssetsData[widget.type];
            items.add(imagePath);

            await FirebaseFirestore.instance
                .collection('ownedAssets')
                .doc(ownedAssetsSnapshot.id)
                .update({widget.type: items});
          } else {
            await FirebaseFirestore.instance
                .collection('ownedAssets')
                .doc(ownedAssetsSnapshot.id)
                .update({
              widget.type: [imagePath]
            });
          }
        }

        setState(() {
          userFitopians = updatedFitopians;
          isAlreadyOwned = true;
        });
        widget.updateFitopians(updatedFitopians);
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Purchase Successful'),
              content: Text('You have successfully purchased!'),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('OK'),
                ),
              ],
            );
          },
        );
      }
    } catch (e) {
      print('Error buying item: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15.0),
        border: Border.all(
          color: Color.fromRGBO(248, 153, 80, 1),
          width: 2.0,
        ),
        color: Colors.white,
      ),
      padding: EdgeInsets.all(16.0),
      margin: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: EdgeInsets.only(bottom: 8.0),
            child: Text(
              widget.title,
              style: TextStyle(
                fontSize: 40.0,
                fontFamily: 'Aristotellica',
                fontWeight: FontWeight.w600,
                color: Color.fromRGBO(255, 131, 96, 1),
              ),
            ),
          ),
          Container(
            height: 2.4,
            color: Color.fromRGBO(255, 131, 96, 1),
            margin: EdgeInsets.only(bottom: 8.0),
          ),
          GridView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 16.0,
              mainAxisSpacing: 16.0,
            ),
            itemCount: widget.products.length,
            itemBuilder: (context, index) {
              final product = widget.products[index];
              return GestureDetector(
                onTap: () async {
                  bool alreadyOwned =
                      await checkOwnership(product['imagePath']!);
                  int productPrice = int.parse(product['price']!);

                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                        content: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              height: 100.0,
                              child: Image.asset(
                                product['imagePath']!,
                                fit: BoxFit.cover,
                              ),
                            ),
                            SizedBox(height: 8.0),
                            Text(
                              product['name']!,
                              style: TextStyle(
                                fontSize: 18.0,
                                fontFamily: 'Pines',
                                color: Color.fromRGBO(68, 74, 79, 1),
                              ),
                              textAlign: TextAlign.center,
                            ),
                            SizedBox(height: 4.0),
                            Text(
                              '\$${product['price']}',
                              style: TextStyle(
                                fontSize: 14.0,
                                fontFamily: 'Pines',
                                color: Color.fromRGBO(68, 74, 79, 1),
                              ),
                              textAlign: TextAlign.center,
                            ),
                            SizedBox(height: 8.0),
                            Text(
                              product['description']!,
                              style: TextStyle(
                                fontSize: 14.0,
                                fontFamily: 'Pines',
                                color: Color.fromRGBO(68, 74, 79, 1),
                              ),
                              textAlign: TextAlign.center,
                            ),
                            SizedBox(height: 16.0),
                            if (alreadyOwned)
                              Text(
                                'Item already owned',
                                style: TextStyle(
                                  fontSize: 14.0,
                                  fontFamily: 'Pines',
                                  color: Colors.red,
                                ),
                                textAlign: TextAlign.center,
                              )
                            else if (userFitopians < productPrice)
                              Text(
                                'Not enough points',
                                style: TextStyle(
                                  fontSize: 14.0,
                                  fontFamily: 'Pines',
                                  color: Colors.red,
                                ),
                                textAlign: TextAlign.center,
                              )
                            else
                              ElevatedButton(
                                onPressed: () {
                                  buyItem(product['imagePath']!, productPrice);

                                  Navigator.of(context).pop();
                                },
                                child: Text('Buy'),
                              ),
                          ],
                        ),
                        actions: <Widget>[
                          IconButton(
                            icon: Icon(Icons.close),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                        ],
                      );
                    },
                  );
                },
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15.0),
                    border: Border.all(
                      color: Color.fromRGBO(248, 153, 80, 1),
                      width: 2.0,
                    ),
                    color: Colors.white,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        height: 60.0,
                        child: Image.asset(
                          product['imagePath']!,
                          fit: BoxFit.cover,
                        ),
                      ),
                      SizedBox(height: 8.0),
                      Text(
                        product['name']!,
                        style: TextStyle(
                          fontSize: 18.0,
                          fontFamily: 'Pines',
                          color: Color.fromRGBO(68, 74, 79, 1),
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 4.0),
                      Text(
                        '\$${product['price']}',
                        style: TextStyle(
                          fontSize: 14.0,
                          fontFamily: 'Pines',
                          color: Color.fromRGBO(68, 74, 79, 1),
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
