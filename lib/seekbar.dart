import 'dart:math';

import 'package:flutter/material.dart';

class SeekBarData {
  final Duration position;
  final Duration duration;

  SeekBarData(this.position, this.duration);
}

class SeekBar extends StatefulWidget {
  final Duration position;
  final Duration duration;
  final ValueChanged<Duration>? onChanged;
  final ValueChanged<Duration>? onChangedEnd;
  const SeekBar({
    super.key,
    required this.position,
    required this.duration,
    this.onChanged,
    this.onChangedEnd,
  });

  @override
  State<SeekBar> createState() => _SeekBarState();
}

class _SeekBarState extends State<SeekBar> {
  double? _dragValue;
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: SliderTheme(
            data: SliderTheme.of(context).copyWith(
                trackHeight: 4,
                thumbShape: const RoundSliderThumbShape(
                  enabledThumbRadius: 5,
                  elevation: 5,
                ),
                overlayShape: const RoundSliderOverlayShape(overlayRadius: 14),
                thumbColor: Colors.white,
                activeTrackColor: Colors.white.withOpacity(0.6),
                inactiveTrackColor: Colors.white.withOpacity(0.6),
                overlayColor: Colors.black),
            child: Slider(
              min: 0.0,
              max: widget.position.inMilliseconds.toDouble(),
              value: min(
                  _dragValue ?? widget.position.inMilliseconds.toDouble(),
                  widget.duration.inMilliseconds.toDouble(),
              ),
              onChanged: (value) {
                setState(
                  (){
                    _dragValue = value;
                  });
                if(widget.onChanged != null)
                  {
                    widget.onChanged!(Duration(milliseconds: value.round(),),);
                  }
              },
            ),
          ),
        ),
      ],
    );
  }
}
