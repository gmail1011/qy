import 'dart:math';

import 'package:flutter/widgets.dart';

class MySliverDelegate extends SliverPersistentHeaderDelegate {
  double maxHeight;
  double minHeight;
  Widget child;

  MySliverDelegate({
    @required this.maxHeight,
    @required this.minHeight,
    @required this.child,
  });

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    // TODO: implement build
    return SizedBox.expand(child: child,);
  }

  @override
  // TODO: implement maxExtent
  double get maxExtent => max(maxHeight, minHeight);

  @override
  // TODO: implement minExtent
  double get minExtent => minHeight;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    // TODO: implement shouldRebuild
    return maxHeight != oldDelegate.maxExtent || minHeight != oldDelegate.minExtent;
  }
}
