// Copyright 2020 The yjpark. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

// ignore_for_file: public_member_api_docs

import 'package:flutter/material.dart';
import 'map_view.dart';
import 'map_click.dart';
import 'map_coordinates.dart';
import 'page.dart';
import 'place_marker.dart';

final List<KakaoMapExampleAppPage> _allPages = <KakaoMapExampleAppPage>[
  MapViewPage(),
  MapCoordinatesPage(),
  MapClickPage(),
  PlaceMarkerPage(),
];

class MapsDemo extends StatelessWidget {
  void _pushPage(BuildContext context, KakaoMapExampleAppPage page) {
    Navigator.of(context).push(MaterialPageRoute<void>(
        builder: (_) => Scaffold(
              appBar: AppBar(title: Text(page.title)),
              body: page,
            )));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('KakaoMaps examples')),
      body: ListView.builder(
        itemCount: _allPages.length,
        itemBuilder: (_, int index) => ListTile(
          leading: _allPages[index].leading,
          title: Text(_allPages[index].title),
          onTap: () => _pushPage(context, _allPages[index]),
        ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(home: MapsDemo()));
}
