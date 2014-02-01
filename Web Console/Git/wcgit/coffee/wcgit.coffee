@wcGit =
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
    data = 
      branch: value
    @appendTemplate("#branch-template", data)

# wcGit.appendTemplate("#staged-template")

# TODO Construct the rest of the templates
# TODO I'll need some method for making sure things are appending in the right order
# file-template
# staged-template
# unstaged-template
# branch-template