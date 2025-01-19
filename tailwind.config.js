/** @type {import('tailwindcss').Config} */

import colors from "tailwindcss/colors";

export default {
  content: [
    "./app/**/*.{elm, ts, js}",
    "./src/**/*.{elm, ts, js}",
    "./index.html",
  ],
  theme: {
    extend: {
      colors: {
        primary: colors.sky,
      },
    },
  },
  plugins: [require("@tailwindcss/typography")],
};
