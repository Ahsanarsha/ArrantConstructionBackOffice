import 'package:cached_network_image/cached_network_image.dart';
import '../../helpers/app_constants.dart' as constants;
import 'package:flutter/material.dart';

class UserCircularAvatar extends StatelessWidget {
  final String imgUrl;
  final double width;
  final double height;
  final BoxFit adjustment;
  final bool hasBorder;
  const UserCircularAvatar(
      {required this.imgUrl,
      this.height = 100.0,
      this.width = 100.0,
      this.adjustment = BoxFit.contain,
      this.hasBorder = true,
      Key? key})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: '${constants.storageBaseUrl}$imgUrl',
      placeholder: (context, url) {
        return Container(
          height: height,
          width: width,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            image: DecorationImage(
              image: AssetImage("assets/img/loading.gif"),
              fit: BoxFit.contain,
            ),
          ),
        );
      },
      imageBuilder: (context, imageProvider) {
        return Container(
          // height: height,
          // width: width,
          padding: hasBorder ? const EdgeInsets.all(3) : EdgeInsets.zero,
          decoration: const BoxDecoration(
            // to set one color border around image
            color: Colors.white,
            // to set gradiet border around image
            // gradient: LinearGradient(
            //   colors: [
            //     Colors.amber,
            //     Colors.redAccent,
            //   ],
            // ),
            shape: BoxShape.circle,
          ),
          child: Container(
            height: height,
            width: width,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              image: DecorationImage(
                image: imageProvider,
                fit: adjustment,
              ),
            ),
          ),
        );
      },
      errorWidget: (context, error, d) {
        // print(error.toString());
        // print(d.toString());
        return Container(
          height: height,
          width: width,
          decoration: const BoxDecoration(
            // borderRadius: BorderRadius.circular(5),
            shape: BoxShape.circle,
            image: DecorationImage(
              image: AssetImage("assets/img/profile_placeholder.png"),
              fit: BoxFit.contain,
            ),
          ),
        );
      },
    );
  }
}
