/// Code written and created by Elijah Storm
// Copywrite April 5, 2020
// for use only in ARRIVAL Project

import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:meta/meta.dart';
import 'sales.dart';


class LatLng {
  final double lat;
  final double lng;

  LatLng(this.lat, this.lng);
}

enum SourceIndustry {
  none,
  cosmetics,
  entertainment,
  media,
  food,
  music,
}
class StoreImages {
  static const String source = 'https://arrival-app.herokuapp.com/partners/';

    // Strings are asset paths
  String href;
  String logo;
  String storefront;
  List<String> extras;
  String input;

  String toString() {
    return input;
  }

  StoreImages(String _href) {
    input = _href;
    href = StoreImages.source + _href;
    logo = href + '/logo.jpg';
    storefront = href + '/stft.jpg';
    extras = List<String>();
  }
}
class Industry {
  final String name;
  final bool essential;
  final SourceIndustry type;
  Map<String, Business> companyList;  // a list of all the Business classes
                                      // contained -> all the ones that have
                                      // the industy enum index link

  Industry({
    @required this.name,
    @required this.type,
    @required this.essential,
  });
}
Industry blankIndustry = Industry(
  name: 'none',
  type: SourceIndustry.none,
  essential: false,
);

class LocalIndustries {
  static List<Industry> all = [
    Industry(
      name: 'Cosmetics',
      type: SourceIndustry.cosmetics,
      essential: false,
    ),
    Industry(
      name: 'Entertainment',
      type: SourceIndustry.entertainment,
      essential: true,
    ),
    Industry(
      name: 'Media',
      type: SourceIndustry.media,
      essential: true,
    ),
    Industry(
      name: 'Food',
      type: SourceIndustry.food,
      essential: true,
    ),
    Industry(
      name: 'Music',
      type: SourceIndustry.music,
      essential: true,
    ),
  ];

  static Industry industryGrabber(SourceIndustry index) {
    for (var i=0;i<all.length;i++) {
      if (all[i].type==index)
      {
        return all[i];
      }
    }
    return blankIndustry;
  }
}


class ContactList {
  String phoneNumber;
  String email;
  String facebook;
  String twitter;
  String instagram;
  String pintrest;
  String address;
  String city;
  String state;
  String zip;
  String website;

  String toString() {
    String str = '';
    if (phoneNumber!=null) {
      str += 'phoneNumber:' + phoneNumber + ',';
    }
    if (address!=null) {
      str += 'address:' + address + ',';
    }
    if (city!=null) {
      str += 'city:' + city + ',';
    }
    if (state!=null) {
      str += 'state:' + state + ',';
    }
    if (zip!=null) {
      str += 'zip:' + zip + ',';
    }
    if (website!=null) {
      str += 'website:' + website + ',';
    }
    if (email!=null) {
      str += 'email:' + email + ',';
    }
    if (facebook!=null) {
      str += 'facebook:' + facebook + ',';
    }
    if (twitter!=null) {
      str += 'twitter:' + twitter + ',';
    }
    if (instagram!=null) {
      str += 'instagram:' + instagram + ',';
    }
    if (pintrest!=null) {
      str += 'pintrest:' + pintrest + ',';
    }
    if (str.substring(str.length-1, str.length)==',') {
      str = str.substring(0, str.length-1);
    }
    return str;
  }

  ContactList({
    this.phoneNumber,
    this.email,
    this.facebook,
    this.twitter,
    this.instagram,
    this.pintrest,
    this.address,
    this.city,
    this.state,
    this.zip,
    this.website,
  });

