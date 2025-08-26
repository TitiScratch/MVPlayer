-- MVPlayer v1.4 by AntHJ
-- ======================
-- Fixed image loading issues to handle more movies
-- added (+5 movie) page skip on L and R Triggers
-- added movie count in top left corner


function deltmp()
if System.doesFileExist("ux0:/data/MyVideos/storage") then System.deleteFile("ux0:/data/MyVideos/storage") end
if System.doesFileExist("ux0:/data/MyVideos/last") then System.deleteFile("ux0:/data/MyVideos/last") end end
if Controls.check(Controls.read(), SCE_CTRL_LTRIGGER) then deltmp() end
if Controls.check(Controls.read(), SCE_CTRL_RTRIGGER) then deltmp() end
	
Video.init()
Sound.init()

white = Color.new(255,255,255)
white2 = Color.new(255,255,255,120)
black = Color.new(10,10,10,120)
yellow = Color.new(255,255,0)
green = Color.new(0,255,0)

if System.doesFileExist("app0:img/bg.png") then defaultbg = Graphics.loadImage("app0:img/bg.png") else
math.randomseed(os.time())
rndbg = math.random(5); math.random(5); math.random(5)
if rndbg == 1 then defaultbg = Graphics.loadImage("app0:img/bg1.png") end
if rndbg == 2 then defaultbg = Graphics.loadImage("app0:img/bg2.png") end
if rndbg == 3 then defaultbg = Graphics.loadImage("app0:img/bg3.png") end
if rndbg == 4 then defaultbg = Graphics.loadImage("app0:img/bg4.png") end
if rndbg == 5 then defaultbg = Graphics.loadImage("app0:img/bg5.png") end
end

DVDBox = Graphics.loadImage("app0:img/box.png")
loading = Graphics.loadImage("app0:img/loading.png")
iconCI = Graphics.loadImage("app0:img/PS-CI.png")
iconCR = Graphics.loadImage("app0:img/PS-CR.png")
iconSQ = Graphics.loadImage("app0:img/PS-SQ.png")
iconTR = Graphics.loadImage("app0:img/PS-TR.png")

bx1img = Graphics.loadImage("app0:img/box.png")
bx2img = Graphics.loadImage("app0:img/box.png")
bx3img = Graphics.loadImage("app0:img/box.png")
bx4img = Graphics.loadImage("app0:img/box.png")

bxshow=0
viewmode=1
lastview=1
EPSelected=0
selectedstorage=1
lastseason="0"
PLOTPAGE=1
old_i=0
scanned=0
skiptoi=0
ep_dir=0
bgmusic=0
playing=0
disMode=2
outputpx=0
outputpy=60
outputx=960
outputy=420
lastplayed=("xyz")
storagedevice=("ux0")
Current_title_id = System.getTitleID()

if System.doesDirExist("ux0:/data/MyVideos") then nofolder=0 else nofolder=1 System.createDirectory("ux0:/data/MyVideos") end
if System.doesFileExist("app0:/media/2") then disMode=2 outputx=960 outputy=420 outputpx=0 outputpy=60 end
if System.doesFileExist("app0:/media/1") then disMode=1 outputx=960 outputy=544 outputpx=0 outputpy=0 end
if System.doesFileExist("app0:/media/3") then disMode=3 outputx=1260 outputy=544 outputpx=-150 outputpy=0 end
		
function mvplayer()
vpkmode=2
chkmov=0
if System.doesDirExist("ux0:/data/MyVideos/Movies") then nofolder=0 else nofolder=1 System.createDirectory("ux0:/data/MyVideos/Movies") end
if System.doesFileExist("ux0:/data/MyVideos/storage") then 
dofile("ux0:/data/MyVideos/storage") end
movie_dir = ""..storagedevice..":data/MyVideos/Movies/"
shows_dir = ""..storagedevice..":data/MyVideos/Shows/"
if System.doesFileExist("ux0:/data/MyVideos/last") then
dofile("ux0:/data/MyVideos/last")
	lastplayed = lastplayed:gsub("%-","_")
System.deleteFile("ux0:/data/MyVideos/last")
end
if lastview == 2 then viewmode=2 cur_dir = shows_dir else viewmode = 1 old_i = 0 cur_dir = movie_dir end
scripts = System.listDirectory(cur_dir)
if scripts == nil then if viewmode == 1 then viewmode = 2 cur_dir = shows_dir else viewmode = 1 cur_dir = movie_dir end end
scripts = System.listDirectory(cur_dir)
if scripts == nil then deltmp() System.launchEboot("app0:/eboot.bin") end
table.sort(scripts, function(a,b) return a["name"] < b["name"] end)
end

