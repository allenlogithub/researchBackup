import 'package:flutter/material.dart';

import 'package:web3dart1/widgets/balance.dart';
import 'package:web3dart1/widgets/ownedNFT.dart';

class Main extends StatefulWidget {
  const Main({Key? key}) : super(key: key);

  @override
  _MainState createState() => _MainState();
}

class _MainState extends State<Main> {
  int _bottomNavigationBarIndex = 0;

  void _bottomNavigationBarTapped(int index) {
    setState(() {
      _bottomNavigationBarIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: IndexedStack(
        index: _bottomNavigationBarIndex,
        children: const <Widget>[
          Balance(),
          OwnedNFT(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
              icon: Icon(Icons.monetization_on_outlined), label: 'Balance'),
          BottomNavigationBarItem(
              icon: Icon(Icons.shopping_bag_outlined), label: 'NFTs'),
          // BottomNavigationBarItem(icon: Icon(Icons.group), label: 'Network'),
        ],
        currentIndex: _bottomNavigationBarIndex,
        onTap: _bottomNavigationBarTapped,
        fixedColor: Colors.white,
      ),
    );
  }
}
