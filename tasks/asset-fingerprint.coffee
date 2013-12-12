fs     = require "fs"
path   = require "path"
crypto = require "crypto"

"use strict"

module.exports = (grunt) ->
  _ = grunt.util._

  stripDestPath = (file, files) ->
    file.replace(path.normalize("#{files.orig.dest}/"), "")

  grunt.registerMultiTask "assetFingerprint", "Generates asset fingerprints and appends to a rails manifest", ->
    manifestPath   = @options(manifestPath: "dist/assets.json").manifestPath
    algorithm      = @options(algorithm: "md5").algorithm

    filesToHashed = {}

    _(@files).each (files) ->
      src = files.src[0]
      dest = files.dest

      return grunt.log.debug("Source file `#{src}` was a directory. Skipping.") if grunt.file.isDir(src)
      grunt.log.warn("Source file `#{src}` not found.") unless grunt.file.exists(src)

      algorithmHash = crypto.createHash(algorithm)
      extension     = path.extname(dest)

      content  = grunt.file.read(src)
      filename = "#{path.dirname(dest)}/#{path.basename(dest, extension)}-#{algorithmHash.update(content).digest("hex")}#{extension}"
      filesToHashed[stripDestPath(dest, files)] = stripDestPath(filename, files)

      grunt.file.write filename, content
      grunt.log.writeln "File #{filename} created."

    fs.writeFileSync(manifestPath, JSON.stringify(filesToHashed))
    grunt.log.writeln "Recorded #{_(filesToHashed).size()} asset mapping(s) to #{manifestPath}"