function boxset()
vpkmode=1
dofile ("app0:media/list.lua")
cur_dir = "app0:media/"
if System.doesFileExist("uma0:app/"..CurrentID.."/media/list.lua") then dofile ("uma0:app/"..CurrentID.."/media/list.lua") end
if System.doesFileExist("grw0:app/"..CurrentID.."/media/list.lua") then dofile ("grw0:app/"..CurrentID.."/media/list.lua") end
if System.doesFileExist("xmc0:app/"..CurrentID.."/media/list.lua") then dofile ("xmc0:app/"..CurrentID.."/media/list.lua") end
if System.doesFileExist("imc0:app/"..CurrentID.."/media/list.lua") then dofile ("imc0:app/"..CurrentID.."/media/list.lua") end
for j, file	in pairs(scripts) do chkmov = (""..file.name.."") end
if System.doesFileExist("app0:media/theme.ogg") then bgmusic = 1 snd = Sound.open("app0:media/theme.ogg") end
if System.doesFileExist("app0:media/theme.ogg") then Sound.play(snd, NO_LOOP) end
if System.doesDirExist("app0:Shows") then bxshow = 1 viewmode = 2 shows_dir = ("app0:Shows/") cur_dir = shows_dir end
if System.doesFileExist("ux0:/data/MyVideos/last") then
dofile("ux0:/data/MyVideos/last") lastplayed = lastplayed:gsub("%-","_") System.deleteFile("ux0:/data/MyVideos/last") end
end

--		VPK MODE SELECTION		--
CurrentID = Current_title_id
if Current_title_id==("MVPLAYER0") then mvplayer() else boxset() end
--		VPK MODE SELECTION 		--

function storageselect()
if selectedstorage==6 then selectedstorage=1 end
if selectedstorage==1 then storagedevice=("ux0") end
if selectedstorage==2 then if System.doesDirExist("uma0:/data/MyVideos/Movies") or System.doesDirExist("uma0:/data/MyVideos/Shows") then storagedevice=("uma0") else selectedstorage=selectedstorage+1 end end
if selectedstorage==3 then if System.doesDirExist("grw0:/data/MyVideos/Movies") or System.doesDirExist("grw0:/data/MyVideos/Shows") then storagedevice=("grw0") else selectedstorage=selectedstorage+1 end end
if selectedstorage==4 then if System.doesDirExist("xmc0:/data/MyVideos/Movies") or System.doesDirExist("xmc0:/data/MyVideos/Shows") then storagedevice=("xmc0") else selectedstorage=selectedstorage+1 end end
if selectedstorage==5 then if System.doesDirExist("imc0:/data/MyVideos/Movies") or System.doesDirExist("imc0:/data/MyVideos/Shows") then storagedevice=("imc0") else selectedstorage=1 storagedevice=("ux0") end end
movie_dir = ""..storagedevice..":data/MyVideos/Movies/"
shows_dir = ""..storagedevice..":data/MyVideos/Shows/"
if System.doesFileExist("ux0:/data/MyVideos/storage") then System.deleteFile("ux0:/data/MyVideos/storage") end
storagedev = io.open("ux0:/data/MyVideos/storage", "a+")
storagedev:write("storagedevice = \""..storagedevice.."\"", "\n")
storagedev:write("selectedstorage = "..selectedstorage.."")
storagedev:close()

if System.doesDirExist(""..storagedevice..":/data/MyVideos/Movies") then cur_dir = movie_dir viewmode = 1 else
	if System.doesDirExist(""..storagedevice..":/data/MyVideos/Shows") then cur_dir = shows_dir viewmode = 2 end end
--if viewmode==1 then if System.doesDirExist(""..storagedevice..":/data/MyVideos/Movies") then cur_dir = movie_dir else viewmode=2 end end
--if viewmode==2 then if System.doesDirExist(""..storagedevice..":/data/MyVideos/Shows") then cur_dir = shows_dir else viewmode=1 end end
scripts = System.listDirectory(cur_dir)
if scripts == nil then if viewmode == 1 then viewmode = 2 cur_dir = shows_dir else viewmode = 1 cur_dir = movie_dir end end
scripts = System.listDirectory(cur_dir)
table.sort(scripts, function(a,b) return a["name"] < b["name"] end)

	Graphics.initBlend()
	Screen.clear()
	Graphics.drawImage(0,0, defaultbg)
	Graphics.fillRect(0, 960, 120, 160, Color.new(0,0,0,80))
	Graphics.debugPrint(400, 130, "Storage : "..storagedevice.."", white)
	Graphics.termBlend()
	Screen.flip()
	System.wait(2000000)
end

SelectedVideo=("ux0:")
oldpad=0
i = 1

