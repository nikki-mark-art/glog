'use strict';

module.exports = (grunt) ->

    grunt.tasksPath = 'grunt-tasks'

    # Project configuration.
    grunt.initConfig
        pkg:
            grunt.file.readJSON('package.json')

        connect:
            server:
                options:
                    port: 5000
                    base: '.'
                    directory: '.'

        coffee:
            compile:
                files:
                    'js/main.js': 'src/main.coffee'
                    'js/config.js': 'src/config.coffee'

        watch:
            
            uglify:
                files: ['src/**/*.js', 'test/**/*.js']
                tasks: ['uglify'],
                options:
                    spawn: true

            coffee:
                files: ['src/**/*.coffee', 'test/**/*.coffee']
                tasks: ['coffee'],
                options:
                    spawn: true

            options:
                dateFormat: (time) ->
                    grunt.log.writeln('The watch finished in ' + time + 'ms at' + (new Date()).toString())
                    grunt.log.writeln('Waiting for more changes...')

        concat:
            options:
                # Specifies string to be inserted between concatenated files.
                separator: ';'
                stripBanners: true
                banner: '/*! <%= pkg.name %> - v<%= pkg.version %> - ' +
                        '<%= grunt.template.today("yyyy-mm-dd") %> */',
            dist:
                src: ['js/vendor/*.js']
                dest: 'js/plugins.js'

        uglify:
            options:
                banner: '/*! Compressing <%= pkg.name %> <%= grunt.template.today("yyyy-mm-dd") %> */\n'

            build:
                src: ['src/**/*.coffee', 'test/**/*.coffee']
                dest: ['src/**/*.min.js', 'test/**/*.min.js']

    # Load our custom tasks (if any) in the grunt.tasksPath folder
    # grunt.task.loadTasks grunt.tasksPath

    # Serve files
    grunt.loadNpmTasks 'grunt-contrib-connect'

    # Concatenate all plugins
    grunt.loadNpmTasks 'grunt-contrib-concat'

    # Compile CoffeeScript
    grunt.loadNpmTasks 'grunt-contrib-coffee'

    # Watch file changes
    grunt.loadNpmTasks 'grunt-contrib-watch'

    # Load the plugin that provides the "uglify" task.
    grunt.loadNpmTasks 'grunt-contrib-uglify'

    # Default task(s)
    grunt.registerTask 'default', ['watch']
