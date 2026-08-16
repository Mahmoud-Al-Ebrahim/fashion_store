/// Response model for `GET StoreRequest/GetFilesByStore/{storeId}` -> `data`.
class StoreRequestFilesModel {
  final String? nationalIdFrontImage;
  final String? nationalIdBackImage;
  final String? storeLicenseImage;

  StoreRequestFilesModel({
    this.nationalIdFrontImage,
    this.nationalIdBackImage,
    this.storeLicenseImage,
  });

  factory StoreRequestFilesModel.fromJson(Map<String, dynamic> json) {
    return StoreRequestFilesModel(
      nationalIdFrontImage: json['nationalIdFrontImage']?.toString(),
      nationalIdBackImage: json['nationalIdBackImage']?.toString(),
      storeLicenseImage: json['storeLicenseImage']?.toString(),
    );
  }
}
