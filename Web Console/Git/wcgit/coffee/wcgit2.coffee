Function::property = (prop, desc) ->
  Object.defineProperty @prototype, prop, desc

class Element
  constructor: (@selector, @parentSelector) ->
  @property 'element',
    get: -> 
      element = $(@selector)
      if element.length
        return element
      else
        return null
    set: (element) ->
      ($ element).appendTo(@parentSelector)

class TemplateElement extends Element
  constructor: (@selector, @parentSelector, @templateSelector) ->
    super(@selector, @parentSelector)
  add: (data) ->
    source = $(@templateSelector).html()
    template = Handlebars.compile(source)
    if (data)
      result = template(data)
    else
      result = template()
    @element = result

class BranchMessageElement extends TemplateElement
  SELECTOR: "#branch_message"
  PARENT_SELECTOR: "body"
  TEMPLATE_SELECTOR: "#branch-template"
  BRANCH_NAME_SELECTOR: "#branch"
  constructor: () ->
    super(@SELECTOR, @PARENT_SELECTOR, @TEMPLATE_SELECTOR)
  @property 'branchName',
    get: -> 
      return null unless @element?
      ($ @BRANCH_NAME_SELECTOR).text()
    set: (branchName) ->
      if not @element?
        @add(branchName: branchName)
      else
        ($ @BRANCH_NAME_SELECTOR).text(branchName)

class WcGit
  constructor: ->
    @branchMessageElement = new BranchMessageElement
  @property 'branchName',
    get: -> @branchMessageElement.branchName
    set: (branchName) -> @branchMessageElement.branchName = branchName

@wcGit = new WcGit

# wcGit.appendTemplate("#staged-template")

# TODO Setting the branch to an empty string should remove it
# TODO Construct the rest of the templates
# TODO I'll need some method for making sure things are appending in the right order
# file-template
# staged-template
# unstaged-template
# branch-template