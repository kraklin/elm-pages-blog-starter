/** @type {import('tailwindcss').Config} */

const colors = require('tailwindcss/colors')

export default {
  content: [
    "./app/**/*.{elm, ts, js}",
    "./src/**/*.{elm, ts, js}",
    "./index.html"
  ],
  theme: {
    extend: {
      colors: {
        primary: colors.sky,
      },
    },
  },
  plugins: [
    require('@tailwindcss/typography'),
  ],
}

