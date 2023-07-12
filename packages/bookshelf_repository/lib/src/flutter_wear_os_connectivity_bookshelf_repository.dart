import 'dart:io';

import 'package:bookshelf_repository/bookshelf_repository.dart';
import 'package:flutter_wear_os_connectivity/flutter_wear_os_connectivity.dart';
import 'package:rxdart/subjects.dart';

/// Path where bookshelf title and path information is synced.
const _dataLayerBookshelfPath = '/bookshelf-titles-to-paths';
const _uriScheme = 'wear';
final _bookshelfUri =
    Uri(scheme: _uriScheme, host: '*', path: _dataLayerBookshelfPath);

/// Implementation of [BookshelfRepository] with flutter_wear_os_connectivity
/// using Android Wear network Data Layer for sending data from companion app.
///
/// https://pub.dev/packages/flutter_wear_os_connectivity
/// https://developer.android.com/training/wearables/data/data-layer
class FlutterWearOsConnectivityBookshelfRepository
    implements BookshelfRepository {
  /// Default constructor.
  FlutterWearOsConnectivityBookshelfRepository({
    FlutterWearOsConnectivity? connectivity,
  }) : _connectivity = connectivity ?? FlutterWearOsConnectivity();

  /// Handles read, write, delete operations between companion app and watch.
  final FlutterWearOsConnectivity _connectivity;

  /// Stream informs listeners when bookshelf changes.
  final _titlesAndFilepaths = BehaviorSubject<Map<String, String>>.seeded({});

  @override
  Map<String, String> get titlesAndFilepaths => _titlesAndFilepaths.value;

  @override
  Stream<Map<String, String>> get titlesAndFilepathsStream =>
      _titlesAndFilepaths.stream.distinct();

  @override
  Future<void> addBook({
    required String title,
    required String path,
    required File file,
  }) async {
    await _refreshBookshelf();
    if (titlesAndFilepaths.containsKey(title)) {
      // TODO: Return status message to display in UI?
      print('$title already in bookshelf');
      return;
    }

    await _connectivity.syncData(
      path: _dataLayerBookshelfPath,
      data: {...titlesAndFilepaths, title: path},
      isUrgent: true,
    );
    // Store file in a separate path (instead of in _dataLayerBookshelfPath's
    // files parameter) so we don't have to read all the epub files when
    // fetching the list of book titles with titlesAndFilepaths.
    await _connectivity
        .syncData(path: path, data: {'title': title}, files: {'book': file});
  }

  @override
  Future<void> deleteBook(String title) async {
    await _refreshBookshelf();
    if (titlesAndFilepaths.containsKey(title)) {
      final path = titlesAndFilepaths[title];
      await _connectivity.deleteDataItems(
        uri: Uri(scheme: _uriScheme, host: '*', path: path),
      );

      final newTitles = {...titlesAndFilepaths}..remove(title);
      await _connectivity.syncData(
        path: _dataLayerBookshelfPath,
        data: newTitles,
        isUrgent: true,
      );
    }
  }

  @override
  Future<File?> getBookFile(String title) async {
    return titlesAndFilepaths.containsKey(title)
        ? _connectivity
            .findDataItemsOnURIPath(
              pathURI: Uri(
                scheme: _uriScheme,
                host: '*',
                path: titlesAndFilepaths[title],
              ),
            )
            .then((dataItem) => dataItem.single.files.values.single)
        : null;
  }

  @override
  Future<void> onChange() {
    return _refreshBookshelf();
  }

  /// Updates [_titlesAndFilepaths] with current values in Data Layer.
  Future<void> _refreshBookshelf() async {
    _titlesAndFilepaths.add(
      await _connectivity.findDataItemsOnURIPath(pathURI: _bookshelfUri).then(
            (d) => d.isEmpty
                ? {}
                : d.single.mapData
                    .map((key, value) => MapEntry(key, value.toString())),
          ),
    );
  }

  @override
  Future<void> initialize() async {
    await _connectivity.configureWearableAPI();
    _connectivity
        .dataChanged(
            // TODO: Uncomment to only listen for bookshelf changes (not Files).
            // pathURI: _bookshelfUri
            )
        .listen((event) {
      onChange();
    });
    await _refreshBookshelf();
  }

  @override
  void dispose() {
    _titlesAndFilepaths.close();
    _connectivity.dispose();
  }
}
