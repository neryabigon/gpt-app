import 'package:flutter/material.dart';

import 'gpt_service.dart';

class ModelSettingsWidget extends StatefulWidget {
  const ModelSettingsWidget({
    super.key,
    required this.useLightMode,
    required this.handleBrightnessChange,
    required this.gptService,
  });

  final bool useLightMode;
  final Function(bool useLightMode) handleBrightnessChange;
  final GptService gptService;

  @override
  _ModelSettingsWidgetState createState() => _ModelSettingsWidgetState();
}

class _ModelSettingsWidgetState extends State<ModelSettingsWidget> {
  double _temperature = 0.7;
  int _maxTokens = 200;
  double _topP = 1.0;
  double _frequencyPenalty = 0.0;
  double _presencePenalty = 0.0;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildSlider(
          title: 'Temperature: ${_temperature.toStringAsFixed(2)}',
          value: _temperature,
          min: 0.0,
          max: 1.0,
          tooltip: 'Controls the model\'s randomness',
          onChanged: (newValue) {
            setState(() {
              _temperature = newValue;
            });
          },
        ),
        _buildSlider(
          title: 'Max Tokens: $_maxTokens',
          value: _maxTokens.toDouble(),
          min: 1,
          max: 2048,
          tooltip: 'Controls the length of the generated text',
          onChanged: (newValue) {
            setState(() {
              _maxTokens = newValue.toInt();
            });
          },
        ),
        _buildSlider(
          title: 'Top P: ${_topP.toStringAsFixed(2)}',
          value: _topP,
          min: 0.0,
          max: 1.0,
          tooltip: 'Controls the model\'s diversity via nucleus sampling',
          onChanged: (newValue) {
            setState(() {
              _topP = newValue;
            });
          },
        ),
        _buildSlider(
          title: 'Frequency Penalty: ${_frequencyPenalty.toStringAsFixed(2)}',
          value: _frequencyPenalty,
          min: 0.0,
          max: 2.0,
          tooltip: 'Controls the model\'s tendency to repeat itself',
          onChanged: (newValue) {
            setState(() {
              _frequencyPenalty = newValue;
            });
          },
        ),
        _buildSlider(
          title: 'Presence Penalty: ${_presencePenalty.toStringAsFixed(2)}',
          value: _presencePenalty,
          min: 0.0,
          max: 2.0,
          tooltip: 'Controls the model\'s tendency to talk about the same topic',
          onChanged: (newValue) {
            setState(() {
              _presencePenalty = newValue;
            });
          },
        ),
      ],
    );
  }

  Widget _buildSlider({
    required String title,
    required String tooltip,
    required double value,
    required double min,
    required double max,
    required Function(double) onChanged,
  }) {
    return Column(
      children: [
        Tooltip(
          message: tooltip,
          showDuration: const Duration(milliseconds: 600),
          child: Text(
            title,
            style: TextStyle(
                fontSize: 13,
                color: Theme.of(context).colorScheme.onInverseSurface
            ), // Smaller font size
          ),
        ),
        SizedBox(
          height: 24, // Smaller height for the Slider
          child: Slider(
            value: value,
            min: min,
            max: max,
            activeColor: Theme
                .of(context)
                .colorScheme
                .primaryContainer,
            onChanged: onChanged,
          ),
        ),
      ],
    );
  }
}