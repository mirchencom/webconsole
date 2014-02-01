@wcGit =
  addBranch: (branch) ->
    # TODO use this to create a general purpose method for generating templates
    # TODO Optional parameters template can either take data or not
    source = $("#branch-template").html()
    template = Handlebars.compile(source)
    data = 
      branch: branch
    $(template(data)).appendTo("body")
  appendTemplate: (selector, data) ->
    source = $(selector).html()
    template = Handlebars.compile(source)
    if (data)
      result = template(data)
    else
      result = template()
    $(result).appendTo("body")

Object.defineProperty wcGit, 'branch',
  get: -> $("#branch").text()
  set: (value) ->
    # source = $("#branch-template").html()
    # template = Handlebars.compile(source)
    # data = 
    #   branch: value
    # $(template(data)).appendTo("body")
    data = 
      branch: value
    @appendTemplate("#branch-template", data)


wcGit.appendTemplate("#staged-template")

# TODO Construct the rest of the templates
# TODO I'll need some method for making sure things are appending in the right order
# file-template
# staged-template
# unstaged-template
# branch-template