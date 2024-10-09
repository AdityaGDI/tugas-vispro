import 'dart:io';
import 'dart:async';
import 'dart:collection';

base class CharEntry extends LinkedListEntry<CharEntry> {
  final String data;

  CharEntry(this.data);
}

void main() async {
  int terminalWidth = stdout.terminalColumns;
  LinkedList<CharEntry> aditList = LinkedList<CharEntry>();
  String adit = "ADIT ";
  int aditLength = adit.length;

  aditList.add(CharEntry(adit));

  print("Masukkan berapa kali output ingin diulang: ");
  String? input = stdin.readLineSync();
  int repeatCount = int.tryParse(input ?? '') ?? 1;

  int aditCount = terminalWidth ~/ aditLength;

  for (int i = 0; i < repeatCount; i++) {
    await printADITLine(aditList, aditCount);
    print(" " * (terminalWidth - aditLength) + "ADIT");
    await printADITLine(aditList, aditCount);
    print("ADIT" + " " * (terminalWidth - aditLength - 5));
  }

  stdout.write('\x1B[31m');

  for (int i = 0; i < repeatCount; i++) {
    await printADITLine(aditList, aditCount);
    print(" " * (terminalWidth - aditLength) + "ADIT");
    await printADITLine(aditList, aditCount);
    print("ADIT" + " " * (terminalWidth - aditLength - 5));
  }

  stdout.write('\x1B[0m');
}

Future<void> printADITLine(LinkedList<CharEntry> aditList, int count) async {
  for (int j = 0; j < count; j++) {
    await printAnimated(aditList);
  }
  print("");
}

Future<void> printAnimated(LinkedList<CharEntry> aditList) async {
  for (var node in aditList) {
    stdout.write(node.data); // Mengakses data dari CharEntry
    await Future.delayed(Duration(milliseconds: 10));
  }
}
