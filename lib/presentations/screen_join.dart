import 'package:flutter/material.dart';

import 'package:jitsi_meet/jitsi_meet.dart';

class Join extends StatefulWidget {
  @override
  _JoinState createState() => _JoinState();
}

class _JoinState extends State<Join> {
  final _formKey = GlobalKey<FormState>();
  String _formMeetingId = '';

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.all(40),
            child: Form(
              key: _formKey,
              child: TextFormField(
                onSaved: (value) => _formMeetingId = value,
                decoration: InputDecoration(
                  labelText: 'Enter a MeetingID',
                ),
                validator: (value) {
                  if (value.isEmpty) return "Enter Meeting ID";
                  return null;
                },
              ),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              onPrimary: Colors.black87,
              primary: Colors.grey[300],
              minimumSize: Size(88, 36),
              padding: EdgeInsets.symmetric(horizontal: 16),
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(2)),
              ),
            ),
            onPressed: () => _joinMeeting(),
            child: Text('Join Meeting'),
          )
        ],
      ),
    );
  }

  _joinMeeting() async {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      try {
        print(_formMeetingId);
        var options = JitsiMeetingOptions()..room = _formMeetingId;

        await JitsiMeet.joinMeeting(options);
      } catch (error) {
        debugPrint("error: $error");
      }
    }
  }
}
