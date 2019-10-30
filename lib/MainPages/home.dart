import 'dart:async';

import 'package:flutter/material.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';

class HomeScreen extends StatelessWidget {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();

  static final List<String> _items = <String>[
    'A',
    'B',
    'C',
    'D',
    'E',
    'F',
    'G',
    'H',
    'I',
    'J',
    'K',
    'L',
    'M',
    'N'
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LiquidPullToRefresh(
        showChildOpacityTransition: false,
        key: _refreshIndicatorKey,
        onRefresh: _handleRefresh,
        child: ListView.builder(
          padding: kMaterialListPadding,
          itemCount: _items.length,
          itemBuilder: (BuildContext context, int index) {
            final String item = _items[index];
            return ListTile(
              isThreeLine: true,
              leading: CircleAvatar(child: Text(item)),
              title: Text('This item represents $item.'),
              subtitle: const Text(
                  'Even more additional list item information appears on line three.'),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.edit),
        onPressed: () {
          Navigator.pushNamed(context, 'edit_msg_page');
        },
      ),
    );
  }

  Future<void> _handleRefresh() {
    final Completer<void> completer = Completer<void>();
    Timer(const Duration(seconds: 3), () {
      completer.complete();
    });
    return completer.future.then<void>((_) {
      _scaffoldKey.currentState?.showSnackBar(SnackBar(
          content: const Text('Refresh complete'),
          action: SnackBarAction(
              label: 'RETRY',
              onPressed: () {
                _refreshIndicatorKey.currentState.show();
              })));
    });
  }
}
