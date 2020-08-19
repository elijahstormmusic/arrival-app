
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '../data/partners.dart';
import '../users/profile.dart';
import '../users/data.dart';
import '../screens/home.dart';
import '../data/local.dart';

class ArrivalData {
  static _DataState server;
  static String result;
  static String sendMessage;
  static List<Business> partners;
  static List<String> partner_strings;

  static void save() async {
    ArrivalFiles file = ArrivalFiles('partners.json');

    Map<String, dynamic> data = Map<String, dynamic>();

    for(var i=0;i<ArrivalData.partners.length;i++) {
      data[ArrivalData.partners[i].cryptlink] =
        ArrivalData.partner_strings[i];
    }

    await file.write(data);
  }
  static void load() async {
    ArrivalFiles file = ArrivalFiles('partners.json');

    ArrivalData.partner_strings = List<String>();
    ArrivalData.partners = List<Business>();

    try {
      Map<String, dynamic> data = await file.readAll();

      data.forEach((String key, dynamic value) {
        ArrivalData.partner_strings.add(value);
        ArrivalData.partners.add(Business.parse(value));
      });
    } catch(e) {
      print('-------');
      print('Some error happened in link.dart @ 42');
      print(e);
      print('-------');
    }
  }
  static void refresh() async {
    ArrivalFiles file = ArrivalFiles('partners.json');

    try {
      file.delete();
    } catch(e) {
      print('-------');
      print('Could not delete file in link.dart @ 47');
      print(e);
      print('-------');
    }
  }
}

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
  Data.radius(int lat, int lng) {
    this._query = '?r:'+lat.toString()+':'+lng.toString();
  }

  @override
  _DataState createState() => _DataState(_query);
}

class _DataState extends State<Data> {
  final String query;
  WebViewController _webViewController;
  _DataState(this.query);

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
    if(equalsLoc==-1) return List<String>();
    if(message.indexOf(';')==-1) return message.split('=');
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
            name: 'AppAndPartnersCommunication',
            onMessageReceived: (JavascriptMessage message) {
              List<String> split = _splitMessage(message.message);
              if(split.length==0) return;
              if(split[0]=='response') {
                for(int i=1;i<split.length;i++) {
                  ArrivalData.partners.add(Business.parse(split[i]));
                  ArrivalData.partner_strings.add(split[i]);
                }
                ArrivalData.save();

                // pop off this data pull page
                Navigator.pop(context);

                // display home screen
                Navigator.of(context).push<void>(CupertinoPageRoute(
                  builder: (context) => HomeScreen(),
                  fullscreenDialog: true,
                ));
              }
            }),
        JavascriptChannel(
            name: 'AppAndUserdataCommunication',
            onMessageReceived: (JavascriptMessage message) {
              List<String> split = _splitMessage(message.message);
              if(split.length==0) return;
              if(split[0]=='response') {
                if(split.length!=2) return;
                UserData.client = Profile.parse(split[1]);
                UserData.client_string = split[1];
                UserData.save();

                // pop off this data pull page
                Navigator.pop(context);

                // load up parnets data download page
                Navigator.of(context).push<void>(CupertinoPageRoute(
                  builder: (context) => Data.partners(''),
                  fullscreenDialog: false,
                ));
              }
            }),
        JavascriptChannel(
            name: 'AppAndInfoCommunication',
            onMessageReceived: (JavascriptMessage message) {
              List<String> split = _splitMessage(message.message);
              if(split.length==0) return;
              if(split[0]=='response') {
                for(int i=1;i<split.length;i++) {
                  print(split[i]);
                }
              }
            }),
        JavascriptChannel(
            name: 'AppAndErrorCommunication',
            onMessageReceived: (JavascriptMessage message) {
              List<String> split = _splitMessage(message.message);
              if(split.length==0) return;
              if(split[0]=='link') {
                for(int i=1;i<split.length;i++) {
                  print(split[i]);
                }
              }
            }),
      ]),
      onWebViewCreated: (WebViewController w) {
        _webViewController = w;
      },
    );
  }
}
