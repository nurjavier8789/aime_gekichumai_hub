import 'package:aime_gekichumai_hub/pages/web_view_page_usefullink.dart';
import 'package:flutter/material.dart';

import 'web_view_page_gamedataarcade.dart';
import 'web_view_page_cardmanage.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text("AmuseLink"),
        ),
        body: Center(
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.only(top: 10, bottom: 10),
                child: Text("Quick Links", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              ),
              Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      FilledButton(
                        onPressed: () {
                          Navigator.of(context).push(MaterialPageRoute(builder: (context) => WebViewPageGekiChuMai(regionVersion: "GLOBAL", game: "maimai")));
                        },
                        child: Text("maimai DX"),
                      ),
                      FilledButton(
                        onPressed: () {
                          Navigator.of(context).push(MaterialPageRoute(builder: (context) => WebViewPageGekiChuMai(regionVersion: "GLOBAL", game: "chunithm")));
                        },
                        child: Text("CHUNITHM"),
                      ),
                    ],
                  ),
                  SizedBox(height: 25),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      FilledButton(
                        onPressed: () {
                          Navigator.of(context).push(MaterialPageRoute(builder: (context) => WebViewPageGekiChuMai(regionVersion: "", game: "taiko")));
                        },
                        child: Text("Taiko No Tatsujin"),
                      ),
                      FilledButton(
                        onPressed: () {
                          Navigator.of(context).push(MaterialPageRoute(builder: (context) => WebViewPageGekiChuMai(regionVersion: "", game: "sdvxNabla")));
                        },
                        child: Text("SOUND VOLTEX"),
                      ),
                    ],
                  ),
                ],
              ),
              Divider(height: 50),
              Container(
                padding: EdgeInsets.only(bottom: 10),
                child: Text("Card Management", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  FilledButton(
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(builder: (context) => WebViewPageCardManage(provider: "myAime",)));
                    },
                    child: Text("My Aime"),
                  ),
                  FilledButton(
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(builder: (context) => WebViewPageCardManage(provider: "banapass",)));
                    },
                    child: Text("Banapass"),
                  ),
                  FilledButton(
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(builder: (context) => WebViewPageCardManage(provider: "eamusement",)));
                    },
                    child: Text("e-amusement"),
                  ),
                ],
              ),
              Divider(height: 50),
              Container(
                padding: EdgeInsets.only(bottom: 10),
                child: Text("Useful Links", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  FilledButton(
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(builder: (context) => WebViewPageUsefullink(whatdoyouwant: "song_list")));
                    },
                    child: Text("Song list"),
                  ),
                  FilledButton(
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(builder: (context) => WebViewPageUsefullink(whatdoyouwant: "arcade_locator")));
                    },
                    child: Text("Arcade Locator"),
                  ),
                ],
              ),
            ],
          ),
        ),
    );
  }
}
