import 'dart:convert';

import 'package:flutter/material.dart';

class VehicleInfoScreen extends StatefulWidget {
  String json;

  VehicleInfoScreen(this.json);

  @override
  _VehicleInfoScreenState createState() => _VehicleInfoScreenState();
}

class _VehicleInfoScreenState extends State<VehicleInfoScreen> {
  String jsonString;
  bool _isLoading = true;
  TextStyle titleTextStyle =
      TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 16);
  TextStyle valueTextStyle = TextStyle(color: Colors.grey[700], fontSize: 14);
  VehicleInfo vehicleInfo;
  List<OdometerEvent> odometerEvents = [];
  List<BrandInfoItem> brandsInfo = [];
  List<Auction> auctions = [];

  Future parseJson() async {
    String jsonString = widget.json;
    final jsonResponse = jsonDecode(jsonString);
    vehicleInfo = VehicleInfo.fromJson(((((jsonResponse
            as Map<String, dynamic>)['result'])
        as Map<String, dynamic>)['report'] as Map<String, dynamic>)['decoder']);
    odometerEvents.addAll(((((((jsonResponse as Map<String, dynamic>)['result'])
                as Map<String, dynamic>)['report'])['nmvtis'])[
            'historyInformation'] as List<dynamic>)
        .map((e) => OdometerEvent.fromJson(e))
        .toList());
    brandsInfo.addAll(((((((jsonResponse as Map<String, dynamic>)['result'])
                as Map<String, dynamic>)['report'])['nmvtis'])[
            'brandsInformation'] as List<dynamic>)
        .map((e) => BrandInfoItem.fromJson(e))
        .toList());
    auctions.addAll((((((jsonResponse as Map<String, dynamic>)['result'])
            as Map<String, dynamic>)['report'])['auctions'] as List<dynamic>)
        .map((e) => Auction.fromJson(e))
        .toList());
  }

  Widget _buildHeader(String title) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.only(top: 16),
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 16),
      color: Colors.grey[300],
      child: Text(
        title,
        style: TextStyle(
            color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildListItem(String title, String value) {
    return Container(
      padding: EdgeInsets.all(6),
      child: Row(
        children: [
          Text(title, style: titleTextStyle),
          SizedBox(width: 8),
          Text(value ?? 'No Data', style: valueTextStyle)
        ],
      ),
    );
  }

  Widget _buildVehicleInfoColumn() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      child: Column(
        children: [
          _buildListItem('VIN: ', vehicleInfo.vin),
          _buildListItem('السنة: ', vehicleInfo.year),
          _buildListItem('نوع المركية: ', vehicleInfo.make),
          _buildListItem('الموديل: ', vehicleInfo.model),
          _buildListItem('الشكل: ', vehicleInfo.trim),
          _buildListItem('مكان الصنع: ', vehicleInfo.madeIn),
          _buildListItem('النمط: ', vehicleInfo.style),
          _buildListItem('المحرك: ', vehicleInfo.engine),
          _buildListItem('خزان الوقود: ', vehicleInfo.fuelTank),
          _buildListItem('الأميال داخل المدينة: ', vehicleInfo.cityMileage),
          _buildListItem(
              'الأميال على الطرق السريعة: ', vehicleInfo.highwayMileage),
          _buildListItem('نوع التحكم: ', vehicleInfo.steeringType),
          _buildListItem('عدد المقاعد: ', vehicleInfo.standardSeating),
          _buildListItem('مقاعد اختيارية: ', vehicleInfo.optionalSeating),
        ],
      ),
    );
  }

  Widget _buildOdoMeterEventsTableHeader() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      color: Colors.grey[300],
      child: Row(
        children: [
          Expanded(
            child: Text(
              'التاريخ',
              textAlign: TextAlign.center,
              style: titleTextStyle,
            ),
          ),
          Expanded(
            child: Text(
              'عدد الأميال',
              textAlign: TextAlign.center,
              style: titleTextStyle,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOdoMeterEventsTableRow(OdometerEvent event) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Expanded(
            child: Text(
              event.date,
              textAlign: TextAlign.center,
              style: valueTextStyle,
            ),
          ),
          Expanded(
            child: Text(
              event.readingMeasure,
              textAlign: TextAlign.center,
              style: valueTextStyle,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOdoMeterEventsList() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      child: ListView.builder(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        itemCount: odometerEvents.length,
        itemBuilder: (ctx, index) => _buildOdoMeterEventsTableRow(
          odometerEvents[index],
        ),
      ),
    );
  }

  Widget _buildBrandInfoItem(BrandInfoItem item) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(item.name, style: titleTextStyle),
          SizedBox(height: 6),
          Text(item.description, style: valueTextStyle),
        ],
      ),
    );
  }

  Widget _buildBrandsInfoList() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      child: ListView.builder(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        itemCount: brandsInfo.length,
        itemBuilder: (ctx, index) => _buildBrandInfoItem(
          brandsInfo[index],
        ),
      ),
    );
  }

  Widget _buildAuctionItem(Auction auction) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Column(
        children: [
          _buildListItem('التاريخ: ', auction.date),
          _buildListItem('عداد المسافات: ', auction.odometer.toString()),
          _buildListItem('حالة عداد المسافات: ', auction.odometer_status),
          _buildListItem('اللون: ', auction.color),
          _buildListItem('كلفة الصيانة: ', auction.repair_cost),
          _buildListItem('العطل الأساسي: ', auction.primary_damage),
          _buildListItem('أعطال ثانوية: ', auction.secondary_damage),
          _buildListItem('الموقع: ', auction.location),
          _buildListItem('ناريخ البيع: ', auction.sale_date),
          _buildListItem('تاريخ الإعلان: ', auction.announced_at_auction),
          ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: auction.images.length,
              itemBuilder: (ctx, index) => Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Image.network(auction.images[index]),
                  )),
          Container(
            height: 1,
            color: Colors.grey[300],
          )
        ],
      ),
    );
  }

  Widget _buildAuctionsList() {
    return ListView.builder(
      itemCount: auctions.length,
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemBuilder: (ctx, index) => _buildAuctionItem(
        auctions[index],
      ),
    );
  }

  @override
  void initState() {
    parseJson().then((value) => setState(() {
          _isLoading = false;
        }));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Vehicle Info.'),
      ),
      body: _isLoading
          ? Container()
          : SingleChildScrollView(
              child: Directionality(
                textDirection: TextDirection.rtl,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _buildHeader('معلومات المركبة'),
                    _buildVehicleInfoColumn(),
                    _buildHeader('قراءات عداد المسافات'),
                    _buildOdoMeterEventsTableHeader(),
                    _buildOdoMeterEventsList(),
                    _buildHeader('معلومات الماركة'),
                    _buildBrandsInfoList(),
                    _buildHeader('المزاد العلني'),
                    _buildAuctionsList()
                  ],
                ),
              ),
            ),
    );
  }
}

