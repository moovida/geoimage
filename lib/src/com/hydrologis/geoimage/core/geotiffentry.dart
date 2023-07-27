import 'package:image/image.dart';
import 'package:image/src/formats/tiff/tiff_entry.dart';

class GeoTiffEntry {
  TiffEntry tiffEntry;

  GeoTiffEntry(this.tiffEntry);

  List<int> readValues() {
    tiffEntry.p.offset = tiffEntry.valueOffset;
    final values = <int>[];
    for (var i = 0; i < tiffEntry.count; ++i) {
      values.add(_readValue());
    }
    return values;
  }
  int _readValue() {
    switch (tiffEntry.type) {
      case IfdValueType.byte:
      case IfdValueType.ascii:
        return tiffEntry.p.readByte();
      case IfdValueType.short:
        return tiffEntry.p.readUint16();
      case IfdValueType.long:
        return tiffEntry.p.readUint32();
      case IfdValueType.rational:
        final num = tiffEntry.p.readUint32();
        final den = tiffEntry.p.readUint32();
        if (den == 0) {
          return 0;
        }
        return num ~/ den;
      case IfdValueType.sByte:
        throw ImageException('Unhandled value type: SBYTE');
      case IfdValueType.undefined:
        return tiffEntry.p.readByte();
      case IfdValueType.sShort:
        throw ImageException('Unhandled value type: SSHORT');
      case IfdValueType.sLong:
        throw ImageException('Unhandled value type: SLONG');
      case IfdValueType.sRational:
        throw ImageException('Unhandled value type: SRATIONAL');
      case IfdValueType.single:
        throw ImageException('Unhandled value type: FLOAT');
      case IfdValueType.double:
        throw ImageException('Unhandled value type: DOUBLE');
    }
    return 0;
  }
  String readString() {
    if (tiffEntry.type != IfdValueType.ascii) {
      throw ImageException('readString requires ASCII entity');
    }
    // TODO: ASCII fields can contain multiple strings, separated with a NULL.
    return String.fromCharCodes(readValues());
  }

  List read() {
    tiffEntry.p.offset = tiffEntry.valueOffset;
    final values = <dynamic>[];
    for (var i = 0; i < tiffEntry.count; ++i) {
      switch (tiffEntry.type) {
        case IfdValueType.byte:
        case IfdValueType.ascii:
          values.add(tiffEntry.p.readByte());
          break;
        case IfdValueType.short :
          values.add(tiffEntry.p.readUint16());
          break;
        case IfdValueType.long:
          values.add(tiffEntry.p.readUint32());
          break;
        case IfdValueType.rational:
          final num = tiffEntry.p.readUint32();
          final den = tiffEntry.p.readUint32();
          if (den != 0) {
            values.add(num / den);
          }
          break;
        case IfdValueType.single:
          values.add(tiffEntry.p.readFloat32());
          break;
        case IfdValueType.double:
          values.add(tiffEntry.p.readFloat64());
          break;
      }
    }
    return values;
  }
}
