module.exports =
  activate: (state) ->
    atom.workspaceView.command "semicolons:remove", (e) ->
      e.abortKeyBinding()
      editor = atom.workspace.activePaneItem
      if editor.getGrammar().name is 'JavaScript'
        rep = editor.getText().replace(/;$/mg, '')
        editor.setText(rep)
      null