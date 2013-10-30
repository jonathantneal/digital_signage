if $('#slide-upload-dropzone').length > 0
  # initialize spinner progress bar
  bg = $('#circle-canvas')[0]
  ctx = bg.getContext('2d')
  circ = Math.PI * 2
  quart = Math.PI / 2

  initializeCircle = (color) ->
    ctx.beginPath()
    ctx.strokeStyle = color
    ctx.lineCap = 'square'
    ctx.closePath()
    ctx.fill()
    ctx.lineWidth = 20.0

  updateProgressCircle = (percentage) ->
    ctx.beginPath()
    ctx.arc(100, 100, 90, -(quart), ((circ) * percentage) - quart, false)
    ctx.stroke()

  delayedReload = (mils) ->
    initializeCircle('#ffffff')

    current = 0
    stop = false
    setInterval (->
      unless stop
        current += 5
        updateProgressCircle(current / mils)
        if current >= mils
          stop = true
          location.reload()
    ), 5

  initializeCircle('#99CC33')

  Dropzone.options.slideUploadDropzone = {
    clickable: false
    createImageThumbnails: false
    dictDefaultMessage: "<i class='fa fa-cloud-upload'></i> Drag and drop files to upload"

    addedfile: ->
      $('#page-spinner').show()
    processing: ->
      # wait for it...
    uploadprogress: ->
      # wait for it......
    success: ->
      console.log('upload complete!')

    totaluploadprogress: (totalUploadProgress, totalBytes, totalBytesSent) ->
      updateProgressCircle(totalUploadProgress / 100)

      if totalUploadProgress >= 100
        # It takes a second for the image to process. So just wait here for a second before reloading
        delayedReload(1000)

  }