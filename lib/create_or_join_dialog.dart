import 'package:flutter/animation.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:smack_talking_scoreboard/on_line_game_dialog.dart';
import 'package:smack_talking_scoreboard/ui_components/dialog_action_button.dart';
import 'package:smack_talking_scoreboard/utils/strings.dart' as strings;

class CreateOrJoinGameDialog extends StatefulWidget {
  const CreateOrJoinGameDialog();

  @override
  _CreateOrJoinGameDialogState createState() => _CreateOrJoinGameDialogState();
}

class _CreateOrJoinGameDialogState extends State<CreateOrJoinGameDialog>
    with SingleTickerProviderStateMixin {
  AnimationController controller;
  Animation animation;

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
    return ScaleTransition(
      scale: animation,
      child: AlertDialog(
        title: Text(
          strings.joiningOrCreating,
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 24),
        ),
        content: Row(
          children: [
            DialogActionButton(
              onPressedFunction: () async {
                Navigator.of(context).pop();
                await showDialog(
                  context: context,
                  builder: (context) => OnLineGameDialog.join(context),
                  barrierDismissible: false,
                );
              },
              label: strings.joinExisting,
              backgroundColor: Colors.white,
              borderColor: Colors.green,
            ),
            SizedBox(width: 16),
            DialogActionButton(
              onPressedFunction: () async {
                Navigator.of(context).pop();
                await showDialog(
                  context: context,
                  builder: (context) => OnLineGameDialog.create(context),
                  barrierDismissible: false,
                );
              },
              label: strings.createNew,
              backgroundColor: Colors.blue,
              textColor: Colors.white,
            ),
          ],
        ),
        actions: <Widget>[
          FlatButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(
              strings.offLine,
              style: TextStyle(fontSize: 20),
            ),
          ),
        ],
      ),
    );
  }
}
