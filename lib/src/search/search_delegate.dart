import 'package:flutter/material.dart';
import 'package:movies_app/src/models/film_model.dart';
import 'package:movies_app/src/providers/films_provider.dart';
import 'package:movies_app/src/widgets/card_swiper_widget.dart';

class DataSearch extends SearchDelegate {
  FilmsProvider filmsProvider = new FilmsProvider();

  String selection = '';

  final films = [
    'Spiderman',
    'Aquaman',
    'Batman',
    'Shazam!',
    'Ironman',
    'Capitan America'
  ];
  final filmsRecent = ['Spiderman', 'Aquaman'];

  @override
  List<Widget> buildActions(BuildContext context) {
    // Acciones de nuestro appbar
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      )
    ];

    // throw UnimplementedError();
  }

  @override
  Widget buildLeading(BuildContext context) {
    // Icono a la izquierda del appbar
    return IconButton(
      icon: AnimatedIcon(
          icon: AnimatedIcons.menu_arrow, progress: transitionAnimation),
      onPressed: () {
        close(context, null);
      },
    );
    // throw UnimplementedError();
  }

  @override
  Widget buildResults(BuildContext context) {
    // Builder que crea los resultados a mostrar
    return Center(
        child: Container(
      height: 100.0,
      width: 100.0,
      color: Colors.blueAccent,
      child: Text(selection),
    ));
    // throw UnimplementedError();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    // Sugerencias de busqueda
    if (query.isEmpty) {
      return Container();
    }

    return FutureBuilder(
      future: filmsProvider.getFilm(query),
      builder: (BuildContext context, AsyncSnapshot<List<Film>> snapshot) {
        if (snapshot.hasData) {
          final films = snapshot.data;

          return ListView(
              children: films.map((film) {
            return ListTile(
              leading: FadeInImage(
                placeholder: AssetImage('assets/img/no-image.jpg'),
                image: NetworkImage(film.getPosterImage()),
                width: 50.0,
                fit: BoxFit.contain,
              ),
              title: Text(film.title),
              subtitle: Text(film.originalTitle),
              onTap: () {
                close(context, null);
                film.uniqueId = '';
                Navigator.pushNamed(context, 'detail', arguments: film);
              },
            );
          }).toList());
        } else {
          return Center(child: CircularProgressIndicator());
        }
      },
    );
    // throw UnimplementedError();
  }

  // @override
  // Widget buildSuggestions(BuildContext context) {
  //   // Sugerencias de busqueda

  //   final listSuggestion = (query.isEmpty)
  //       ? filmsRecent
  //       : films
  //           .where((element) =>
  //               element.toLowerCase().startsWith(query.toLowerCase()))
  //           .toList();

  //   return ListView.builder(
  //     itemCount: listSuggestion.length,
  //     itemBuilder: (context, index) {
  //       return ListTile(
  //         leading: Icon(Icons.movie),
  //         title: Text(listSuggestion[index]),
  //         onTap: () {
  //           selection = listSuggestion[index];
  //           showResults(context);
  //         },
  //       );
  //     },
  //   );
  //   // throw UnimplementedError();
  // }
}
