import 'package:algolia/algolia.dart';
import 'package:app_3/data/item_model.dart';

const Algolia algolia = Algolia.init(
  applicationId: 'UUFOSKMFHW',
  apiKey: 'ffb921c7af68f32bebce1cd8e3e8eeec',
);

class AlgoliaService {
  static final AlgoliaService _algoliaService = AlgoliaService._internal();

  factory AlgoliaService() => _algoliaService;

  AlgoliaService._internal();

  Future<List<ItemModel>> queryItems(String queryStr) async {
    AlgoliaQuery query = algolia.instance.index('items').query(queryStr);

    // Perform multiple facetFilters
    // query = query.facetFilter('status:published');
    // query = query.facetFilter('isDelete:false');
    AlgoliaQuerySnapshot algoliaSnapshot = await query.getObjects();
    List<AlgoliaObjectSnapshot> hits = algoliaSnapshot.hits;
    List<ItemModel> items = [];
    hits.forEach((element) {
      ItemModel item =
      ItemModel.fromAlgoliaObject(element.data, element.objectID);
      items.add(item);
    });
    return items;
  }
}