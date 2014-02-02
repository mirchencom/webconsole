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

Object.defineProperty wcGit, 'branchName',
  get: -> $(@BRANCH_SELECTOR).text()
  set: (branchName) ->
    branchElement = $(@BRANCH_SELECTOR)
    if branchElement.length
      branchElement.text(branchName)
      return
    @appendTemplate(@BRANCH_TEMPLATE_SELECTOR, branchName: branchName)

# wcGit.appendTemplate("#staged-template")

# TODO Construct the rest of the templates
# TODO I'll need some method for making sure things are appending in the right order
# file-template
# staged-template
# unstaged-template
# branch-template