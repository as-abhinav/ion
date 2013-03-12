load 'application'

before 'load notes', ->
  Notes.find params.id, (err, notes) =>
    if err || !notes
      if !err && !notes && params.format == 'json'
        return send code: 404, error: 'Not found'
      redirect pathTo.notes
    else
      @notes = notes
      next()
, only: ['show', 'edit', 'update', 'destroy']

action 'new', ->
  @notes = new Notes
  @title = 'New notes'
  render()

action 'create', ->
  Notes.create body.Notes, (err, notes) =>
    respondTo (format) =>
      format.json ->
        if err
          send code: 500, error: notes.errors || err
        else
          send code: 200, data: notes.toObject()
      format.html =>
        if err
          flash 'error', 'Notes can not be created'
          @notes = notes
          @title = 'New notes'
          render 'new'
        else
          flash 'info', 'Notes created'
          redirect pathTo.notes

action 'index', ->
  Notes.all (err, notes) =>
    @notes = notes
    @title = 'Notes index'
    respondTo (format) ->
      format.json ->
        send code: 200, data: notes
      format.html ->
        render notes: notes

action 'show', ->
  @title = 'Notes show'
  respondTo (format) =>
    format.json =>
      send code: 200, data: @notes
    format.html ->
      render()

action 'edit', ->
  @title = 'Notes edit'
  respondTo (format) =>
    format.json =>
      send code: 200, data: @notes
    format.html ->
      render()

action 'update', ->
  @notes.updateAttributes body.Notes, (err) =>
    respondTo (format) =>
      format.json =>
        if err
          send code: 500, error: @notes.errors || err
        else
          send code: 200, data: @notes
      format.html =>
        if !err
          flash 'info', 'Notes updated'
          redirect path_to.notes(@notes)
        else
          flash 'error', 'Notes can not be updated'
          @title = 'Edit notes details'
          render 'edit'

action 'destroy', ->
  @notes.destroy (error) ->
    respondTo (format) ->
      format.json ->
        if error
          send code: 500, error: error
        else
          send code: 200
      format.html ->
        if error
          flash 'error', 'Can not destroy notes'
        else
          flash 'info', 'Notes successfully removed'
        send "'" + path_to.notes + "'"
