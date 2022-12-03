import 'package:flutter/material.dart';

class SearchField extends StatefulWidget {
  SearchField({
    Key? key,
    required this.onPressed,
    required this.onSubmitted,
    required this.textEditingController,
  }) : super(key: key);

  final void Function() onPressed;
  final void Function(String) onSubmitted;
  final TextEditingController textEditingController;
  final RegExp validDomainExp = RegExp(r'(\w\.\w)');

  @override
  State<SearchField> createState() => _SearchFieldState();
}

class _SearchFieldState extends State<SearchField> {
  bool isInputValid = false;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      color: isInputValid
          ? Theme.of(context).colorScheme.secondary
          : Colors.black12,
      duration: const Duration(milliseconds: 200),
      child: TextField(
        decoration: InputDecoration(
            prefixIcon: const Icon(
              Icons.search,
            ),
            hintText: 'Insert a valid site domain ...',
            suffixIcon: IconButton(
                onPressed: widget.onPressed, icon: const Icon(Icons.close))),
        onSubmitted: widget.onSubmitted,
        controller: widget.textEditingController,
        onChanged: (input) {
          if (widget.validDomainExp.hasMatch(input)) {
            setState(() {
              isInputValid = true;
            });
          } else if (isInputValid && !widget.validDomainExp.hasMatch(input)) {
            setState(() {
              isInputValid = false;
            });
          }
        },
      ),
    );
  }
}