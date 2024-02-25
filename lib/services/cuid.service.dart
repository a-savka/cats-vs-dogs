import 'dart:math';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'cuid.service.g.dart';

class CuidService {
  final String _prefix = 'c';
  final int _base = 36;
  final _secureRandom = Random.secure();

  int _counter = 0;
  late num _discreteValues;
  late String _fingerprint;

  CuidService._privateConstructor() {
    _discreteValues = pow(_base, 4);
    _fingerprint = _secureRandomBlock();
  }

  static final CuidService _instance = CuidService._privateConstructor();

  factory CuidService() {
    return _instance;
  }

  String _pad(String s, int l) {
    s = s.padLeft(l, '0');
    return s.substring(s.length - l);
  }

  String _timeBlock() {
    final now = DateTime.now().toUtc().millisecondsSinceEpoch;
    return now.toRadixString(_base);
  }

  String _counterBlock() {
    _counter = _counter < _discreteValues ? _counter : 0;
    _counter++;
    return _pad((_counter - 1).toRadixString(_base), 4);
  }

  String _secureRandomBlock() {
    const max = 0x7fffffff;
    return _pad(_secureRandom.nextInt(max).toRadixString(_base), 4);
  }

  String newCuid() {
    final tblock = _timeBlock();
    final cblock = _counterBlock();
    final fblock = _fingerprint;
    final rblock = _secureRandomBlock() + _secureRandomBlock();
    return _prefix + tblock + cblock + fblock + rblock;
  }

  bool isCuid(String? s) {
    s = s ?? '';
    return s.startsWith(_prefix);
  }

  String newLocalCuid() {
    return '-' + newCuid();
  }

  bool isLocalCuid(String? s) {
    s = s ?? '';
    return s.startsWith('-$_prefix');
  }
}

@Riverpod(keepAlive: true)
CuidService cuidService(CuidServiceRef ref) => CuidService();
