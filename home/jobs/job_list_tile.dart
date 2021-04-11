import 'package:flutter/material.dart';
import 'package:flutter_firebase/home/models/job.dart';

class JobListTile extends StatelessWidget {
  JobListTile({Key key, @required this.job, @required this.onTap})
      : super(key: key);

  final Job job;
  final VoidCallback onTap;
  List get dateList => job.id.substring(0, 16).split('T');
  @override
  Widget build(BuildContext context) {
    final postDay = dateList[0];
    final postTime = dateList[1];
    return ListTile(
      title: Text(job.name),
      subtitle: Text('Post: $postDay $postTime'),
      onTap: onTap,
      trailing: Icon(Icons.chevron_right),
    );
  }
}
