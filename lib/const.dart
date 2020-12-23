/// Code written and created by Elijah Storm
// Copywrite April 5, 2020
// for use only in ARRIVAL Project

class Constants {
  static const String media_source = 'https://res.cloudinary.com/arrival-kc/image/upload/';
  static const String basic_plant_image = 'https://res.cloudinary.com/arrival-kc/image/upload/v1599325166/sample.jpg';
  static const String default_profile_pic = 'https://arrival-app.herokuapp.com/includes/img/default-profile-pic.png';
  static const String loading_placeholder = 'https://arrival-app.herokuapp.com/includes/img/default-profile-pic.png';
  static const String site = 'https://arrival-app.herokuapp.com/';
}

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
