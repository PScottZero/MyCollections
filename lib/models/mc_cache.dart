import 'package:my_collections/models/collection.dart';
import 'package:my_collections/models/entry.dart';
import 'package:my_collections/models/folder.dart';
import 'package:my_collections/models/mc_db.dart';

class MCCache {
  static List<Collection> collections = [];
  static List<Entry> entries_ = [];
  static List<Entry> wantlist_ = [];
  static List<Folder> folders = [];

  static bool collectionsLoaded = false;
  static bool entriesLoaded = false;
  static bool foldersLoaded = false;

  static void resetCollections() => collectionsLoaded = false;
  static void resetEntries() => entriesLoaded = false;
  static void resetFolders() => foldersLoaded = false;

  static int get collectionCount => collections.length;
  static int get entryCount => entries_.length;
  static int get wantlistCount => wantlist_.length;
  static int get folderCount => folders.length;
  static String get collectionValue => Entry.valueStr(entries_
      .map((e) => e.floatValue)
      .fold(0.0, (prevValue, value) => prevValue += value));
  static String get wantlistValue => Entry.valueStr(wantlist_
      .map((e) => e.floatValue)
      .fold(0.0, (prevValue, value) => prevValue += value));

  // ---------------------------------------------------------------------------
  // Get Cache
  // ---------------------------------------------------------------------------

  static Future<void> loadCollections() async {
    collections = await MCDB.collections();
    sortCollections(nameColumn, true);
    collectionsLoaded = true;
  }

  static Future<void> loadEntries(int collectionId, bool wantlist) async {
    var entries = await MCDB.entriesByCollectionId(collectionId);
    entries_ = entries.where((e) => e.inWantlist == 0).toList();
    wantlist_ = entries.where((e) => e.inWantlist == 1).toList();
    sortEntries(nameColumn, true);
    entriesLoaded = true;
  }

  static Future<void> loadFolders(int collectionId) async {
    folders = await MCDB.foldersByCollectionId(collectionId);
    foldersLoaded = true;
  }

  // ---------------------------------------------------------------------------
  // Sort Cache
  // ---------------------------------------------------------------------------

  static void sortCollections(String sortBy, bool asc) {
    collections.sort((c1, c2) => _collectionComparator(c1, c2, sortBy, asc));
  }

  static void sortEntries(String sortBy, bool asc) {
    entries_.sort((e1, e2) => _entryComparator(e1, e2, sortBy, asc));
    wantlist_.sort((e1, e2) => _entryComparator(e1, e2, sortBy, asc));
  }

  static void reverseCollections() {
    collections = collections.reversed.toList();
  }

  static void reverseEntries() {
    entries_ = entries_.reversed.toList();
    wantlist_ = wantlist_.reversed.toList();
  }

  static void reverseFolders() {
    folders = folders.reversed.toList();
  }

  static int _collectionComparator(
    Collection c1,
    Collection c2,
    String sortBy,
    bool asc,
  ) {
    var sortResult = switch (sortBy) {
      valueColumn => c1.value.compareTo(c2.value),
      collectionSizeColumn => c1.collectionSize.compareTo(c2.collectionSize),
      wantlistSizeColumn => c1.wantlistSize.compareTo(c2.wantlistSize),
      createdAtColumn => c1.createdAt.compareTo(c2.createdAt),
      nameColumn || _ => c1.name.compareTo(c2.name),
    };
    return (asc ? 1 : -1) * sortResult;
  }

  static int _entryComparator(
    Entry e1,
    Entry e2,
    String sortBy,
    bool asc,
  ) {
    var sortResult = switch (sortBy) {
      valueColumn => e1.value.compareTo(e2.value),
      createdAtColumn => e1.createdAt.compareTo(e2.createdAt),
      nameColumn || _ => e1.name.compareTo(e2.name),
    };
    return (asc ? 1 : -1) * sortResult;
  }
}
