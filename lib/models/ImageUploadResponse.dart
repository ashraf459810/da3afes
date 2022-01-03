class ImageUploadResponse {
  String aZSVR;
  String fileName;
  String path;
  String fileSize;

  ImageUploadResponse.name(this.aZSVR);

  ImageUploadResponse({this.aZSVR, this.fileName, this.path, this.fileSize});

  ImageUploadResponse.fromJson(Map<String, dynamic> json) {
    aZSVR = json['AZSVR'];
    fileName = json['FileName'];
    path = json['Path'];
    fileSize = json['FileSize'];
  }

  @override
  String toString() {
    return 'ImageUploadResponse{aZSVR: $aZSVR, fileName: $fileName, path: $path, fileSize: $fileSize}';
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['AZSVR'] = this.aZSVR;
    data['FileName'] = this.fileName;
    data['Path'] = this.path;
    data['FileSize'] = this.fileSize;
    return data;
  }
}
