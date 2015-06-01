describe 'LmoUrlService', ->
  describe 'group', ->

    beforeEach module 'loomioApp'
    beforeEach useFactory
    beforeEach inject (LmoUrlService) -> @subject = LmoUrlService
    beforeEach ->
      window.Loomio = { hostInfo: {} }
      window.Loomio.hostInfo.host = "example.com"
      @group = @factory.create 'groups', name: 'name', key: 'key'

    it 'serves a path when there is no default subdomain', ->
      expect(@subject.group(@group)).toBe('/g/key/name')

    it 'serves a secure path when ssl is turned on', ->
      Loomio.hostInfo.ssl = true
      expect(@subject.group(@group)).toBe('https://www.example.com/g/key/name')

    it 'can include port in the url', ->
      Loomio.hostInfo.port = 3000
      expect(@subject.group(@group)).toBe('http://www.example.com:3000/g/key/name')

    it 'does not include port in the url when default port is selected', ->
      Loomio.hostInfo.port = 80
      expect(@subject.group(@group)).toBe('/g/key/name')

    it 'serves the default subdomain url when there is a default subdomain', ->
      Loomio.hostInfo.default_subdomain = 'sub'
      expect(@subject.group(@group)).toBe('http://sub.example.com/g/key/name')

    it 'serves root when the group\'s subdomain is used', ->
      Loomio.hostInfo.default_subdomain = 'subdomain'
      @group.updateFromJSON(subdomain: 'subdomain')
      expect(@subject.group(@group)).toBe('http://subdomain.example.com/')

    it 'serves a url when a subgroup has a parent with a subdomain', ->
      @group.updateFromJSON(subdomain: 'subdomain')
      @subgroup = @factory.create 'groups', parentId: @group.id, key: 'subkey', name: 'subname'
      expect(@subject.group(@subgroup)).toBe('http://subdomain.example.com/g/subkey/name-subname')

    it 'serves the parent\'s subdomain when on a custom subdomain', ->
      @group.updateFromJSON(subdomain: 'subdomain')
      Loomio.hostInfo.default_subdomain = 'custom'
      @subgroup = @factory.create 'groups', parentId: @group.id, key: 'subkey', name: 'subname'
      expect(@subject.group(@subgroup)).toBe('http://subdomain.example.com/g/subkey/name-subname')

    it 'serves a relative path when the parent\'s subdomain is the current subdomain', ->
      @group.updateFromJSON(subdomain: 'subdomain')
      Loomio.hostInfo.default_subdomain = 'subdomain'
      @subgroup = @factory.create 'groups', parentId: @group.id, key: 'subkey', name: 'subname'
      expect(@subject.group(@subgroup)).toBe('http://subdomain.example.com/g/subkey/name-subname')      