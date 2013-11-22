"use strict"
module.exports = (grunt) ->

  grunt.loadNpmTasks "grunt-jasmine-bundle"

  grunt.initConfig
    spec:
      e2e:
        minijasminenode:
          showColors: true
