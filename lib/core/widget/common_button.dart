import 'package:flutter/material.dart';

class CommonButton extends StatelessWidget {
  Function() onPressed;
  String buttonTitle;
  bool? isLoading = false;
  CommonButton({
    super.key,
    required this.buttonTitle,
    required this.onPressed,
    this.isLoading,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          elevation: 0,
          backgroundColor: Colors.black,
          minimumSize: Size(MediaQuery.of(context).size.width, 50),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadiusGeometry.circular(15),
          ),
        ),
        onPressed: onPressed,
        child: isLoading ?? false
            ? SizedBox(
                height: 30,
                width: 30,
                child: CircularProgressIndicator(color: Colors.white),
              )
            : Text(
                buttonTitle,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
      ),
    );
  }
}
