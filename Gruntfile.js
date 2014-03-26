module.exports = function(grunt) {

  // for my mac
  var ADDONS_DIR = '/Applications/World\ of\ Warcraft/Interface/AddOns/';

  // for my workpc
  // var ADDONS_DIR = 'm:\\World of Warcraft\\Interface\\AddOns\\';

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
      },
      SimpleTimingLib: {
        files: [{
          cwd: 'SimpleTimingLib',
          src: '**',
          dest: ADDONS_DIR + 'SimpleTimingLib'
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
      },
      SimpleTimingLib: {
        files: 'SimpleTimingLib/**/*.*',
        tasks: ['sync:SimpleTimingLib']
      }
    }

  });

  // Load the plugin that provides the "uglify" task.
  grunt.loadNpmTasks('grunt-sync');
  grunt.loadNpmTasks('grunt-contrib-watch');

  // Default task(s).
  grunt.registerTask('default', ['watch']);

};