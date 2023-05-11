import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

import '../../screens/selectphoto/select_photo_options_screen.dart';

class ImagePickerWidget extends StatefulWidget {
  final Function(File?) onImageSelected;

  const ImagePickerWidget({Key? key, required this.onImageSelected})
      : super(key: key);

  @override
  _ImagePickerWidgetState createState() => _ImagePickerWidgetState();
}

class _ImagePickerWidgetState extends State<ImagePickerWidget>
    with SingleTickerProviderStateMixin {
  File? image;
  late AnimationController _animationController;
  late Animation<double> _animation;
  Future pickImage(ImageSource source) async {
    try {
      final image = await ImagePicker().pickImage(source: source);
      if (image == null) return;
      File? img = File(image.path);
      img = await cropImage(imageFile: img);

      setState(() {
        this.image = img;
      });
      widget.onImageSelected(img);
      _animationController.forward(from: 0.0);
      Navigator.of(context).pop();
    } on PlatformException catch (e) {
      print(e);
      Navigator.of(context).pop();
    }
  }

  Future<File?> cropImage({required File imageFile}) async {
    CroppedFile? croppedImage =
        await ImageCropper().cropImage(sourcePath: imageFile.path);
    if (croppedImage == null) return null;
    return File(croppedImage.path);
  }

  void removeImage() {
    _animationController.forward(from: 1.0).then((_) {
      setState(() {
        image = null;
      });
      widget.onImageSelected(null);
    });
  }

  void showSelectPhotoOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(25.0),
        ),
      ),
      builder: (context) => DraggableScrollableSheet(
          initialChildSize: 0.28,
          maxChildSize: 0.4,
          minChildSize: 0.28,
          expand: false,
          builder: (context, scrollController) {
            return SingleChildScrollView(
              controller: scrollController,
              child: SelectPhotoOptionsScreen(
                onTap: pickImage,
              ),
            );
          }),
    );
  }

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 1000),
    );
    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        if (image != null) ...[
          Stack(
            children: [
              ScaleTransition(
                scale: _animation,
                child: Container(
                  width: 140.0,
                  height: 140.0,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                  ),
                  child: CircleAvatar(
                    radius: 140,
                    backgroundImage: Image.file(
                      image!,
                    ).image,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Positioned(
                bottom: 0,
                left: 0,
                child: InkWell(
                  onTap: removeImage,
                  child: CircleAvatar(
                    backgroundColor: Colors.red,
                    radius: 25.0,
                    child: Icon(
                      Icons.cameraswitch,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          )
        ] else ...[
          Stack(
            children: [
              Container(
                width: 140.0,
                height: 140.0,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                    image: ExactAssetImage('assets/images/profile.png'),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Positioned(
                bottom: 0,
                left: 0,
                child: InkWell(
                  onTap: () {
                    showSelectPhotoOptions(context);
                  },
                  child: CircleAvatar(
                    backgroundColor: Colors.blue[400],
                    radius: 25.0,
                    child: Icon(
                      Icons.camera_alt,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          )
        ],
      ],
    );
  }
}
