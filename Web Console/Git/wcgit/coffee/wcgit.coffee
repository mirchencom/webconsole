@wcGit =
  BRANCH_SELECTOR: "#branch"
  BRANCH_TEMPLATE_SELECTOR: "#branch-template"
  BASE_SELECTOR: "body"
  appendTemplate: (selector, data) ->
    source = $(selector).html()
    template = Handlebars.compile(source)
    if (data)
      result = template(data)
    else
      result = template()
    $(result).appendTo(@BASE_SELECTOR)

Object.defineProperty wcGit, 'branch',
  get: -> $(@BRANCH_SELECTOR).text()
  set: (value) ->
    if $(@BRANCH_SELECTOR).length
      $(@BRANCH_SELECTOR).text(value)
      return
    data = 
      branch: value
    @appendTemplate(@BRANCH_TEMPLATE_SELECTOR, data)

# wcGit.appendTemplate("#staged-template")

# TODO Construct the rest of the templates
# TODO I'll need some method for making sure things are appending in the right order
# file-template
# staged-template
# unstaged-template
# branch-template