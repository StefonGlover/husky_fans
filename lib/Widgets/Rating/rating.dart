import 'package:fan_page_app/models/friendsList.dart';
import 'package:flutter/material.dart';

class Ranking extends StatefulWidget {
  late final int maximumRating;
  late final Function(int) onRatingSelected;

  Ranking(this.onRatingSelected, [this.maximumRating = 5]);


  @override
  _RankingState createState() => _RankingState();
}

class _RankingState extends State<Ranking> {
  late int _rating;

  int _currentRating = 0;

  Widget _buildRatingStar(int index) {
    if (index < _currentRating) {
      return Icon(Icons.star, color: Colors.orange);
    } else {
      return Icon(Icons.star_border_outlined);
    }
  }

  Widget _buildBody() {
    final stars = List<Widget>.generate(this.widget.maximumRating, (index) {
      return GestureDetector(
        child: _buildRatingStar(index),
        onTap: () {
          setState(() {
            _currentRating = index + 1;
          });

          this.widget.onRatingSelected(_currentRating);
        },
      );
    });

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Row(
          children: stars,
        ),
        TextButton(
          child: Text("Clear", style: TextStyle(color: Colors.blue)),
          onPressed: () {
            setState(() {
              _currentRating = 0;
            });
            this.widget.onRatingSelected(_currentRating);
          },
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return _buildBody();
  }
}

