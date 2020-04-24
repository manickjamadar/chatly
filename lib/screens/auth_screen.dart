import 'package:chatly/providers/auth_user_providers.dart';
import "package:flutter/material.dart";
import 'package:provider/provider.dart';

class AuthScreen extends StatefulWidget {
  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  TextEditingController _numberController;
  TextEditingController _otpController;
  bool isNumberValid = false;
  bool isOtpValid = false;
  bool isVerifyingOtp = false;

  @override
  void initState() {
    _numberController = TextEditingController();
    _otpController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _numberController.dispose();
    _otpController.dispose();
    super.dispose();
  }

  void resetState(BuildContext ctx, String resetReason) {
    setState(() {
      _numberController.clear();
      _otpController.clear();
      isNumberValid = false;
      isOtpValid = false;
      isVerifyingOtp = false;
    });
    Scaffold.of(ctx).showSnackBar(SnackBar(content: Text(resetReason)));
  }

  void resetVerifyOtpState(BuildContext ctx, String resetReason) {
    setState(() {
      _otpController.clear();
      isOtpValid = false;
    });
    Scaffold.of(ctx).showSnackBar(SnackBar(content: Text(resetReason)));
  }

  Dialog getLoadingDialog(String message) {
    return Dialog(
      child: Container(
        padding: const EdgeInsets.all(20),
        child: Row(
          children: <Widget>[
            CircularProgressIndicator(),
            SizedBox(
              width: 30,
            ),
            Text(message ?? 'Loading...')
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final AuthUserProvider authUserProvider =
        Provider.of<AuthUserProvider>(context);
    return Scaffold(
        appBar: AppBar(
          title: Text("Chatly Login"),
          centerTitle: true,
        ),
        body: Container(
          padding: EdgeInsets.all(20),
          child: Column(
            children: <Widget>[
              if (!isVerifyingOtp)
                Column(
                  children: <Widget>[
                    TextFormField(
                      controller: _numberController,
                      maxLength: 10,
                      decoration: InputDecoration(
                        hintText: "Enter your number",
                      ),
                      onChanged: (number) {
                        setState(() {
                          isNumberValid = number.length == 10;
                        });
                      },
                      keyboardType: TextInputType.number,
                    ),
                    Builder(
                      builder: (ctx) => RaisedButton(
                        child: Text("Sent OTP"),
                        onPressed: isNumberValid
                            ? () async {
                                if (!isNumberValid) return;
                                final String number = _numberController.text;
                                setState(() {
                                  isVerifyingOtp = !isVerifyingOtp;
                                });
                                _numberController.clear();
                                _otpController.clear();
                                final response = await authUserProvider.sentOtp(
                                    "+91$number", onAutoVerificationStart: () {
                                  showDialog(
                                      context: ctx,
                                      child:
                                          getLoadingDialog("Verfying number"));
                                }, onVerificationEnd: () {
                                  Navigator.pop(context);
                                }, onVerificationFailed: (failureResponse) {
                                  if (Navigator.canPop(context)) {
                                    Navigator.pop(context);
                                  }
                                  resetState(ctx, failureResponse.message);
                                }, onCodeTimeout: () {
                                  resetState(ctx, "Code timeout , try again");
                                });
                                if (response.error) {
                                  resetState(ctx, response.message);
                                }
                              }
                            : null,
                      ),
                    ),
                  ],
                ),
              if (isVerifyingOtp)
                Column(
                  children: <Widget>[
                    TextFormField(
                      controller: _otpController,
                      maxLength: 6,
                      onChanged: (otp) {
                        setState(() {
                          isOtpValid = otp.length == 6;
                        });
                      },
                      decoration: InputDecoration(hintText: "Enter OTP"),
                    ),
                    Builder(
                      builder: (ctx) => RaisedButton(
                        child: Text("Verify OTP"),
                        onPressed: isOtpValid
                            ? () async {
                                if (!isOtpValid) return;
                                final String otp = _otpController.text;
                                showDialog(
                                    context: ctx,
                                    child: getLoadingDialog("Verifying otp"));
                                final response =
                                    await authUserProvider.verifyOtp(otp);
                                Navigator.pop(ctx);
                                if (response.error) {
                                  resetVerifyOtpState(ctx, response.message);
                                }
                              }
                            : null,
                      ),
                    )
                  ],
                )
            ],
          ),
        ));
  }
}
