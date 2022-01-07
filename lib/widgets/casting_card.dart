import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import 'package:movies_app/providers/movie_provider.dart';
import 'package:movies_app/models/models.dart';

class CastingCard extends StatelessWidget {

  final int movieId;

  const CastingCard({
    Key? key,
    required this.movieId
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {

    final moviesProdiver = Provider.of<MovieProvider>(context, listen: false);

    return FutureBuilder(
      future: moviesProdiver.getMovieCast(movieId),
      builder: (_, AsyncSnapshot<List<Cast>> snapshot) {
        if (!snapshot.hasData) {
          return const SizedBox(
            height: 180,
            child: Center(child: CircularProgressIndicator()),
          );
        }

        final List<Cast> cast = snapshot.data!;

        return Container(
          height: 180,
          margin: const EdgeInsets.only(bottom: 30),
          width: double.infinity,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: cast.length,
            itemBuilder: (_, index) => _CastCard(actor: cast[index])
          ),
        );
      },
    );
  }

}

class _CastCard extends StatelessWidget {

  final Cast actor;

  const _CastCard({
    Key? key,
    required this.actor
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10),
      height: 110,
      width: 110,
      child: Column(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: FadeInImage(
              placeholder: const AssetImage('assets/no-image.jpg'),
              image: NetworkImage(actor.fullProfilePath),
              fit: BoxFit.cover,
              height: 120,
              width: 100,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            actor.name,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
          )
        ],
      ),
    );
  }

}
