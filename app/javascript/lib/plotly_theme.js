export function plotlyTheme() {
  const theme = document.documentElement.getAttribute("data-theme")

  const isLight = theme === "light"

  return {
    bg: isLight ? "#FFFFFF" : "#202020",
    font: isLight ? "#000000" : "#FFFFFF",
    isLight
  }
}