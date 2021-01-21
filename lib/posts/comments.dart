/// Code written and created by Elijah Storm
// Copywrite April 5, 2020
// for use only in ARRIVAL Project

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:scoped_model/scoped_model.dart';

import '../posts/post.dart';
import '../users/data.dart';
import '../users/profile.dart';
import '../data/preferences.dart';
import '../data/socket.dart';
import '../styles.dart';


class CommentsPage extends StatefulWidget {
  Post post;

  CommentsPage(this.post);

  static final TextStyle usernameTextStyle = TextStyle(
                  fontStyle: FontStyle.normal,
                  fontWeight: FontWeight.bold,
                );

  @override
  _CommentsPState createState() => _CommentsPState();
}
class _CommentsPState extends State<CommentsPage> {
  final ScrollController _scrollController = ScrollController();
  CommentAdder _commentAdder;

  @override
  void initState() {
    super.initState();
    _commentAdder = CommentAdder(widget.post, this);
  }
  @override
  void dispose() {
    _scrollController.dispose();
  }

  void redraw() {
    setState(() => 0);
  }


  String _addPluralS(int amount) {
    if (amount>1) return 's';
    return '';
  }
  Widget _buildComment(Map<String, dynamic> _comment) {
    if (_comment==null) return Container();
    return Text.rich(
      TextSpan(
        style: Styles.postText,
        children: [
          TextSpan(
            text: _comment['user'].name + '  ',
            style: CommentsPage.usernameTextStyle,
            recognizer: new TapGestureRecognizer()..onTap = ()
                              => _comment['user'].navigateToProfile(),
          ),
          TextSpan(text: '  ' + _comment['content']),
        ],
      ),
      textAlign: TextAlign.left,
    );
  }
  Widget _buildCaption() {
    return _buildComment({
      'username': widget.post.user==null
                    ? 'no user'
                    : widget.post.user.name,
      'user': widget.post.user,
      'content': widget.post.caption,
    });
  }
  Widget _buildShortCommentList(List<Map<String, dynamic>> commentsList) {
    int maxShortDisplay = 3;
    int commentLimit = commentsList.length<maxShortDisplay ? commentsList.length : maxShortDisplay;
    List<Widget> shortDisplay = List<Widget>();

    for (int i=0;i<commentLimit;i++) {
      shortDisplay.add(_buildComment(commentsList[i]));
    }

    return Column(
      children: shortDisplay,
    );
  }

