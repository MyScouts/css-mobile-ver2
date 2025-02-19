import 'dart:developer';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/src/components/dialog_widget.dart';
import 'package:flutter_application_1/src/components/srceen_scrollview.dart';
import 'package:flutter_application_1/src/components/toast_widget.dart';
import 'package:flutter_application_1/src/configs/constants/app_router.dart';
import 'package:flutter_application_1/src/configs/di/injection.dart';
import 'package:flutter_application_1/src/presentations/otp_confirm/components/content_title.dart';
import 'package:flutter_application_1/src/presentations/otp_confirm/components/pin_code_input.dart';
import 'package:flutter_application_1/src/resource/bloc/get_otp_login/login_phone_bloc.dart';
import 'package:flutter_application_1/src/resource/repository/auth_reponsitory.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class OtpConfirmScreen extends StatefulWidget {
  final String verificationId;
  const OtpConfirmScreen({Key? key, required this.verificationId})
      : super(key: key);

  @override
  State<OtpConfirmScreen> createState() => _OtpConfirmScreenState();
}

class _OtpConfirmScreenState extends State<OtpConfirmScreen> {
  final AuthRepository authRepository = getIt<AuthRepository>();
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  String _registrationToken = '';

  @override
  void initState() {
    super.initState();
    log('setState');
    _firebaseMessaging.getToken().then((token) {
      _registrationToken = token ?? "";
      log("OtpConfirmScreen token: $token");
    });
  }

  @override
  Widget build(BuildContext context) {
    return ScrollViewBase(
      appBarColor: Colors.transparent,
      body: BlocProvider<LoginPhoneBloc>(
        create: (_) => getIt<LoginPhoneBloc>(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const BackButton(),
            Container(
                margin: EdgeInsets.only(
                    top: MediaQuery.of(context).size.height * 0.1),
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    _buildContentTitle(),
                    const SizedBox(height: 20),
                    _buildPinCodeInput(),
                  ],
                )),
          ],
        ),
      ),
    );
  }

  Widget _buildContentTitle() {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: ContentTitle(),
    );
  }

  Widget _buildPinCodeInput() {
    return BlocListener<LoginPhoneBloc, LoginPhoneState>(
      listener: (context, state) {
        if (state is VerifyOtpSuccess) {
          // bool status = aw authRepository.login(state.firebaseToken);
        }

        if (state is LoginServerSuccess) {
          Navigator.of(context).pop();
          Navigator.of(context).pop();
          Navigator.of(context).pushReplacementNamed(AppRouters.mainScreen,
              arguments: {"pageIndex": 0});
        }

        if (state is LoginServerFailure) {
          Navigator.of(context).pop();
          DialogHelper.errorAnimation(
              context, "Login is failed, please try again!");
        }

        if (state is VerifyOtpLoading) {
          DialogHelper.onLoading(context);
        }

        if (state is VerifyOtpFailure) {
          Navigator.of(context).pop();
          // showErrorToast(context, state.error);
          DialogHelper.errorAnimation(
              context, "Opps...,\nplease check your otp or try again!");
        }
      },
      child: BlocBuilder<LoginPhoneBloc, LoginPhoneState>(
        builder: (context, state) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: PinCodeInput(
              onCompleted: (value) async {
                BlocProvider.of<LoginPhoneBloc>(context).add(
                    VerifyOtpLoginButtonPressed(
                        registrationToken: _registrationToken,
                        verificationId: widget.verificationId,
                        otp: value ?? ""));
                // bool result = await _verifyOtpPhoneLogin.execute(
                //     VerifyOtpPhoneLoginInput(widget.verificationId, value ?? ""));
                // log("result: $result");
              },
            ),
          );
        },
      ),
    );
  }
}
