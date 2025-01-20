import * as ExpoPdfPdf from 'expo-pdf-pdf';
import { Button, Platform, Text, View } from 'react-native';
import * as dp from 'expo-document-picker';
import * as fs from 'expo-file-system';

export default function App() {
  return (
    <View style={{ flex: 1, alignItems: 'center', justifyContent: 'center' }}>
      <Button title={`Test`} onPress={async () => {
        const { assets, canceled } = await dp.getDocumentAsync();
        const file = assets?.[0];
        if (file) {
          try {
            console.log("#0", file.uri);

            const res = ExpoPdfPdf.uncompress(file.uri);
            console.log("#1 uncompress", res);
  
            const files = await fs.readDirectoryAsync(res);
            console.log("#2 read", files);
          } catch(err) {
            console.error(err);
          }
        }
      }} />
    </View>
  );
}