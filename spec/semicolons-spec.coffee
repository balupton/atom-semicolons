{WorkspaceView} = require 'atom'
temp = require('temp')
fs = require('fs')
path = require('path')


# Use the command `window:run-package-specs` (cmd-alt-ctrl-p) to run specs.
#
# To run a specific `it` or `describe` block add an `f` to the front (e.g. `fit`
# or `fdescribe`). Remove the `f` to unfocus the block.

describe "Semicolons", ->
  editor = null
  buffer = null

  beforeEach ->
    # for some reason we have to use a real file, instead of an empty file that we then set a grammer on
    directory = temp.mkdirSync()
    atom.project.setPath(directory)
    filePath = path.join(directory, 'atom-semicolons.js')
    fs.writeFileSync(filePath, '')

    atom.workspaceView = new WorkspaceView()
    atom.workspace = atom.workspaceView.model

    waitsForPromise ->
        atom.workspace.open(filePath).then (e) ->
          editor = e

    runs ->
      buffer = editor.getBuffer()

    waitsForPromise ->
      atom.packages.activatePackage('semicolons')

  describe "when the semicolons:remove event is triggered", ->
    it "removes semicolons", ->
      source = """
        "use strict"

        import Ember from 'ember'
        import Ember from 'ember';

        a();
        (1).toString();

        a();
        [1].toString();

        doSomething();
        doSomethingElse();

        export default App
        export default App;
        """
      expectation = """
        "use strict";

        import Ember from 'ember';
        import Ember from 'ember';

        a()
        ;(1).toString()

        a()
        ;[1].toString()

        doSomething()
        doSomethingElse()

        export default App;
        export default App;
        """

      # editor.setGrammar(atom.syntax.grammarForScopeName("source.js"))
      buffer.setText(source)
      atom.workspaceView.trigger('semicolons:remove')
      # editor.save()
      result = buffer.getText()
      expect(result).toEqual(expectation)
