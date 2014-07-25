replacements = [
  # move needed semicolons to start of line
  [
    /;+(\n\s*)([\(\[])/gm
    '$1;$2'
  ]

  # remove unneeded semicolons
  [
    /;+$/gm
    ''
  ]

  # re-add needed semicolons to end of lines
  # https://github.com/jshint/jshint/issues/459
  # https://github.com/square/es6-module-transpiler/pull/72
  [
    /^("use strict"|(?:import|export).+?)$/gm
    '$1;'
  ]
]

module.exports =
  activate: (state) ->
    atom.workspaceView.command "semicolons:remove", (e) ->
      e.abortKeyBinding()
      editor = atom.workspace.activePaneItem
      if editor.getGrammar().name is 'JavaScript'
        result = editor.getText()
        for replacement in replacements
          result = result.replace(replacement[0], replacement[1])
        editor.setText(result)
      null