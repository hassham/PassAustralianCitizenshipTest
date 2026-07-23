import 'dart:io';

int currentResidentMemoryBytes() => ProcessInfo.currentRss;
