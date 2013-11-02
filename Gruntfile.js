module.exports = function(grunt) {

  // Project configuration.
  grunt.initConfig({
    yuidoc: {
      compile: {
        name: "<%= pkg.name %>",
        description: "<%= pkg.description %>",
        version: "<%= pkg.version %>",
        url: "<%= pkg.homepage %>",
        options: {
          extension: ".js,.html",
          paths: "elements",
          outdir: "docs",
          linkNatives: "true",
          tabtospace: 2,
          themedir: "themes/bootstrap"
        }
      }
    },
    pkg: grunt.file.readJSON( "package.json" )
  });

  grunt.loadNpmTasks( "grunt-contrib-yuidoc" );

  // Default task(s).
  grunt.registerTask( "default", [ "yuidoc" ]);

};