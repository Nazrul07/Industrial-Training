import 'dart:math' as math;
import 'dart:io';

void main() {
  print('==============================');
  print('       CMD Calculator');
  print('==============================');

  while (true) {
    print('\nChoose an option:');
    print('1. Add');
    print('2. Subtract');
    print('3. Multiply');
    print('4. Divide');
    print('5. Power');
    print('6. Modulus');
    print('7. Exit');

    stdout.write('Enter choice: ');
    var choice = stdin.readLineSync();

    if (choice == '7') {
      print('Goodbye!');
      break;
    }

    if (choice == null || int.parse(choice) < 1 || int.parse(choice) > 7) {
      print('Invalid choice. Try again.');
      continue;
    }

    final firstNumber = _readNumber('Enter first number: ');
    final secondNumber = _readNumber('Enter second number: ');

    double result;

    switch (choice) {
      case '1':
        result = firstNumber + secondNumber;
        print('Result: $result');
        break;
      case '2':
        result = firstNumber - secondNumber;
        print('Result: $result');
        break;
      case '3':
        result = firstNumber * secondNumber;
        print('Result: $result');
        break;
      case '4':
        if (secondNumber == 0) {
          print('Cannot divide by zero.');
        } else {
          result = firstNumber / secondNumber;
          print('Result: $result');
        }
        break;
      case '5':
        result = math.pow(firstNumber, secondNumber).toDouble();
        print('Result: $result');
        break;
      case '6':
        result = firstNumber % secondNumber;
        print('Result: $result');
        break;
    }
  }
}

double _readNumber(String message) {
  while (true) {
    stdout.write(message);
    final input = stdin.readLineSync();
    final number = double.tryParse(input ?? '');

    if (number != null) {
      return number;
    }

    print('Please enter a valid number.');
  }
}
