import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:markme_teacher/core/theme/color_palette.dart';

class ProfilePhotoSelection extends StatefulWidget {
  File? profileImage;
  Function(File?) onSelectImage;
  ProfilePhotoSelection({
    super.key,
    required this.profileImage,
    required this.onSelectImage,
  });

  @override
  State<ProfilePhotoSelection> createState() => _ProfilePhotoSelectionState();
}

class _ProfilePhotoSelectionState extends State<ProfilePhotoSelection> {
  ImagePicker picker= ImagePicker();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Stack(
        children: [
          CircleAvatar(
            radius: 70,
            backgroundColor: AppColors.primary.withValues(alpha: 0.4),
            backgroundImage: widget.profileImage != null
                ? FileImage(widget.profileImage!)
                : null,
            child: widget.profileImage == null
                ? Icon(Icons.person, size: 80, color: AppColors.scaffoldBg)
                : null,
          ),
          Positioned(
              bottom: 0,
              right: 0,
              child: InkWell(
                onTap:() async{
                  final pickedFile= await picker.pickImage(source: ImageSource.gallery);
                  if(pickedFile !=null){
                    setState(() {
                      widget.onSelectImage(File(pickedFile.path));
                    });
                  }
                }, child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.accent,
                  shape: BoxShape.circle,
                  border:  Border.all(color: Colors.white, width: 2),
                ),
                child:const Icon(
                Icons.camera_enhance,
                color: Colors.white,
                size: 20,
              ),
              ),
              ),
              )
        ],
      ),
    );
  }
}
