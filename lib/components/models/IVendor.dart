import 'package:Rozgar/components/models/IProduct.dart';

class Ivendor {
  final int cid;
  final int cateId;
  final int sCateId;
  final String vendorName;
  final String phoneNumber;
  final String email;
  final String adminNotes;
  final int vendorStatus;
  final int KIDNumber;
  final String cnic;
  final String vAddress;
  final String vendorIcon;
  final String userName;
  final String password;
  final String hasePassword;

  Ivendor(
      {
        required this.cid,
        required this.cateId,
        required this.sCateId,
        required this.vendorName,
        required this.phoneNumber,
        required this.email,
        required this.adminNotes,
        required this.vendorStatus,
        required this.KIDNumber,
        required this.cnic,
        required this.vAddress,
        required this.vendorIcon,
        required this.userName,
        required this.password,
        required this.hasePassword
      });
      factory Ivendor.fromJson(Map<dynamic,dynamic> json)=>Ivendor(
      cid: json['cid'], 
      cateId: json['cateId'], 
      sCateId: json['sCateId'], 
      vendorName: json['vendorName'], 
      phoneNumber: json['phoneNumber'], 
      email: json['email'], 
      adminNotes: json['adminNotes'], 
      vendorStatus: json['vendorStatus'], 
      KIDNumber: json['KIDNumber'], 
      cnic: json['cnic'], 
      vAddress: json['vAddress'], 
      vendorIcon: json['vendorIcon'], 
      userName: json['userName'], 
      password: json['password'], 
      hasePassword: json['hasePassword']);

}
