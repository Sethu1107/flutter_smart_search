import 'package:flutter/material.dart';
import 'package:flutter_smart_search/constant/asset_constant.dart';
import 'custom_container_button.dart';

class NoDataView extends StatelessWidget {
  final String? imageString;
  final double? imageSize;
  final String? noDataContent;
  final Function? onTap;
  final Widget? noDataWidget;
  final Color? imageColor;
  final Color? containerColor;
  final double? textSize;
  final String? buttonText;
  final Color? buttonTextColor;
  const NoDataView({super.key , this.imageString,this.imageSize,
    this.noDataContent,this.onTap,this.noDataWidget,this.buttonText,
    this.imageColor =const Color(0xFFBDBDBD),this.textSize=12,
    this.containerColor,this.buttonTextColor});

  @override
  Widget build(BuildContext context) {
    return noDataWidget??Container(width:MediaQuery.of(context).size.width,
      padding:EdgeInsets.symmetric(horizontal:18),child:Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(height: 10),
          Image.asset(imageString ?? AssetConstant.noDataFiles,height: imageSize ?? 60,width: imageSize ?? 80,
            color:imageColor,),
          SizedBox(height: 10),
          Text(noDataContent ?? "No data found !",style:TextStyle(
            fontSize: 12, fontWeight: FontWeight.w500,),
          ),
          SizedBox(height: 15),
          CustomContainerButton(bgColor:containerColor??Color(0xff5D87FF),
            buttonText:buttonText??"Add New", textSize: textSize??12,
            textColor: buttonTextColor??Colors.white,onTap:(){
              if(onTap!=null){
                onTap!();
              }
            },horizontal:18,vertical:5,
          ),
          SizedBox(height: 15),
        ]),);
  }
}
