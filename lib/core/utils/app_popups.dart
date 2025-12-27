import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../export.dart';

class AppPopups {
  static void showSnackBar(BuildContext context, String text) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(text, style: TextStyle(color: AppColors.white)),
        backgroundColor: AppColors.black,
      ),
    );
  }

  static void showComingSoonDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => CupertinoAlertDialog(
        title: const Text('🚧 Coming Soon'),
        content: const Text(
          'This feature is under development and will be available soon!',
        ),
        actions: [
          CupertinoButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OKAY', style: AppTextTheme.size12Normal),
          ),
        ],
      ),
    );
  }

  static void showPopupDialog(
    BuildContext context,
    String title,
    String description, {
    List<Widget>? actions,
  }) {
    showCupertinoDialog(
      context: context,
      builder: (context) {
        return CupertinoAlertDialog(
          actions:
              actions ??
              [
                CupertinoButton(
                  child: Text('Okay', style: AppTextTheme.size14Bold),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
          content: Column(
            children: [
              Text(title, style: AppTextTheme.size16Bold),
              8.heightBox,
              Text(
                description,
                textAlign: TextAlign.center,
                style: AppTextTheme.size14Normal,
              ),
            ],
          ),
        );
      },
    );
  }

  // static void showRatingDialogPopup(
  //   BuildContext context,
  //   WidgetRef ref,
  //   CouponModel coupon,
  //   String requestId,
  //   String toUser,
  //   String fromUser,
  // ) {
  //   final formKey = GlobalKey<FormState>();
  //   double rating = 0.0;
  //   final targetUserId = toUser;
  //   final raterUserId = fromUser;
  //   // final tradeId = coupon.id;
  //   final couponRef = ref.read(ratingRepoProvider);
  //   final TextEditingController feedbackController = TextEditingController();
  //   final ValueNotifier<bool> isLoading = ValueNotifier(false);
  //   showModalBottomSheet(
  //     isDismissible: false,
  //     enableDrag: false,
  //     isScrollControlled: true,
  //     backgroundColor: AppColors.white,
  //     context: context,
  //     builder: (context) {
  //       return SafeArea(
  //         child: Form(
  //           key: formKey,
  //           child: Column(
  //             mainAxisSize: MainAxisSize.min,
  //             crossAxisAlignment: CrossAxisAlignment.start,
  //             children: [
  //               24.heightBox,

  //               Text('Rate your trade', style: AppTextTheme.size20Bold).px(20),

  //               16.heightBox,
  //               Text(
  //                 'Rate it on a scale of 1–5 stars',
  //                 style: AppTextTheme.size14Normal,
  //               ).px(20),

  //               16.heightBox,
  //               Center(
  //                 child: RatingBar.builder(
  //                   initialRating: 0,
  //                   minRating: 1,
  //                   direction: Axis.horizontal,
  //                   allowHalfRating: true,
  //                   itemCount: 5,
  //                   itemSize: 38,
  //                   glowColor: AppColors.grey,
  //                   itemPadding: EdgeInsets.symmetric(horizontal: 12.0),
  //                   itemBuilder: (context, _) =>
  //                       Icon(Icons.star, color: AppColors.yellow),
  //                   onRatingUpdate: (newRating) {
  //                     rating = newRating;
  //                   },
  //                 ),
  //               ),

  //               16.heightBox,

  //               CustomTextField(
  //                 controller: feedbackController,
  //                 isPara: true,
  //                 fillColor: AppColors.grey,
  //                 labelText: 'Feedback in details',
  //                 hintText:
  //                     'Write a detailed description regarding your experience...',
  //                 customValidator: (value) {
  //                   if (value == null || value.trim().isEmpty) {
  //                     return "Feedback is required";
  //                   }
  //                   return null;
  //                 },
  //               ).px(20),

  //               24.heightBox,
  //               ValueListenableBuilder(
  //                 valueListenable: isLoading,
  //                 builder: (context, value, child) => CustomElevatedButton(
  //                   isLoading: value,
  //                   text: 'Submit',
  //                   ontap: value
  //                       ? null
  //                       : () async {
  //                           if (rating == 0) {
  //                             AppPopups.showSnackBar(
  //                               context,
  //                               'Please provide a rating before submitting.',
  //                             );
  //                             return;
  //                           }
  //                           isLoading.value = true;
  //                           if (formKey.currentState?.validate() ?? false) {
  //                             try {
                              
  //                               if (context.mounted) {
  //                                 Navigator.pop(context);
  //                                 Navigator.pop(context);
  //                                 AppPopups.showSnackBar(
  //                                   context,
  //                                   'Rating submitted successfully!',
  //                                 );
  //                               }
  //                             } catch (e) {
  //                               if (context.mounted) {
  //                                 AppPopups.showSnackBar(context, '$e');
  //                               }
  //                               debugPrint(e.toString());
  //                             }
  //                             isLoading.value = false;
  //                           }
  //                         },
  //                 ).px(20),
  //               ),

  //               24.heightBox,
  //             ],
  //           ),
  //         ),
  //       );
  //     },
  //   );
  // }

  static Future<String?> showOtpInputDialog(BuildContext context) async {
    String? otp;
    await showCupertinoDialog(
      context: context,
      builder: (context) {
        final controller = TextEditingController();
        return CupertinoAlertDialog(
          title: Text(
            'Enter OTP to delete account',
            style: AppTextTheme.size16Bold,
          ),
          content: Material(
            color: Colors.transparent,
            child: CustomTextField(
              controller: controller,
              keyboardType: TextInputType.number,
              hintText: 'Enter 6-digit OTP',
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                LengthLimitingTextInputFormatter(6),
              ],
            ),
          ).py(16),
          actions: [
            TextButton(
              child: Text('Cancel'),
              onPressed: () => Navigator.pop(context),
            ),
            TextButton(
              child: Text('Confirm'),
              onPressed: () {
                otp = controller.text;
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
    return otp;
  }
}
