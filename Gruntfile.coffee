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
        src: [
          "src/register.coffee"
          "src/QuetzalElement.coffee"
          "src/properties.coffee"
          "src/render.coffee"
          "src/Super.QuetzalElement.coffee"
          "src/Property.QuetzalElement.coffee"
        ]
        dest: "quetzal.js"
      test:
        src: sortDependencies.sortFiles "test/*.coffee"
        dest: "test/unittests.js"
  
  # Default task.
  @registerTask "default", [ "coffee" ]
