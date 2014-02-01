@wcGit =
  addBranch: (branch) ->
    # TODO use this to create a general purpose method for generating templates
    # TODO Optional parameters template can either take data or not
    source = $("#branch-template").html()
    template = Handlebars.compile(source)
    data = 
      branch: branch
    $(template(data)).appendTo("body")

Object.defineProperty wcGit, 'branch',
  get: -> $("#branch").text()
  set: (value) ->
    source = $("#branch-template").html()
    template = Handlebars.compile(source)
    data = 
      branch: value
    $(template(data)).appendTo("body")

# TODO Construct the rest of the templates
# file-template
# staged-template
# unstaged-template
# branch-template