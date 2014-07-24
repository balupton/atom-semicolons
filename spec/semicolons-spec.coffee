{WorkspaceView} = require 'atom'

# Use the command `window:run-package-specs` (cmd-alt-ctrl-p) to run specs.
#
# To run a specific `it` or `describe` block add an `f` to the front (e.g. `fit`
# or `fdescribe`). Remove the `f` to unfocus the block.

describe "Semicolons", ->
  activationPromise = null

  beforeEach ->
    atom.workspaceView = new WorkspaceView
    activationPromise = atom.packages.activatePackage('semicolons')

  describe "when the semicolons:remove event is triggered", ->
    it "removes semicolons", ->
      source = """
        I have semicolons;
        yay;
        """
      expectation = """
        I have semicolons
        yay
        """

      waitsForPromise ->
        atom.workspace.open().then (editor) ->
          editor.setText(source)
          atom.workspaceView.trigger('semicolons:remove')
          setTimeout((->
            expect(editor.getText()).toEqual(expectation)
          ), 1000)
