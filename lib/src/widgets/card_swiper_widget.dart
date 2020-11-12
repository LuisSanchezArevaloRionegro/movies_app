import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:movies_app/src/models/film_model.dart';

class CardSwiper extends StatelessWidget {
  final List<Film> contain;

  CardSwiper({@required this.contain});

  @override
  Widget build(BuildContext context) {
    final _screenSize = MediaQuery.of(context).size;

    return Container(
      padding: EdgeInsets.only(top: 10.0),
      child: Swiper(
        itemWidth: _screenSize.width * 0.6,
        itemHeight: _screenSize.height * 0.5,
        itemBuilder: (BuildContext context, int index) {
          contain[index].uniqueId = '${contain[index].id}-card';

          return Hero(
            tag: contain[index].uniqueId,
            child: ClipRRect(
                borderRadius: BorderRadius.circular(20.0),
                child: GestureDetector(
                  onTap: () => Navigator.pushNamed(
                    context,
                    'detail',
                    arguments: contain[index],
                  ),
                  child: FadeInImage(
                    placeholder: AssetImage('assets/img/loading.gif'),
                    image: NetworkImage(contain[index].getPosterImage()),
                    fit: BoxFit.cover,
                  ),
                )),
          );
        },
        itemCount: contain.length,
        // pagination: new SwiperPagination(),
        // control: new SwiperControl(),
        layout: SwiperLayout.STACK,
      ),
    );
  }
}
