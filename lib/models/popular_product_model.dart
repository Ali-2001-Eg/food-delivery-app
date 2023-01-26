class PopularProductModel {
  int? _totalSize;
  int? _typeId;
  int? _offset;
   late List<ProductsModel> _products;
   List<ProductsModel>get products=>_products;

  PopularProductModel.fromJson(Map<String, dynamic> json) {
    _totalSize = json['total_size'];
    _typeId = json['type_id'];
    _offset = json['offset'];
    if (json['products'] != null) {
      _products = <ProductsModel>[];
      for (var v in (json['products'])) {
        _products.add(ProductsModel.fromJson(v));
      }
    }
  }
}

class ProductsModel {
  int? id;
  String? name;
  String? description;
  int? price;
  int? stars;
  String? img;
  String? location;
  String? createdAt;
  String? updatedAt;
  int? typeId;



  ProductsModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    description = json['description'];
    price = json['price'];
    stars = json['stars'];
    img = json['img'];
    location = json['location'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    typeId = json['type_id'];
  }
  Map<String, dynamic> toJson(){
    return{
      "id": this.id,
      "name": this.name,
      "price": this.price,
      "img": this.img,
      "description": this.description,
      "updatedAt": this.updatedAt,
      "createdAt": this.createdAt,
      "stars": this.stars,
      "location": this.location,
      "location": this.location,
    };
  }
}
