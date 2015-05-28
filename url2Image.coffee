webshot = require 'webshot'
http = require 'http'
crypto = require 'crypto'
fs = require 'fs'
config = require './config.json'

options = config.webshotOptions

garbageCollect = ->
	files = fs.readdirSync __dirname+'/cache/'
	now = ~~(new Date().getTime()/1000)
	for file in files
		stats = fs.statSync __dirname+'/cache/'+file
		if ~~(stats.ctime.getTime()/1000)+config.ttl < now
			fs.unlinkSync __dirname+'/cache/'+file

renderFile = (imageName,res)->
	img = fs.readFileSync __dirname+'/cache/'+imageName
	garbageCollect()
	res.writeHead 200, {'Content-Type':'image/jpg'}
	res.end img, 'binary'
	return

server = http.createServer (req,res)->
	url = req.url[1..]
	if url is 'favicon.ico'
		res.writeHead 404
		res.end()
		return

	name = crypto.createHash('md5').update(url).digest('hex')
	if fs.existsSync(__dirname+'/cache/'+name+'.jpg')
		renderFile name+'.jpg',res
	else
		webshot url, __dirname+'/cache/'+name+'.jpg', options, (err)->
			if err
				console.log err
				res.writeHead 500
				res.end 'Error getting thumbnail'
			else
				renderFile name+'.jpg',res



server.listen config.port
console.log 'http://localhost:'+config.port+'/'