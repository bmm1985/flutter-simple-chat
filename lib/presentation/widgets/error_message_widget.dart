import 'package:chat/domain/entities/exceptions.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class ErrorMessageWidget extends StatefulWidget {
  final dynamic error;

  const ErrorMessageWidget({super.key, this.error});

  @override
  State<ErrorMessageWidget> createState() => _ErrorMessageWidgetState();
}

class _ErrorMessageWidgetState extends State<ErrorMessageWidget> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.error_outline,
              size: 90,
              color: Colors.red,
            ),
            const SizedBox(height: 8),
            Text(
              context.tr('ErrorMessageWidget.Title'),
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 8),
            Text(
              _handleError(),
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w400),
            ),
          ],
        ),
      ),
    );
  }

  String _handleError() {
    if (widget.error is ServerException) {
      return context.tr('ErrorMessageWidget.ServerException');
    }

    if (widget.error is AuthException) {
      return context.tr('ErrorMessageWidget.AuthException');
    }

    if (widget.error is ChatException) {
      var x = widget.error as ChatException;
      return x.message;
    }

    return context.tr('ErrorMessageWidget.OtherException');
  }
}
