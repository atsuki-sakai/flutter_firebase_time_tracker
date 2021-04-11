import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_firebase/conponets_widgets/show_exception_alert.dart';
import 'package:flutter_firebase/home/job_entries/entry_list_item.dart';
import 'package:flutter_firebase/home/job_entries/entry_page.dart';
import 'package:flutter_firebase/home/jobs/edit_job_page.dart';
import 'package:flutter_firebase/home/jobs/list_item_builder.dart';
import 'package:flutter_firebase/home/models/entry.dart';
import 'package:flutter_firebase/home/models/job.dart';
import 'package:flutter_firebase/service/database.dart';
import 'package:provider/provider.dart';

class JobEntriesPage extends StatelessWidget {
  const JobEntriesPage({@required this.database, @required this.job});
  final Database database;
  final Job job;

  static Future<void> show(BuildContext context, Job job) async {
    final database = Provider.of<Database>(context, listen: false);
    await Navigator.of(context).push(
      //CupertinoPageRoute パララックスエフェクトになる
      CupertinoPageRoute(
        fullscreenDialog: false,
        builder: (context) => JobEntriesPage(database: database, job: job),
      ),
    );
  }

  Future<void> _deleteEntry(BuildContext context, Entry entry) async {
    try {
      await database.deleteEntry(entry);
    } on FirebaseException catch (e) {
      showExceptionAlertDialog(
        context,
        title: 'Operation failed',
        exception: e,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 2.0,
        title: StreamBuilder<Job>(
          stream: database.jobStream(jobId: job.id),
          builder: (context, snapshot) {
            final job = snapshot.data;
            final jobName = job?.name ?? 'No Name';
            return Text(jobName);
          }
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.edit, color: Colors.white,),
            onPressed: () =>
                EditJobPage.show(context, database: database, job: job),
          ),
          IconButton(
            icon: Icon(Icons.add, color: Colors.white,),
            onPressed: () =>
                EntryPage.show(context: context, database: database, job: job),
          ),
        ],
      ),
      body: _buildContent(context, job),
    );
  }

  Widget _buildContent(BuildContext context, Job job) {
    return StreamBuilder<List<Entry>>(
      stream: database.entriesStream(job: job),
      builder: (context, snapshot) {
        return ListItemsBuilder(
          snapshot: snapshot,
          itemBuilder: (context, entry) {
            return DismissibleEntryListItem(
              key: Key('entry-${entry.id}'),
              entry: entry,
              job: job,
              onDismissed: () => _deleteEntry(context, entry),
              onTap: () => EntryPage.show(
                context: context,
                database: database,
                job: job,
                entry: entry,
              ),
            );
          },
        );
      },
    );
  }
}
