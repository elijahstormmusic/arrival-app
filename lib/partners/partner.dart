/// Code written and created by Elijah Storm
// Copywrite April 5, 2020
// for use only in ARRIVAL Project

import 'dart:convert';
import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:meta/meta.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../data/arrival.dart';
import '../data/socket.dart';

import '../styles.dart';
import '../const.dart';

import 'page.dart';
import 'sale.dart';
import 'industries.dart';


class Partner {
  final int id;
  final String name;
  final String shortDescription;
  final String cryptlink;
  int yourRating;
  double rating;
  int ratingAmount;
  final LatLng location;
  final StoreImages images;
  final SourceIndustry industry;
  final ContactList contact;
  List<Sale> sales = List<Sale>();
  bool isFavorite;

  dynamic toJson() {
    return {
      'name': name,
      'cryptlink': cryptlink,
      'lat': location.latitude,
      'lng': location.longitude,
      'info': shortDescription,
      'rating': rating,
      'ratingAmount': ratingAmount,
      'industry': industry.index,
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
  PartnerDisplayPage navigateTo() {
    return PartnerDisplayPage(cryptlink);
  }
  static int index = 0;
  static Partner blankPartner = Partner(
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
}
