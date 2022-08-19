// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';

class CustomImageContainer extends StatelessWidget {
  final String? imageUrl;
  final VoidCallback? onPressed;
  const CustomImageContainer({Key? key, this.imageUrl, this.onPressed})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    Widget plus = Align(
      alignment: Alignment.bottomRight,
      child: IconButton(
          icon: Icon(
            Icons.add_circle,
            color: Theme.of(context).accentColor,
          ),
          onPressed: onPressed ?? () {}),
    );
    return Padding(
      padding: const EdgeInsets.only(bottom: 10.0, right: 10.0),
      child: Container(
        height: 150,
        width: 100,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5.0),
          border: Border(
            bottom: BorderSide(
              width: 1,
              color: imageUrl != null
                  ? Colors.white
                  : Theme.of(context).primaryColor,
            ),
            top: BorderSide(
              width: 1,
              color: imageUrl != null
                  ? Colors.white
                  : Theme.of(context).primaryColor,
            ),
            left: BorderSide(
              width: 1,
              color: imageUrl != null
                  ? Colors.white
                  : Theme.of(context).primaryColor,
            ),
            right: BorderSide(
              width: 1,
              color: imageUrl != null
                  ? Colors.white
                  : Theme.of(context).primaryColor,
            ),
          ),
        ),
        child: (imageUrl == null)
            ? plus
            : onPressed != null
                ? Stack(children: [
                    Image.network(
                      imageUrl ?? "",
                      fit: BoxFit.cover,
                      loadingBuilder: (BuildContext context, Widget child,
                          ImageChunkEvent? loadingProgress) {
                        if (loadingProgress == null) return child;
                        return Center(
                          child: CircularProgressIndicator(
                            value: loadingProgress.expectedTotalBytes != null
                                ? loadingProgress.cumulativeBytesLoaded /
                                    loadingProgress.expectedTotalBytes!
                                : null,
                          ),
                        );
                      },
                    ),
                    plus
                  ])
                : Image.network(
                    imageUrl ?? "",
                    fit: BoxFit.cover,
                    loadingBuilder: (BuildContext context, Widget child,
                        ImageChunkEvent? loadingProgress) {
                      if (loadingProgress == null) return child;
                      return Center(
                        child: CircularProgressIndicator(
                          value: loadingProgress.expectedTotalBytes != null
                              ? loadingProgress.cumulativeBytesLoaded /
                                  loadingProgress.expectedTotalBytes!
                              : null,
                        ),
                      );
                    },
                  ),
      ),
    );
  }
}
