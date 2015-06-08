describe 'LmoUrlService', ->
  describe 'group', ->

    beforeEach module 'loomioApp'
    beforeEach useFactory
    beforeEach inject (LmoUrlService) -> @subject = LmoUrlService
    beforeEach ->
      window.Loomio = { hostInfo: {} }
      window.Loomio.hostInfo.host = "example.com"
      @group = @factory.create 'groups', name: 'name', key: 'key'

    contextLocalhost =
      port: 3000
      default_subdomain: null
      host: 'localhost'

    contextLoomIo =
      host: 'loom.io'
      default_subdomain: null

    contextLoomioOrg =
      host: 'loomio.org'
      default_subdomain: 'www'

    contextAnotherDomain =
      host: 'loomio.anotherdomain.com'
      default_subdomain: null

    it "handles a group without subdomain on localhost", ->
      window.Loomio.hostInfo = contextLocalhost
      expect(@subject.group(@group)).toBe 'http://localhost:3000/g/key/name'

    it "handles a group with subdomain on localhost", ->
      window.Loomio.hostInfo = contextLocalhost
      @group.updateFromJSON subdomain: 'subdomain'
      expect(@subject.group(@group)).toBe 'http://subdomain.localhost:3000/'

    it "handles a subgroup with subdomain on localhost", ->
      window.Loomio.hostInfo = contextLocalhost
      @group.updateFromJSON subdomain: 'subdomain'
      subgroup = @factory.create 'groups', parent_id: @group.id, key: 'subkey', name: 'subname'
      expect(@subject.group(subgroup)).toBe 'http://subdomain.localhost:3000/g/subkey/name-subname'

    it 'handles a group without subdomain on loom.io', ->
      window.Loomio.hostInfo = contextLoomIo
      expect(@subject.group(@group)).toBe 'http://loom.io/g/key/name'

    it 'handles a group with subdomain on loom.io', ->
      window.Loomio.hostInfo = contextLoomIo
      @group.updateFromJSON subdomain: 'subdomain'
      expect(@subject.group(@group)).toBe 'http://subdomain.loom.io/'

    it 'handles a subgroup with subdomain on loom.io', ->
      window.Loomio.hostInfo = contextLoomIo
      @group.updateFromJSON subdomain: 'subdomain'
      subgroup = @factory.create 'groups', parent_id: @group.id, key: 'subkey', name: 'subname'
      expect(@subject.group(subgroup)).toBe 'http://subdomain.loom.io/g/subkey/name-subname'

    it 'handles a group without subdomain on loomio.org', ->
      window.Loomio.hostInfo = contextLoomioOrg
      expect(@subject.group(@group)).toBe 'http://www.loomio.org/g/key/name'

    it 'handles a group with subdomain on loomio.org', ->
      window.Loomio.hostInfo = contextLoomioOrg
      @group.updateFromJSON subdomain: 'subdomain'
      expect(@subject.group(@group)).toBe 'http://subdomain.loomio.org/'

    it 'handles a subgroup with subdomain on loomio.org', ->
      window.Loomio.hostInfo = contextLoomioOrg
      @group.updateFromJSON subdomain: 'subdomain'
      subgroup = @factory.create 'groups', parent_id: @group.id, key: 'subkey', name: 'subname'
      expect(@subject.group(subgroup)).toBe 'http://subdomain.loomio.org/g/subkey/name-subname'

    it 'handles a group without subdomain on loomio.anotherdomain.com', ->
      window.Loomio.hostInfo = contextAnotherDomain
      expect(@subject.group(@group)).toBe 'http://loomio.anotherdomain.com/g/key/name'

    it 'handles a group with subdomain on loomio.anotherdomain.com', ->
      window.Loomio.hostInfo = contextAnotherDomain
      @group.updateFromJSON subdomain: 'subdomain'
      expect(@subject.group(@group)).toBe 'http://subdomain.loomio.anotherdomain.com/'

    it 'handles a subgroup with subdomain on loomio.anotherdomain.com', ->
      window.Loomio.hostInfo = contextAnotherDomain
      @group.updateFromJSON subdomain: 'subdomain'
      subgroup = @factory.create 'groups', parent_id: @group.id, key: 'subkey', name: 'subname'
      expect(@subject.group(subgroup)).toBe 'http://subdomain.loomio.anotherdomain.com/g/subkey/name-subname'
