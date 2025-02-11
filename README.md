# Hahnah's Blog Template with Elm Pages

[![Netlify Status](https://api.netlify.com/api/v1/badges/25a90b8a-f6ca-4823-a957-eb7f6e653b2f/deploy-status)](https://app.netlify.com/sites/taupe-mousse-68837d/deploys)

This is a tempalte for building a blog as static site with elm-pages, forked from [https://github.com/kraklin/elm-pages-blog-starter](https://github.com/kraklin/elm-pages-blog-starter).

## Demo

[https://hahnah-blog-template.netlify.app/](https://hahnah-blog-template.netlify.app/)

## Features

- Static Site Generation
- Blog posts with markdown
- Tags
- Categories (Tech and Life)
- Mutiple authors
- Pagination
- Sitemap feed

## What is used?

- [Elm](https://elm-lang.org/) language v0.19
- [Elm Pages](https://elm-pages.com/) v3
- [Tailwind CSS](https://tailwindcss.com/) v3

See package.json for more details.

## Setup

1. Install [Volta](https://volta.sh/) for manageing Node.js and npm versions.
   - _OPTION_: You can replace Volta with any other manager what you like, or can just install Node.js directory.
2. Install and set Node.js and npm with Volta like below.
   ```bash
   volta install node@22 # Intall Node.js v22.x, or you can choose newer version
   volta list node # Check the installed version of Node.js
   volta pin node@22.13.0 # Specify the installed version you saw above command
   volta install npm@11 # Intall npm v11.x, or you can choose newer version
   volta list npm # Check the installed version of npm
   volta pin npm@11.0.0 # Specify the installed version you saw above command
   ```
3. Install Node modules
   ```bash
   npm install
   ```

## Running dev server

```bash
npm run start
```

Then open `http://localhost:1234` in your browser.

## Writing a blog post

Add a new markdown file in `content/tech-blog/<any slug what to want>/index.md` or `content/life-blog/<any slug what to want>/index.md`.

## Deploying on Netlify

Just make sure your repository is conneted to Netlify.

## Deploying on GitHub Pages

1. Make sure your repositgory name is same as your github username. If not, change it.
2. Edit `Settings.domain` definition in `src/Settings.elm` file. It shoulbe be `<your github username>.github.io`.
3. Make sure `Settings.basePath` is `"/"` in `src/Settings.elm` file.
4. Setup GitHub Pages on GitHub site at "Settings" tab -> "Pages":
   - Set "Source" to `Deploy from a branch`
   - Set "Branch" to `gh-pages` branch and `/root` directory.

Deployment Settings are done!  
Every time you push to the `main` branch, the site will be built and deployed to GitHub Pages with this URL: `https://<your github username>.github.io`.

### Can we deploy site to subdirectory in GitHub Pages?

Which mean, like `https://<your github username>.github.io/any-subdirectory`.  
Typically, subdirectory name will be same as repository name.

The answer is... **No, we can't**.

It's because of elm-pages bug of `build --base ...` command.  
See below issue for more details.  
[https://github.com/dillonkearns/elm-pages/issues/404](https://github.com/dillonkearns/elm-pages/issues/404)

## Author

Hahnah (Natsuki Harai)

## LICENSE

See [LICENSE](LICENSE) file.
