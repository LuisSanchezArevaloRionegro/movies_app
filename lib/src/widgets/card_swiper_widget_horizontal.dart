import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:movies_app/src/models/film_model.dart';

class CardSwiperHorizontal extends StatelessWidget {
  final List<Film> contain;
  final Function nextPage;

  CardSwiperHorizontal({@required this.contain, @required this.nextPage});

  final _pageController = new PageController(
    initialPage: 1,
    viewportFraction: 0.3,
  );

  @override
  Widget build(BuildContext context) {
    final _screenSize = MediaQuery.of(context).size;

    _pageController.addListener(() {
      if (_pageController.position.pixels >=
          _pageController.position.maxScrollExtent - 200) {
        nextPage();
      }
    });

    return Container(
      height: _screenSize.height * 0.2,
      child: PageView.builder(
        controller: _pageController,
        pageSnapping: false,
        // children: _cards(context),
        itemCount: contain.length,
        itemBuilder: (context, index) {
          return _card(context, contain[index]);
        },
      ),
    );
  }

  Widget _card(BuildContext context, Film film) {
    film.uniqueId = film.id.toString() + '-poster';

    final card = Container(
      margin: EdgeInsets.only(right: 15.0),
      child: Column(
        children: [
          Hero(
            tag: film.uniqueId,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20.0),
              child: FadeInImage(
                placeholder: AssetImage('assets/img/loading.gif'),
                image: NetworkImage(film.getPosterImage()),
                fit: BoxFit.cover,
                height: 100.0,
              ),
            ),
          ),
          SizedBox(
            height: 5.0,
          ),
          Text(
            film.title,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.caption,
          )
        ],
      ),
    );

    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, 'detail', arguments: film);
      },
      child: card,
    );
  }

  List<Widget> _cards(BuildContext context) {
    return contain.map((e) {
      return Container(
        margin: EdgeInsets.only(right: 15.0),
        child: Column(
          children: [
            Hero(
              tag: e.id,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20.0),
                child: FadeInImage(
                  placeholder: AssetImage('assets/img/loading.gif'),
                  image: NetworkImage(e.getPosterImage()),
                  fit: BoxFit.cover,
                  height: 100.0,
                ),
              ),
            ),
            SizedBox(
              height: 5.0,
            ),
            Text(
              e.title,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.caption,
            )
          ],
        ),
      );
    }).toList();
  }
}
