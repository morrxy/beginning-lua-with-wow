module.exports = function(grunt) {

  var ADDONS_DIR = (function() {
    // addon path of my mac
    var dir_mac = '/Applications/World of Warcraft/Interface/AddOns/';
    // addon path of my workpc
    var dir_pc = 'd:\\Program Files\\World of Warcraft\\Interface\\AddOns\\';
    // addon path of linux
    var dir_linux = '/media/data/Program Files/World of Warcraft/Interface/AddOns/';

    // choose addon path
    var dir;
    if (grunt.file.exists(dir_pc)) {
      dir = dir_pc;
    } else if (grunt.file.exists(dir_mac)) {
      dir = dir_mac;
    } else if (grunt.file.exists(dir_linux)) {
      dir = dir_linux;
    }

    return dir;
  })();

  if (!ADDONS_DIR) {
    // grunt.log.writeln("sync's target dir not found.");
    grunt.fail.warn("sync's target dir not found.");
  }

  grunt.loadNpmTasks('grunt-sync');
  grunt.loadNpmTasks('grunt-contrib-watch');

  // dynamic config sync and watch's targets for every dir except for node_modules
  grunt.registerTask('config_watch', 'dynamically config watch', function() {

    grunt.file.expand({
      filter: 'isDirectory'
    }, ['*', '!node_modules']).forEach(function(dir) {
      // config watch's target
      var watch_tasks = grunt.config.get('watch') || {};
      watch_tasks[dir] = {
        files: dir + '/**/*',
        tasks: ['config_sync', 'sync:' + dir]
      };
      grunt.config.set('watch', watch_tasks);

    });

  });

  grunt.registerTask('config_sync', 'dynamically config sync', function() {

    grunt.file.expand({
      filter: 'isDirectory'
    }, ['*', '!node_modules']).forEach(function(dir) {
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
  grunt.registerTask('default', ['synceach', 'watcheach']);

};