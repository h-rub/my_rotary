import 'package:my_rotary/screens/tasks/tasks_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

enum SlidableAction { archive, done, more, delete }

class SlidableWidget<T> extends StatelessWidget {
  final Widget child;
  final Function(SlidableAction action) onDismissed;
  final bool isCompleted;

  const SlidableWidget({
    @required this.child,
    @required this.onDismissed,
    @required this.isCompleted,
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => Slidable(
        actionPane: SlidableDrawerActionPane(),
        child: child,

        /// left side
        actions: <Widget>[
          isCompleted
              ? IconSlideAction(
                  caption: 'Completada',
                  color: Colors.green,
                  icon: Icons.done,
                  onTap: () => onDismissed(SlidableAction.done),
                )
              : IconSlideAction(
                  caption: 'Completar',
                  color: Colors.indigo,
                  icon: Icons.done,
                  onTap: () => onDismissed(SlidableAction.done),
                ),
        ],

        /// right side
        secondaryActions: <Widget>[
          IconSlideAction(
            caption: 'Eliminar',
            color: Colors.red,
            icon: Icons.delete,
            onTap: () => onDismissed(SlidableAction.delete),
          ),
        ],
      );
}
