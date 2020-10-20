/// Code written and created by Elijah Storm
// Copywrite April 5, 2020
// for use only in ARRIVAL Project

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/widgets.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:photo_view/photo_view.dart';

import '../data/app_state.dart';
import '../data/link.dart';
import '../posts/post.dart';
import '../users/profile.dart';
import '../users/page.dart';
import '../users/data.dart';
import '../data/arrival.dart';
import '../data/socket.dart';
import '../styles.dart';
import 'comments.dart';
import 'video.dart';


class PostDisplay extends StatefulWidget {
  Post post;
  bool scrollable;

  PostDisplay(@required this.post, {this.scrollable = false}) : assert(post!=null);

  @override
  _PostDisState createState() => _PostDisState();
}
class _PostDisState extends State<PostDisplay> {
  bool _clientHasLikedPost = false;
  final _padding = 7.0;
  final _lineSize = 3.0;
  double _buttonSize = 35.0;
  int _page = 0;
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
    super.dispose();
  }

  void redraw() {
    setState(() => 0);
  }


  String _addPluralS(int amount) {
    if (amount>1) return 's';
    return '';
  }
  Widget _buildLikesDisplay() {
    int currentLikes =
      widget.post.likes + (_clientHasLikedPost ? 1 : 0);
    int commentAmt = widget.post.comments.length;

    return Row(
      children: [
        Text(
          _showTimeSinceDate(widget.post.uploadDate) + '   ',
          style: Styles.postText,
        ),
        Text.rich(
          TextSpan(
            style: Styles.postText,
            children: [
              TextSpan(
                text:
                (currentLikes==0) ? '' :
                currentLikes.toString() + ' like' + _addPluralS(currentLikes),
                style: TextStyle(
                  fontStyle: FontStyle.italic,
                  fontWeight: FontWeight.w700,
                ),
              ),
              TextSpan(
                text:
                commentAmt==0 ? '' :
                ((currentLikes==0 ? '' : ' & ')
                + commentAmt.toString()
                + ' comment' + _addPluralS(commentAmt)),
                style: TextStyle(
                  fontStyle: FontStyle.italic,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          textAlign: TextAlign.left,
        ),
      ],
    );
  }
  Widget _buildComment(Map<String, dynamic> _comment) {
    if (_comment==null) return Container();
    return Text.rich(
      TextSpan(
        style: Styles.postText,
        children: [
          TextSpan(
            text: _comment['username']
            + '  ',
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
  Widget _buildShortCommentList(List<Map<String, dynamic>> commentsList, List<Map<String, dynamic>> client_comments) {
    int maxShortDisplay = 3;
    int commentLimit = commentsList.length<maxShortDisplay ? commentsList.length : maxShortDisplay;
    List<Widget> shortDisplay = List<Widget>();

    for (int i=0;i<commentLimit;i++) {
      shortDisplay.add(_buildComment(commentsList[i]));
    }

    for (int i=0;i<client_comments.length;i++) {
      shortDisplay.add(_buildComment(client_comments[i]));
    }

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: shortDisplay,
    );
  }

  void _openCommentsPage(BuildContext context) {
    Arrival.navigator.currentState.push(MaterialPageRoute(
      builder: (context) => CommentsPage(widget.post),
      fullscreenDialog: true,
    ));
  }
  void _loadMore() {
    socket.emit('posts get comments', {
      'link': widget.post.cryptlink,
      'page': ++_page,
    });
  }
  void _loadReplies(String reply_index) {
    socket.emit('posts get comments', {
      'link': widget.post.cryptlink,
      'page': _page,
      'reply': reply_index,
    });
  }

  void _likePost() {
    setState(() => _clientHasLikedPost = !_clientHasLikedPost);
  }
  Widget _drawSupportingElements(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: <Widget>[
            Expanded(
              flex: 1,
              child: GestureDetector(
                child: Icon(
                  _clientHasLikedPost
                    ? Styles.heart_full
                    : Styles.heart,
                  color: _clientHasLikedPost
                    ? Colors.red
                    : Colors.black,
                  size: _buttonSize,
                ),
                onTap: _likePost,
              ),
            ),
            Expanded(
              flex: 1,
              child: GestureDetector(
                child: Icon(
                  Styles.comment,
                  size: _buttonSize,
                  color: Colors.black,
                ),
                onTap: () => setState(() => _commentAdder.requestFocus()),
              ),
            ),
            Expanded(
              flex: 6,
              child: Container(),
            ),
            Expanded(
              flex: 1,
              child: GestureDetector(
                child: Icon(
                  Styles.share,
                  size: _buttonSize,
                  color: Colors.black,
                ),
                onTap: () => setState(() => _commentAdder.requestFocus()),
              ),
            ),
          ],
        ),
        SizedBox(height: _padding),
        (widget.post.likes==0
          && widget.post.comments.length==0)
          ? Container()
          : _buildLikesDisplay(),
        SizedBox(height: _padding),
        _buildCaption(),
        SizedBox(height: _padding*2),
        _buildShortCommentList(widget.post.comments, widget.post.client_comments),
        (widget.post.comments.length>0) ? GestureDetector(
          onTap: () => _openCommentsPage(context),
          child: Container(
            height: 50,
            child: Text.rich(
              TextSpan(
                style: Styles.postText,
                children: [
                  TextSpan(
                    text: 'Show all comments...',
                    style: TextStyle(
                      fontStyle: FontStyle.italic,
                      fontWeight: FontWeight.w500,
                    )
                  ),
                ],
              ),
              textAlign: TextAlign.left,
            ),
          ),
        ) : Container(),
        _commentAdder,
      ],
    );
  }
  Widget _profileDisplay(Profile user) {
    return GestureDetector(
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: 8,
          vertical: 6,
        ),
        height: 50,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.all(4.0),
              child: CircleAvatar(
                radius: 19.0,
                backgroundImage: NetworkImage(user.image_href()),
              ),
            ),
            Text(
              user.name,
              style: Styles.profileName
            ),
          ],
        ),
      ),
      onTap: () {
        Arrival.navigator.currentState.push(MaterialPageRoute(
          builder: (context) => ProfilePage.user(user),
          fullscreenDialog: true,
        ));
      },
    );
  }

  Widget _buildCommentsList(List<Map<String, dynamic>> commentsList) {
    double _commonCommentPadding = 10;
    double _profilePicSize = 25;

    return ListView.builder(
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
                          backgroundImage: NetworkImage(widget.post.user.image_href()),
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
              children: <Widget>[
                GestureDetector(
                  onTap: () => commentsList[index - 1]['user'].navigateToProfile(),
                  child: Container(
                    padding: EdgeInsets.all(_commonCommentPadding),
                    child: CircleAvatar(
                      radius: _profilePicSize,
                      // backgroundImage: NetworkImage(widget.post.user.image_href()),
                      backgroundImage: NetworkImage(commentsList[index - 1]['user'].image_href()),
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(_commonCommentPadding),
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

  @override
  Widget build(BuildContext context) {
    final appState = ScopedModel.of<AppState>(context, rebuildOnChange: true);
    final themeData = CupertinoTheme.of(context);

    var postContents = [
      _profileDisplay(
        (widget.post.user==null)
          ? Profile.empty
          : widget.post.user
      ),
      Container(
        height: 400,
        child: GestureDetector(
          onDoubleTap: _likePost,
          child: PhotoView(
            imageProvider: NetworkImage(widget.post.image_href()),
            maxScale: PhotoViewComputedScale.contained,
            minScale: PhotoViewComputedScale.contained,
            initialScale: PhotoViewComputedScale.contained,
          ),
        ),
      ),
      // widget.post.image(),
      Padding(
        padding: const EdgeInsets.fromLTRB(15, 5, 15, 0),
        child: _drawSupportingElements(context),
      ),
      widget.scrollable ? SizedBox(height: 20) : Container(),
    ];

    return widget.scrollable ? Scaffold(
      body: ListView(
        children: postContents,
      ),
    ) : Column(
      children: postContents,
    );
  }
}
