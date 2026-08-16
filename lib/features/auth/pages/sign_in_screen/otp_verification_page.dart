import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/theme/app_color.dart';
import '../../../../core/utils/show_message.dart';

class OTPVerificationPage extends StatefulWidget {
  final bool cameFromRegisterPage;
  final String email;

  const OTPVerificationPage({
    super.key,
    this.cameFromRegisterPage = true,
    required this.email,
  });

  @override
  _OTPVerificationPageState createState() => _OTPVerificationPageState();
}

class _OTPVerificationPageState extends State<OTPVerificationPage> {
  @override
  void initState() {
    super.initState();
    // BlocProvider.of<AuthBloc>(context).add(SendOtpEvent(email: widget.email));
  }

  final TextEditingController code = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          'تأكيد الحساب',
          style: TextStyle(
            color: Colors.black,
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: SvgPicture.asset('assets/icons/Arrow-left.svg'),
        ),
        systemOverlayStyle: SystemUiOverlayStyle.light,
      ),
      body: ListView(
        shrinkWrap: true,
        padding: EdgeInsets.symmetric(horizontal: 24),
        physics: BouncingScrollPhysics(),
        children: [
          Container(
            margin: EdgeInsets.only(top: 20, bottom: 8),
            child: Text(
              'تأكيد البريد الالكتروني',
              style: TextStyle(
                color: AppColor.secondary,
                fontWeight: FontWeight.w700,
                fontFamily: 'poppins',
                fontSize: 20,
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.only(bottom: 32),
            child: Column(
              children: [
                Text(
                  'رمز التحقق تم إرساله إلى البريد الالكتروني',
                  style: TextStyle(
                    color: AppColor.secondary.withOpacity(0.7),
                    fontSize: 14,
                  ),
                ),
                SizedBox(width: 8),
                Text(
                  widget.email,
                  style: TextStyle(
                    color: AppColor.primary,
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
          Directionality(
            textDirection: TextDirection.ltr,
            child: PinCodeTextField(
              appContext: (context),
              length: 4,
              onChanged: (value) {},
              obscureText: false,
              controller: code,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              pinTheme: PinTheme(
                shape: PinCodeFieldShape.box,
                borderWidth: 1.5,
                borderRadius: BorderRadius.circular(8),
                fieldHeight: 70,
                fieldWidth: 70,
                activeColor: AppColor.primary,
                inactiveColor: AppColor.border,
                inactiveFillColor: AppColor.primarySoft,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              if (code.text.length < 4) {
                showMessage("رجاء أدخل كامل الرمز أولاً");
                return;
              }
              // BlocProvider.of<AuthBloc>(context).add(
              //   VerifyOtpEvent(email: widget.email, code: code.text),
              // );
            },
            style: ElevatedButton.styleFrom(
              padding: EdgeInsets.symmetric(
                horizontal: 36,
                vertical: 18,
              ),
              backgroundColor: AppColor.primary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              elevation: 0,
              shadowColor: Colors.transparent,
            ),
            child: Text(
              'تأكيد الرمز',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
                fontSize: 18,
                fontFamily: 'poppins',
              ),
            ),
          )
          // BlocConsumer<AuthBloc, AuthState>(
          //   listener: (context, state) {
          //     if (state.verifyOtpStatus == VerifyOtpStatus.success) {
          //       Navigator.of(context).pushReplacement(
          //         MaterialPageRoute(builder: (ctx) => UpdatePasswordPage(email: widget.email,)),
          //       );
          //       showMessage('تم التحقق بنجاح ✅', hasError: false);
          //     }
          //     if (state.verifyOtpStatus == VerifyOtpStatus.failure) {
          //       showMessage(state.errorMessage ?? "حدث خطأ ما");
          //     }
          //   },
          //   listenWhen: (p,c)=> p.verifyOtpStatus != c.verifyOtpStatus,
          //   builder: (context, state) {
          //     return state.verifyOtpStatus == VerifyOtpStatus.loading
          //         ? FashionLoader()
          //         : Container(
          //           margin: EdgeInsets.only(top: 32, bottom: 16),
          //           child: ElevatedButton(
          //             onPressed: () {
          //               if (code.text.length < 4) {
          //                 showMessage("رجاء أدخل كامل الرمز أولاً");
          //                 return;
          //               }
          //               BlocProvider.of<AuthBloc>(context).add(
          //                 VerifyOtpEvent(email: widget.email, code: code.text),
          //               );
          //             },
          //             child: Text(
          //               'تأكيد الرمز',
          //               style: TextStyle(
          //                 color: Colors.white,
          //                 fontWeight: FontWeight.w600,
          //                 fontSize: 18,
          //                 fontFamily: 'poppins',
          //               ),
          //             ),
          //             style: ElevatedButton.styleFrom(
          //               padding: EdgeInsets.symmetric(
          //                 horizontal: 36,
          //                 vertical: 18,
          //               ),
          //               backgroundColor: AppColor.primary,
          //               shape: RoundedRectangleBorder(
          //                 borderRadius: BorderRadius.circular(16),
          //               ),
          //               elevation: 0,
          //               shadowColor: Colors.transparent,
          //             ),
          //           ),
          //         );
          //   },
          // ),
          ,ElevatedButton(
            onPressed: () {
              // BlocProvider.of<AuthBloc>(context).add(SendOtpEvent(email: widget.email));
            },
            style: ElevatedButton.styleFrom(
              foregroundColor: AppColor.primary,
              padding: EdgeInsets.symmetric(
                horizontal: 36,
                vertical: 18,
              ),
              backgroundColor: AppColor.primarySoft,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              elevation: 0,
              shadowColor: Colors.transparent,
            ),
            child: Text(
              'إعادة إرسال الرمز',
              style: TextStyle(
                color: AppColor.secondary,
                fontWeight: FontWeight.w600,
              ),
            ),
          )
          // BlocConsumer<AuthBloc, AuthState>(
          //   listenWhen: (p,c)=> p.sendOtpStatus != c.sendOtpStatus,
          //   listener: (context , state){
          //     if(state.sendOtpStatus == SendOtpStatus.failure){
          //       showMessage(state.errorMessage ?? "حدث خطأ ما");
          //     }
          //   },
          //   builder: (context, state) {
          //     return state.sendOtpStatus == SendOtpStatus.loading
          //         ? FashionLoader()
          //         : ElevatedButton(
          //           onPressed: () {
          //             BlocProvider.of<AuthBloc>(context).add(SendOtpEvent(email: widget.email));
          //           },
          //           style: ElevatedButton.styleFrom(
          //             foregroundColor: AppColor.primary,
          //             padding: EdgeInsets.symmetric(
          //               horizontal: 36,
          //               vertical: 18,
          //             ),
          //             backgroundColor: AppColor.primarySoft,
          //             shape: RoundedRectangleBorder(
          //               borderRadius: BorderRadius.circular(16),
          //             ),
          //             elevation: 0,
          //             shadowColor: Colors.transparent,
          //           ),
          //           child: Text(
          //             'إعادة إرسال الرمز',
          //             style: TextStyle(
          //               color: AppColor.secondary,
          //               fontWeight: FontWeight.w600,
          //             ),
          //           ),
          //         );
          //   },
          // ),
        ],
      ),
    );
  }
}
