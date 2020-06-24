import 'package:flutter/cupertino.dart';
import 'package:Arrival/data/partners.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';


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
      if(all[i].type==index)
      {
        return all[i];
      }
    }
    return blankIndustry;
  }
}

class LocalSavedBusinesses {
  static List<Business> biz = [
    Business(
      id: 1,
      name: 'Westport Media Collective',
      rating: 5,
      ratingAmount: 100,
      location: LatLng(39.053511, -94.589732),
      images: StoreImages(
        logo: 'assets/images/westport/logo.jpg',
        storefront: 'assets/images/westport/stft.jpg',
      ),
      industry: SourceIndustry.music,
      contact: ContactList(
        phoneNumber: '(913) 912-2861',
        address: '315 Westport Rd',
        city: 'Kansas City',
        state: 'MO',
        zip: '64111',
        website: 'http://www.wmckc.com/',
      ),
      shortDescription: 'Recording Studio, Photography Studio',
    ),
    Business(
      id: 2,
      name: 'Catalyst Barber Co.',
      rating: 5,
      ratingAmount: 81,
      location: LatLng(39.195300, -94.575750),
      images: StoreImages(
        logo: 'assets/images/catalystbarb/logo.jpg',
        storefront: 'assets/images/catalystbarb/stft.jpg',
      ),
      industry: SourceIndustry.cosmetics,
      contact: ContactList(
        phoneNumber: '(816) 701-6773',
        address: '5545 N. Oak Trfy, #15c',
        city: 'Kansas City',
        state: 'MO',
        zip: '64118',
        instagram: 'https://instagram.com/catalystbarberco',
        facebook: 'https://www.facebook.com/catalystbarberco/',
        email: 'catalystartcorporation@gmail.com',
        website: 'https://www.thecatalystcut.com/',
      ),
      shortDescription: 'Barber shop',
    ),
    Business(
      id: 3,
      name: 'Headrush Roasters',
      rating: 4.7,
      ratingAmount: 471,
      location: LatLng(39.223381, -94.576408),
      images: StoreImages(
        logo: 'assets/images/headrushcoffee/logo.jpg',
        storefront: 'assets/images/headrushcoffee/stft.jpg',
      ),
      industry: SourceIndustry.food,
      contact: ContactList(
        phoneNumber: '(816) 888-4675',
        address: '7108 N Oak Trafficway',
        city: 'Kansas City',
        state: 'MO',
        zip: '64118',
        email: 'headrushroastersgroup@gmail.com',
        instagram: 'https://instagram.com/headrushroasters',
        facebook: 'https://www.facebook.com/HeadrushRoasters/',
        website: 'https://www.headrushroasters.com/',
      ),
      shortDescription: 'Coffee & Tea Shop',
    ),
    Business(
      id: 4,
      name: 'The Laya Center',
      rating: 3,
      ratingAmount: 39,
      location: LatLng(39.106079, -94.581390),
      images: StoreImages(
        logo: 'assets/images/layacenter/logo.jpg',
        storefront: 'assets/images/layacenter/stft.jpg',
      ),
      industry: SourceIndustry.cosmetics,
      contact: ContactList(
        phoneNumber: '(816) 912-3285',
        address: '601 Walnut St',
        city: 'Kansas City',
        state: 'MO',
        zip: '64106',
        email: 'thelayacenter@gmail.com',
        instagram: 'https://instagram.com/thelayacenter',
        facebook: 'https://www.facebook.com/TheLayaCenterMO/',
        website: 'https://www.thelayacenter.com/',
      ),
      shortDescription: 'Health Spa',
    ),
    Business(
      id: 5,
      name: 'Wings Cafe',
      rating: 4.2,
      ratingAmount: 473,
      location: LatLng(39.195830, -94.587150),
      images: StoreImages(
        logo: 'assets/images/wingscafe/logo.jpg',
        storefront: 'assets/images/wingscafe/stft.jpg',
      ),
      industry: SourceIndustry.food,
      contact: ContactList(
        phoneNumber: '(816) 413-9464',
        address: '516 NW Englewood Rd',
        city: 'Kansas City',
        state: 'MO',
        zip: '64118',
        facebook: 'https://www.facebook.com/thewingscafe/',
        instagram: 'https://instagram.com/wingscafe',
        website: 'https://www.thewingscafe.com',
      ),
      shortDescription: 'Wings and golden cooked BBQ flavors',
    ),
  ];
}
