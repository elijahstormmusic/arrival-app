
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '../data/cards/partners.dart';
import '../posts/post.dart';
import '../posts/page.dart';
import '../users/profile.dart';
import '../users/data.dart';
import '../screens/home.dart';
import '../data/local.dart';
import '../data/arrival.dart';

class Data extends StatefulWidget {
  String _query;
  Data.userdata(String username, String password) {
    this._query = '?u:'+username+':'+password;
  }
  Data.saveinfo(String username, String password, ArrivalData data) {
    this._query = '?i:'+username+':'+password+':'+data.toString();
  }
  Data.partners(String _q) {
    this._query = '?p:'+_q;
  }
  Data.posts(String _q) {
    this._query = '?o:'+_q;
  }
  Data.post_data(String _link) {
    this._query = '?d:'+_link;
  }
  Data.post_comments(String _link) {
    this._query = '?c:'+_link;
  }
  Data.radius(int lat, int lng) {
    this._query = '?r:'+lat.toString()+':'+lng.toString();
  }

  @override
  DataState createState() => DataState(_query);
}

class DataState extends State<Data> {
  final String query;
  WebViewController _webViewController;
  DataState(this.query);

  @override
  void initState() {
    ArrivalData.server = this;
    ArrivalData.partners = List<Business>();
    super.initState();
  }

  void passInformation() {
    _webViewController?.evaluateJavascript(
        'Server.Info(' + ArrivalData.sendMessage +
        ',' + ArrivalData.result + ');'
    );
  }
  void requestAccountData() {
    _webViewController?.evaluateJavascript(
        'Server.Info(' + ArrivalData.sendMessage + ');'
    );
  }
  void requestPartnersData() {
    _webViewController?.evaluateJavascript(
        'Server.Partners(' + ArrivalData.sendMessage + ');'
    );
  }

  //** Pull data from message handlers **/
  List<String> _splitMessage(String message)
  {
    int equalsLoc = message.indexOf('=');
    if (equalsLoc==-1) return List<String>();
    if (message.indexOf(';')==-1) return message.split('=');
    List<String> result = List<String>();
    result.add(message.substring(0, equalsLoc));
    return result + message.substring(equalsLoc+1).split(';');
  }


  @override
  Widget build(BuildContext context) {
    return WebView(
      initialUrl: 'https://arrival-app.herokuapp.com/applink'+query,
      javascriptMode: JavascriptMode.unrestricted,
      javascriptChannels: Set.from([
        JavascriptChannel(
            name: 'AppAndPostsCommunication',
            onMessageReceived: (JavascriptMessage message) {
              List<String> split = _splitMessage(message.message);
              if (split.length==0) return;
              if (split[0]=='links') {
                for (int i=1;i<split.length;i++) {
                  ArrivalData.posts.add(Post.icon(
                    cryptlink: split[i].substring(6, split[i].length-1)
                  ));
                }

                // pop off this data pull page
                Navigator.pop(context);

                if (!ArrivalData.carry) return;
                // display home screen
                Navigator.of(context).push<void>(CupertinoPageRoute(
                  builder: (context) => HomeScreen(),
                  fullscreenDialog: true,
                ));
                ArrivalData.carry = false;
              }
              else if (split[0]=='data') {
                var post = Post.parse(split[1]);
                for (int i=0;i<ArrivalData.posts.length;i++) {
                  if (ArrivalData.posts[i].cryptlink==
                      post.cryptlink) {
                    ArrivalData.posts[i] = post;
                    break;
                  }
                }

                // pop off this data pull page
                Navigator.pop(context);

                // display Post Page
                // Navigator.of(context).push<void>(CupertinoPageRoute(
                //   builder: (context) => PostDisplayPage(post),
                //   fullscreenDialog: true,
                // ));
              }
              else if (split[0]=='comments') {
                Navigator.pop(context);
              }
            }),
        JavascriptChannel(
            name: 'AppAndUserdataCommunication',
            onMessageReceived: (JavascriptMessage message) {
              List<String> split = _splitMessage(message.message);
              if (split.length==0) return;
              if (split[0]=='response') {
                if (split.length!=2) return;
                UserData.client = Profile.parse(split[1]);
                UserData.client_string = split[1];
                UserData.save();

                // pop off this data pull page
                Navigator.pop(context);

                if (!ArrivalData.carry) return;
                // load up parnets data download page
                Navigator.of(context).push<void>(CupertinoPageRoute(
                  builder: (context) => Data.partners(''),
                  fullscreenDialog: false,
                ));
              }
            }),
        JavascriptChannel(
          name: 'AppAndPartnersCommunication',
          onMessageReceived: (JavascriptMessage message) {
            List<String> split = _splitMessage(message.message);
            if (split.length==0) return;
            if (split[0]=='response') {
              for (int i=1;i<split.length;i++) {
                ArrivalData.partners.add(Business.parse(split[i]));
                ArrivalData.partner_strings.add(split[i]);
              }
              ArrivalData.save();

              // pop off this data pull page
              Navigator.pop(context);

              if (!ArrivalData.carry) return;
              // display home screen
              Navigator.of(context).push<void>(CupertinoPageRoute(
                builder: (context) => Data.posts(''),
                fullscreenDialog: true,
              ));
            }
          }),
        JavascriptChannel(
            name: 'AppAndInfoCommunication',
            onMessageReceived: (JavascriptMessage message) {
              List<String> split = _splitMessage(message.message);
              if (split.length==0) return;
              if (split[0]=='response') {
                for (int i=1;i<split.length;i++) {
                  print(split[i]);
                }
              }

              // pop off this data pull page
              Navigator.pop(context);
            }),
        JavascriptChannel(
            name: 'AppAndErrorCommunication',
            onMessageReceived: (JavascriptMessage message) {
              List<String> split = _splitMessage(message.message);
              if (split.length==0) return;
              if (split[0]=='link') {
                for (int i=1;i<split.length;i++) {
                  print(split[i]);
                }
              }

              // pop off this data pull page
              Navigator.pop(context);
            }),
      ]),
      onWebViewCreated: (WebViewController w) {
        _webViewController = w;
      },
    );
  }
}
