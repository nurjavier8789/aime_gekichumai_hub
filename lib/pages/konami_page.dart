import 'package:flutter/material.dart';

import 'web_view_page_gamedataarcade.dart';
import 'web_view_page_cardmanage.dart';

class konami_page extends StatelessWidget {
  const konami_page({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Konami (e-amusement)"),
      ),
      body: Center(
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.only(top: 10, bottom: 10),
              child: Text("SOUND VOLTEX", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            ),
            FilledButton(
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(builder: (context) => WebViewPageGekiChuMai(regionVersion: "", game: "sdvx")));
              },
              child: Text("SOUND VOLTEX"),
            ),
            SizedBox(height: 15),
            FilledButton(
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(builder: (context) => WebViewPageGekiChuMai(regionVersion: "", game: "sdvxExceed")));
              },
              child: Text("SOUND VOLTEX EXCEED GEAR"),
            ),
            Divider(height: 50),
            Container(
              padding: EdgeInsets.only(bottom: 10),
              child: Text("beatmania", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            ),
            FilledButton(
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(builder: (context) => WebViewPageGekiChuMai(regionVersion: "", game: "bms")));
              },
              child: Text("beatmania IIDX"),
            ),
            Divider(height: 50),
            Container(
              padding: EdgeInsets.only(bottom: 10),
              child: Text("e-amusement pass", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            ),
            FilledButton(
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(builder: (context) => WebViewPageCardManage(provider: "eamusement",)));
              },
              child: Text("e-amusement"),
            ),
          ],
        ),
      ),
    );
  }
}
