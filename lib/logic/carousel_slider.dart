import 'package:carousel_slider/carousel_controller.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'carousel_slider.g.dart';

@Riverpod(keepAlive: true)
CarouselSliderController carousel(CarouselRef ref) =>
    CarouselSliderController();
