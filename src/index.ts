import { NativeModule, requireNativeModule } from 'expo';
import { addProtocol, normalize } from './path';

export type ExpoPdfPdfModuleEvents = {};

export declare class ExpoPdfPdfModule extends NativeModule<ExpoPdfPdfModuleEvents> {
  compress(sourcePath: string): string;
  uncompress(sourcePath: string): string;
}

export const ExpoPdfPdf = requireNativeModule<ExpoPdfPdfModule>('ExpoPdfPdf');

export function compress(sourcePath: string) {
  return addProtocol(ExpoPdfPdf.compress(normalize(sourcePath)));
}

export function uncompress(sourcePath: string) {
  return addProtocol(ExpoPdfPdf.uncompress(normalize(sourcePath)))
}