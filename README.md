# grunt-asset-fingerprint

[![Build Status](https://travis-ci.org/testdouble/grunt-asset-fingerprint.png?branch=master)](https://travis-ci.org/testdouble/grunt-asset-fingerprint)

### Overview

grunt-asset-fingerprint works by appending a hash to all asset files. Find and replace is then used to identify references to these assets in your code so that they point at the new fingerprinted assets. Ideally this task works best at the end of the build process.

### Config

```js
assetFingerprint: {
  "options": {
    "manifestPath": "dist/assets.json",
    "findAndReplaceFiles": [
      "dist/**/*.{js,css,html,xml}"
    ],
    "keepOriginalFiles": false
  },
  "dist": {
    "files": [
      {
        "expand": true,
        "cwd": "dist",
        "src": [
          "img/**/*",
          "webfonts/**/*",
          "js/app.js",
          "css/app.css"
        ],
        "dest": "dist"
      }
    ]
  }
}
```
## Running Specs

* clone this repo
* `npm install`
* `grunt spec`
