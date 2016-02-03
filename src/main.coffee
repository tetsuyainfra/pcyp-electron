

yargs         = require('yargs')
PcypApp       = require('./pcyp-app')

parseCommandLine = ->
  version = PcypApp.version
  options = yargs(process.argv[1..]).wrap(100)
  options.usage """
    pcyp-electron v#{version}
    Usage: pcyp-electron [options]

    Environment Variables:
      -d --dev : debug mode
  """

  options.alias('d', 'dev').boolean('d').describe('d', 'Run in development mode')
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


pcyp_app = PcypApp.start(argv)
