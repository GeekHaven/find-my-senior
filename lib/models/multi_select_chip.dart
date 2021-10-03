import 'package:flutter/material.dart';

class MultiSelectChip extends StatefulWidget {
  final List<String> list;
  final List<String> selected;
  final Function(List<String>) onSelectionChanged;
  const MultiSelectChip(this.list, this.selected, {this.onSelectionChanged});
  @override
  _MultiSelectChipState createState() => _MultiSelectChipState();
}

class _MultiSelectChipState extends State<MultiSelectChip> {
  bool isSelected = false;
  _buildChoiceList() {
    List<Widget> choices = [];
    widget.list.forEach((item) {
      choices.add(Container(
        padding: const EdgeInsets.all(2.0),
        child: ChoiceChip(
          label: Text(item),
          selected: widget.selected.contains(item),
          onSelected: (selected) {
            setState(() {
              widget.selected.contains(item)
                  ? widget.selected.remove(item)
                  : widget.selected.add(item);
              widget.onSelectionChanged(widget.selected);
            });
          },
        ),
      ));
    });
    return choices;
  }

  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: _buildChoiceList(),
    );
  }
}
