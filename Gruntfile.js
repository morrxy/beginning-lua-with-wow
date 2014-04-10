module.exports = function(grunt) {

  grunt.initConfig({});

  // addon path of my mac
  var ADDONS_DIR_MAC = '/Applications/World of Warcraft/Interface/AddOns/';

  // addon path of my workpc
  var ADDONS_DIR_PC = 'm:\\World of Warcraft\\Interface\\AddOns\\';

  // choose addon path
  var ADDONS_DIR;
  if (grunt.file.exists(ADDONS_DIR_PC)) {
    ADDONS_DIR = ADDONS_DIR_PC;
  } else if (grunt.file.exists(ADDONS_DIR_MAC)) {
    ADDONS_DIR = ADDONS_DIR_MAC;
  }

  grunt.loadNpmTasks('grunt-sync');
  grunt.loadNpmTasks('grunt-contrib-watch');

  // dynamic config sync and watch's targets for every dir except for node_modules
  grunt.registerTask('config_watch', 'dynamically config watch', function() {

    grunt.file.expand({filter: 'isDirectory'},
      ['*', '!node_modules']).forEach(function(dir) {
      // config watch's target
      var watch_tasks = grunt.config.get('watch') || {};
      watch_tasks[dir] = {
        files: dir + '/**/*',
        tasks: ['config_sync', 'sync:' + dir]
        // tasks: 'synceach'
      };
      grunt.config.set('watch', watch_tasks);

    });

  });

  grunt.registerTask('config_sync', 'dynamically config sync', function() {

    grunt.file.expand({filter: 'isDirectory'},
      ['*', '!node_modules']).forEach(function(dir) {
      // config sync's targets
      var sync_tasks = grunt.config.get('sync') || {};
      sync_tasks[dir] = {
        files: [{
          cwd: dir,
          src: '**/*',
          dest: ADDONS_DIR + dir
        }]
      };
      grunt.config.set('sync', sync_tasks);
    });

  });

  grunt.registerTask('synceach', ['config_sync', 'sync']);
  grunt.registerTask('watcheach', ['config_watch', 'watch']);
  grunt.registerTask('default', ['watcheach']);

};


