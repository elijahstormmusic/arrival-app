
import 'package:arrival_kc/data/partners.dart';

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

