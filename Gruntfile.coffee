"use strict"
module.exports = (grunt) ->

  grunt.loadNpmTasks "grunt-jasmine-bundle"

  grunt.registerTask "test", ["spec"]
  grunt.registerTask "default", ["test"]
