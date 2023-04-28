import 'package:flutter/material.dart';

import '../models/gpt_service.dart';

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

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildSlider(
          title: 'Temperature: ${widget.gptService.temperature.toStringAsFixed(2)}',
          value: widget.gptService.temperature,
          min: 0.0,
          max: 1.0,
          divisions: 100,
          tooltip: 'Controls the model\'s randomness',
          onChanged: (newValue) {
            setState(() {
              widget.gptService.temperature = newValue;
              widget.gptService.temperature = widget.gptService.temperature;
            });
          },
        ),
        _buildSlider(
          title: 'Max Tokens: ${widget.gptService.maxTokens}',
          value: widget.gptService.maxTokens.toDouble(),
          min: 1,
          max: 2048,
          divisions: 2048,
          tooltip: 'Controls the length of the generated text',
          onChanged: (newValue) {
            setState(() {
              widget.gptService.maxTokens = newValue.toInt();
              widget.gptService.maxTokens = widget.gptService.maxTokens;
            });
          },
        ),
        _buildSlider(
          title: 'Top P: ${widget.gptService.topP.toStringAsFixed(2)}',
          value: widget.gptService.topP,
          min: 0.0,
          max: 1.0,
          divisions: 100,
          tooltip: 'Controls the model\'s diversity via nucleus sampling',
          onChanged: (newValue) {
            setState(() {
              widget.gptService.topP = newValue;
              widget.gptService.topP = widget.gptService.topP;
            });
          },
        ),
        _buildSlider(
          title: 'Frequency Penalty: ${widget.gptService.frequencyPenalty.toStringAsFixed(2)}',
          value: widget.gptService.frequencyPenalty,
          min: 0.0,
          max: 2.0,
          divisions: 200,
          tooltip: 'Controls the model\'s tendency to repeat itself',
          onChanged: (newValue) {
            setState(() {
              widget.gptService.frequencyPenalty = newValue;
              widget.gptService.frequencyPenalty = widget.gptService.frequencyPenalty;
            });
          },
        ),
        _buildSlider(
          title: 'Presence Penalty: ${widget.gptService.presencePenalty.toStringAsFixed(2)}',
          value: widget.gptService.presencePenalty,
          min: 0.0,
          max: 2.0,
          divisions: 200,
          tooltip: 'Controls the model\'s tendency to talk about the same topic',
          onChanged: (newValue) {
            setState(() {
              widget.gptService.presencePenalty = newValue;
              widget.gptService.presencePenalty = widget.gptService.presencePenalty;
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
    required int divisions,
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
            divisions: divisions,
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