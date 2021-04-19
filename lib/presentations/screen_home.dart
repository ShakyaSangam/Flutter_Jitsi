import 'package:flutter/material.dart';
import 'package:near/logic/providers/provider_meeting.dart';
import 'package:provider/provider.dart';

import 'package:share/share.dart';
import 'package:jitsi_meet/jitsi_meet.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final _formKey = GlobalKey<FormState>();
  String _formMeetingName = '';
  // bool _isLoading = true;

  @override
  void initState() {
    Provider.of<MeetingsProvider>(context, listen: false).getAll();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<MeetingsProvider>(
      builder: (BuildContext context, meetingProvider, Widget child) {
        return Scaffold(
          body: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                SizedBox(
                  height: 20,
                ),
                Container(
                  margin: EdgeInsets.all(20),
                  child: meetingProvider.listMeetings.length > 0
                      ? ListView.builder(
                          shrinkWrap: true,
                          itemCount: meetingProvider.listMeetings.length,
                          itemBuilder: (BuildContext context, int index) {
                            return Container(
                              padding: EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: Colors.redAccent,
                                  width: 1.2,
                                ),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10)),
                              ),
                              child: ListTile(
                                title: Text(
                                  meetingProvider.listMeetings[index]['name'],
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 24,
                                  ),
                                ),
                                subtitle: Column(
                                  children: [
                                    Align(
                                      alignment: Alignment.bottomLeft,
                                      child: Text(
                                        meetingProvider.listMeetings[index]
                                            ['meeting'],
                                        style: TextStyle(
                                            fontWeight: FontWeight.w600,
                                            fontSize: 14,
                                            color: Color(0xff585f6b)),
                                      ),
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        Row(
                                          children: [
                                            MaterialButton(
                                              height: 40,
                                              minWidth: 40,
                                              color: Color(0xff252d34),
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 16),
                                              shape:
                                                  const RoundedRectangleBorder(
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(10)),
                                              ),
                                              onPressed: () => meetingProvider
                                                  .removeMeeting(meetingProvider
                                                          .listMeetings[index]
                                                      ['meeting']),
                                              child: Icon(
                                                Icons.delete,
                                                size: 15,
                                                color: Colors.white,
                                              ),
                                            ),
                                            SizedBox(
                                              width: 5,
                                            ),
                                            MaterialButton(
                                              height: 40,
                                              minWidth: 40,
                                              color: Color(0xff252d34),
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 16),
                                              shape:
                                                  const RoundedRectangleBorder(
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(10)),
                                              ),
                                              onPressed: () => {
                                                Share.share(
                                                    'Join me MeetingID: ' +
                                                        meetingProvider
                                                                .listMeetings[
                                                            index]['meeting'])
                                              },
                                              child: Icon(
                                                Icons.share,
                                                size: 15,
                                                color: Colors.white,
                                              ),
                                            ),
                                          ],
                                        ),
                                        Align(
                                          alignment: Alignment.bottomRight,
                                          child: MaterialButton(
                                              height: 47,
                                              minWidth: 85,
                                              color: Color(0xfffb4d4c),
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 16),
                                              shape:
                                                  const RoundedRectangleBorder(
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(10)),
                                              ),
                                              onPressed: () => _joinMeeting(
                                                  meetingProvider
                                                          .listMeetings[index]
                                                      ['meeting']),
                                              child: Text(
                                                'Join',
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 16),
                                              )),
                                        )
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        )
                      : Image.asset("assets/images/slide_1.jpg"),
                )
              ],
            ),
          ),
          floatingActionButton: FloatingActionButton(
            backgroundColor: Color(0xfffb4d4c),
            onPressed: () => _meetingForm(context),
            child: Icon(
              Icons.add_call,
              color: Colors.white,
            ),
          ),
        );
      },
    );
  }

  // ignore: unused_element
  _joinMeeting(meetingid) async {
    try {
      var options = JitsiMeetingOptions()..room = meetingid;

      await JitsiMeet.joinMeeting(options);
    } catch (error) {
      debugPrint("error: $error");
    }
  }

  _meetingForm(context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => Padding(
        padding: MediaQuery.of(context).viewInsets,
        child: Container(
          padding: EdgeInsets.all(10),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              SizedBox(height: 20),
              Form(
                key: _formKey,
                child: Wrap(
                  children: <Widget>[
                    TextFormField(
                      onSaved: (value) => _formMeetingName = value,
                      decoration: InputDecoration(labelText: "Meeting Name"),
                      validator: (value) {
                        if (value.isEmpty) return "Enter Meeting Name";
                        return null;
                      },
                    ),
                  ],
                ),
              ),
              SizedBox(height: 10),
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
                onPressed: () => _createMeeting(context),
                child: Text('Create Meeting'),
              )
            ],
          ),
        ),
      ),
    );
  }

  _createMeeting(context) {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();

      Provider.of<MeetingsProvider>(context, listen: false)
          .addMeeting(_formMeetingName);
      Navigator.pop(context);
    }
  }
}
