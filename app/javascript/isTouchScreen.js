export function isTouchScreen() {
  if (window.PointerEvent && ('maxTouchPoints' in navigator))
    return navigator.maxTouchPoints > 0;

  if (window.matchMedia && window.matchMedia("(any-pointer:coarse)").matches)
    return true;

  if (window.TouchEvent || ('ontouchstart' in window))
    return true;

  return false;
}