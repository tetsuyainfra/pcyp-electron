gulp = require('gulp')
$    = require('gulp-load-plugins')()
del  = require('del')

env  = require('../env')
config = require('../config')
packageJson = config.packageJson

gulp.task 'electron:copy_app', ->
  gulp.src "#{config.APP}/**/*"
  .pipe gulp.dest(config.DIST)

gulp.task 'electron:copy_module', ->
  dep_names=[]
  for name of require("#{config.root}/package").dependencies
    dep_names.push name unless name in ["electron-prebuilt"]
  gulp.src(["node_modules/{#{dep_names.join(',')}}/**/*"])
  .pipe gulp.dest("#{config.DIST}/node_modules")

gulp.task 'electron:packaging', ->
    gulp.src ''
    .pipe $.electron({
        src: config.DIST,
        packageJson: packageJson,
        release: config.BUILD,
        cache: config.CACHE,
        version: 'v0.36.1',
        packaging: false,
        asar: false,
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
                "icon": 'src/pcyp-electron_icon.ico'
            }
        }
    })
    .pipe gulp.dest("")


gulp.task 'electron',
 $.sequence( 'electron:clean', ['electron:copy_app', 'electron:copy_module'], 'electron:packaging')
