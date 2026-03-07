import 'package:flutter/material.dart';

import 'web_view_page_gekichumai.dart';
import 'web_view_page_myaime.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text("AiKiChuMai Hub"),
        ),
        body: Center(
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.only(top: 10, bottom: 10),
                child: Text("International version", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              ),
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
                    child: Text("Chunithm"),
                  )
                ],
              ),
              Divider(height: 50),
              Container(
                padding: EdgeInsets.only(bottom: 10),
                child: Text("Japan version", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  FilledButton(
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(builder: (context) => WebViewPageGekiChuMai(regionVersion: "JAPAN", game: "maimai")));
                    },
                    child: Text("maimai DX"),
                  ),
                  FilledButton(
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(builder: (context) => WebViewPageGekiChuMai(regionVersion: "JAPAN", game: "chunithm")));
                    },
                    child: Text("Chunithm"),
                  ),
                  FilledButton(
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(builder: (context) => WebViewPageGekiChuMai(regionVersion: "JAPAN", game: "ongeki")));
                    },
                    child: Text("O.N.G.E.K.I."),
                  )
                ],
              ),
              Divider(height: 50),
              Container(
                padding: EdgeInsets.only(bottom: 10),
                child: Text("My Aime", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              ),
              FilledButton(
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(builder: (context) => WebViewPageMyAime()));
                    },
                    child: Text("My Aime"),
                  ),
            ],
          ),
        ),
    );
  }
}
