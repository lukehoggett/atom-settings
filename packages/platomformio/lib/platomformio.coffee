PlatomformioView      = require './platomformio-view'
{CompositeDisposable} = require 'atom'

module.exports = Platomformio =
  config:
    verboseBuild:
      title: 'Show all build output (default is to only show if an error occurs)'
      type: 'boolean'
      default: false
    verboseUpload:
      title: 'Show all upload output (default is to only show if an error occurs)'
      type: 'boolean'
      default: true
    platformioPath:
      title: 'Path for platformio command'
      description: 'This package depends on platformio, find path by typing `which platformio` into your terminal'
      type: 'string'
      default: '/usr/local/bin/platformio'
  subscriptions: null

  activate: (state) ->
    @platomformioView = new PlatomformioView state.platomformioViewState

    @subscriptions = new CompositeDisposable
    @subscriptions.add atom.commands.add 'atom-workspace',
      'core:cancel'               : => @close()
      'platomformio:build'        : => @build()
      'platomformio:upload'       : => @upload()
      'platomformio:close'        : => @close()
      'platomformio:kill-process' : => @kill()

  deactivate: ->
    @platomformioView.close()

  serialize: ->
    platomformioViewState: @platomformioView.serialize()

  build: ->
    @saveWorkspace()

    @platomformioView.resetView("Building...")
    if atom.config.get('platomformio.verboseBuild')
      @platomformioView.panel.addClass("descriptive")

    @platomformioView.run(atom.config.get('platomformio.platformioPath'), ["run"])

  upload: ->
    @saveWorkspace()

    @platomformioView.resetView("Uploading...")
    if atom.config.get('platomformio.verboseUpload')
      @platomformioView.panel.addClass("descriptive")

    @platomformioView.run(atom.config.get('platomformio.platformioPath'), ["run", "--target=upload"])

  close: ->
    @platomformioView.close()

  kill: ->
    @platomformioView.kill()

  saveWorkspace: ->
    paneItem = atom.workspace.getActivePaneItem()
    paneItem.save()
