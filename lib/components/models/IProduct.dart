import 'package:flutter/cupertino.dart';

class Iproduct{
        final int cid;
        final int vendorId;
        final String productName;
        final String productImage;
        final double price;
        final String brand;
        final String pDescription;
        final int pStatus;

        Iproduct({
          required this.cid,
          required this.vendorId,
          required this.productName,
          required this.productImage,
          required this.price,
          required this.brand,
          required this.pDescription,
          required this.pStatus,
        });

        factory Iproduct.fromJson(Map<dynamic, dynamic> json)=>Iproduct(
          cid: json['cid'], 
          vendorId: json['vendorId'], 
          productName: json['productName'], 
          productImage: json['productImage'], 
          price: json['price'], 
          brand: json['brand'], 
          pDescription: json['pDescription'], 
          pStatus: json['pStatus']
          );
}