declare const __IS_MACOS__: boolean;

export const keys = {
  cmd:   __IS_MACOS__ ? '⌘'  : 'Ctrl',
  alt:   __IS_MACOS__ ? '⌥'  : 'Alt',
  shift: __IS_MACOS__ ? '⇧'  : 'Shift',
};
