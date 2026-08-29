export function useClickOutside() {
  return undefined
}

export function useMatchMedia(controller, options = {}) {
  const mediaQueries = options.mediaQueries || {}
  for (const [name, query] of Object.entries(mediaQueries)) {
    const mediaQueryList = window.matchMedia ? window.matchMedia(query) : { matches: false }
    const callbackName = `${name}Changed`
    if (typeof controller[callbackName] === "function") {
      controller[callbackName]({ matches: mediaQueryList.matches })
    }
  }

  return undefined
}

export function useDebounce() {
  return undefined
}
