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
      protocol: 'http'
      default_subdomain: null
      tld_length: 0
      host: 'localhost'

    contextLoomIo =
      host: 'loom.io'
      default_subdomain: null
      tld_length: 1

    contextLoomioOrg =
      host: 'loomio.org'
      default_subdomain: 'www'
      tld_length: 1

    contextAnotherDomain =
      host: 'loomio.anotherdomain.com'
      default_subdomain: null
      tld_length: 2

    it "handles a group without subdomain on localhost", ->
      window.Loomio.hostInfo = contextLocalhost
      expect(@subject.group(@group)).to eq 'http://localhost:3000/g/key/name'

    it "handles a group with subdomain on localhost", ->
      window.Loomio.hostInfo = contextLocalhost
      @group.updateFromJSON subdomain: 'subdomain'
      expect(@subject.group(@group)).to eq 'http://subdomain-group.localhost:3000/'

    it "handles a subgroup with subdomain on localhost", ->
      window.Loomio.hostInfo = contextLocalhost
      @group.updateFromJSON subdomain: 'subdomain'
      subgroup = @factory.create 'groups', parent_id: @group.id, key: 'subkey', name: 'subname'
      expect(@subject.group(subgroup)).to eq 'http://subdomain.localhost:3000/g/subkey/subname-name'

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
      expect(@subject.group(subgroup)).to eq 'http://subdomain.loom.io/g/subkey/subname-name'

    it 'handles a group without subdomain on loomio.org', ->
      window.Loomio.hostInfo = contextLoomIo
      expect(@subject.group(@group)).toBe 'http://www.loomio.org/g/key/name'

    it 'handles a group with subdomain on loomio.org', ->
      window.Loomio.hostInfo = contextLoomIo
      @group.updateFromJSON subdomain: 'subdomain'
      expect(@subject.group(@group)).toBe 'http://subdomain.loomio.org/'

    it 'handles a subgroup with subdomain on loomio.org', ->
      window.Loomio.hostInfo = contextLoomIo
      @group.updateFromJSON subdomain: 'subdomain'
      subgroup = @factory.create 'groups', parent_id: @group.id, key: 'subkey', name: 'subname'
      expect(@subject.group(subgroup)).to eq 'http://subdomain.loomio.org/g/subkey/subname-name'

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
      expect(@subject.group(subgroup)).to eq 'http://subdomain.loomio.anotherdomain.com/g/subkey/subname-name'
