'use strict';

module.exports = function(grunt)
{
    // A very basic default task.
    grunt.registerTask('simple_task', 'A placeholder for your task',
        function()
        {
            grunt.log.write('Running simple_task').ok();
        }
    );
}