window.wcGit =
  addBranch: (branch) ->
    source = $("#branch-template").html()
    template = Handlebars.compile(source)
    data = 
      branch: branch
    $(template(data)).appendTo("body")
  # _renderTemplate(templateID, data)

# TODO Optional parameters template can either take data or not

  # file-template
  # staged-template
  # unstaged-template
  # branch-template