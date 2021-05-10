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

