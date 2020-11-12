import 'package:flutter/material.dart';
import 'package:movies_app/src/providers/films_provider.dart';
import 'package:movies_app/src/search/search_delegate.dart';
import 'package:movies_app/src/widgets/card_swiper_widget.dart';
import 'package:movies_app/src/widgets/card_swiper_widget_horizontal.dart';

class HomePage extends StatelessWidget {
  final filmsProvider = new FilmsProvider();

  @override
  Widget build(BuildContext context) {
    filmsProvider.getPopular();

    return Scaffold(
        appBar: AppBar(
          title: Text('Movies on the billboard'),
          backgroundColor: Colors.indigoAccent,
          actions: [
            IconButton(
              icon: Icon(Icons.search),
              onPressed: () {
                showSearch(
                  context: context,
                  delegate: DataSearch(),
                );
              },
            )
          ],
        ),
        body: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [_swiperCards(), _swiperFooterCards(context)],
          ),
        ));
  }

  Widget _swiperCards() {
    return FutureBuilder(
      future: filmsProvider.getNowPlaying(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.hasData) {
          return CardSwiper(contain: snapshot.data);
        } else {
          return Container(
              height: 400.0, child: Center(child: CircularProgressIndicator()));
        }
      },
    );

    // filmsProvider.GetNowPlaying();
    // return CardSwiper(contain: [1, 2, 3, 4, 5]);
  }

  Widget _swiperFooterCards(BuildContext context) {
    return Container(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
              padding: EdgeInsets.only(left: 20.0),
              child: Text('Populares',
                  style: Theme.of(context).textTheme.headline6)),
          SizedBox(
            height: 5.0,
          ),
          StreamBuilder(
            // future: filmsProvider.getPopular(),
            stream: filmsProvider.popularStream,
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.hasData) {
                return CardSwiperHorizontal(
                  contain: snapshot.data,
                  nextPage: filmsProvider.getPopular,
                );
              } else {
                return Container(
                    child: Center(child: CircularProgressIndicator()));
              }
            },
          ),
        ],
      ),
    );
  }
}
