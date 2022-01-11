import 'package:flutter/material.dart';

import 'package:card_swiper/card_swiper.dart';
import 'package:movies_app/models/models.dart';

class CardSwiper extends StatelessWidget {

  final List<Movie> movies;

  const CardSwiper({
    Key? key,
    required this.movies
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {

    final _size = MediaQuery.of(context).size;

    if (movies.isEmpty) {
      return SizedBox(
        height: _size.height * 0.5,
        width: double.infinity,
        child: const Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return SizedBox(
      height: _size.height * 0.5,
      width: double.infinity,
      child: Swiper(
        itemCount: movies.length,
        itemBuilder: (_, index) {
          final movie = movies[index];
          movie.heroId = 'swiper-${ movie.id }';

          return GestureDetector(
            onTap: () => Navigator.pushNamed(context, 'details', arguments: movie),
            child: Hero(
              tag: movie.heroId!,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: FadeInImage(
                  placeholder: const AssetImage('assets/no-image.jpg'),
                  image: NetworkImage(movie.fullPosterPath),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          );
        },
        itemHeight: _size.height * 0.4,
        itemWidth: _size.width * 0.6,
        layout: SwiperLayout.STACK
      ),
    );
  }

}
