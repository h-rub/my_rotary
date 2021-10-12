import 'package:amplified_todo/screens/tasks/tasks_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

enum SlidableAction { archive, done, more, delete }

class SlidableWidget<T> extends StatelessWidget {
  final Widget child;
  final Function(SlidableAction action) onDismissed;

  const SlidableWidget({
    @required this.child,
    @required this.onDismissed,
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => Slidable(
        actionPane: SlidableDrawerActionPane(),
        child: child,

        /// left side
        actions: <Widget>[
          IconSlideAction(
            caption: 'Completado',
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
