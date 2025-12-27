import 'package:flutter/material.dart';
import '/core/extensions/app_extensions.dart';
import 'package:shimmer/shimmer.dart';

class CustomLoadingList extends StatelessWidget {
  const CustomLoadingList({super.key});

  @override
  Widget build(BuildContext context) => ListView.separated(
        itemBuilder: (context, index) => Shimmer.fromColors(
          baseColor: Colors.grey[300]!,
          highlightColor: Colors.grey[100]!,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(11),
              color: Colors.white,
              border: Border.all(color: Color(0xffEEEEEE)),
            ),
            child: ListTile(
              contentPadding: EdgeInsets.all(12),
              title: Container(
                width: 100,
                height: 16,
                color: Colors.grey[300],
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(width: 50, height: 12, color: Colors.grey[300]),
                      10.widthBox,
                      Container(width: 80, height: 12, color: Colors.grey[300]),
                    ],
                  ),
                  8.widthBox,
                  Row(
                    children: [
                      Container(width: 60, height: 12, color: Colors.grey[300]),
                      10.widthBox,
                      Container(width: 40, height: 12, color: Colors.grey[300]),
                    ],
                  ),
                ],
              ),
              trailing: Container(width: 95, height: 25, color: Colors.grey[300]),
            ),
          ),
        ),
        separatorBuilder: (context, index) => 12.heightBox,
        itemCount: 10,
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
      );
}


class ReferralUserShimmerTile extends StatelessWidget {
  const ReferralUserShimmerTile({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(color: Colors.grey.shade300),
          ),
        ),
        child: Row(
          children: [
            Expanded(
              flex: 3,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 20,
                    height: 12,
                    color: Colors.grey[300],
                  ),
                  const SizedBox(width: 12),
                  Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      shape: BoxShape.circle,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 5,
              child: Container(
                height: 14,
                width: 80,
                color: Colors.grey[300],
              ),
            ),
            Expanded(
              flex: 3,
              child: Container(
                height: 14,
                width: 40,
                color: Colors.grey[300],
              ),
            ),
          ],
        ),
      ),
    );
  }
}