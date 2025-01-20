// import { Platform } from 'react-native';

// Remove file protocol. "file://"
export function normalize(path: string) {
  return path.replace(/^file:\/\//, "");
}

export function addProtocol(path: string) {
  return "file://"+path;
}