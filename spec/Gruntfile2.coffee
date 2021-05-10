module.exports = (grunt) ->
  grunt.initConfig
    assetFingerprint:
      options:
        manifestPath: "tmp/dist/assets.json"
      sut:
        expand: true
        cwd: "fixtures"
        src: ["**/*"]
        dest: "tmp/dist"

      # Add another fingerprinting target to specifically fingerprint the
      # background.png file and find and replace occurrences in the already
      # fingerprinted tmp/dist/some-css-*.css file. Do this to avoid dirtying
      # the fixtures directory.
      sut2:
        options:
          findAndReplaceFiles: ["tmp/dist/*.css"]
          cdnPrefixForRootPaths: "https://cdn.domain.com"
        expand: true
        cwd: "fixtures"
        src: ["background.png"]
        dest: "tmp/dist"

