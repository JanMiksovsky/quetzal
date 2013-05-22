###
Build instructions for Grunt.js
### 
module.exports = ->

  @loadNpmTasks "grunt-contrib-coffee"
  # @loadNpmTasks "grunt-contrib-less"
  sortDependencies = require "sort-dependencies"
  
  @initConfig
    pkg: @file.readJSON "package.json"
    coffee:
      elements:
        src: sortDependencies.sortFiles "elements/*.coffee"
        dest: "elements/elements.js"
      test:
        src: sortDependencies.sortFiles "test/*.coffee"
        dest: "test/unittests.js"
    # less:
    #   controls:
    #     files:
    #       "controls/controls.css": sortDependencies.sortFiles "controls/*.less"
  
  # Default task.
  @registerTask "default", [ "coffee" ]
