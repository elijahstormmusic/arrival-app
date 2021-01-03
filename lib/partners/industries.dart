/// Code written and created by Elijah Storm
// Copywrite April 5, 2020
// for use only in ARRIVAL Project

import 'package:flutter/material.dart';
import '../styles.dart';
import '../const.dart';
import 'partner.dart';


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
  static const String source = Constants.media_source;

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
  final Color color;
  final String image;
  Map<String, Partner> companyList;  // a list of all the Partner classes
                                      // contained -> all the ones that have
                                      // the industy enum index link

  Industry({
    @required this.name,
    @required this.type,
    this.essential = false,
    this.image = Constants.basic_plant_image,
    this.color = Styles.ArrivalPalletteRedDarken,
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
      name: 'none',
      type: SourceIndustry.none,
      essential: false,
      color: Styles.ArrivalPalletteRedDarken,
      image: Constants.basic_plant_image,
    ),
    Industry(
      name: 'Dine In',
      type: SourceIndustry.diner,
      essential: true,
      color: Styles.ArrivalPalletteRedDarken,
      image: Constants.basic_plant_image,
    ),
    Industry(
      name: 'Fast Food',
      type: SourceIndustry.fastfood,
      essential: true,
      color: Styles.ArrivalPalletteBlueDarken,
      image: Constants.basic_plant_image,
    ),
    Industry(
      name: 'Coffee',
      type: SourceIndustry.coffee,
      essential: true,
      color: Styles.ArrivalPalletteYellowDarken,
      image: Constants.basic_plant_image,
    ),
    Industry(
      name: 'Bar',
      type: SourceIndustry.bar,
      essential: false,
      color: Styles.ArrivalPalletteRedDarken,
      image: Constants.basic_plant_image,
    ),
    Industry(
      name: 'Music Studio',
      type: SourceIndustry.musicstu,
      essential: false,
      color: Styles.ArrivalPalletteBlueDarken,
      image: Constants.basic_plant_image,
    ),
    Industry(
      name: 'Music Gear',
      type: SourceIndustry.musicshop,
      essential: false,
      color: Styles.ArrivalPalletteYellowDarken,
      image: Constants.basic_plant_image,
    ),
    Industry(
      name: 'Photo Studio',
      type: SourceIndustry.photostu,
      essential: false,
      color: Styles.ArrivalPalletteRedDarken,
      image: Constants.basic_plant_image,
    ),
    Industry(
      name: 'Hair Salon',
      type: SourceIndustry.hair,
      essential: false,
      color: Styles.ArrivalPalletteBlueDarken,
      image: Constants.basic_plant_image,
    ),
    Industry(
      name: 'Clothing',
      type: SourceIndustry.clothing,
      essential: true,
      color: Styles.ArrivalPalletteYellowDarken,
      image: Constants.basic_plant_image,
    ),
    Industry(
      name: 'Shoes',
      type: SourceIndustry.shoes,
      essential: false,
      color: Styles.ArrivalPalletteRedDarken,
      image: Constants.basic_plant_image,
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
  String pinterest;
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
    if (pinterest!=null) {
      str += 'pinterest:' + pinterest + ',';
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
      'pinterest': pinterest,
    };
  }
  ContactList({
    this.phoneNumber,
    this.email,
    this.facebook,
    this.twitter,
    this.instagram,
    this.pinterest,
    this.address,
    this.city,
    this.state,
    this.zip,
    this.website,
  });

  static ContactList json(var data) {
    if (data==null) return ContactList();

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
      pinterest: data['pinterest'],
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
      else if (curData[0]=='pinterest') {
        contactData.pinterest = curData[1];
      }
    }
    return contactData;
  }
}
