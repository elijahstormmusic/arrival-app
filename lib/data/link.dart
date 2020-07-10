
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:arrival_kc/data/partners.dart';
import 'package:arrival_kc/screens/home.dart';

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
  Business _parseData(String input)
  {
    var id, name, rating, ratingAmount, lat, lng,
        location, images, industry, contact,
        shortDescription, sales, cryptlink;

//    int id;
//    String name;
//    double rating;
//    int ratingAmount;
//    double lat,lng;
//    LatLng location;
//    StoreImages images;
//    SourceIndustry industry; // an enum link to the Industy index
//    ContactList contact;
//    String shortDescription;
//    String cryptlink;
//    SalesList sales;

    var startDataLoc, endDataLoc = 0;

    startDataLoc = input.indexOf('name')            + 5;
    endDataLoc = input.indexOf(',', startDataLoc);
    name = input.substring(startDataLoc, endDataLoc);

    startDataLoc = input.indexOf('images')          + 7;
    endDataLoc = input.indexOf(',', startDataLoc);
    images = StoreImages(input.substring(startDataLoc, endDataLoc));

    startDataLoc = input.indexOf('lat')             + 4;
    endDataLoc = input.indexOf(',', startDataLoc);
    lat = double.parse(input.substring(startDataLoc, endDataLoc));

    startDataLoc = input.indexOf('lng')             + 4;
    endDataLoc = input.indexOf(',', startDataLoc);
    lng = double.parse(input.substring(startDataLoc, endDataLoc));

    location = LatLng(lat, lng);

    startDataLoc = input.indexOf('info')            + 5;
    endDataLoc = input.indexOf(',', startDataLoc);
    shortDescription = input.substring(startDataLoc, endDataLoc).
      replaceAll('~', ',');

    startDataLoc = input.indexOf('rating')          + 7;
    endDataLoc = input.indexOf(',', startDataLoc);
    rating = double.parse(input.substring(startDataLoc, endDataLoc));

    startDataLoc = input.indexOf('ratingAmount')    + 13;
    endDataLoc = input.indexOf(',', startDataLoc);
    ratingAmount = int.parse(input.substring(startDataLoc, endDataLoc));

    startDataLoc = input.indexOf('icon')            + 5;
    endDataLoc = input.indexOf(',', startDataLoc);
    industry = SourceIndustry.values[int.parse(input.substring(
        startDataLoc, endDataLoc))];

    startDataLoc = input.indexOf('cryptlink')       + 10;
    endDataLoc = input.indexOf(',', startDataLoc);
    cryptlink = input.substring(startDataLoc, endDataLoc);

    startDataLoc = input.indexOf('contact')         + 9;
    endDataLoc = input.indexOf('}', startDataLoc);
    contact = _parseContact(input.substring(startDataLoc, endDataLoc));

    startDataLoc = input.indexOf('sales')           + 6;
    endDataLoc = input.indexOf(']', startDataLoc);
    sales = _parseSales(input.substring(startDataLoc, endDataLoc));

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
    List<String> list = input.split(',');
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
    List<String> list = input.split(',');
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
                  ArrivalData.partners.add(_parseData(split[i]));
                }
              }

              // pop off this data pull page
              Navigator.pop(context);

              // display home screen
              Navigator.of(context).push<void>(CupertinoPageRoute(
                builder: (context) => HomeScreen(),
                fullscreenDialog: true,
              ));
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