function menu3()
AIRED="" TITLE="" PLOT1="" PLOT2="" PLOT3=""
bgexists=0
continue=0
showmenu=3
x=30

	Graphics.initBlend()
	Screen.clear()
	Graphics.drawImage(0,0, defaultbg)

	for j, file	in pairs(scripts) do
		ListedEP = (""..file.name.."")
		ListedEP = ListedEP:sub(1, #ListedEP - 4)
		if j >= i and x < 960 then

			if i == j then
				EPSelected=(""..ListedEP.."")
				SelectedEP=(""..cur_dir..""..ListedEP.."")
				if System.doesFileExist(""..SelectedEP..".png") then
				bgexists = 1 bgimg = Graphics.loadImage(""..SelectedEP..".png")
				Graphics.drawImage(0,0, bgimg)
				end
				if System.doesFileExist(""..SelectedEP..".info") then 
				dofile(""..SelectedEP..".info") end
				Graphics.fillRect(0, 960, 350, 380, Color.new(0,0,0,80))
				Graphics.fillRect(0, 960, 390, 550, Color.new(0,0,0,80))
				Graphics.debugPrint(x,355, ListedEP, green)
				Graphics.debugPrint(730, 400, "Aired :", yellow)		
				Graphics.debugPrint(810, 400, AIRED, white)
				Graphics.debugPrint(30, 400, TITLE, yellow)		
				Graphics.debugPrint(30, 440, PLOT1, white)		
				Graphics.debugPrint(30, 470, PLOT2, white)		
				Graphics.debugPrint(30, 500, PLOT3, white)
			else
				x = x + 150
				Graphics.debugPrint(x,355, ListedEP, white)
			end
		end
	end
	Graphics.fillRect(0, 960, 20, 60, Color.new(0,0,0,80))	
	Graphics.debugPrint(50, 30, SelectedShow, white)
	Graphics.termBlend()
	if old_i > 0 then i = old_i old_i = 0 i = i + 1 if i > #scripts then i = 1 end menu3() else Screen.flip() end
	if bgexists == 1 then Graphics.freeImage(bgimg) end
	
while continue == 0 do
	pad = Controls.read()
	
	if Controls.check(pad, SCE_CTRL_RIGHT) and not Controls.check(oldpad, SCE_CTRL_RIGHT) then
	i = i + 1
	if i > #scripts then i = 1 elseif i < 1 then i = #scripts end
	menu3()
	end
	
	if Controls.check(pad, SCE_CTRL_LEFT) and not Controls.check(oldpad, SCE_CTRL_LEFT) then
	i = i - 1
	if i > #scripts then i = 1 elseif i < 1 then i = #scripts end
	menu3()
	end

	if Controls.check(pad, SCE_CTRL_CIRCLE) and not Controls.check(oldpad, SCE_CTRL_CIRCLE) then
	cur_dir = SeasonList
	scripts = System.listDirectory(cur_dir)
	table.sort(scripts, function(a,b) return a["name"] < b["name"] end)
	i = 1 menu() end

	if Controls.check(pad, SCE_CTRL_CROSS) and not Controls.check(oldpad, SCE_CTRL_CROSS) then
	videofile2 = (""..SelectedEP..".mp4")
	videofile = videofile2
	if not System.doesFileExist(""..videofile.."") then videofile = string.gsub(videofile2,"app0:", "uma0:app/"..CurrentID.."/") end
	if not System.doesFileExist(""..videofile.."") then videofile = string.gsub(videofile2,"app0:", "imc0:app/"..CurrentID.."/") end
	if not System.doesFileExist(""..videofile.."") then videofile = string.gsub(videofile2,"app0:", "xmc0:app/"..CurrentID.."/") end
	if not System.doesFileExist(""..videofile.."") then videofile = string.gsub(videofile2,"app0:", "grw0:app/"..CurrentID.."/") end
	if snd ~= nil and Sound.isPlaying(snd) then Sound.close(snd) end dofile ("app0:/player.lua") menu3()
	end

	if Controls.check(pad, SCE_CTRL_START) and not Controls.check(oldpad, SCE_CTRL_START) then
		wait=1 oldpad = pad
		Graphics.initBlend()
		Screen.clear()
		Graphics.drawImage(0,0, defaultbg)
		if System.doesFileExist(""..SelectedEP..".png") then
			bgexists = 1 bgimg = Graphics.loadImage(""..SelectedEP..".png")
			Graphics.drawImage(0,0, bgimg) end
		Graphics.termBlend()
		Screen.flip()
		if bgexists == 1 then bgexists = 0 Graphics.freeImage(bgimg) end

		while wait==1 do
			pad = Controls.read()
				if Controls.check(pad, SCE_CTRL_START) and not Controls.check(oldpad, SCE_CTRL_START) then
				wait=0
				end

				if Controls.check(pad, SCE_CTRL_CIRCLE) and not Controls.check(oldpad, SCE_CTRL_CIRCLE) then
				wait=0
				end
					
			oldpad=pad
		end
	menu3()
	end
	oldpad=pad
end
end

function menu2()
showmenu=2
TAG="" PLOT1="" PLOT2="" PLOT3="" PLOT4="" PLOT5="" PLOT6="" PLOT7="" PLOT8="" PLOT9="" 
PLOT10="" PLOT11="" PLOT12="" PLOT13="" PLOT14="" REL="" SCORE="" CERT="" RUNTIME=""
dofile(""..SelectedVideo.."/movie.info")
	Graphics.initBlend()
	Screen.clear()
	if bgexists==1 then
		bgimg = Graphics.loadImage(""..SelectedVideo.."/background.png")
		Graphics.drawImage(0,0, bgimg) else Graphics.drawImage(0,0, defaultbg) end
	Graphics.fillRect(0, 960, 440, 544, Color.new(0,0,0,150))
	Graphics.fillRect(0, 960, 20, 60, Color.new(0,0,0,80))
	Graphics.drawScaleImage(18, 832, DVDBox, 1, -1,Color.new(100,100,100,100))
	Graphics.drawImage(18,92, DVDBox)
	Graphics.debugPrint(50, 30, SelectedName, white)
	if bxexists==1 then
		bximg = Graphics.loadImage(""..SelectedVideo.."/boxart.png")
		Graphics.drawImage(20,100, bximg) 
		Graphics.drawScaleImage(20, 820, bximg, 1, -1,Color.new(100,100,100,100)) end
	if validselection>0 then 
		Graphics.drawImage(50,477, iconCR)
		Graphics.debugPrint(100, 480, "Play", white) end
	Graphics.drawImage(50,507, iconCI)
	Graphics.debugPrint(100, 508, "Back", white)
	
	if vpkmode==2 then
		Graphics.drawImage(918,28, iconTR)
		if viewmode==1 then	Graphics.debugPrint(760, 30, "Movies", white)
			Graphics.debugPrint(840, 30, "Shows", white2)
			end
		if viewmode==2 then	Graphics.debugPrint(760, 30, "Movies", white2)
			Graphics.debugPrint(840, 30, "Shows", white)
			end	
		if System.doesFileExist(""..SelectedVideo.."/theme.ogg") then
			Graphics.drawImage(883,507, iconSQ)
			if snd==nil then Graphics.debugPrint(765, 508, "Play theme", white2) end end
		if snd~=nil then
			Graphics.drawImage(883,507, iconSQ) 
			Graphics.debugPrint(765, 508, "Stop theme", white2) end end
	if System.doesFileExist(""..SelectedVideo.."/theme.ogg") then
				Graphics.drawImage(883,507, iconSQ)
				if snd==nil then Graphics.debugPrint(765, 508, "Play theme", white2) end end
	if vpkmode==1 then
			if snd~=nil then
			Graphics.drawImage(883,507, iconSQ)
			if Sound.isPlaying(snd) then Graphics.debugPrint(735, 508, "theme playing", white2) else Graphics.debugPrint(735, 508, "theme paused", white) end end end
	
	Graphics.fillRect(280, 945, 100, 430, Color.new(0,0,0,150))
	Graphics.debugPrint(290,105,"Tagline", yellow)
	Graphics.debugPrint(290,125,TAG, white)
	Graphics.debugPrint(290,155,"Plot", yellow)
	if PLOTPAGE==1 then
	Graphics.debugPrint(290,175,PLOT1, white)
	Graphics.debugPrint(290,195,PLOT2, white)
	Graphics.debugPrint(290,215,PLOT3, white)
	Graphics.debugPrint(290,235,PLOT4, white)
	Graphics.debugPrint(290,255,PLOT5, white)
	Graphics.debugPrint(290,275,PLOT6, white)
	Graphics.debugPrint(290,295,PLOT7, white)
	end
	if PLOTPAGE==2 then
	Graphics.debugPrint(290,175,PLOT8, white)
	Graphics.debugPrint(290,195,PLOT9, white)
	Graphics.debugPrint(290,215,PLOT10, white)
	Graphics.debugPrint(290,235,PLOT11, white)
	Graphics.debugPrint(290,255,PLOT12, white)
	Graphics.debugPrint(290,275,PLOT13, white)
	Graphics.debugPrint(290,295,PLOT14, white)
	end
	if PLOT8~="" then	if PLOTPAGE==1 then Graphics.debugPrint(600,315,"v", yellow) end
						if PLOTPAGE==2 then Graphics.debugPrint(600,160,"^", yellow) end end
	Graphics.debugPrint(290,325,"Release Date", yellow)
	Graphics.debugPrint(290,345,REL, white)
	Graphics.debugPrint(845,325,"Rating", yellow)
	Graphics.debugPrint(845,345,SCORE, white)
	Graphics.debugPrint(290,380,"Certificate", yellow)
	Graphics.debugPrint(290,400,CERT, white)
	Graphics.debugPrint(845,380,"Runtime", yellow)	
	Graphics.debugPrint(845,400,RUNTIME, white)
	
	Graphics.termBlend()
	Screen.flip()
	if bgexists == 1 then Graphics.freeImage(bgimg) end
	if bxexists == 1 then Graphics.freeImage(bximg) end

end

function menu()
showmenu=1
validselection=0
bgexists = 0
bxexists = 0
local x = 300
local bxcount=1

	Graphics.initBlend()
	Screen.clear()
	Graphics.drawImage(0,0, defaultbg)
	
	for j, file	in pairs(scripts) do
				scanfile = (""..file.name.."")
				scanfile = scanfile:gsub("%-","_")
				if string.find(lastplayed, scanfile) then skiptoi=j end
				if searchfor ~= nil then AAA=scanfile:upper() BBB=searchfor:upper()
					if string.find(AAA,BBB) then skiptoi=j searchfor=nil end end
				
		if j >= i and x < 960 then

			if i == j then
				SelectedVideo = (""..cur_dir..""..file.name.."")
				SelectedName = (""..file.name.."")
				if string.match(SelectedName, ".mp4") then validselection=2 end
				SelectedVideoB = 0
				if System.doesFileExist("uma0:app/"..CurrentID.."/media/"..chkmov.."/video.mp4") then SelectedVideoB = string.gsub(SelectedVideo, "app0:","uma0:app/"..CurrentID.."/") end
				if System.doesFileExist("grw0:app/"..CurrentID.."/media/"..chkmov.."/video.mp4") then SelectedVideoB = string.gsub(SelectedVideo, "app0:","grw0:app/"..CurrentID.."/") end
				if System.doesFileExist("xmc0:app/"..CurrentID.."/media/"..chkmov.."/video.mp4") then SelectedVideoB = string.gsub(SelectedVideo, "app0:","xmc0:app/"..CurrentID.."/") end
				if System.doesFileExist("imc0:app/"..CurrentID.."/media/"..chkmov.."/video.mp4") then SelectedVideoB = string.gsub(SelectedVideo, "app0:","imc0:app/"..CurrentID.."/") end
				if System.doesFileExist(""..SelectedVideo.."/video.mp4") then validselection=1 end
				if System.doesFileExist(""..SelectedVideoB.."/video.mp4") then validselection=1 end
				if System.doesDirExist(""..SelectedVideo.."/Seasons") then SelectedShow=SelectedName validselection=3 end
				if System.doesDirExist(""..SelectedVideo.."/../Seasons") then validselection=4 end
				if System.doesFileExist(""..SelectedVideo.."/background.png") then
				bgexists = 1 bgimg = Graphics.loadImage(""..SelectedVideo.."/background.png")
				Graphics.drawImage(0,0, bgimg) end
				if System.doesFileExist(""..SelectedVideo.."/../background.png") then
				bgexists = 1 bgimg = Graphics.loadImage(""..SelectedVideo.."/../background.png")
				Graphics.drawImage(0,0, bgimg) end
				Graphics.fillRect(0, 960, 440, 544, Color.new(0,0,0,150))
				Graphics.fillRect(0, 960, 20, 60, Color.new(0,0,0,80))
				Graphics.drawScaleImage(18, 832, DVDBox, 1, -1,Color.new(100,100,100,100))
				Graphics.drawImage(18,92, DVDBox)
				Graphics.debugPrint(2, 0, ""..i.."/"..#scripts.."", white2)
				Graphics.debugPrint(50, 30, SelectedName, white)
				if System.doesFileExist(""..cur_dir..""..file.name.."/boxart.png") then
				bxexists = 1 bximg = Graphics.loadImage(""..cur_dir..""..file.name.."/boxart.png")
				Graphics.drawImage(20,100, bximg) 
				Graphics.drawScaleImage(20, 820, bximg, 1, -1,Color.new(100,100,100,100))
				end
				if System.doesFileExist(""..SelectedVideo.."/../"..SelectedName.."-poster.png") then
				bxexists = 1 bximg = Graphics.loadImage(""..SelectedVideo.."/../"..SelectedName.."-poster.png")
				Graphics.drawImage(20,100, bximg) 
				Graphics.drawScaleImage(20, 820, bximg, 1, -1,Color.new(100,100,100,100))
				end
			else
				Graphics.drawScaleImage(x-1, 680, DVDBox, 0.6, -0.6,Color.new(100,100,100,100))
				Graphics.drawScaleImage(x-1, 236, DVDBox, 0.6, 0.6)
				
				if System.doesFileExist(""..cur_dir..""..file.name.."/boxart.png") then
					if bxcount == 1 then Graphics.freeImage(bx1img) bx1img = nil
						bx1img = Graphics.loadImage(""..cur_dir..""..file.name.."/boxart.png")
						Graphics.drawScaleImage(300, 240, bx1img, 0.6, 0.6)
						Graphics.drawScaleImage(300, 672, bx1img, 0.6, -0.6,Color.new(100,100,100,100)) end
						
					if bxcount == 2 then Graphics.freeImage(bx2img) bx2img = nil
						bx2img = Graphics.loadImage(""..cur_dir..""..file.name.."/boxart.png")
						Graphics.drawScaleImage(470, 240, bx2img, 0.6, 0.6)
						Graphics.drawScaleImage(470, 672, bx2img, 0.6, -0.6,Color.new(100,100,100,100)) end
						
					if bxcount == 3 then Graphics.freeImage(bx3img) bx3img = nil
						bx3img = Graphics.loadImage(""..cur_dir..""..file.name.."/boxart.png")
						Graphics.drawScaleImage(640, 240, bx3img, 0.6, 0.6)
						Graphics.drawScaleImage(640, 672, bx3img, 0.6, -0.6,Color.new(100,100,100,100)) end
					
					if bxcount == 4 then Graphics.freeImage(bx4img) bx4img = nil
						bx4img = Graphics.loadImage(""..cur_dir..""..file.name.."/boxart.png")
						Graphics.drawScaleImage(810, 240, bx4img, 0.6, 0.6)
						Graphics.drawScaleImage(810, 672, bx4img, 0.6, -0.6,Color.new(100,100,100,100)) end
				else
				Graphics.fillRect(x,x+147,240, 600, Color.new(40,40,40,80))
				end
				if System.doesFileExist(""..SelectedVideo.."/../"..file.name.."-poster.png") then
				bximg = Graphics.loadImage(""..SelectedVideo.."/../"..file.name.."-poster.png")
				Graphics.drawScaleImage(x, 240, bximg, 0.6, 0.6)
				Graphics.drawScaleImage(x, 672, bximg, 0.6, -0.6,Color.new(100,100,100,100)) 
				else
				Graphics.fillRect(x,x+147,240, 600, Color.new(40,40,40,80))
				end
				x = x + 170
				bxcount = bxcount + 1
			end
		end
	end
	
	if validselection>0 then 
		Graphics.drawImage(50,477, iconCR)
		if validselection<3 then Graphics.debugPrint(100, 480, "Play", white) else
								 Graphics.debugPrint(100, 480, "Open", white) end end
	if System.doesFileExist(""..SelectedVideo.."/movie.info") then
		Graphics.drawImage(50,507, iconCI)
		Graphics.debugPrint(100, 508, "Movie Information", white) end
	if vpkmode==2 then 
		Graphics.drawImage(918,28, iconTR)
		if viewmode==1 then	Graphics.debugPrint(760, 30, "Movies", white)
			Graphics.debugPrint(840, 30, "Shows", white2)
			end
		if viewmode==2 then	Graphics.debugPrint(760, 30, "Movies", white2)
			Graphics.debugPrint(840, 30, "Shows", white)
			end
			
		if System.doesFileExist(""..SelectedVideo.."/theme.ogg")  then
			Graphics.drawImage(883,507, iconSQ)
			if snd==nil then Graphics.debugPrint(765, 508, "Play theme", white2) end end
			
		if System.doesFileExist(""..SelectedVideo.."/../theme.ogg")  then
			Graphics.drawImage(883,507, iconSQ)
			if snd==nil then Graphics.debugPrint(765, 508, "Play theme", white2) end end
			
		if snd~=nil then
			Graphics.drawImage(883,507, iconSQ) 
			Graphics.debugPrint(765, 508, "Stop theme", white2) end end
		if System.doesFileExist(""..SelectedVideo.."/theme.ogg") then
			Graphics.drawImage(883,507, iconSQ)
			if snd==nil then Graphics.debugPrint(765, 508, "Play theme", white2) end end		
	if vpkmode==1 then
			if snd~=nil then
			Graphics.drawImage(883,507, iconSQ)
			if Sound.isPlaying(snd) then Graphics.debugPrint(735, 508, "theme playing", white2) else Graphics.debugPrint(735, 508, "theme paused", white) end end end

	if viewmode==2 then 
			Graphics.drawImage(50,507, iconCI)
			if System.doesFileExist(""..SelectedVideo.."/movie.info") then ok=ok else Graphics.debugPrint(100, 508, "Back", white) end end
	Graphics.termBlend()
	if skiptoi == 0 then if scanned == 0 then Screen.flip() end end
	if bgexists == 1 then Graphics.freeImage(bgimg) end
	if bxexists == 1 then Graphics.freeImage(bximg) end
	if skiptoi>0 then i=skiptoi skiptoi=0 if AAA == nil then scanned = 1 else scanned = 2 end lastplayed=("xyz")
		if viewmode==2 then if scanned == 1 then cur_dir = ""..SelectedVideo.."/Seasons"
							SeasonList = ""..SelectedVideo.."/Seasons"
							scripts = System.listDirectory(cur_dir)
							if scripts==nil then System.launchEboot("app0:/eboot.bin") end
							table.sort(scripts, function(a,b) return a["name"] < b["name"] end)
							i = 1 end end
		menu() end
	if scanned==1 then scanned = 0 if viewmode == 2 then ep_list() else menu() end end
	if scanned==2 then scanned = 0 menu() end
	
while true do

	pad = Controls.read()
	TX,TY = Controls.readTouch()

if showmenu==1 then 	
if TX ~= nil then
	if TX >= 18 and TX <=267  and TY >= 98 and TY <=462 then pad = SCE_CTRL_CROSS end
	if TX >= 298 and TX <=449  and TY >= 238 and TY <=458 then i = i + 1 end
	if TX >= 468 and TX <=619  and TY >= 238 and TY <=458 then i = i + 2 end
	if TX >= 638 and TX <=789  and TY >= 238 and TY <=458 then i = i + 3 end
	if TX >= 808 and TX <=959  and TY >= 238 and TY <=458 then i = i + 4 end
	if i > #scripts then i = 1 end
	menu() end
end

	if Controls.check(pad, SCE_CTRL_START) and not Controls.check(oldpad, SCE_CTRL_START) then
		wait=1 oldpad = pad
		Graphics.initBlend()
		Screen.clear()
		Graphics.drawImage(0,0, defaultbg)
		if System.doesFileExist(""..SelectedVideo.."/background.png") then
			bgexists = 1 bgimg = Graphics.loadImage(""..SelectedVideo.."/background.png")
			Graphics.drawImage(0,0, bgimg) end
		if System.doesFileExist(""..SelectedVideo.."/../background.png") then
			bgexists = 1 bgimg = Graphics.loadImage(""..SelectedVideo.."/../background.png")
			Graphics.drawImage(0,0, bgimg) end
		Graphics.termBlend()
		Screen.flip()
		if bgexists == 1 then bgexists = 0 Graphics.freeImage(bgimg) end
		
		while wait==1 do
			pad = Controls.read()
				if Controls.check(pad, SCE_CTRL_START) and not Controls.check(oldpad, SCE_CTRL_START) then
				wait=0
				end

				if Controls.check(pad, SCE_CTRL_CIRCLE) and not Controls.check(oldpad, SCE_CTRL_CIRCLE) then
				wait=0
				end
					
			oldpad=pad
		end
		
		if showmenu==1 then menu() else menu2() end
	end

	if Controls.check(pad, SCE_CTRL_UP) and not Controls.check(oldpad, SCE_CTRL_UP) then
	if showmenu~=2 then
	keyb=0
	Keyboard.clear()
	Keyboard.start("Enter search name", "", 512, TYPE_DEFAULT, MODE_TEXT, OPT_NO_AUTOCAP)
	while keyb < 2 do
	Graphics.initBlend()
	Screen.clear()
	keyb = Keyboard.getState()
	Graphics.termBlend()
	Screen.flip()
	end
	searchfor = Keyboard.getInput()
	menu()
	else if PLOT8~="" then if PLOTPAGE==1 then PLOTPAGE=2 else PLOTPAGE=1 end menu2() end end end
	
	if Controls.check(pad, SCE_CTRL_DOWN) and not Controls.check(oldpad, SCE_CTRL_DOWN) then
	if showmenu==2 then
	if PLOT8~="" then if PLOTPAGE==1 then PLOTPAGE=2 else PLOTPAGE=1 end menu2() end end end

	if Controls.check(pad, SCE_CTRL_RIGHT) and not Controls.check(oldpad, SCE_CTRL_RIGHT) then
	if showmenu==1 then 
	oldpad = pad i = i + 1
	if i > #scripts then i = 1 elseif i < 1 then i = #scripts end
	menu() end end

	if Controls.check(pad, SCE_CTRL_LEFT) and not Controls.check(oldpad, SCE_CTRL_LEFT) then
	if showmenu==1 then 
	oldpad = pad i = i - 1
	if i > #scripts then i = 1 elseif i < 1 then i = #scripts end
	menu() end end

	if Controls.check(pad, SCE_CTRL_RTRIGGER) and not Controls.check(oldpad, SCE_CTRL_RTRIGGER) then
	if showmenu==1 then 
	oldpad = pad i = i + 5
	if i > #scripts then i = #scripts elseif i < 1 then i = #scripts end
	menu() end end

	if Controls.check(pad, SCE_CTRL_LTRIGGER) and not Controls.check(oldpad, SCE_CTRL_LTRIGGER) then
	if showmenu==1 then 
	oldpad = pad i = i - 5
	if i > #scripts then i = 1 elseif i < 1 then i = 1 end
	menu() end end
 
	if Controls.check(pad, SCE_CTRL_TRIANGLE) and not Controls.check(oldpad, SCE_CTRL_TRIANGLE) then
if vpkmode==2 then	
	oldpad = pad
	if viewmode==1 	then if System.doesDirExist(""..shows_dir.."") then viewmode=2 cur_dir = shows_dir end
					else if System.doesDirExist(""..movie_dir.."") then viewmode=1 cur_dir = movie_dir end
	end			
	scripts = System.listDirectory(cur_dir) 
	table.sort(scripts, function(a,b) return a["name"] < b["name"] end) i = 1 menu()
	end
end

	if Controls.check(pad, SCE_CTRL_SELECT) and not Controls.check(oldpad, SCE_CTRL_SELECT) then
if vpkmode==2 then
	oldpad = pad selectedstorage = selectedstorage+1 storageselect() i = 1 menu()
	end
end

	if Controls.check(pad, SCE_CTRL_CIRCLE) and not Controls.check(oldpad, SCE_CTRL_CIRCLE) then
	PLOTPAGE=1
	oldpad = pad
	if showmenu==2 then menu() end
	if showmenu==1 then if System.doesFileExist(""..SelectedVideo.."/movie.info") then menu2() end end
	if viewmode==2 then if showmenu==1 then cur_dir = shows_dir end
						if showmenu==3 then cur_dir = ""..cur_dir"/../" end
	if System.doesFileExist(""..SelectedVideo.."/movie.info") then ok=ok else
	scripts = System.listDirectory(cur_dir)	table.sort(scripts, function(a,b) return a["name"] < b["name"] end) 
	if i > #scripts then i = 1 end menu() end end
	end
	
	if Controls.check(pad, SCE_CTRL_SQUARE) and not Controls.check(oldpad, SCE_CTRL_SQUARE) then
	oldpad = pad
			if playing == i then if snd~=nil then if Sound.isPlaying(snd) then Sound.pause(snd) else Sound.resume(snd) end end end
			
		--	if bgmusic==1 then if snd~=nil then if Sound.isPlaying(snd) then Sound.pause(snd) else Sound.resume(snd) end end else
			if playing ~= i then
			if snd~=nil then if System.doesFileExist(""..SelectedVideo.."/theme.ogg") then Sound.close(snd) snd=nil else if Sound.isPlaying(snd) then Sound.pause(snd) else Sound.resume(snd) end end end
			--if snd~=nil then if System.doesFileExist(""..SelectedVideo.."/../theme.ogg") then Sound.close(snd) snd=nil end end
			if snd==nil then if System.doesFileExist(""..SelectedVideo.."/theme.ogg") then snd = Sound.open(""..SelectedVideo.."/theme.ogg") playing = i Sound.play(snd, NO_LOOP) end end
			if snd==nil then if System.doesFileExist(""..SelectedVideo.."/../theme.ogg") then snd = Sound.open(""..SelectedVideo.."/../theme.ogg") playing = i  Sound.play(snd, NO_LOOP) end end
			if snd==0 then snd=nil end end
		
	if showmenu==1 then menu() else menu2() end
	
	end

	if not Controls.check(pad, SCE_CTRL_CROSS) and Controls.check(oldpad, SCE_CTRL_CROSS) then
		if System.doesFileExist(""..SelectedVideo.."/2") then disMode=2 outputx=960 outputy=420 outputpx=0 outputpy=60 end
		if System.doesFileExist(""..SelectedVideo.."/1") then disMode=1 outputx=960 outputy=544 outputpx=0 outputpy=0 end
		if System.doesFileExist(""..SelectedVideo.."/3") then disMode=3 outputx=1260 outputy=544 outputpx=-150 outputpy=0 end
	oldpad = pad
	if validselection==1 then
		if snd~=nil then if Sound.isPlaying(snd) then Sound.close(snd) end end
		if SelectedVideoB==0 then videofile = (""..SelectedVideo.."/video.mp4") dofile ("app0:/player.lua") menu() end 
		if SelectedVideoB~=0 then videofile = (""..SelectedVideoB.."/video.mp4") dofile ("app0:/player.lua") menu() end
	end
	
	if validselection==2 then
		if snd~=nil then if Sound.isPlaying(snd) then Sound.close(snd) end end
		if string.match(SelectedName, ".mp4") then videofile = (""..SelectedVideo.."") dofile ("app0:/player.lua") menu() end end		
	if validselection==3 then
		cur_dir = ""..SelectedVideo.."/Seasons"
		SeasonList = ""..SelectedVideo.."/Seasons"
		scripts = System.listDirectory(cur_dir)
		table.sort(scripts, function(a,b) return a["name"] < b["name"] end)
		i = 1 menu() end
		
	if validselection==4 then
	ep_list()
	end
end

	oldpad=pad
end

end

function ep_list()

	i=1
	ii=1
	if lastseason~="0" then ep_dir = lastseason else ep_dir = ""..SelectedVideo.."/../Seasons/"..SelectedName.."" end
	ep_table = System.listDirectory(ep_dir)
	if bxshow==0 then listfile = io.open (""..SelectedVideo.."/../list.lua" , "w") end
	if bxshow==1 then listfile = io.open ("ux0:/data/MyVideos/tmp" , "w") end
	listfile:write("scripts = {\n")
	for j, file	in pairs(ep_table) do
	ep_log = ("{[\"j\"] = \""..ii.."\", [\"name\"] = \""..file.name.."\"},\n")
	if string.match(ep_table[i].name, ".png") then listfile:write(ep_log) ii = ii + 1 end
	i=i+1
	end
	listfile:write("}")
	io.close(listfile)
	if bxshow==0 then dofile (""..SelectedVideo.."/../list.lua") end
	if bxshow==1 then dofile ("ux0:/data/MyVideos/tmp") end
	table.sort(scripts, function(a,b) return a["name"] < b["name"] end)
	if lastview==1 then if System.doesFileExist("ux0:/data/MyVideos/last") then System.deleteFile("ux0:/data/MyVideos/last") end end
	if lastname~=nil then cur_dir = ""..cur_dir.."/"..lastname.."/" else cur_dir = ""..cur_dir.."/"..SelectedName.."/" end
	i=1
	menu3()
	
end

menu()