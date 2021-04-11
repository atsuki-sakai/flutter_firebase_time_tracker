import 'package:flutter/material.dart';
import 'package:flutter_firebase/home/jobs/empty_content.dart';

typedef ItemWidgetBuilder<T> = Widget Function(BuildContext context, T item);

class ListItemsBuilder extends StatelessWidget {
  const ListItemsBuilder(
      {Key key, @required this.snapshot, @required this.itemBuilder})
      : super(key: key);
  final AsyncSnapshot<List<dynamic>> snapshot;
  final ItemWidgetBuilder itemBuilder;
  @override
  Widget build(BuildContext context) {
    if (snapshot.hasData) {
      final List<dynamic> items = snapshot.data;
      if (items.isNotEmpty) {
        return _buildList(items);
      } else {
        return EmptyContent();
      }
    } else if (snapshot.hasError) {
      return EmptyContent(
        title: 'Something went wrong',
        message: "can't not load items right now.",
      );
    }
    return Center(
      child: CircularProgressIndicator(),
    );
  }

  Widget _buildList(List<dynamic> items) {
    return ListView.separated(
      separatorBuilder: (context, index) => Divider(
        thickness: 0.7,
      ),
      itemCount: items.length,
      itemBuilder: (context, index) {
        return itemBuilder(
          context,
          items[index],
        );
      },
    );
  }
}
