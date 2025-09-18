import 'package:flutter/material.dart';

class CustomContainerButton extends StatelessWidget {
  final Color bgColor;
  final Color textColor;
  final Function? onTap;
  final String buttonText;
  final double textSize;
  final FontWeight fontWeight;
  final double vertical;
  final double horizontal;
  final TextAlign align;
  final double circleRadius;
  final IconData? icon;
  final double size;
  final Color iconColor;
  final String imgString;
  final Color imgColor;
  final double letterSpacing;
  final MainAxisAlignment mainAxisAlignment;
  final double paddingHorizontal;
  final Color borderColor;
  const CustomContainerButton({super.key,this.onTap,required this.bgColor,this.imgString='',
    required this.buttonText,required this.textSize,this.iconColor=Colors.transparent,this.imgColor=Colors.transparent,
    required this.textColor,this.fontWeight=FontWeight.w400,this.vertical=10,this.horizontal=15,this.size=14,this.letterSpacing=0,
    this.align=TextAlign.center,this.circleRadius=15,this.paddingHorizontal=0,
    this.icon,this.mainAxisAlignment=MainAxisAlignment.spaceAround,this.borderColor=Colors.transparent});

  @override
  Widget build(BuildContext context) {
    return InkWell(onTap:(){
      if(onTap !=null){
        onTap!();
      }
    },borderRadius:BorderRadius.circular(circleRadius),
      child: Container(decoration:BoxDecoration(borderRadius:BorderRadius.circular(circleRadius),color:bgColor,
          border:Border.all(color:borderColor)),
        padding:EdgeInsets.symmetric(vertical:vertical,horizontal:horizontal),
        child:(imgString.trim().isNotEmpty || icon !=null)?

        Row(mainAxisAlignment:mainAxisAlignment, children: [
          (imgString.isNotEmpty)? ImageIcon(AssetImage(imgString),size:size,color:imgColor):
          (icon.toString().isNotEmpty)? Icon(icon,size:size,color:iconColor,):SizedBox.shrink(),
          Padding(padding: EdgeInsets.only(left:paddingHorizontal),
            child: Text(buttonText,textAlign:align,style:TextStyle(
                color: textColor,letterSpacing: letterSpacing,
                fontSize:textSize,fontWeight:fontWeight
            ),
            ),
          )
        ])
            :Text(buttonText,textAlign:align,style:TextStyle(
            color: textColor,letterSpacing:letterSpacing,
            fontSize:textSize,fontWeight:fontWeight),
        ),
      ),
    );
  }
}