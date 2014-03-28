// grunt.file.expand([options, ] patterns)
// isDirectory
// grunt.file.expand('isDirectory', '!node_modules')

// grunt.registerTask("your-task-name", "your description", function() {

//   // read all subdirectories from your modules folder
//   grunt.file.expand("./modules/*").forEach(function (dir) {

//     // get the current concat config
//     var concat = grunt.config.get('concat') || {};

//     // set the config for this modulename-directory
//     concat[dir] = {
//      src: ['/modules/' + dir + '/js/*.js', '!/modules/' + dir + '/js/compiled.js'],
//      dest: '/modules/' + dir + '/js/compiled.js'
//     }

//     // save the new concat config
//     grunt config.set('concat', concat);
//   });
//   // when finished run the concatinations
//   grunt.task.run('concat');
// });

module.exports = function(grunt) {

  // addon path of my mac
  var ADDONS_DIR_MAC = '/Applications/World\ of\ Warcraft/Interface/AddOns/';

  // addon path of my workpc
  var ADDONS_DIR_PC = 'm:\\World of Warcraft\\Interface\\AddOns\\';

  // choose addon path
  var ADDONS_DIR;
  if (grunt.file.exists(ADDONS_DIR_PC)) {
    ADDONS_DIR = ADDONS_DIR_PC;
  } else if (grunt.file.exists(ADDONS_DIR_MAC)) {
    ADDONS_DIR = ADDONS_DIR_MAC;
  }

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

  // dynamic mapping sync
  grunt.registerTask('sync-addons', function() {

  });

};