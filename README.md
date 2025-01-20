# expo-pdf-pdf

Extract page to images from PDF in expo.

## Getting Started

### Installation

```console
npm install github:shinich39/expo-pdf-pdf
```

### Usage

```js
import { uncompress } from 'expo-pdf-pdf';
import * as dp from 'expo-document-picker';
import * as fs from 'expo-file-system';

const { assets, canceled } = await dp.getDocumentAsync();
const file = assets?.[0];
if (file) {
  // Uncompress Example
  const res = uncompress(file.uri);
  // dirPath: String
  // file://...
  
  // Read extracted files
  const files = await fs.readDirectoryAsync(res);
}
```

## References

- [Expo DocumentPicker](https://docs.expo.dev/versions/latest/sdk/document-picker/)
- [Expo FileSystem](https://docs.expo.dev/versions/latest/sdk/filesystem/)
- [PdfRenderer](https://developer.android.com/reference/android/graphics/pdf/PdfRenderer)
- [PDFKit](https://developer.apple.com/documentation/pdfkit)

## Acknowledgements
