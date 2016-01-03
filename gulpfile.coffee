gulp = require('gulp')
$    = require('gulp-load-plugins')()
del  = require('del')

# package for pcyp-electron
packageJson = require('./src/package.json');

SRC  = 'src'
DEST = 'build'
CACHE = 'cache'

gulp.task 'compile:copy_resource', ->
  gulp.src "#{SRC}/**/*.json"
  .pipe gulp.dest("#{DEST}/dist")

gulp.task 'compile:html', ->
  gulp.src "#{SRC}/**/*.html"
  .pipe gulp.dest("#{DEST}/dist")

gulp.task 'compile:coffee', ->
  gulp.src "#{SRC}/**/*.coffee"
  .pipe $.coffee()
  .pipe gulp.dest("#{DEST}/dist")

gulp.task 'compile', ['compile:html', 'compile:coffee', 'compile:copy_resource']

gulp.task 'electron:packaging', ->
    gulp.src ''
    .pipe $.electron({
        src: "#{DEST}/dist",
        packageJson: packageJson,
        release: "#{DEST}/Release",
        cache: CACHE,
        version: 'v0.36.1',
        packaging: true,
        platforms: ['win32-ia32'],
        platformResources: {
            darwin: {
                CFBundleDisplayName: packageJson.name,
                CFBundleIdentifier: packageJson.name,
                CFBundleName: packageJson.name,
                CFBundleVersion: packageJson.version,
                icon: 'gulp-electron.icns'
            },
            win: {
                "version-string":  packageJson.version,
                "file-version":    packageJson.version,
                "product-version": packageJson.version,
                "icon": 'gulp-electron.ico'
            }
        }
    })
    .pipe gulp.dest("")

gulp.task 'electron:clean', ->
  del(["#{DEST}/Release"])

gulp.task 'electron', (cb)->
  $.sequence('electron:clean', 'electron:packaging')(cb)


gulp.task 'default', ['compile']
