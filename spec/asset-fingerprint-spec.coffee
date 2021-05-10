grunt  = require("grunt")
spawn  = require("child_process").spawn
read   = grunt.file.read
write  = grunt.file.write
mkdir  = grunt.file.mkdir
clear  = grunt.file.delete
expand = grunt.file.expand

runGruntTask = (task, gruntFile, done) ->
  spawn("grunt",
    [
      task,
      "--tasks", "../tasks"
      "--gruntfile", gruntFile
    ],
    {stdio: 'inherit'}
  ).on("exit", -> done())

beforeEach -> mkdir @workspacePath = "spec/tmp/dist"
afterEach  -> clear "spec/tmp/"

describe "assetFingerprint", ->

  describe "writes contents of fingerprinted files properly", ->
    When (done) -> runGruntTask("assetFingerprint", "spec/Gruntfile1.coffee", done)
    Then  -> read("#{expand('spec/tmp/dist/some-javascript-*.js')[0]}") == read("spec/fixtures/some-javascript.js")

  describe "finds and replaces references properly", ->
    appearsOnce = (needle, haystack) -> haystack.match(needle)?.length == 1
    When (done) -> runGruntTask("assetFingerprint", "spec/Gruntfile2.coffee", done)
    Then ->
      console.log 'juice', read("#{expand('spec/tmp/dist/some-css-*.css')[0]}")

      appearsOnce(
        /'\.\/background-95ac97ead4f4543f3161da2bfdb5ec56\.png'/g,
        read("#{expand('spec/tmp/dist/some-css-*.css')[0]}")
      )
    Then ->
      appearsOnce(
        /'https:\/\/cdn\.domain\.com\/background-95ac97ead4f4543f3161da2bfdb5ec56\.png'/g,
        read("#{expand('spec/tmp/dist/some-css-*.css')[0]}")
      )

  describe "JSON asset manifest", ->
    When (done) -> runGruntTask("assetFingerprint", "spec/Gruntfile1.coffee", done)
    And -> @assets = JSON.parse(read("spec/tmp/dist/assets.json"))
    Then -> expect(@assets).toEqual
      "some-javascript.js": "some-javascript-848617e97516659d0d8c68d3e142b48f.js"
      "background.png": "background-95ac97ead4f4543f3161da2bfdb5ec56.png"
      "some-css.css": "some-css-14df887bc4003c9f380dde8dd513408b.css"
