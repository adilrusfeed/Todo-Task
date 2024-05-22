import 'package:flutter/material.dart';

class CustomDurationPicker extends StatefulWidget {
  final Duration initialDuration;
  final ValueChanged<Duration>? onChanged;

  const CustomDurationPicker({
    Key? key,
    required this.initialDuration,
    this.onChanged,
  }) : super(key: key);

  @override
  _CustomDurationPickerState createState() => _CustomDurationPickerState();
}

class _CustomDurationPickerState extends State<CustomDurationPicker> {
  late int _hours;
  late int _minutes;

  @override
  void initState() {
    super.initState();
    _hours = widget.initialDuration.inHours;
    _minutes = widget.initialDuration.inMinutes.remainder(60);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Select Duration',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildDurationPicker(
                label: 'Hours',
                value: _hours,
                onChanged: (value) {
                  setState(() {
                    _hours = value;
                    _notifyParent();
                  });
                },
              ),
              _buildDurationPicker(
                label: 'Minutes',
                value: _minutes,
                onChanged: (value) {
                  setState(() {
                    _minutes = value;
                    _notifyParent();
                  });
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _notifyParent() {
    if (widget.onChanged != null) {
      final duration = Duration(hours: _hours, minutes: _minutes);
      widget.onChanged!(duration);
    }
  }

  Widget _buildDurationPicker({
    required String label,
    required int value,
    required ValueChanged<int> onChanged,
  }) {
    return Column(
      children: [
        Text(label, style: TextStyle(fontSize: 16)),
        SizedBox(height: 8),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: Icon(Icons.remove),
              onPressed: value > 0 ? () => onChanged(value - 1) : null,
            ),
            Text(
              value.toString().padLeft(2, '0'),
              style: TextStyle(fontSize: 18),
            ),
            IconButton(
              icon: Icon(Icons.add),
              onPressed: () => onChanged(value + 1),
            ),
          ],
        ),
      ],
    );
  }
}
