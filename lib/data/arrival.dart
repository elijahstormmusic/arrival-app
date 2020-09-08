
import '../data/cards/partners.dart';
import '../posts/post.dart';
import '../posts/page.dart';
import '../users/profile.dart';
import '../users/data.dart';
import '../data/local.dart';
import '../data/link.dart';

class ArrivalData {
  static DataState server;
  static String result;
  static String sendMessage;
  static bool carry;
  static List<Post> posts;
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
    ArrivalData.posts = List<Post>();

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
