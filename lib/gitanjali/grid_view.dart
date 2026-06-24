import 'package:flutter/material.dart';

class MyApp extends StatefulWidget {
  const MyApp({super.key});
  @override
  State<MyApp> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(),
        body: Center(
          child: GridView(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3, crossAxisSpacing: 5, mainAxisSpacing: 2),
            children: [
              Image.network(
                  'https://cdn.pixabay.com/photo/2015/04/23/22/00/tree-736885_640.jpg'),
              Image.network(
                  'https://cdn.pixabay.com/photo/2017/01/12/06/25/birds-1973872_960_720.jpg'),
              Image.network(
                  'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRINNzOtuyfM2iHaiBfbdu7_m2UgMuanAyAzWQK69TeXToPmwU6LdLP2YjBqvQzlxMkjWs&usqp=CAU'),
              Image.network(
                  'https://cdn.pixabay.com/photo/2015/04/23/22/00/tree-736885_640.jpg'),
              Image.network(
                  'https:cdn.pixabay.com/photo/2017/01/12/06/25/birds-1973872_960_720.jpg'),
              Image.network(
                  'https://cdn.pixabay.com/photo/2015/04/23/22/00/tree-736885_1280.jpg'),
              Image.network(
                  'https://akm-img-a-in.tosshub.com/indiatoday/images/story/202007/nature-3289812_1280_0.jpeg?size=690:388'),
              Image.network(
                  'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQ90pagD-UDbJkBpOGluYhTWiJohDzOv9MtVkBbJkJsdg&s'),
              Image.network(
                  'https://image.shutterstock.com/image-photo/womans-hand-fern-leaf-man-260nw-2190358695.jpg'),
              Image.network(
                  'https://static.vecteezy.com/system/resources/thumbnails/024/669/489/small/mountain-countryside-landscape-at-sunset-dramatic-sky-over-a-distant-valley-green-fields-and-trees-on-hill-beautiful-natural-landscapes-of-the-carpathians-generative-ai-variation-5-photo.jpeg'),
              Image.network(
                  'https://cdn.pixabay.com/photo/2015/04/23/22/00/tree-736885_1280.jpg'),
              Image.network(
                  'https://akm-img-a-in.tosshub.com/indiatoday/images/story/202007/nature-3289812_1280_0.jpeg?size=690:388'),
              Image.network(
                  'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQ90pagD-UDbJkBpOGluYhTWiJohDzOv9MtVkBbJkJsdg&s'),
              Image.network(
                  'https://image.shutterstock.com/image-photo/womans-hand-fern-leaf-man-260nw-2190358695.jpg'),
              Image.network(
                  'https://static.vecteezy.com/system/resources/thumbnails/024/669/489/small/mountain-countryside-landscape-at-sunset-dramatic-sky-over-a-distant-valley-green-fields-and-trees-on-hill-beautiful-natural-landscapes-of-the-carpathians-generative-ai-variation-5-photo.jpeg'),
              Image.network(
                  'https://cdn.pixabay.com/photo/2015/04/23/22/00/tree-736885_1280.jpg'),
              Image.network(
                  'https://akm-img-a-in.tosshub.com/indiatoday/images/story/202007/nature-3289812_1280_0.jpeg?size=690:388'),
              Image.network(
                  'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQ90pagD-UDbJkBpOGluYhTWiJohDzOv9MtVkBbJkJsdg&s'),
              Image.network(
                  'https://image.shutterstock.com/image-photo/womans-hand-fern-leaf-man-260nw-2190358695.jpg'),
            ],
          ),
        ),
      ),
    );
  }
}
