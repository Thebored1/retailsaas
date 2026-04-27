import 'dart:io';
import 'dart:typed_data';

void main() {
  final pngFile = File('assets/app_icon.png');
  if (!pngFile.existsSync()) {
    print('Error: assets/app_icon.png not found.');
    exit(1);
  }

  final pngBytes = pngFile.readAsBytesSync();
  final icoFile = File('assets/app_icon.ico');

  // ICO header (6 bytes)
  final header = ByteData(6);
  header.setUint16(0, 0, Endian.little); // Reserved
  header.setUint16(2, 1, Endian.little); // Type (1 for ICO)
  header.setUint16(4, 1, Endian.little); // Number of images

  // Icon Directory Entry (16 bytes)
  final directory = ByteData(16);
  directory.setUint8(0, 0); // Width (0 for 256)
  directory.setUint8(1, 0); // Height (0 for 256)
  directory.setUint8(2, 0); // Color count
  directory.setUint8(3, 0); // Reserved
  directory.setUint16(4, 1, Endian.little); // Color planes
  directory.setUint16(6, 32, Endian.little); // Bits per pixel
  directory.setUint32(8, pngBytes.length, Endian.little); // Image size
  directory.setUint32(12, 22, Endian.little); // Image offset (6 + 16 = 22)

  final icoBytes = Uint8List.fromList([
    ...header.buffer.asUint8List(),
    ...directory.buffer.asUint8List(),
    ...pngBytes,
  ]);

  icoFile.writeAsBytesSync(icoBytes);
  print('Successfully created assets/app_icon.ico');
}
