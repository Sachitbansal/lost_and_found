import 'package:flutter/material.dart';
import 'package:lost_and_found/widgets.dart';
import 'package:provider/provider.dart';
import '../../constants.dart';
import '../../controllers/MenuAppController.dart';
import '../../controllers/responsive.dart';
import '../Home/components/category.dart';
import '../Home/components/header.dart';

class AddLostScreen extends StatelessWidget {
  const AddLostScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        primary: false,
        padding: const EdgeInsets.all(defaultPadding),
        child: Column(
          children: [
            const Header(),
            const SizedBox(height: defaultPadding),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 5,
                  child: Column(
                    children: [
                      context.watch<MenuAppController>().topBlocks[
                          context.watch<MenuAppController>().pageIndex],
                      const SizedBox(height: defaultPadding),
                      AddData(),
                      if (Responsive.isMobile(context))
                        const SizedBox(height: defaultPadding),
                      if (Responsive.isMobile(context)) const StorageDetails(),
                    ],
                  ),
                ),
                if (!Responsive.isMobile(context))
                  const SizedBox(width: defaultPadding),
                // On Mobile means if the screen is less than 850 we don't want to show it
                if (!Responsive.isMobile(context))
                  const Expanded(
                    flex: 2,
                    child: StorageDetails(),
                  ),
              ],
            )
          ],
        ),
      ),
    );
  }
}

class AddData extends StatefulWidget {
  const AddData({super.key});

  @override
  State<AddData> createState() => _AddDataState();
}

class _AddDataState extends State<AddData> {
  late String categoryLost = 'None';

  final titleControllerLost = TextEditingController();
  final descriptionControllerLost = TextEditingController();

  @override
  void dispose() {
    titleControllerLost.dispose();
    descriptionControllerLost.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(defaultPadding),
      decoration: const BoxDecoration(
        color: secondaryColor,
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Add Lost Items Data",
                style: Theme.of(context).textTheme.titleLarge,
              ),
              IconButton(
                style: ButtonStyle(
                  iconColor: WidgetStateProperty.all(Colors.white70),
                  shape: WidgetStateProperty.all(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                      side: const BorderSide(color: primaryColor),
                    ),
                  ),
                ),
                onPressed: () {
                  try {
                    context
                        .read<MenuAppController>()
                        .addLost(titleControllerLost.text,
                            descriptionControllerLost.text)
                        .then((value) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Added Successfully'),
                        ),
                      );
                    });
                  } catch (error) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text("$error"),
                        duration: const Duration(milliseconds: 2000),
                      ),
                    );
                  }
                },
                icon: const Icon(Icons.add),
              )
            ],
          ),
          const SizedBox(
            height: defaultPadding,
          ),
          CustomTextField(
            labelText: "Title",
            titleController: titleControllerLost,
          ),
          const SizedBox(
            height: defaultPadding,
          ),
          CustomTextField(
            labelText: "Description",
            maxLines: 5,
            titleController: descriptionControllerLost,
          ),
          Wrap(
            children: [
              for (var category
                  in context.watch<MenuAppController>().categoryList)
                ButtonWithText(
                  size: 90,
                  onTap: () {
                    context.read<MenuAppController>().changeCategory(category);
                  },
                  title: category,
                  bgColor:
                      context.watch<MenuAppController>().selectedCategory ==
                              category
                          ? Colors.blue[400]
                          : secondaryColor,
                  fontColor:
                      context.watch<MenuAppController>().selectedCategory ==
                              category
                          ? Colors.white
                          : Colors.white70,
                ),
            ],
          )
        ],
      ),
    );
  }
}
