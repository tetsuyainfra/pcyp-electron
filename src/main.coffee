#--------------------------------------------------
#  entry point for electron main-process
#--------------------------------------------------

yargs         = require('yargs')
logger        = require('commons/logger')

parseCommandLine = ->
  version = PcypApp.version
  options = yargs(process.argv[1..]).wrap(100)
  options.usage """
    pcyp-electron v#{version}
    Usage:
      pcyp-electron [options]

    Player mode Usage(testing):
      pcyp-electron -p [http://URL_HERE/ | file://localhost/c:/hogehoge.mp4]
  """
  options.count('verbose').alias('v', 'verbose')
  .describe('v', 'VERBOSE LEVEL -v warn, -vv info, -vvv debug, -vvvv trace')

  options.alias('P', 'play').string('P')
  .describe('P', 'Run in Test Player mode')
  args = options.argv

  if args.help
    process.stdout.write(options.help())
    process.exit(0)

  if args.version
    process.stdout.write("#{version}\n")
    process.exit(0)

  devMode = args['dev'] || process.env.NODE_ENV == 'development' || false

  # return args
  {devMode}

argv = parseCommandLine()
