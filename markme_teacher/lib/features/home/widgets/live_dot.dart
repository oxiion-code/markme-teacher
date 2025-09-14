import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';

class LiveDot extends StatefulWidget{
  const LiveDot({super.key});



  @override
  State<LiveDot> createState() => _LiveDotState();
}

class _LiveDotState extends State<LiveDot> with SingleTickerProviderStateMixin {
  late AnimationController  _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState(){
    super.initState();
    _controller= AnimationController(vsync: this, duration: const Duration( seconds: 1))..repeat(reverse: true);
    _scaleAnimation=Tween<double>(begin: 1.0,end: 1.4).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }
  @override
  void dispose(){
    _controller.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return ScaleTransition(scale: _scaleAnimation,child:const Icon(
      MaterialCommunityIcons.circle,
      color: Colors.redAccent,
      size: 20,
    ),);
  }
}