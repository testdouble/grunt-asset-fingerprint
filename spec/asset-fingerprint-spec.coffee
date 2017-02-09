grunt  = require("grunt")
spawn  = require("child_process").spawn
read   = grunt.file.read
write  = grunt.file.write
mkdir  = grunt.file.mkdir
clear  = grunt.file.delete
expand = grunt.file.expand

runGruntTask = (task, config, done) ->
  spawn("grunt",
    [
      task,
      "--config", JSON.stringify(config),
      "--tasks", "../tasks"
      "--gruntfile", "spec/Gruntfile.coffee"
    ],
    {stdio: 'inherit'}
  ).on("exit", -> done())

beforeEach -> mkdir @workspacePath = "spec/tmp"
afterEach  -> clear "spec/tmp/"

describe "assetFingerprint", ->

  Given ->
    @config =
      assetFingerprint:
        options:
          manifestPath: "tmp/dist/assets.json"
          findAndReplaceFiles: ['fixtures/some-css.css']
          cdnPrefixForRootPaths: 'https://cdn.domain.com'

        sut:
          expand: true
          cwd: "fixtures"
          src: ["**/*"]
          dest: "tmp/dist"

  describe "writes contents of fingerprinted files properly", ->
    appearsOnce = (needle, haystack) -> haystack.match(needle)?.length == 1
    When (done) -> runGruntTask("assetFingerprint", @config, done)
    Then  -> read("#{expand('spec/tmp/dist/some-javascript-*.js')[0]}") == read("spec/fixtures/some-javascript.js")
    Then -> appearsOnce(
      /'\.\/background-95ac97ead4f4543f3161da2bfdb5ec56\.png'/g
      read("#{expand('spec/tmp/dist/some-css-*.css')[0]}"))
    Then -> appearsOnce(
      /'https:\/\/cdn\.domain\.com\/background-95ac97ead4f4543f3161da2bfdb5ec56\.png'/g
      read("#{expand('spec/tmp/dist/some-css-*.css')[0]}"))


  describe "JSON asset manifest", ->
    When (done) -> runGruntTask("assetFingerprint", @config, done)
    And -> @assets = JSON.parse(read("spec/tmp/dist/assets.json"))
    Then -> expect(@assets).toEqual
      "some-javascript.js": "some-javascript-848617e97516659d0d8c68d3e142b48f.js"
      "background.png": "background-95ac97ead4f4543f3161da2bfdb5ec56.png"
      "some-css.css": "some-css-4046ce32976bb9cb70e20b3a6ad54ea0.css"
