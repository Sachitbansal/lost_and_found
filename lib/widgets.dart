import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lost_and_found/constants.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'controllers/MenuAppController.dart';

class CustomTextField extends StatelessWidget {
  const CustomTextField({
    super.key,
    this.titleController,
    required this.labelText,
    this.validator,
    this.keyboardType,
    this.onChanged,
    this.icon,
    this.maxLines,
  });

  final TextEditingController? titleController;
  final String labelText;
  final void Function(String)? onChanged;
  final TextInputType? keyboardType;
  final Widget? icon;
  final int? maxLines;
  final String? Function(String?)? validator;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      maxLines: maxLines,
      onChanged: onChanged,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        suffixIcon: icon,
        isCollapsed: true,
        fillColor: Colors.blue[200]?.withOpacity(0.05),
        contentPadding:
            const EdgeInsets.symmetric(vertical: 15.0, horizontal: 10),
        filled: true,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5),
          borderSide: const BorderSide(width: 0.8),
        ),
        enabledBorder: const OutlineInputBorder(
          borderSide: BorderSide(
            width: 0.8,
            color: primaryColor,
          ),
        ),
        labelText: labelText,
      ),
      controller: titleController,
      validator: validator,
    );
  }
}

class FilterTitle extends StatelessWidget {
  const FilterTitle({
    super.key,
    required this.title,
  });

  final String title;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(
          height: 5,
        ),
        Text(
          title,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(
          height: 5,
        ),
      ],
    );
  }
}

class ButtonWithText extends StatelessWidget {
  const ButtonWithText({
    super.key,
    required this.onTap,
    this.size,
    required this.title,
    required this.bgColor,
    required this.fontColor,
  });

  final void Function() onTap;
  final double? size;
  final String title;
  final Color? bgColor, fontColor;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding:
            const EdgeInsets.fromLTRB(0, defaultPadding, defaultPadding, 0),
        child: Container(
          width: size,
          height: 40,
          decoration: BoxDecoration(
            border: Border.all(color: primaryColor),
            color: bgColor,
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: Center(
            child: Text(
              title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.play(
                color: fontColor,
                fontWeight: FontWeight.w600,
                fontSize: 16,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class ItemsBlock extends StatefulWidget {
  const ItemsBlock({
    super.key,
    required this.asset,
    required this.share,
    required this.onTap,
    required this.bookmarkFunction,
    required this.bookmarkIcon,
    required this.deleteIcon,
    required this.isSelected,
    required this.docId,
    this.usage,
  });

  final List asset;
  final dynamic docId;
  final String? usage;
  final bool bookmarkIcon, deleteIcon;
  final void Function()? share, onTap, bookmarkFunction;
  final ValueChanged<bool> isSelected;

  @override
  State<ItemsBlock> createState() => _ItemsBlockState();
}

class _ItemsBlockState extends State<ItemsBlock> {
  bool isSelected = false;

  final CollectionReference ref =
  FirebaseFirestore.instance.collection('Found');

  @override
  Widget build(BuildContext context) {


    Future<void> confirmationDialog(
        {required String confirmDialog,
          void Function()? onPressed,
          required String proceedButton}) async {
      return showDialog<void>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: bgColor,
            title: context.watch<MenuAppController>().loading
                ? const Center(
              child: CircularProgressIndicator(),
            )
                : Text(confirmDialog),
            actions: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  TextButton(
                    child: const Text('Cancel'),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                  TextButton(
                    onPressed: onPressed,
                    child: Text(
                      proceedButton,
                      style: const TextStyle(color: Colors.red),
                    ),
                  ),
                ],
              ),
            ],
          );
        },
      );
    }

    Future<void> deleteMethod(dynamic docId) async {
      try {
        // context.read<MenuAppController>().changeLoading(true);

        await ref.doc(docId['id']).delete().then(
              (doc) {
            // context.read<MenuAppController>().changeLoading(false);
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text("Item Deleted Successfully"),
                duration: Duration(milliseconds: 2000),
              ),
            );
          },
        );
      } catch (e) {
        // context.read<MenuAppController>().changeLoading(false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Error $e"),
            duration: const Duration(milliseconds: 2000),
          ),
        );
      }
    }

    Future<void> deleteImage(dynamic docId) async {
      try {
        // context.read<MenuAppController>().changeLoading(true);

        await FirebaseStorage.instance
            .refFromURL(docId['imageUrl'])
            .delete()
            .then(
              (doc) {
            // context.read<MenuAppController>().changeLoading(false);
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text("Image Deleted Successfully"),
                duration: Duration(milliseconds: 2000),
              ),
            );

            deleteMethod(docId);
          },
        );
      } catch (e) {
        // context.read<MenuAppController>().changeLoading(false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Error $e"),
            duration: const Duration(milliseconds: 2000),
          ),
        );
      }
    }

    Future<void> moveToPast(String docId) async {

      final DocumentReference docRef = FirebaseFirestore.instance.collection("Found").doc(docId);

      try {
        await docRef.update({"past": true}).then(
              (value) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text("Moved to Past"),
              ),
            );
          },
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Error $e"),
            duration: const Duration(milliseconds: 2000),
          ),
        );
      }

    }

    return Padding(
      padding: const EdgeInsets.all(defaultPadding / 2),
      child: GestureDetector(
        onTap: widget.onTap,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.black26,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                height: 65,
                width: 65,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  image: DecorationImage(
                    image: NetworkImage(widget.asset[0]),
                    fit: BoxFit.fitWidth,
                  ),
                ),
              ),
              const SizedBox(
                width: 10,
              ),
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.docId['title'],
                            overflow: TextOverflow.ellipsis,
                            softWrap: false,
                            maxLines: 2,
                            style: const TextStyle(
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          Text(
                            widget.docId['name'],
                            softWrap: false,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 13,
                            ),
                          ),
                          const SizedBox(
                            height: 5,
                          ),

                        ],
                      ),
                    ),
                    if (widget.deleteIcon)
                      Row(
                        children: [
                          IconButton(
                            icon: const Icon(
                              Icons.delete_outline,
                              color: Colors.white60,
                            ),
                            onPressed: () => confirmationDialog(
                                confirmDialog: "Confirm Delete?",
                                proceedButton: "Delete",
                                onPressed: () {
                                  deleteImage(widget.docId)
                                      .whenComplete(() {
                                    Navigator.of(context).pop();
                                  });
                                }),
                            // deleteImage(ref, widget.docId).whenComplete(() {
                            // TODO: Add Loading screen for deleting
                            // }),
                          ),
                          IconButton(
                            icon: const Icon(Icons.check),
                            onPressed: () => confirmationDialog(
                                confirmDialog: "Move to Past Items?",
                                proceedButton: "Move",
                                onPressed: () {
                                  moveToPast(widget.docId['id']);
                                  Navigator.pop(context);
                                }),
                          )
                        ],
                      ),
                    if (!widget.deleteIcon)
                      IconButton(
                        icon: const Icon(
                          Icons.mail_outline,
                          color: Colors.white60,
                        ),
                        onPressed: () async {
                          try {
                            final Uri url =
                            Uri.parse("mailto:${widget.docId['email']}");
                            if (await canLaunchUrl(url)) {
                              await launchUrl(url);
                            }
                          } catch (e) {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text("Error $e"),
                            ));
                          }
                        },
                      ),
                    const SizedBox(
                      width: 10,
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
