angular.module('loomioApp').factory 'LmoUrlService', ->
  new class LmoUrlService

    hostInfo: ->
      window.Loomio.hostInfo

    stub: (name) ->
      name.replace(/[^a-z0-9\-_]+/gi, '-').replace(/-+/g, '-').toLowerCase()

    discussion: (d) ->
      @urlForPath "/d/#{d.key}/#{@stub(d.title)}"

    proposal: (p) ->
      @urlForPath "/m/#{p.key}/#{@stub(p.name)}"

    comment: (c) ->
      d = c.discussion()
      @urlForPath "/d/#{d.key}/#{@stub(d.title)}#comment-#{c.id}"

    group: (g) ->
      @forcedSubdomain = @parentGroupSubdomainFor(g)
      @urlForPath @groupRelativeUrl(g)

    # force absolute url with subdomain if subgroup's parent has a non-default subdomain
    parentGroupSubdomainFor: (g) ->
      if g.isSubgroup() and g.parent().subdomain != @subdomain()
        g.parent().subdomain

    groupRelativeUrl: (g) ->
      if g.subdomain == @subdomain()
        "/"
      else
        "/g/#{g.key}/#{@stub(g.fullName())}"

    urlForPath: (path) ->
      if @urlIsAbsolute()
        "#{@absoluteUrl()}#{path}"
      else
        path

    absoluteUrl: ->
      "#{@protocol()}#{@subdomain()}.#{@host()}#{@port()}"

    urlIsAbsolute: ->
      @subdomain() != 'www' or
      @hostInfo().ssl or 
      @port().length

    protocol: ->
      if @hostInfo().ssl then 'https://' else 'http://'
    
    subdomain: ->
      @forcedSubdomain or
      @hostInfo().default_subdomain or 
      'www'

    host: ->
      @hostInfo().host

    port: ->
      if @hostInfo().port && !@portIsDefault()
        ":#{@hostInfo().port}"
      else
        ""

    portIsDefault: ->
      @hostInfo().port == if @hostInfo().ssl then 443 else 80
