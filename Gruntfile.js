module.exports = function(grunt) {

  var ADDONS_DIR = '/Applications/World\ of\ Warcraft/Interface/AddOns/';

  // Project configuration.
  grunt.initConfig({
    sync: {
      HelloWorld: {
        files: [{
          cwd: 'HelloWorld',
          src: '**',
          dest: ADDONS_DIR + 'HelloWorld'
        }]
      },
      ChatlinkTooltips: {
        files: [{
          cwd: 'ChatlinkTooltips',
          src: '**',
          dest: ADDONS_DIR + 'ChatlinkTooltips'
        }]
      }

    },
    watch: {
      HelloWorld: {
        files: 'HelloWorld/**/*.*',
        tasks: ['sync:HelloWorld']
      },
      ChatlinkTooltips: {
        files: 'ChatlinkTooltips/**/*.*',
        tasks: ['sync:ChatlinkTooltips']
      }

    }
  });

  // Load the plugin that provides the "uglify" task.
  grunt.loadNpmTasks('grunt-sync');
  grunt.loadNpmTasks('grunt-contrib-watch');

  // Default task(s).
  grunt.registerTask('default', ['watch']);

};