import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../constants.dart';
import '../../../controllers/MenuAppController.dart';
import '../../../models/MyFiles.dart';

class TopBlocksCard extends StatelessWidget {
  const TopBlocksCard({
    super.key,
    required this.info,
  });

  final CloudStorageInfo info;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        context.read<MenuAppController>().changePage(info.onTap);
      },
      child: Container(
        padding: const EdgeInsets.all(defaultPadding),
        decoration: const BoxDecoration(
          color: secondaryColor,
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Expanded(
            //   child: Container(
            //     padding: const EdgeInsets.all(defaultPadding * 0.75),
            //     decoration: BoxDecoration(
            //       color: info.color!.withOpacity(0.1),
            //       borderRadius: const BorderRadius.all(Radius.circular(10)),
            //     ),
            //     child: IconButton(
            //       onPressed: null,
            //       icon: Icon(
            //         info.icon
            //       ),
            //     ),
            //   ),
            // ),
            IconButton(
              style: ButtonStyle(
                backgroundColor: WidgetStateProperty.all(info.color),
                shape: WidgetStateProperty.all(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              // color: info.color,
              onPressed: null,
              icon: Icon(
                info.icon,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 10,),
            FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                info.title!,
                overflow: TextOverflow.ellipsis,
                softWrap: false,
              ),
            ),
            // Text(
            //   info.title!,
            //   maxLines: 1,
            //   overflow: TextOverflow.ellipsis,
            // ),
            // ProgressLine(
            //   color: info.color,
            //   percentage: info.percentage,
            // ),
            // Row(
            //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //   children: [
            //     Text(
            //       "${info.numOfFiles} Files",
            //       style: Theme.of(context)
            //           .textTheme
            //           .bodySmall!
            //           .copyWith(color: Colors.white70),
            //     ),
            //     Text(
            //       info.totalStorage!,
            //       style: Theme.of(context)
            //           .textTheme
            //           .bodySmall!
            //           .copyWith(color: Colors.white),
            //     ),
            //   ],
            // )
          ],
        ),
      ),
    );
  }
}

class ProgressLine extends StatelessWidget {
  const ProgressLine({
    super.key,
    this.color = primaryColor,
    required this.percentage,
  });

  final Color? color;
  final int? percentage;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          width: double.infinity,
          height: 5,
          decoration: BoxDecoration(
            color: color!.withOpacity(0.1),
            borderRadius: BorderRadius.all(Radius.circular(10)),
          ),
        ),
        LayoutBuilder(
          builder: (context, constraints) => Container(
            width: constraints.maxWidth * (percentage! / 100),
            height: 5,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.all(Radius.circular(10)),
            ),
          ),
        ),
      ],
    );
  }
}
