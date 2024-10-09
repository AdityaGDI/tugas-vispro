import 'dart:math';
import 'dart:io';
import 'dart:async';

const String RESET = '\x1B[0m';
const String RED = '\x1B[31m';
const String GREEN = '\x1B[32m';
const String YELLOW = '\x1B[33m';
const String BLUE = '\x1B[34m';
const String MAGENTA = '\x1B[35m';
const String CYAN = '\x1B[36m';

String chooseDifferentColor(String exclude) {
  List<String> colorOptions = [RED, GREEN, YELLOW, BLUE, MAGENTA, CYAN];
  colorOptions.removeWhere((color) => color == exclude);
  return colorOptions[Random().nextInt(colorOptions.length)];
}

class Node {
  String value;
  Node? next;

  Node(this.value);
}

Node constructLinkedList(String name) {
  Node? head;
  Node? tail;

  for (int i = 0; i < name.length; i++) {
    Node newNode = Node(name[i]);

    if (head == null) {
      head = newNode;
    } else {
      tail!.next = newNode;
    }

    tail = newNode;
  }

  tail!.next = head;

  return head!;
}

List<int> getTerminalSize() => [stdout.terminalColumns, stdout.terminalLines];

void moveToPosition(int row, int col) => stdout.write('\x1B[${row};${col}H');

void clearRow(int row) {
  moveToPosition(row, 1);
  stdout.write('\x1B[K');
}

void clearScreen() => stdout.write('\x1B[2J\x1B[0;0H');

Node getNextNode(Node node) => node.next ?? node;

Future<void> displayWavePattern(Node head, int lines, String color) async {
  Node currentNode = head;
  for (int row = 1; row <= lines; row++) {
    clearRow(row);
    
    if (row % 2 != 0) {
      for (int col = 1; col <= getTerminalSize()[0]; col++) {
        moveToPosition(row, col);
        stdout.write(color + currentNode.value + RESET);
        currentNode = getNextNode(currentNode);
        await Future.delayed(Duration(milliseconds: 15));
      }
    } else {
      int terminalWidth = getTerminalSize()[0];
      // Menampilkan dari kanan ke kiri, tapi urutan "adit" tetap benar
      List<String> rowChars = [];
      for (int i = 0; i < terminalWidth; i++) {
        rowChars.add(currentNode.value);
        currentNode = getNextNode(currentNode);
      }

      // Cetak dari kanan ke kiri
      for (int col = terminalWidth; col >= 1; col--) {
        moveToPosition(row, col);
        stdout.write(color + rowChars[terminalWidth - col] + RESET);
        await Future.delayed(Duration(milliseconds: 15));
      }
    }
  }
}

void main() async {
  stdout.write('Enter your name: ');
  String userName = stdin.readLineSync()!;

  stdout.write('Enter the number of lines to display: ');
  int numLines = int.parse(stdin.readLineSync()!);

  Node head = constructLinkedList(userName);
  clearScreen();

  String currentColor = RESET;
  while (true) {
    await displayWavePattern(head, numLines, currentColor);
    currentColor = chooseDifferentColor(currentColor);
  }
}