  static ContactList json(var data) {
    return ContactList(
      phoneNumber: data['phoneNumber'],
      address: data['address'],
      city: data['city'],
      state: data['state'],
      zip: data['zip'],
      website: data['website'],
      email: data['email'],
      facebook: data['facebook'],
      twitter: data['twitter'],
      instagram: data['instagram'],
      pintrest: data['pintrest'],
    );
  }
  static ContactList parse(String input) {
    ContactList contactData = ContactList();
    List<String> curData;
    List<String> list = input.split(',');
    for (var i=0;i<list.length;i++) {
      curData = list[i].split(':');
      if (curData[0]=='phoneNumber') {
        contactData.phoneNumber = curData[1];
      }
      else if (curData[0]=='address') {
        contactData.address = curData[1];
      }
      else if (curData[0]=='city') {
        contactData.city = curData[1];
      }
      else if (curData[0]=='state') {
        contactData.state = curData[1];
      }
      else if (curData[0]=='zip') {
        contactData.zip = curData[1];
      }
      else if (curData[0]=='website') {
        contactData.website = curData[1];
      }
      else if (curData[0]=='email') {
        contactData.email = curData[1];
      }
      else if (curData[0]=='facebook') {
        contactData.facebook = curData[1];
      }
      else if (curData[0]=='twitter') {
        contactData.twitter = curData[1];
      }
      else if (curData[0]=='instagram') {
        contactData.instagram = curData[1];
      }
      else if (curData[0]=='pintrest') {
        contactData.pintrest = curData[1];
      }
    }
    return contactData;
  }
}
class Business {
  final int id;
  final String name;
  final String shortDescription;
  final String cryptlink;
  int yourRating;
  final double rating;
  final int ratingAmount;
  final LatLng location;
  final StoreImages images;
  final SourceIndustry industry; // an enum link to the Industy index
  final ContactList contact;
  List<Sale> sales;
  bool isFavorite;

  String toString() {
    String str = '';
    double lat = location.lat;
    double lng = location.lng;
    str += 'name:' + name + ',';
    str += 'info:' + shortDescription + ',';
    str += 'cryptlink:' + cryptlink + ',';
    str += 'lat:' + lat.toString() + ',';
    str += 'lng:' + lng.toString() + ',';
    str += 'rating:' + rating.toString() + ',';
    str += 'ratingAmount:' + ratingAmount.toString() + ',';
    str += 'images:' + images.toString() + ',';
    str += 'industry:' + industry.index.toString() + ',';
    str += 'contact:{' + contact.toString() + '},';
    str += 'sales:{' + sales.toString() + '}';
    return str;
  }
  bool isOpen() {
    return true;
  }

  Business({
    @required this.id,
    @required this.name,
    @required this.rating,
    @required this.ratingAmount,
    @required this.location,
    @required this.images,
    @required this.industry,
    @required this.contact,
    @required this.shortDescription,
    @required this.sales,
    @required this.cryptlink,
    this.isFavorite = false,
  }) {
    if(sales.length==0) {
      int rando = Random().nextInt(10);
      for (int i=0;i<rando;i++) {
        sales.add(blankSale);
      }
    }
  }

  static Business json(var data) {
    return Business(
      id: Business.index++,
      name: data['name'],
      cryptlink: data['cryptlink'],
      location: LatLng(data['lat'], data['lng']),
      shortDescription: data['info'],
      rating: data['rating'].toDouble(),
      ratingAmount: data['ratingAmount'],
      industry: SourceIndustry.values[data['icon']],
      images: StoreImages(data['images']),
      contact: ContactList.json(data['contact']),
      sales: List<Sale>(),
    );
  }
  static Business parse(String input) {
    var id, name, rating, ratingAmount, lat, lng,
        location, images, industry, contact,
        shortDescription, sales, cryptlink;

    var startDataLoc, endDataLoc = 0;

    id = Business.index++;

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
    contact = ContactList.parse(input.substring(startDataLoc, endDataLoc));

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
      sales: List<Sale>(),
    );
  }
  static int index = 0;
}
Business blankBusiness = Business(
  id: -1,
  name: 'none',
  rating: 0,
  ratingAmount: 0,
  location: LatLng(0, 0),
  images: StoreImages('empty'),
  industry: SourceIndustry.none,
  contact: ContactList(),
  shortDescription: 'description',
  sales: List<Sale>(),
  cryptlink: "",
);


enum Season {
  winter,
  spring,
  summer,
  autumn,
}
const Map<Season, String> seasonNames = {
  Season.winter: 'Winter',
  Season.spring: 'Spring',
  Season.summer: 'Summer',
  Season.autumn: 'Autumn',
};
