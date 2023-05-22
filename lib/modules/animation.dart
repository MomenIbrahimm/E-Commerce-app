import 'package:flutter/material.dart';

class SlideAnimate extends PageRouteBuilder{
  final page;
  SlideAnimate({this.page}):super(
    pageBuilder:(context,animation,animationTwo) => page,
    transitionsBuilder: (context,animation,animationTwo,child){
      var begin =0.0;
      var end =1.0;
      var tween =Tween(begin: begin,end: end);
      var curves = CurvedAnimation(parent: animation, curve: Curves.fastOutSlowIn);
      // return Align(child: SizeTransition(sizeFactor: animation,child: child),);
      return FadeTransition(opacity: animation,child: Align(child: SizeTransition(sizeFactor: animation,child: child,),),);
    }
  );
}