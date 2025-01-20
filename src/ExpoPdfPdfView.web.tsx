import * as React from 'react';

import { ExpoPdfPdfViewProps } from './ExpoPdfPdf.types';

export default function ExpoPdfPdfView(props: ExpoPdfPdfViewProps) {
  return (
    <div>
      <iframe
        style={{ flex: 1 }}
        src={props.url}
        onLoad={() => props.onLoad({ nativeEvent: { url: props.url } })}
      />
    </div>
  );
}
