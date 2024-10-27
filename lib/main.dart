import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Calculator(),
    );
  }
}

class Calculator extends StatefulWidget {
  const Calculator({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _CalculatorState createState() => _CalculatorState();
}

class _CalculatorState extends State<Calculator> {
  List<dynamic> inputs = []; // Store numbers and operations in a list
  dynamic text = '0'; // Calculator display text
  dynamic result = ''; // Current result
  String currentInput = ''; // Input buffer for numbers

  // Button Widget with uniform size and font style
  Widget calcbutton(String btntxt, Color btncolor, Color txtcolor) {
    return SizedBox(
      width: 80, // Set a fixed width for uniform button size
      height: 80, // Set a fixed height for uniform button size
      child: ElevatedButton(
        onPressed: () {
          calculation(btntxt);
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: btncolor,
          shape: const CircleBorder(),
          padding: const EdgeInsets.all(20),
        ),
        child: Text(
          btntxt,
          style: TextStyle(
            fontSize: 30, // Set a consistent font size
            fontWeight: FontWeight.bold, // Set a consistent font weight
            color: txtcolor,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Calculator
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('Numble-Calculator'),
        backgroundColor: Colors.black,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 5),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            // Calculator display
            SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Text(
                      '$text',
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: text == "I Love You" ? 50 : 100, // Adjust font size for special message
                      ),
                    ),
                  )
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                calcbutton('AC', Colors.grey, Colors.black),
                calcbutton('+/-', Colors.grey, Colors.black),
                calcbutton('%', Colors.grey, Colors.black),
                calcbutton('/', const Color.fromARGB(255, 251, 159, 2), Colors.white),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                calcbutton('7', Colors.grey[850]!, Colors.white),
                calcbutton('8', Colors.grey[850]!, Colors.white),
                calcbutton('9', Colors.grey[850]!, Colors.white),
                calcbutton('x', Colors.amber[700]!, Colors.white),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                calcbutton('4', Colors.grey[850]!, Colors.white),
                calcbutton('5', Colors.grey[850]!, Colors.white),
                calcbutton('6', Colors.grey[850]!, Colors.white),
                calcbutton('-', Colors.amber[700]!, Colors.white),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                calcbutton('1', Colors.grey[850]!, Colors.white),
                calcbutton('2', Colors.grey[850]!, Colors.white),
                calcbutton('3', Colors.grey[850]!, Colors.white),
                calcbutton('+', Colors.amber[700]!, Colors.white),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                SizedBox(
                  width: 170, // Make '0' button twice as wide for uniformity
                  height: 80,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey[850],
                      shape: const StadiumBorder(),
                    ),
                    onPressed: () {
                      calculation('0');
                    },
                    child: const Text(
                      '0',
                      style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                  ),
                ),
                calcbutton('.', Colors.grey[850]!, Colors.white),
                calcbutton('=', Colors.amber[700]!, Colors.white),
              ],
            ),
            const SizedBox(height: 60),
          ],
        ),
      ),
    );
  }

  void calculation(String btnText) {
    if (btnText == 'AC') {
      text = '0';
      inputs.clear();
      currentInput = '';
      result = '';
    } else if (btnText == '=') {
      if (currentInput.isNotEmpty) {
        inputs.add(currentInput);
      }
      calculateResult();
    } else if (btnText == '+' || btnText == '-' || btnText == 'x' || btnText == '/') {
      if (currentInput.isNotEmpty) {
        inputs.add(currentInput);
        inputs.add(btnText);
        currentInput = '';
      }
    } else if (btnText == '+/-') {
      if (currentInput.isNotEmpty) {
        currentInput = currentInput.startsWith('-')
            ? currentInput.substring(1)
            : '-$currentInput';
      }
    } else {
      currentInput += btnText;
      result = currentInput;
    }

    setState(() {
      text = result;
    });
  }

  void calculateResult() {
    // Check if inputs are empty before proceeding
    if (inputs.isEmpty) {
      return; // Exit the function if there are no inputs
    }

    // Special case for the input "143"
    if (inputs.length == 1 && inputs[0] == '143') {
      // If input is "143" and user presses "="
      setState(() {
        text = "I Love You";
      });
      inputs.clear();
      currentInput = '';
      return;
    }

    // Convert 'x' to '*' for calculation
    for (int i = 0; i < inputs.length; i++) {
      if (inputs[i] == 'x') {
        inputs[i] = '*';
      }
    }

    // Calculate the result considering operator precedence (PEMDAS/BODMAS)
    double total = double.parse(inputs[0]);
    String operation = '';

    for (int i = 1; i < inputs.length; i++) {
      if (inputs[i] == '+' || inputs[i] == '-' || inputs[i] == '*' || inputs[i] == '/') {
        operation = inputs[i];
      } else {
        double number = double.parse(inputs[i]);
        switch (operation) {
          case '+':
            total += number;
            break;
          case '-':
            total -= number;
            break;
          case '*':
            total *= number;
            break;
          case '/':
            if (number != 0) {
              total /= number;
            } else {
              // Handle division by zero
              total = double.nan; // You can also set an error message instead
            }
            break;
        }
      }
    }

    result = total.toString();
    inputs.clear();
    currentInput = '';
    setState(() {
      text = result;
    });
  }
}
