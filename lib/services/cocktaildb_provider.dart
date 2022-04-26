import 'package:darty_json/darty_json.dart';
import 'package:get/get.dart';

class Cocktail {
  String id;
  String name;
  String description;
  Uri? imageUrl;

  Cocktail(this.id, this.name, this.description, this.imageUrl);

  factory Cocktail.fromJson(Json json) {
    return Cocktail(
      json['idDrink'].stringValue,
      json['strDrink'].stringValue,
      json['strInstructions'].stringValue,
      json['strDrinkThumb'].string != null ? Uri.parse(json['strDrinkThumb'].stringValue) : null,
    );
  }
}

class CocktailDbProvider extends GetConnect {
  Future<Json> _fetch(String url) async {
    var res = await get(url);
    if (res.statusCode != 200) throw 'Api error, response ${res.statusCode} ${res.bodyString}';
    return Json.fromString(res.bodyString ?? '{}');
  }

  Future<List<Cocktail>> fetchSome() async {
    var res = await _fetch('https://www.thecocktaildb.com/api/json/v1/1/search.php?f=a');
    return res['drinks'].listValue.map((e) => Cocktail.fromJson(e)).toList();
  }

  Future<Cocktail> fetchOne(String id) async {
    var res = await _fetch('https://www.thecocktaildb.com/api/json/v1/1/lookup.php?i=$id');
    return Cocktail.fromJson(res['drinks'].listValue.first);
  }
}
