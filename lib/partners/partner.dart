/// Code written and created by Elijah Storm
// Copywrite April 5, 2020
// for use only in ARRIVAL Project

import 'dart:convert';
import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:meta/meta.dart';
import '../data/arrival.dart';
import '../data/socket.dart';

import 'page.dart';
import 'sale.dart';


class LatLng {
  final double lat;
  final double lng;

  LatLng(this.lat, this.lng);
}

enum SourceIndustry {
  none,
  diner,
  fastfood,
  coffee,
  bar,
  musicstu,
  musicshop,
  photostu,
  hair,
  clothing,
  shoes,
}
class StoreImages {
  static const String source = 'https://res.cloudinary.com/arrival-kc/image/upload/';

  String logo;
  String storefront;
  List<String> extras;
  List<String> _input;

  List<String> toJson() {
    return _input;
  }

  StoreImages(List<dynamic> input) {
    _input = List<String>();
    for (int i=0;i<input.length;i++) {
      _input.add(input[i]);
    }
    logo = StoreImages.source + input[0];
    if (input.length<2)
      storefront = StoreImages.source + input[1];
    else storefront = StoreImages.source + input[0];

    extras = List<String>();
    for (int i=2;i<input.length;i++) {
      extras.add(StoreImages.source + input[i]);
    }
  }
}
class Industry {
  final String name;
  final bool essential;
  final SourceIndustry type;
  Map<String, Partner> companyList;  // a list of all the Partner classes
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
      name: 'Dine In',
      type: SourceIndustry.diner,
      essential: true,
    ),
    Industry(
      name: 'Fast Food',
      type: SourceIndustry.fastfood,
      essential: true,
    ),
    Industry(
      name: 'Coffee',
      type: SourceIndustry.coffee,
      essential: true,
    ),
    Industry(
      name: 'Bar',
      type: SourceIndustry.bar,
      essential: false,
    ),
    Industry(
      name: 'Music Studio',
      type: SourceIndustry.musicstu,
      essential: false,
    ),
    Industry(
      name: 'Music Gear',
      type: SourceIndustry.musicshop,
      essential: false,
    ),
    Industry(
      name: 'Photo Studio',
      type: SourceIndustry.photostu,
      essential: false,
    ),
    Industry(
      name: 'Hair Salon',
      type: SourceIndustry.hair,
      essential: false,
    ),
    Industry(
      name: 'Clothing',
      type: SourceIndustry.clothing,
      essential: true,
    ),
    Industry(
      name: 'Shoes',
      type: SourceIndustry.shoes,
      essential: false,
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
  dynamic toJson() {
    return {
      'phoneNumber': phoneNumber,
      'address': address,
      'city': city,
      'state': state,
      'zip': zip,
      'website': website,
      'email': email,
      'facebook': facebook,
      'twitter': twitter,
      'instagram': instagram,
      'pintrest': pintrest,
    };
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
class Partner {
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
  List<Sale> sales = List<Sale>();
  bool isFavorite;

  dynamic toJson() {
    return {
      'name': name,
      'cryptlink': cryptlink,
      'lat': location.lat,
      'lng': location.lng,
      'info': shortDescription,
      'rating': rating,
      'ratingAmount': ratingAmount,
      'icon': industry.index,
      'images': images.toJson(),
      'contact': contact.toJson(),
    };
  }
  bool isOpen() {
    return true;
  }

  Partner({
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
  });

  static Partner json(var data) {
    return Partner(
      id: Partner.index++,
      name: data['name'],
      cryptlink: data['cryptlink'],
      location: LatLng(data['lat'], data['lng']),
      shortDescription: data['info'],
      rating: data['rating'].toDouble(),
      ratingAmount: data['ratingAmount'],
      industry: SourceIndustry.values[data['industry']],
      images: StoreImages(data['images']),
      contact: ContactList.json(data['contact']),
      sales: List<Sale>(),
    );
  }
  static Partner link(String input) {
    for (var i=0;i<ArrivalData.partners.length;i++) {
      if (ArrivalData.partners[i].cryptlink==input) {
        return ArrivalData.partners[i];
      }
    }
    Partner P = Partner(
      cryptlink: input,
      id: -1,
      name: 'none',
      rating: 0,
      ratingAmount: 0,
      location: LatLng(0, 0),
      images: StoreImages(<String>[]),
      industry: SourceIndustry.none,
      contact: ContactList(),
      shortDescription: 'description',
      sales: List<Sale>(),
    );
    socket.emit('partners link', {
      'link': input,
    });
    ArrivalData.innocentAdd(ArrivalData.partners, P);
    return P;
  }
  static PartnerDisplayPage navigateTo(String link) {
    return PartnerDisplayPage(link);
  }
  static int index = 0;
}
Partner blankPartner = Partner(
  id: -1,
  name: 'none',
  rating: 0,
  ratingAmount: 0,
  location: LatLng(0, 0),
  images: StoreImages(<String>[]),
  industry: SourceIndustry.none,
  contact: ContactList(),
  shortDescription: 'description',
  sales: List<Sale>(),
  cryptlink: '',
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
