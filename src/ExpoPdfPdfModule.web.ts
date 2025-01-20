import { registerWebModule, NativeModule } from 'expo';

import { ExpoPdfPdfModuleEvents } from './ExpoPdfPdf.types';

class ExpoPdfPdfModule extends NativeModule<ExpoPdfPdfModuleEvents> {
  PI = Math.PI;
  async setValueAsync(value: string): Promise<void> {
    this.emit('onChange', { value });
  }
  hello() {
    return 'Hello world! 👋';
  }
}

export default registerWebModule(ExpoPdfPdfModule);
