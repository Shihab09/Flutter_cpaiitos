import 'package:flutter/material.dart';

class ImageTextButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final String? image;
  final double imageHeight;
  final double imageWidth;
  // final double radius;
  final String? text;

  ImageTextButton({
    @required this.onPressed,
    @required this.image,
    this.imageHeight = 200,
    this.imageWidth = 200,
    // this.radius = 28,
    @required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Card(
        // semanticContainer: true,
        elevation: 8,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        clipBehavior: Clip.antiAlias,
        child: Stack(
          children: [
            Container(
              child: Ink.image(
                image: AssetImage(image!),
                child: InkWell(
                  onTap: onPressed,
                ),
                fit: BoxFit.fill,
                height: imageHeight,
              ),
            ),
            SizedBox(
              height: 5,
            ),
            Container(
              child: Text(
                text!.toString(),
                textAlign: TextAlign.center,
                style: const TextStyle(
                  decoration: TextDecoration.none,
                  color: Color.fromARGB(255, 9, 9, 87),
                  fontWeight: FontWeight.bold,
                  fontSize: 16.0,
                  backgroundColor: Color.fromARGB(207, 210, 240, 234),
                ),
              ),
            )
          ],
          alignment: Alignment.bottomCenter,
        ),
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}
//             Card(
//       elevation: 8,
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
//       clipBehavior: Clip.hardEdge,
//       child: InkWell(
//         onTap: onPressed,
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             Ink.image(
//               image: AssetImage(image!),
//               height: imageHeight,
//               fit: BoxFit.cover,
//             ),
//             SizedBox(height: 6),
//             Text(
//               text!.toString(),
//               style: const TextStyle(
//                 decoration: TextDecoration.none,
//                 color: Colors.black,
//                 fontWeight: FontWeight.bold,
//                 fontSize: 20.0,
//                 backgroundColor: Color.fromARGB(0, 12, 17, 19),
//               ),
//             ),
//             SizedBox(height: 6),
//           ],
//         ),
//       ),
//     )
//         //  debugShowCheckedModeBanner: false,
//         );
//   }
// }
