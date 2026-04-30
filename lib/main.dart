```dart
import 'package:flutter/material.dart';

void main() {
  runApp(const CalculatorApp());
}

class CalculatorApp extends StatelessWidget {
  const CalculatorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Ø­Ø§Ø³Ø¨Ù',
      theme: ThemeData(
        colorSchemeSeed: Colors.blueGrey,
        useMaterial3: true,
        brightness: Brightness.light,
      ),
      home: const CalculatorScreen(),
    );
  }
}

class CalculatorScreen extends StatefulWidget {
  const CalculatorScreen({super.key});

  @override
  State<CalculatorScreen> createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {
  String _display = '0';
  double _firstOperand = 0;
  String _operator = '';
  bool _waitingForSecondOperand = false;

  void _inputDigit(String digit) {
    setState(() {
      if (_waitingForSecondOperand) {
        _display = digit;
        _waitingForSecondOperand = false;
      } else {
        _display = _display == '0' ? digit : _display + digit;
      }
    });
  }

  void _inputDecimal() {
    setState(() {
      if (_waitingForSecondOperand) {
        _display = '0.';
        _waitingForSecondOperand = false;
        return;
      }
      if (!_display.contains('.')) {
        _display += '.';
      }
    });
  }

  void _performOperation(String op) {
    setState(() {
      if (_operator.isNotEmpty && !_waitingForSecondOperand) {
        _calculate();
      }
      _firstOperand = double.parse(_display);
      _operator = op;
      _waitingForSecondOperand = true;
    });
  }

  void _calculate() {
    final double secondOperand = double.parse(_display);
    double result = 0;
    switch (_operator) {
      case '+':
        result = _firstOperand + secondOperand;
        break;
      case '-':
        result = _firstOperand - secondOperand;
        break;
      case 'Ã':
        result = _firstOperand * secondOperand;
        break;
      case 'Ã·':
        result = secondOperand != 0 ? _firstOperand / secondOperand : double.nan;
        break;
      default:
        return;
    }
    _display = result.isNaN ? 'Ø®Ø·Ø£' : _formatResult(result);
    _operator = '';
    _waitingForSecondOperand = true;
  }

  String _formatResult(double value) {
    if (value == value.floorToDouble() && !value.isInfinite) {
      return value.toInt().toString();
    }
    return value.toStringAsFixed(2);
  }

  void _clear() {
    setState(() {
      _display = '0';
      _firstOperand = 0;
      _operator = '';
      _waitingForSecondOperand = false;
    });
  }

  void _delete() {
    setState(() {
      if (_display.length > 1) {
        _display = _display.substring(0, _display.length - 1);
      } else {
        _display = '0';
      }
    });
  }

  void _toggleSign() {
    setState(() {
      if (_display.startsWith('-')) {
        _display = _display.substring(1);
      } else if (_display != '0') {
        _display = '-$_display';
      }
    });
  }

  void _percentage() {
    setState(() {
      final double value = double.parse(_display) / 100;
      _display = _formatResult(value);
    });
  }

  Widget _buildButton(String text, {Color? color, double flex = 1}) {
    return Expanded(
      flex: flex.round(),
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: ElevatedButton(
          onPressed: () {
            if (text == 'C') {
              _clear();
            } else if (text == 'â«') {
              _delete();
            } else if (text == 'Â±') {
              _toggleSign();
            } else if (text == '%') {
              _percentage();
            } else if (text == '=') {
              if (_operator.isNotEmpty) {
                _calculate();
              }
            } else if (text == '+' || text == '-' || text == 'Ã' || text == 'Ã·') {
              _performOperation(text);
            } else if (text == '.') {
              _inputDecimal();
            } else {
              _inputDigit(text);
            }
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: color ?? Theme.of(context).colorScheme.surfaceContainerHighest,
            foregroundColor: color != null ? Colors.white : Theme.of(context).colorScheme.onSurface,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            padding: const EdgeInsets.all(20),
            elevation: 0,
          ),
          child: Text(
            text,
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w500),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ø­Ø§Ø³Ø¨Ù'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: Container(
              alignment: Alignment.bottomRight,
              padding: const EdgeInsets.all(24),
              child: SingleChildScrollView(
                reverse: true,
                child: Text(
                  _display,
                  style: const TextStyle(fontSize: 48, fontWeight: FontWeight.w300),
                  textDirection: TextDirection.ltr,
                  textAlign: TextAlign.right,
                ),
              ),
            ),
          ),
          const Divider(height: 1),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Row(
                  children: [
                    _buildButton('C', color: Colors.red.shade400),
                    _buildButton('â«', color: Colors.orange.shade400),
                    _buildButton('%', color: Colors.blueGrey.shade300),
                    _buildButton('Ã·', color: Colors.blue.shade400),
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    _buildButton('7'),
                    _buildButton('8'),
                    _buildButton('9'),
                    _buildButton('Ã', color: Colors.blue.shade400),
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    _buildButton('4'),
                    _buildButton('5'),
                    _buildButton('6'),
                    _buildButton('-', color: Colors.blue.shade400),
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    _buildButton('1'),
                    _buildButton('2'),
                    _buildButton('3'),
                    _buildButton('+', color: Colors.blue.shade400),
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    _buildButton('Â±'),
                    _buildButton('0'),
                    _buildButton('.'),
                    _buildButton('=', color: Colors.teal.shade400),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
```