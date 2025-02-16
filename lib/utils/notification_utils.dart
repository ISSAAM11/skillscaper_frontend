import 'package:flutter/material.dart';

void successNotification(BuildContext context, String message) {
  final snackBar = SnackBar(
    content: Wrap(children: [
      const Icon(
        Icons.check_circle_outline_outlined,
        color: Colors.white,
      ),
      SizedBox(
        width: 10,
      ),
      Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(
          'Succès!',
          style: TextStyle(
              fontWeight: FontWeight.w700, color: Colors.white, fontSize: 15),
        ),
        Text(
          maxLines: 2,
          message,
          style: TextStyle(
            fontWeight: FontWeight.w500,
            color: Colors.white,
            fontSize: 15,
          ),
        )
      ]),
    ]),
    backgroundColor: Colors.green,
  );
  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}

void errorNotification(BuildContext context, String message) {
  final snackBar = SnackBar(
    content: Wrap(children: [
      const Icon(
        Icons.error_outline,
        color: Colors.white,
      ),
      SizedBox(
        width: 10,
      ),
      Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(
          'Erreur!',
          style: TextStyle(
              fontWeight: FontWeight.w700, color: Colors.white, fontSize: 15),
        ),
        Text(
          maxLines: 5,
          message,
          style: TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 15,
            color: Colors.white,
          ),
        )
      ]),
    ]),
    backgroundColor: Colors.red,
  );
  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}
