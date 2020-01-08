
(($) ->

  cnvs = null
  ctx = null

  mod = (a, b) ->
    (a % b + b) % b

  rand = (a, b) ->
    Math.random() * (b - a) + a

  hsl = (h, s, l) ->
    "hsl(#{Math.floor(h * 360)},#{Math.floor(s * 100)}%,#{Math.floor(l * 100)}%)"

  grad = (x0, y0, x1, y1, a, b) ->
    grd = ctx.createLinearGradient x0, y0, x1, y1
    grd.addColorStop 0, a
    grd.addColorStop 1, b
    grd

  shiftColor = (h, s, l, factor) ->
    h1 = (h + rand(-factor, factor)) % 1.0
    [h1, s, l]

  generate = (args={}) ->

    b = args.branch ? 4
    n = args.steps ? 5
    dvar = args.dvar ? (Math.PI / 6)
    length = args.length ? 10
    length2 = length * 2 # Constant for now; may be variable later
    hue = args.hue ? rand(0.0, 1.0)
    cvar = args.cvar ? 0.03

    tree = (x0, y0, n, d, h, s, l) ->
      if n <= 0
        return
      for i in [1..b]
        [h1, s1, l1] = shiftColor h, s, l, cvar
        len = rand(n * length, n * length2)
        d1 = d + rand(- dvar,
                        dvar)
        x1 = x0 + len * Math.cos(d1)
        y1 = y0 + len * Math.sin(d1)
        ctx.strokeStyle = grad x0, y0, x1, y1, hsl(h, s, l), hsl(h1, s1, l1)
        ctx.beginPath()
        ctx.moveTo x0, y0
        ctx.lineTo x1, y1
        ctx.stroke()
        tree x1, y1, n - 1, d1, h1, s1, l1

    ctx.fillStyle = "#010101"
    ctx.fillRect 0, 0, 640, 480
    tree 320, 400, n, 3 / 2 * Math.PI, hue, 1.0, 0.5
  window.generate = generate

  generateFrom = ->
    branch = $('#param-branch').val()
    steps = $('#param-steps').val()
    dvar = $('#param-dvar').val()
    length = $('#param-length').val()
    hue = if $('#param-color-select').prop('checked') then +$('#param-color-value').val() else null
    cvar = $('#param-cvar').val()
    generate
      branch: branch
      steps: steps
      dvar: dvar
      length: length
      hue: hue
      cvar: cvar
  window.generateFrom = generateFrom

  initializeForms = ->
    $('#param-branch').val 4
    $('#param-steps').val 5
    $('#param-dvar').val (Math.PI / 6)
    $('#param-length').val 10
    $('#param-color-value').val 0.0
    $('#param-color-random').prop 'checked', true
    $('#param-cvar').val 0.03

  showHidePanel = ->
    panel = $('#panel')
    display = panel.css 'display'
    if display == 'none'
      panel.css 'display', 'block'
    else
      panel.css 'display', 'none'
  window.showHidePanel = showHidePanel

  colorSelected = ->
    $('#param-color-select').prop 'checked', true
    color = $('#param-color-value').val()
    $('#color-sampler').css 'background-color', hsl(color, 1.0, 0.5)
  window.colorSelected = colorSelected

  $(document).ready ->
    cnvs = $("#canvas")[0]
    ctx = cnvs.getContext "2d"

    initializeForms()
    generate()

)(window.jQuery);
