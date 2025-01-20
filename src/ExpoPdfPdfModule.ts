import { NativeModule, requireNativeModule } from 'expo';

import { ExpoPdfPdfModuleEvents } from './ExpoPdfPdf.types';

declare class ExpoPdfPdfModule extends NativeModule<ExpoPdfPdfModuleEvents> {
  PI: number;
  hello(): string;
  setValueAsync(value: string): Promise<void>;
}

// This call loads the native module object from the JSI.
export default requireNativeModule<ExpoPdfPdfModule>('ExpoPdfPdf');
