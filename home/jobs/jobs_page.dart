import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase/conponets_widgets/show_exception_alert.dart';
import 'package:flutter_firebase/home/job_entries/job_entries_page.dart';
import 'package:flutter_firebase/home/jobs/job_list_tile.dart';
import 'package:flutter_firebase/home/jobs/list_item_builder.dart';
import 'package:flutter_firebase/home/models/job.dart';
import 'package:flutter_firebase/service/auth.dart';
import 'package:flutter_firebase/conponets_widgets/show_alert_dialog.dart';
import 'package:flutter_firebase/service/database.dart';
import 'package:provider/provider.dart';
import 'list_item_builder.dart';
import 'edit_job_page.dart';

class JobsPage extends StatelessWidget {

  Future<void> _delete(BuildContext context, Job job) async {
    try {
      final database = Provider.of<Database>(context, listen: false);
      await database.deleteJob(job);
    } on FirebaseException catch (e) {
      showExceptionAlertDialog(context, title: 'Operate failer.', exception: e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text('Jobs'),
        actions: [
          IconButton(
            icon: IconButton(
              icon: Icon(Icons.add, color: Colors.white,),
              onPressed: () => EditJobPage.show(
                context,
                database: Provider.of<Database>(
                  context,
                  listen: false,
                ),
              ),
            ),
          ),
        ],
      ),
      body: _buildContent(context),
    );
  }

  Widget _buildContent(BuildContext context) {
    final database = Provider.of<Database>(context);
    // ! StreamBuilderではsteamに渡す値でキャストする。 =>  StreamBuilder<streamに渡した型>
    return StreamBuilder<List<Job>>(
      stream: database.jobsStream(),
      builder: (context, snapShot) {
        return ListItemsBuilder(
          snapshot: snapShot,
          itemBuilder: (context, job) {
            return Dismissible(
              key: Key('job-${job.id}'),
              background: Container(
                color: Colors.red,
              ),
              direction: DismissDirection.endToStart,
              onDismissed: (direction) => _delete(context, job),
              child: JobListTile(
                job: job,
                onTap: () => JobEntriesPage.show(context, job),
              ),
            );
          },
        );
      },
    );
  }
}
