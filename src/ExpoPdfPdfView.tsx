import { requireNativeView } from 'expo';
import * as React from 'react';

import { ExpoPdfPdfViewProps } from './ExpoPdfPdf.types';

const NativeView: React.ComponentType<ExpoPdfPdfViewProps> =
  requireNativeView('ExpoPdfPdf');

export default function ExpoPdfPdfView(props: ExpoPdfPdfViewProps) {
  return <NativeView {...props} />;
}
