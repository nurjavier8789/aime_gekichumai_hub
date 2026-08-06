import 'package:flutter/material.dart';

import 'web_view_page_gamedataarcade.dart';
import 'web_view_page_cardmanage.dart';

class bandai_page extends StatelessWidget {
  const bandai_page({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Bandai Namco (Banapass)"),
      ),
      body: Center(
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.only(top: 10, bottom: 10),
              child: Text("Japan version only", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            ),
            FilledButton(
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(builder: (context) => WebViewPageGekiChuMai(regionVersion: "", game: "taiko")));
              },
              child: Text("Taiko No Tatsujin"),
            ),
            SizedBox(height: 15),
            FilledButton(
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(builder: (context) => WebViewPageGekiChuMai(regionVersion: "", game: "taikoGuide")));
              },
              child: Text("Donder Hiroba User Guide"),
            ),
            Divider(height: 50),
            Container(
              padding: EdgeInsets.only(bottom: 10),
              child: Text("Bandai Namco Passport", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            ),
            FilledButton(
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(builder: (context) => WebViewPageCardManage(provider: "banapass",)));
              },
              child: Text("Banapass"),
            ),
          ],
        ),
      ),
    );
  }
}

