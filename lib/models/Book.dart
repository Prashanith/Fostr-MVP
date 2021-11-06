class VolumeJson {
  final int totalItems;

  final String kind;

  final List<Item> items;

  VolumeJson(this.items, this.kind, this.totalItems);

  factory VolumeJson.fromJson(Map<String, dynamic> parsedJson) {
    var list = parsedJson['items'] as List;

    List<Item> itemList = list.map((i) => Item.fromJson(i)).toList();
    print(itemList.length);

    return VolumeJson(
        itemList,
        parsedJson['kind'],
        parsedJson['totalItems']);
  }
}

class Item {
  final String kind;

  final String etag;

  final VolumeInfo volumeinfo;

  Item(this.kind, this.etag, this.volumeinfo);

  factory Item.fromJson(Map<String, dynamic> parsedJson) {
    return Item(
        parsedJson['kind'],
        parsedJson['etag'],
        VolumeInfo.fromJson(parsedJson['volumeInfo']));
  }
}

class VolumeInfo {
  final String title;

  final String publisher;

  final String printType;

  final ImageLinks image;



  VolumeInfo(
      this.printType, this.title, this.publisher, this.image, );

  factory VolumeInfo.fromJson(Map<String, dynamic> parsedJson) {

    print('GETTING DATA');
    //print(isbnList[1]);
    return VolumeInfo(
      parsedJson['title'],
      parsedJson['publisher'],
      parsedJson['printType'],
      ImageLinks.fromJson(
        parsedJson['imageLinks'],
      ),

    );
  }
}

class ImageLinks {
  final String thumb;

  ImageLinks(this.thumb);

  factory ImageLinks.fromJson(Map<String, dynamic> parsedJson) {
    return ImageLinks(parsedJson['thumbnail']);
  }
}

class ISBN {
  final String iSBN13;
  final String type;

  ISBN(this.iSBN13, this.type);

  factory ISBN.fromJson(Map<String, dynamic> parsedJson) {
    return ISBN(
      parsedJson['identifier'],
      parsedJson['type'],
    );
  }
}