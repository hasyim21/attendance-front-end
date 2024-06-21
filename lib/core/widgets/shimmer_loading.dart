import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '../core.dart';

class ShimmerVerticalLoading extends StatelessWidget {
  final double height;
  final bool isScrolled;
  final bool? usePadding;

  const ShimmerVerticalLoading({
    super.key,
    required this.height,
    required this.isScrolled,
    this.usePadding = true,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: usePadding! ? const EdgeInsets.all(12.0) : null,
      itemCount: 10,
      shrinkWrap: isScrolled ? false : true,
      physics: isScrolled ? null : const NeverScrollableScrollPhysics(),
      separatorBuilder: (context, index) => const SpaceHeight(),
      itemBuilder: (context, index) {
        return Shimmer.fromColors(
          baseColor: Colors.grey.shade100,
          highlightColor: Colors.grey.shade300,
          child: Container(
            height: height,
            width: MediaQuery.of(context).size.width,
            decoration: const BoxDecoration(
              color: MyColors.white,
              borderRadius: BorderRadius.all(
                Radius.circular(8.0),
              ),
            ),
          ),
        );
      },
    );
  }
}

class ShimmerHorizontalLoading extends StatelessWidget {
  const ShimmerHorizontalLoading({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      scrollDirection: Axis.horizontal,
      itemCount: 5,
      separatorBuilder: (context, index) => const SpaceWidth(),
      itemBuilder: (context, index) {
        return Shimmer.fromColors(
          baseColor: Colors.grey.shade100,
          highlightColor: Colors.grey.shade300,
          child: Container(
            width: 100.0,
            decoration: const BoxDecoration(
              color: MyColors.white,
              borderRadius: BorderRadius.all(
                Radius.circular(8.0),
              ),
            ),
          ),
        );
      },
    );
  }
}