class VehicleInfo {
  final String vin;
  final String year;
  final String make;
  final String model;
  final String trim;
  final String madeIn;
  final String style;
  final String engine;
  final String fuelTank;
  final String cityMileage;
  final String highwayMileage;
  final String antiBrakeSystem;
  final String steeringType;
  final String standardSeating;
  final String optionalSeating;

  VehicleInfo({
    this.vin,
    this.year,
    this.make,
    this.model,
    this.trim,
    this.madeIn,
    this.style,
    this.engine,
    this.fuelTank,
    this.cityMileage,
    this.highwayMileage,
    this.antiBrakeSystem,
    this.steeringType,
    this.standardSeating,
    this.optionalSeating,
  });

  factory VehicleInfo.fromJson(Map<String, dynamic> jsonData) {
    return VehicleInfo(
      vin: jsonData['vin'] ?? 'No Data',
      year: jsonData['year'] ?? 'No Data',
      make: jsonData['make'] ?? 'No Data',
      model: jsonData['model'] ?? 'No Data',
      trim: jsonData['trim'] ?? 'No Data',
      madeIn: jsonData['madeIn'] ?? 'No Data',
      style: jsonData['style'] ?? 'No Data',
      engine: jsonData['engine'] ?? 'No Data',
      fuelTank: jsonData['fuelTank'] ?? 'No Data',
      cityMileage: jsonData['cityMileage'] ?? 'No Data',
      highwayMileage: jsonData['highwayMileage'] ?? 'No Data',
      antiBrakeSystem: jsonData['antiBrakeSystem'] ?? 'No Data',
      steeringType: jsonData['steeringType'] ?? 'No Data',
      standardSeating: jsonData['standardSeating'] ?? 'No Data',
      optionalSeating: jsonData['optionalSeating'] == null ||
              jsonData['optionalSeating'].toString().isEmpty
          ? 'No Data'
          : jsonData['optionalSeating'],
    );
  }
}

class OdometerEvent {
  final String date;
  final String readingMeasure;

  OdometerEvent({this.date, this.readingMeasure});

  factory OdometerEvent.fromJson(Map<String, dynamic> jsonData) {
    return OdometerEvent(
        date: (jsonData['TitleIssueDate'] as Map<String, dynamic>)['Date']
            .toString()
            .substring(0, 10),
        readingMeasure: jsonData['VehicleOdometerReadingMeasure']);
  }
}

class BrandInfoItem {
  final String name;
  final String description;

  BrandInfoItem({this.name, this.description});

  factory BrandInfoItem.fromJson(Map<String, dynamic> jsonData) {
    return BrandInfoItem(
        name: jsonData['name'], description: jsonData['description']);
  }
}

class Auction {
  final String announced_at_auction;
  final int odometer;
  final String odometer_status;
  final String color;
  final String repair_cost;
  final String own_doc;
  final String primary_damage;
  final String secondary_damage;
  final String location;
  final String sale_date;
  final String condition;
  final String vendor;
  final String date;
  final List<String> images;

  Auction({
    this.announced_at_auction,
    this.odometer,
    this.odometer_status,
    this.color,
    this.repair_cost,
    this.own_doc,
    this.primary_damage,
    this.secondary_damage,
    this.location,
    this.sale_date,
    this.condition,
    this.vendor,
    this.date,
    this.images,
  });

  factory Auction.fromJson(Map<String, dynamic> jsonData) {
    return Auction(
        announced_at_auction: jsonData['announced_at_auction'],
        odometer: jsonData['odometer'],
        odometer_status: jsonData['odometer_status'],
        color: jsonData['color'],
        repair_cost: jsonData['repair_cost'],
        own_doc: jsonData['own_doc'],
        primary_damage: jsonData['primary_damage'],
        secondary_damage: jsonData['secondary_damage'],
        location: jsonData['location'],
        sale_date: jsonData['sale_date'],
        condition: jsonData['condition'],
        vendor: jsonData['vendor'],
        date: jsonData['date'],
        images: (jsonData['images'] as List<dynamic>)
            .map((e) => e.toString())
            .toList());
  }
}