  String _showTimeSinceDate(DateTime date) {
    Duration timeSince = DateTime.now().difference(date);
    String output = 'just now';

    if (timeSince.inSeconds<0) return output;

    if (timeSince.inDays==0) {
      if (timeSince.inHours==0) {
        if (timeSince.inMinutes==0) {
          output = timeSince.inSeconds.toString() + ' second';
          if (timeSince.inSeconds>1) output+='s';
          output+=' ago';
        } else {
          output = timeSince.inMinutes.toString() + ' minute';
          if (timeSince.inMinutes>1) output+='s';
          output+=' ago';
        }
      } else {
        output = timeSince.inHours.toString() + ' hour';
        if (timeSince.inHours>1) output+='s';
        output+=' ago';
      }
    }
    else {
      if (timeSince.inDays>=365) {
        int years = timeSince.inDays ~/ 365;
        output = years.toString() + ' year';
        if (years>1) output+='s';
        output+=' ago';
      } else if (timeSince.inDays>=29) {
        int months = timeSince.inDays ~/ 30;
        output = months.toString() + ' month';
        if (months>1) output+='s';
        output+=' ago';
      } else {
        output = timeSince.inDays.toString() + ' day';
        if (timeSince.inDays>1) output+='s';
        output+=' ago';
      }
    }

    return output;
  }
  Widget _buildCommentsList(List<Map<String, dynamic>> commentsList) {
    double _commonCommentPadding = 10;
    double _profilePicSize = 20;

    return Container(
      padding: EdgeInsets.fromLTRB(0, 0, 0, 50),
      child: ListView.builder(
        physics: ClampingScrollPhysics(),
        itemCount: commentsList.length + 1,
        itemBuilder: (context, index) {
          return index==0
          ? Column(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical: 4,
                ),
                child: Row(
                  children: <Widget>[
                    GestureDetector(
                      onTap: () => widget.post.user.navigateToProfile(),
                      child: Container(
                        padding: EdgeInsets.all(_commonCommentPadding),
                        child: CircleAvatar(
                          radius: _profilePicSize,
                          backgroundImage: NetworkImage(widget.post.user.media_href()),
                        ),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.all(_commonCommentPadding),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildCaption(),
                          Text(
                            _showTimeSinceDate(widget.post.uploadDate),
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 4),
              Divider(height: 1.0, thickness: 1.0),
            ],
          )
          : Padding(
            padding: EdgeInsets.symmetric(
              horizontal: 8,
              vertical: 4,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                GestureDetector(
                  onTap: () => commentsList[index - 1]['user'].navigateToProfile(),
                  child: Container(
                    padding: EdgeInsets.all(_commonCommentPadding),
                    child: CircleAvatar(
                      radius: _profilePicSize,
                      backgroundImage: NetworkImage(commentsList[index - 1]['user'].media_href()),
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(_commonCommentPadding),
                  width: MediaQuery.of(context).size.width - 120,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildComment(commentsList[index - 1]),
                      Container(
                        width: MediaQuery.of(context).size.width - 150,
                        child: Row(
                          children: [
                            Expanded(
                              flex: 4,
                              child: Text(
                                _showTimeSinceDate(DateTime.parse(commentsList[index - 1]['date'])),
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 3,
                              child: Text(
                                commentsList[index - 1]['votes'].toString() + ' likes',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 2,
                              child: Text(
                                'reply',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(_commonCommentPadding),
                  child: Icon(Styles.heart),
                ),
              ],
            ),
          );
        },
        controller: _scrollController,
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        previousPageTitle: 'Back',
      ),
      child: Material(
        child: Stack(
          children: <Widget>[
            Container(
              height: MediaQuery.of(context).size.height - MediaQuery.of(context).padding.top,
              child: _buildCommentsList(widget.post.comments),
            ),
            Positioned(
              bottom: 0,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 16),
                width: MediaQuery.of(context).size.width,
                child: _commentAdder,
              ),
            ),
          ],
        ),
      ),
    );
  }
}


class CommentAdder extends StatefulWidget {
  Post post;
  dynamic source;
  _CommentAdderState _s;

  CommentAdder(this.post, this.source);

  void requestFocus() => _s.requestFocus();

  @override
  _CommentAdderState createState() {
    _s = _CommentAdderState();
    return _s;
  }
}
class _CommentAdderState extends State<CommentAdder> {
  final _textInputController = TextEditingController();
  final _focusNode = FocusNode();
  BuildContext recentContext;

  @override
  void initState() {
    _textInputController.addListener(_onTextChanged);
    super.initState();
  }
  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  void requestFocus() => _focusNode.requestFocus();

  bool _allowComment = true;
  void _sendCommentToServer() async {
    if (!_allowComment) return;

    var cleanedComment = _textInputController.text;

    if (cleanedComment=='') return;

    _allowComment = false;
    socket.emit('posts add comment', {
      'cryptlink': UserData.client.cryptlink,
      'username': UserData.client.name,
      'content': cleanedComment,
      'link': widget.post.cryptlink,
    });

    var comment_data = {
      'user': UserData.client,
      'username': UserData.client.name,
      'userlink': UserData.client.cryptlink,
      'content': _textInputController.text,
      'reply': null,
      'votes': 0,
      'date': DateTime.now().toString(),
    };
    widget.post.comments.add(comment_data);
    if (widget.post.client_comments.length>=2)
      widget.post.client_comments.removeAt(0);

    _focusNode.unfocus();
    setState(() => _textInputController.text = '');
    widget.source.redraw();

    UserData.client.earnPoints(15);
    await ScopedModel.of<Preferences>(recentContext)..addNotificationHistory({
      'label': 'Made a comment',
      'value': 15,
    });

    await Future.delayed(const Duration(seconds: 5));
    _allowComment = true;
  }
  void _onTextChanged() {
    if (true) return; // check if @ing someone and suggest
    setState(() => 3);
  }
  void _onSubmit(String input) {
    _sendCommentToServer();
  }


  Widget _buildCommentAdder() {
    return Container(
      padding: const EdgeInsets.fromLTRB(0, 0, 0, 8),
      child: Row(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(0, 2, 0, 0),
              child: TextField(
                controller: _textInputController,
                focusNode: _focusNode,
                minLines: 1,
                maxLines: 3,
                onSubmitted: _onSubmit,
                maxLength: 500,
                decoration: InputDecoration(
                  labelText: 'Comment...',
                ),
                style: TextStyle(
                  fontSize: 18,
                  color: Styles.ArrivalPalletteBlack,
                ),
                cursorColor: Styles.searchCursorColor,
              ),
            ),
          ),
          SizedBox(width: 8),
          GestureDetector(
            onTap: _sendCommentToServer,
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: Styles.ArrivalPalletteRed,
                borderRadius: BorderRadius.circular(3),
              ),
              child: Padding(
                padding: EdgeInsets.all(6),
                child: Text(
                  'SEND',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Styles.ArrivalPalletteWhite,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    recentContext = context;

    return _buildCommentAdder();
  }
}
