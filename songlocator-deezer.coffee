###

  SongLocator resolver for Deezer.

  2013 (c) Andrey Popp <8mayday@gmail.com>

###

((root, factory) ->
  if typeof exports == 'object'
    SongLocator = require('songlocator-base')
    module.exports = factory(SongLocator)
  else if typeof define == 'function' and define.amd
    define (require) ->
      SongLocator = require('songlocator-base')
      root.SongLocator.Deezer = factory(SongLocator)
  else
    root.SongLocator.Deezer = factory(SongLocator)

) this, ({BaseResolver, extend}) ->

  class Resolver extends BaseResolver
    name: 'deezer'
    score: 0.9

    search: (qid, query) ->
      this.request
        url: 'http://api.deezer.com/2.0/search'
        params: {q: query}
        callback: (error, response) =>
          return if error?
          return unless response.data.length > 0

          results = for item in response.data
            {
              title: item.title
              artist: item.artist?.name
              album: item.album?.title

              source: this.name
              id: item.id

              linkURL: item.link
              imageURL: "#{item.album?.cover}?size=big"
              audioURL: undefined
              audioPreviewURL: item.preview

              mimetype: 'audio/mpeg'
              duration: item.duration
            }
          results = results.slice(0, this.options.searchMaxResults)
          this.results(qid, results)

  {Resolver}
