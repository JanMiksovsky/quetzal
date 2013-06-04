###
Build instructions for Grunt.js
### 
module.exports = ->

  @loadNpmTasks "grunt-contrib-coffee"
  sortDependencies = require "sort-dependencies"
  
  @initConfig
    pkg: @file.readJSON "package.json"
    coffee:
      elements:
        src: sortDependencies.sortFiles "elements/*.coffee"
        dest: "elements/elements.js"
      src:
        src: sortDependencies.sortFiles "src/*.coffee"
        dest: "src/quetzal.js"
      test:
        src: sortDependencies.sortFiles "test/*.coffee"
        dest: "test/unittests.js"
  
  # Default task.
  @registerTask "default", [ "coffee" ]
