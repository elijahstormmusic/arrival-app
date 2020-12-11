/// Code written and created by Elijah Storm
// Copywrite April 5, 2020
// for use only in ARRIVAL Project

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/widgets.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:photo_view/photo_view.dart';
import 'package:share/share.dart';

import '../data/app_state.dart';
import '../data/link.dart';
import '../data/preferences.dart';
import '../posts/post.dart';
import '../users/profile.dart';
import '../users/page.dart';
import '../users/data.dart';
import '../data/arrival.dart';
import '../data/socket.dart';
import '../styles.dart';
import '../const.dart';
import 'comments.dart';
import 'options.dart';
import 'video.dart';


class PostDisplay extends StatefulWidget {
  Post post;
  bool scrollable;

  PostDisplay(@required this.post, {this.scrollable = false}) : assert(post!=null);

  PostDisplay.video();

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

  Preferences prefs;

  @override
  void initState() {
    super.initState();
    prefs = ScopedModel.of<Preferences>(context);
    _commentAdder = CommentAdder(widget.post, this);
    loader();
  }
  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
  void loader() async {
    bool answer = await prefs.isLikedContent(0, widget.post.cryptlink);
    if (this.mounted) setState(() => _clientHasLikedPost = answer);
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
    if (widget.post.caption=='') return Container();

    return Container(
      padding: EdgeInsets.fromLTRB(0, 0, 0, _padding),
      child: _buildComment({
        'username': widget.post.user==null
          ? 'no user'
          : widget.post.user.name,
        'user': widget.post.user,
        'content': widget.post.caption,
      }),
    );
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

  bool _enactingPostInteraction = false;
  void _likePost() {
    if (_clientHasLikedPost) return;

    if (this.mounted) setState(() => _clientHasLikedPost = true);

    prefs.addLikedContent(0, widget.post.cryptlink);

    socket.emit('posts liked content', {
      'link': widget.post.cryptlink,
      'user': UserData.client.cryptlink,
    });

    prefs.addNotificationHistory({
      'icon': Styles.heart_full,
      'label': 'Gave a heart',
      'value': 1,
      'type': 0,
      'link': widget.post.cryptlink,
    });
  }
  void _unlikePost() {
    if (!_clientHasLikedPost) return;

    if (this.mounted) setState(() => _clientHasLikedPost = false);

    prefs.removeLikedContent(0, widget.post.cryptlink);

    socket.emit('posts liked content', {
      'link': widget.post.cryptlink,
      'user': UserData.client.cryptlink,
      'unliked': true,
    });

    prefs.removeNotificationHistory(0, widget.post.cryptlink);
  }
  void _toggleLikePost() async {
    setState(() => _clientHasLikedPost = !_clientHasLikedPost);

    if (_enactingPostInteraction) return;

    _enactingPostInteraction = true;

    await Future.delayed(Duration(milliseconds: 1000));

    if (_clientHasLikedPost) {
      _clientHasLikedPost = false;
      _likePost();
    }
    else {
      _clientHasLikedPost = true;
      _unlikePost();
    }

    _enactingPostInteraction = false;
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
                    ? Styles.ArrivalPalletteRed
                    : Styles.ArrivalPalletteBlack,
                  size: _buttonSize,
                ),
                onTap: _toggleLikePost,
              ),
            ),
            Expanded(
              flex: 1,
              child: GestureDetector(
                child: Icon(
                  Styles.comment,
                  size: _buttonSize,
                  color: Styles.ArrivalPalletteBlack,
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
                  color: Styles.ArrivalPalletteRed,
                ),
                onTap: () {
                  final RenderBox box = context.findRenderObject();
                  Share.share(
                    Constants.site + 'p?${widget.post.cryptlink}',
                    subject: 'See More on Arrival',
                    sharePositionOrigin:
                      box.localToGlobal(Offset.zero) & box.size,
                  );
                },
              ),
            ),
          ],
        ),
        SizedBox(height: _padding),
        (widget.post.likes==0
          && widget.post.comments.length==0)
          ? Container()
          : _buildLikesDisplay(),
        _buildCaption(),
        _buildShortCommentList(widget.post.comments, widget.post.client_comments),
        (widget.post.comments.length>0) ? GestureDetector(
          onTap: () => _openCommentsPage(context),
          child: Container(
            height: 26,
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
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
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
                    backgroundImage: NetworkImage(user.media_href()),
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
        ),

        SizedBox(width: 4),

        widget.post.user.cryptlink == UserData.client.cryptlink ? Container() :
        GestureDetector(
          onTap: () async {
            await prefs.toggleBookmarked(DataType.profile, widget.post.user.cryptlink);
            setState(() => 0);

            socket.emit('userdata follow', {
              'user': UserData.client.cryptlink,
              'follow': widget.post.user.cryptlink,
              'action': await prefs.isBookmarked(DataType.profile, widget.post.user.cryptlink),
            });
          },
          child: FutureBuilder<bool>(
            future: prefs.isBookmarked(DataType.profile, widget.post.user.cryptlink),
            builder: (BuildContext context, AsyncSnapshot<bool> snapshot) =>
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: 8,
                // vertical: 6,
              ),
              height: 50,
              child: Center(
                child: Text(
                  snapshot.hasData ?
                    (snapshot.data ? '' : 'Follow')
                    : 'Follow',
                  style: Styles.activeTabButtonRed,
                ),
              ),
            ),
          ),
        ),
      ],
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
              children: <Widget>[
                GestureDetector(
                  onTap: () => commentsList[index - 1]['user'].navigateToProfile(),
                  child: Container(
                    padding: EdgeInsets.all(_commonCommentPadding),
                    child: CircleAvatar(
                      radius: _profilePicSize,
                      // backgroundImage: NetworkImage(widget.post.user.media_href()),
                      backgroundImage: NetworkImage(commentsList[index - 1]['user'].media_href()),
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

    var _postDisplay;
    if (widget.post.type==0) {
      _postDisplay = PhotoView(
        imageProvider: NetworkImage(widget.post.media_href()),
        maxScale: PhotoViewComputedScale.contained,
        minScale: PhotoViewComputedScale.contained,
        initialScale: PhotoViewComputedScale.contained,
      );
    }
    else if (widget.post.type==1) {
      // TO DO: Make so all posts display, right now only first one displays
      _postDisplay = SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            PhotoView(
              imageProvider: NetworkImage(widget.post.media_href()),
              maxScale: PhotoViewComputedScale.contained,
              minScale: PhotoViewComputedScale.contained,
              initialScale: PhotoViewComputedScale.contained,
            ),
            // plus more
          ],
        ),
      );
    }
    else if (widget.post.type==2) {
      _postDisplay = ArrivalVideoPlayer(widget.post.media_href(), widget.post.height);
    }
    else _postDisplay = Styles.ArrivalErrorPage('Problem loading post: AP300');

    var resizedHeight = MediaQuery.of(context).size.width / widget.post.width * widget.post.height;
    var postContents = [
      Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _profileDisplay(
            (widget.post.user==null)
            ? Profile.empty
            : widget.post.user
          ),
          Container(),
          GestureDetector(
            onTap: () {
              showDialog<void>(context: context, builder: (context) => PostOptions(prefs, widget.post));
            },
            child: Container(
              margin: EdgeInsets.only(right: 10.0),
              child: Icon(
                Icons.more_vert,
                color: Styles.ArrivalPalletteGrey,
              ),
            )
          ),
        ],
      ),
      Container(
        height: resizedHeight,
        width: MediaQuery.of(context).size.width,
        child: GestureDetector(
          onDoubleTap: _likePost,
          child: _postDisplay,
        ),
      ),
      Padding(
        padding: const EdgeInsets.fromLTRB(15, 5, 15, 0),
        child: _drawSupportingElements(context),
      ),
      widget.scrollable ? SizedBox(height: 20) : Container(),
    ];

    return widget.scrollable ? Scaffold(
      body: PhysicalModel(
        elevation: 5,
        shape: BoxShape.rectangle,
        shadowColor: Styles.ArrivalPalletteBlack,
        color: Styles.ArrivalPalletteWhite,
        child: ListView(
          children: postContents,
        ),
      ),
    ) : PhysicalModel(
      elevation: 5,
      shape: BoxShape.rectangle,
      shadowColor: Styles.ArrivalPalletteBlack,
      color: Styles.ArrivalPalletteWhite,
      child: Column(
        children: postContents,
      ),
    );
  }
}
