
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:arrival_kc/data/partners.dart';

class ArrivalData {
  static String result;
  static _DataState server;
  static List<Business> partners;
  static String sendMessage;
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
    if(message.indexOf(':')==-1) return message.split('=');
    List<String> result;
    result.add(message.substring(0, equalsLoc));
    String args = message.substring(equalsLoc);
    return result + args.split(':');
  }
  Business _parseData(String input)
  {
    var id, name, rating, ratingAmount, lat, lng,
        location, images, industry, contact,
        shortDescription, sales, cryptlink;

    var startDataLoc, endDataLoc = 0;

    startDataLoc = input.indexOf('name');
    endDataLoc = input.indexOf(',', startDataLoc);
    name = input.substring(startDataLoc+1, endDataLoc);

    startDataLoc = input.indexOf('images');
    endDataLoc = input.indexOf(',', startDataLoc);
    images = input.substring(startDataLoc+1, endDataLoc);

    startDataLoc = input.indexOf('lat');
    endDataLoc = input.indexOf(',', startDataLoc);
    lat = double.parse(input.substring(startDataLoc+1, endDataLoc));

    startDataLoc = input.indexOf('lng');
    endDataLoc = input.indexOf(',', startDataLoc);
    lng = double.parse(input.substring(startDataLoc+1, endDataLoc));

    location = LatLng(lat, lng);

    startDataLoc = input.indexOf('info');
    endDataLoc = input.indexOf(',', startDataLoc);
    shortDescription = input.substring(startDataLoc+1, endDataLoc);

    startDataLoc = input.indexOf('rating');
    endDataLoc = input.indexOf(',', startDataLoc);
    rating = double.parse(input.substring(startDataLoc+1, endDataLoc));

    startDataLoc = input.indexOf('ratingAmount');
    endDataLoc = input.indexOf(',', startDataLoc);
    ratingAmount = int.parse(input.substring(startDataLoc+1, endDataLoc));

    startDataLoc = input.indexOf('icon');
    endDataLoc = input.indexOf(',', startDataLoc);
    industry = int.parse(input.substring(startDataLoc+1, endDataLoc));

    startDataLoc = input.indexOf('cryptlink');
    endDataLoc = input.indexOf(',', startDataLoc);
    cryptlink = input.substring(startDataLoc+1, endDataLoc);

    startDataLoc = input.indexOf('contact');
    endDataLoc = input.indexOf(',', startDataLoc);
    contact = _parseContact(input.substring(startDataLoc+1, endDataLoc));

    startDataLoc = input.indexOf('sales');
    endDataLoc = input.indexOf(',', startDataLoc);
    sales = _parseSales(input.substring(startDataLoc+1, endDataLoc));

    return Business(
      id: id,
      name: name,
      rating: rating,
      ratingAmount: ratingAmount,
      location: location,
      images: images,
      industry: industry,
      contact: contact,
      shortDescription: shortDescription,
      cryptlink: cryptlink,
      sales: sales,
    );
  }
  ContactList _parseContact(String input)
  {
    ContactList contactData = ContactList();
    List<String> curData;
    List<String> list = input.substring(1, input.length-1).split(',');
    for(var i=0;i<list.length;i++) {
      curData = list[i].split(':');
      if(curData[0]=='phoneNumber') {
        contactData.phoneNumber = curData[1];
      }
      else if(curData[0]=='address') {
        contactData.address = curData[1];
      }
      else if(curData[0]=='city') {
        contactData.city = curData[1];
      }
      else if(curData[0]=='state') {
        contactData.state = curData[1];
      }
      else if(curData[0]=='zip') {
        contactData.zip = curData[1];
      }
      else if(curData[0]=='website') {
        contactData.website = curData[1];
      }
      else if(curData[0]=='email') {
        contactData.email = curData[1];
      }
      else if(curData[0]=='facebook') {
        contactData.facebook = curData[1];
      }
      else if(curData[0]=='twitter') {
        contactData.twitter = curData[1];
      }
      else if(curData[0]=='instagram') {
        contactData.instagram = curData[1];
      }
      else if(curData[0]=='pintrest') {
        contactData.pintrest = curData[1];
      }
    }
    return contactData;
  }
  SalesList _parseSales(String input)
  {
    SalesList salesData = SalesList();
    List<String> curData;
    List<String> list = input.substring(1, input.length-1).split(',');
    for(var i=0;i<list.length;i++) {
      curData = list[i].split(':');
      if(curData[0]=='name') {
        salesData.name = curData[1];
      }
       else if(curData[0]=='info') {
        salesData.info = curData[1];
      }
    }
    return salesData;
  }
  List<String> _parseGroups(String input)
  {
    List<String> list = new List<String>();
    var groupStartLoc = input.indexOf('{'),
      groupEndLoc;
    while(groupStartLoc!=-1) {
      groupEndLoc = input.indexOf('}', groupStartLoc);
      list.add(input.substring(groupStartLoc+1, groupEndLoc));
      groupStartLoc = input.indexOf('{', groupEndLoc);
    }
    return list;
  }
  void _parseList(String input)
  {
    var startBusinessLoc = 0, endBusinessLoc, innerBrackets;
    var recursionBreak = 20;
    while(true) {
      if(recursionBreak--<0) return;
      endBusinessLoc = -1;
      startBusinessLoc = input.indexOf('{', startBusinessLoc)+1;
      innerBrackets = 1;
      for(var i=startBusinessLoc;i<input.length;i++) {
        if(input[i]=='{') {
          innerBrackets++;
        }
        else if(input[i]=='}') {
          innerBrackets--;
          if(innerBrackets==0) {
            endBusinessLoc = i;
            break;
          }
        }
      }
      var found  = false;
      Business newPartner = _parseData(input.substring(
              startBusinessLoc, endBusinessLoc));
      if(endBusinessLoc!=-1) {
        for(var i=0;i<ArrivalData.partners.length;i++) {
          if(ArrivalData.partners[i].cryptlink==newPartner.cryptlink) {
            found = true;
            break;
          }
        }
        if(found) {
          continue;
        }
        ArrivalData.partners.add(newPartner);
      }
      else break;
    }
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
                  print("***** PRINTING NEXT ******");
                  print(split[i]);
                  _parseList(split[i]);
                }
              }
            }),
        JavascriptChannel(
            name: 'AppAndUserdataCommunication',
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
