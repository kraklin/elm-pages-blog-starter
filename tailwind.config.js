/** @type {import('tailwindcss').Config} */
export default {
  content: [
    "./app/**/*.{elm, ts, js}",
    "./index.html"
  ],
  theme: {
    extend: {},
  },
  plugins: [
    require('@tailwindcss/typography'),
  ],
}

