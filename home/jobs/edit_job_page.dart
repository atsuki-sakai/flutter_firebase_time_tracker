import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase/conponets_widgets/show_alert_dialog.dart';
import 'package:flutter_firebase/conponets_widgets/show_exception_alert.dart';
import 'package:flutter_firebase/home/models/job.dart';
import 'package:flutter_firebase/service/database.dart';
import 'package:provider/provider.dart';

class EditJobPage extends StatefulWidget {
  const EditJobPage({Key key, @required this.database, this.job})
      : super(key: key);
  final Database database;
  final Job job;

  // 自身に画面遷移のメソッドを持つことができる
  static Future<void> show(BuildContext context,
      {Job job, Database database}) async {
    // ! TODO - このメソッドはjobsPageで呼ばれるためProvider.of<Database>of(context);が使える。
    // final database = Provider.of<Database>(context, listen: false);
    await Navigator.of(context, rootNavigator: true).push(
      MaterialPageRoute(
        builder: (context) {
          return EditJobPage(
            database: database,
            job: job,
          );
        },
        fullscreenDialog: true,
      ),
    );
  }

  @override
  _EditJobPageState createState() => _EditJobPageState();
}

class _EditJobPageState extends State<EditJobPage> {
  Database get database => widget.database;
  final _formKey = GlobalKey<FormState>();
  String _name;
  int _ratePerHour;

  @override
  void initState() {
    super.initState();

    if (widget.job != null) {
      _name = widget.job.name;
      _ratePerHour = widget.job.ratePerHour;
    }
  }

  bool _validateAndSaveForm() {
    final form = _formKey.currentState;
    if (form.validate()) {
      form.save();
      return true;
    }
    return false;
  }

  Future<void> _submit() async {
    FocusScope.of(context).unfocus();
    if (_validateAndSaveForm()) {
      try {
        // ! database にあるjobを全て取得 stram型なのでawait必須
        final jobs = await database.jobsStream().first;
        // 同じ名前のjobは排除する
        final allName = jobs.map((job) => job.name).toList();
        final id = widget.job?.id ?? documentIdFromCurrentDate();
        final newJob = Job(name: _name, ratePerHour: _ratePerHour, id: id);
        if (widget.job != null) {
          print('remove ${widget.job.name}');
          allName.remove(widget.job.name);
        }
        if (allName.contains(newJob.name)) {
          print(allName);
          showAlertDialog(context,
              title: 'Name already used.',
              content: 'Please choose a different job name.',
              defaultActionText: 'Ok');
        } else {
          await database.setJob(newJob);
          _formKey.currentState.reset();
          Navigator.pop(context);
        }
      } on FirebaseException catch (e) {
        showExceptionAlertDialog(context, title: 'Add Job Error', exception: e);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.job == null ? 'New Jobs' : 'Edit Jobs'),
        elevation: 2.0,
        actions: [
          TextButton(
            onPressed: _submit,
            child: Text(
              'Save',
              style: TextStyle(color: Colors.white, fontSize: 16.0),
            ),
          ),
        ],
      ),
      body: _buildContents(context),
      backgroundColor: Colors.grey.shade200,
    );
  }

  Widget _buildContents(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: _buildForm(context),
          ),
        ),
      ),
    );
  }

  Widget _buildForm(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: _buildFormChildren(context),
      ),
    );
  }

  List<Widget> _buildFormChildren(BuildContext context) {
    return [
      TextFormField(
        initialValue: _name != null ? _name : null,
        decoration: InputDecoration(
          labelText: 'Job Name',
        ),
        validator: (value) =>
            value.isNotEmpty ? null : "name can't be empty...",
        onSaved: (value) => _name = value,
      ),
      TextFormField(
        initialValue: _ratePerHour != null ? _ratePerHour.toString() : null,
        decoration: InputDecoration(
          labelText: 'Rate per hour',
        ),
        validator: (value) =>
            value.isNotEmpty ? null : "Rate per hour can't be empty...",
        onSaved: (value) => _ratePerHour = int.parse(value),
        keyboardType:
            TextInputType.numberWithOptions(signed: false, decimal: false),
      ),
    ];
  }
}
