import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pinput/pin_put/pin_put.dart';
import 'package:smack_talking_scoreboard/firebase/base_cloudstore.dart';
import 'package:smack_talking_scoreboard/ui_components/dialog_action_button.dart';
import 'package:smack_talking_scoreboard/utils/strings.dart' as strings;

class CreateOnLineGameDialog extends StatefulWidget {
  const CreateOnLineGameDialog(this.routeId);

  final String routeId;

  @override
  _CreateOnLineGameDialogState createState() => _CreateOnLineGameDialogState();
}

class _CreateOnLineGameDialogState extends State<CreateOnLineGameDialog>
    with SingleTickerProviderStateMixin {
  AnimationController controller;
  Animation animation;
  String pinValue;
  bool shouldValidate = false;
  bool isValidPin = false;
  final ValueNotifier<bool> isLoading = ValueNotifier(false);

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 250),
    );
    animation = CurvedAnimation(parent: controller, curve: Curves.easeIn);
    controller.forward();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cloudStore = Cloudstore.of(context);
    return ScaleTransition(
      scale: animation,
      child: AlertDialog(
        title: Text(
          strings.choseAUniquePin,
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 24),
        ),
        content: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              child: PinPut(
                fieldsCount: 4,
                textStyle: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                followingFieldDecoration:
                    _pinPutDecoration(borderColor: Colors.red),
                selectedFieldDecoration:
                    _pinPutDecoration(borderColor: Colors.blue),
                submittedFieldDecoration:
                    _pinPutDecoration(borderColor: Colors.green),
                autoValidate: true,
                validator: (pin) {
                  return pin.length == 4 && !isValidPin
                      ? strings.pinValidationError
                      : null;
                },
                onChanged: (v) => setState(() => pinValue = v),
                onSubmit: (pin) {
                  return setState(() {
                    pinValue = pin;
                    isValidPin = true;
                  });
                },
              ),
            ),
            SizedBox(height: 16),
            isLoading.value == true
                ? CircularProgressIndicator()
                : DialogActionButton(
                    onPressedFunction: pinValue?.length == 4
                        ? () async {
                            setState(() {
                              isLoading.value = true;
                            });
                            try {
                              await cloudStore.createSingleGameCollection(
                                context,
                                pin: pinValue,
                              );
                              await Navigator.popAndPushNamed(
                                context,
                                widget.routeId,
                              );
                            } catch (e) {
                              setState(() => isValidPin = false);
                            } finally {
                              setState(() {
                                isLoading.value = false;
                              });
                            }
                          }
                        : null,
                    label: strings.start,
                    borderColor: Colors.blue,
                  ),
          ],
        ),
      ),
    );
  }

  BoxDecoration _pinPutDecoration({@required Color borderColor}) =>
      BoxDecoration(
        border: Border.all(color: borderColor, width: 4),
        borderRadius: BorderRadius.all(Radius.circular(8)),
      );
}
