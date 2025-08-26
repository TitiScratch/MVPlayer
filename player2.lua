OLDTX=0
if not System.doesDirExist("ux0:/data/MyVideos/Bookmarks") then System.createDirectory("ux0:/data/MyVideos/Bookmarks") end

pad = 0
oldpad = 0
timestamp = 0
stampnote = 150
bmpos=nil
seeking = 0
playspeed = 1
videoended=1
disChange=150
-- disMode=2
-- outputpx=-0
-- outputpy=60
-- outputx=960
-- outputy=420

-- if System.doesFileExist("app0:/media/1") then disMode=1 outputx=960 outputy=544 outputpx=0 outputpy=0 end
-- if System.doesFileExist("app0:/media/2") then disMode=3 outputx=1260 outputy=544 outputpx=-150 outputpy=0 end

setTS=0
if vpkmode==1 then
if System.doesFileExist("ux0:/data/MyVideos/Bookmarks/"..Current_title_id.."-"..SelectedName.."-timestamp") then
position = io.open("ux0:/data/MyVideos/Bookmarks/"..Current_title_id.."-"..SelectedName.."-timestamp", "r")
videopos = position:read()
timestamp = tonumber(videopos)
end
end

if vpkmode==2 then
	if viewmode==1 then
	if System.doesFileExist("ux0:/data/MyVideos/Bookmarks/"..SelectedName.."-timestamp") then
	position = io.open("ux0:/data/MyVideos/Bookmarks/"..SelectedName.."-timestamp", "r")
	videopos = position:read()
	timestamp = tonumber(videopos)
	end
	end
	
	if viewmode==2 then
	if System.doesFileExist("ux0:/data/MyVideos/Bookmarks/"..SelectedShow.."-"..SelectedName.."-"..EPSelected.."-timestamp") then
	position = io.open("ux0:/data/MyVideos/Bookmarks/"..SelectedShow.."-"..SelectedName.."-"..EPSelected.."-timestamp", "r")
	videopos = position:read()
	timestamp = tonumber(videopos)
	end
	end
end


if timestamp>0 then
	Graphics.initBlend()
	Screen.clear()
	Graphics.drawImage(0,0, defaultbg)
	Graphics.fillRect(0,960,216,354,black)
	Graphics.fillRect(0,960,218,352,white2)
	Graphics.fillRect(0,960,220,350,black)
	Graphics.drawImage(300,230, iconCR)
	Graphics.drawImage(300,270, iconTR)
	Graphics.drawImage(300,310, iconCI)
	Graphics.debugPrint(360,233,"Resume from bookmarked position",white)
	Graphics.debugPrint(360,273,"Start from begining",white)
	Graphics.debugPrint(360,313,"Back to the menu",white)
	Graphics.termBlend()
	Screen.flip()
	resume = 0
	while resume == 0 do
	pad = Controls.read()
	if not Controls.check(pad, SCE_CTRL_CROSS) and Controls.check(oldpad, SCE_CTRL_CROSS) then
	resume = 1
	end
	if not Controls.check(pad, SCE_CTRL_TRIANGLE) and Controls.check(oldpad, SCE_CTRL_TRIANGLE) then
	timestamp = 0 resume = 1
	end
	if not Controls.check(pad, SCE_CTRL_CIRCLE) and Controls.check(oldpad, SCE_CTRL_CIRCLE) then
	
	System.launchEboot("app0:/eboot.bin")
	end
	oldpad=pad
	end
end

Video.resume()
if timestamp == 0 then Video.jumpToTime(0) end

 while true do
 
	System.resetTimer(SCREEN_DIMMING_TIMER)
	Graphics.initBlend()
	Screen.clear()
	frame = Video.getOutput()
	if playspeed == 1 then Video.setPlayMode(NORMAL_MODE) end
	if playspeed == 2 then Video.setPlayMode(FAST_FORWARD_2X_MODE) end
	if playspeed == 3 then Video.setPlayMode(FAST_FORWARD_4X_MODE) end
	if playspeed == 4 then Video.setPlayMode(FAST_FORWARD_8X_MODE) end
	if playspeed == 5 then Video.setPlayMode(FAST_FORWARD_16X_MODE) end
	if playspeed == 6 then Video.setPlayMode(FAST_FORWARD_32X_MODE) end
	
	if frame ~= 0 then
		if timestamp > 0 then Video.jumpToTime(timestamp) marked=timestamp timestamp = 0 end
		w = Graphics.getImageWidth(frame)
		h = Graphics.getImageHeight(frame)
		Graphics.setImageFilters(frame, FILTER_LINEAR, FILTER_LINEAR)
		Graphics.drawScaleImage(outputpx, outputpy, frame, outputx / w, outputy / h)
	end

	if not Video.isPlaying() then
	
	if videoended==1 then Video.close() frame = 0
	System.launchEboot("app0:/eboot.bin") end
	
	ms = Video.getTime()
	hh = ms / 1000
	hh = hh / 60
	hh = hh / 60
	hh = math.floor(hh)
	mm = ms - (3600000*hh)
	mm = mm / 1000
	mm = mm / 60
	mm = math.floor(mm)
	ss = ms - (3600000*hh)
	ss = ss - (60000*mm)
	ss = ss / 1000
	ss = math.floor(ss)
	
	Graphics.fillRect(0,960,196,374,black)
	Graphics.fillRect(0,960,198,372,white2)
	Graphics.fillRect(0,960,200,370,black)		
	Graphics.drawImage(340,210, iconCR)
	Graphics.drawImage(340,250, iconTR)
	Graphics.drawImage(340,290, iconSQ)
	Graphics.drawImage(340,330, iconCI)
	Graphics.debugPrint(400,213,"Resume playback",white)
	Graphics.debugPrint(400,253,"Start from begining",white)
	Graphics.debugPrint(400,293,"Save bookmark",white)
	Graphics.debugPrint(400,333,"Return to menu",white)
	Graphics.fillRect(0, 960, 0, 25, black)
	Graphics.debugPrint(0,2,"Paused - "..hh.."h "..mm.."m "..ss.."s",white)
	Graphics.debugPrint(740,2,"TOTAL - "..xhh.."h "..xmm.."m "..xss.."s",white)
	currentvideotime=(ms/fullvideotime)*100
	currentvideotime=currentvideotime*9.6
	Graphics.fillRect(0, 960, 35, 45, black)
	Graphics.fillRect(0, currentvideotime, 38, 42, white)
	Graphics.fillCircle(currentvideotime, 40, 8.0, black)
	Graphics.fillCircle(currentvideotime, 40, 7.0, white)
	if bmpos~=nil then Graphics.fillRect(bmpos-3, bmpos+3, 38, 42, green) end
	
end	

	if disChange<150 and Video.isPlaying() then Graphics.debugPrint(0,524,disModeMSG,white) disChange=disChange+1 end
	
	if seeking<250 and Video.isPlaying() then
		
	ms = Video.getTime()
	hh = ms / 1000
	hh = hh / 60
	hh = hh / 60
	hh = math.floor(hh)
	mm = ms - (3600000*hh)
	mm = mm / 1000
	mm = mm / 60
	mm = math.floor(mm)
	ss = ms - (3600000*hh)
	ss = ss - (60000*mm)
	ss = ss / 1000
	ss = math.floor(ss)
		
		Graphics.fillRect(0, 960, 0, 25, black)
		Graphics.debugPrint(0,2,"CURRENT - "..hh.."h "..mm.."m "..ss.."s",white)
		Graphics.debugPrint(740,2,"TOTAL - "..xhh.."h "..xmm.."m "..xss.."s",white)
		currentvideotime=(ms/fullvideotime)*100
		currentvideotime=currentvideotime*9.6
		Graphics.fillRect(0, 960, 35, 45, black)
		Graphics.fillRect(0, currentvideotime, 38, 42, white)
		Graphics.fillCircle(currentvideotime, 40, 8.0, black)
		Graphics.fillCircle(currentvideotime, 40, 7.0, white)
		if bmpos==nil then if currentvideotime<955 then bmpos=currentvideotime end end
		if bmpos~=nil then Graphics.fillRect(bmpos-3, bmpos+3, 38, 42, green) end
		seeking=seeking+1
	end

	if playspeed > 1 then
		Graphics.fillRect(0, 960, 0, 25, black)
		if playspeed == 2 then Graphics.debugPrint(0,0,"Playback speed : 2X",white) end
		if playspeed == 3 then Graphics.debugPrint(0,0,"Playback speed : 4X",white) end
		if playspeed == 4 then Graphics.debugPrint(0,0,"Playback speed : 8X",white) end
		if playspeed == 5 then Graphics.debugPrint(0,0,"Playback speed : 16X",white) end
		if playspeed == 6 then Graphics.debugPrint(0,0,"Playback speed : 32X",white) end
	end

	if stampnote<150 then
	Graphics.fillRect(0, 960, 0, 25, black)
	Graphics.debugPrint(340,0,"Time position bookmarked.!",white)
	stampnote=stampnote+1 end
	
	Graphics.termBlend()
	Screen.waitVblankStart()
	Screen.flip()

	LAx,LAy = Controls.readLeftAnalog()
	RAx,RAy = Controls.readRightAnalog()
	TX,TY = Controls.readTouch()
	pad = Controls.read()
	
	if TX ~= nil then
	if Video.isPlaying() then seeking=0 end 
	if TX >= 0 and TX <=960 and TY >= 0 and TY <=80 then 
			seektime=(fullvideotime/100)*(TX/9.6) 
			Video.jumpToTime(seektime) end
	end
	
	if Controls.check(pad, SCE_CTRL_CROSS) and not Controls.check(oldpad, SCE_CTRL_CROSS) then
			Video.setPlayMode(NORMAL_MODE)
		if Video.isPlaying() then
			videoended=0
			Video.pause()
		else
			Video.setPlayMode(NORMAL_MODE)
			videoended=1
			Video.resume()
		end
	end	
	
	if not Controls.check(pad, SCE_CTRL_RTRIGGER) and Controls.check(oldpad, SCE_CTRL_RTRIGGER) then
	playspeed = playspeed + 1
	if playspeed == 7 then playspeed = 1 end
	end
	
	if not Controls.check(pad, SCE_CTRL_LTRIGGER) and Controls.check(oldpad, SCE_CTRL_LTRIGGER) then
	playspeed = playspeed - 1
	if playspeed == 1 then playspeed = 1 end
	end

	if Controls.check(pad, SCE_CTRL_DOWN) and not Controls.check(oldpad, SCE_CTRL_DOWN) then
	seeking=0
		if Video.getTime() > 300000 then
			Video.jumpToTime(Video.getTime() - 300000)
		else
			Video.jumpToTime(0)
		end
	end
	
	if Controls.check(pad, SCE_CTRL_LEFT) and not Controls.check(oldpad, SCE_CTRL_LEFT) then
	seeking=0	
		if Video.getTime() > 60000 then
			Video.jumpToTime(Video.getTime() - 60000)
		else
			Video.jumpToTime(0)
		end
	end
	
	if Controls.check(pad, SCE_CTRL_RIGHT) and not Controls.check(oldpad, SCE_CTRL_RIGHT) then
	seeking=0	
		Video.jumpToTime(Video.getTime() + 60000)
	end
	
	if Controls.check(pad, SCE_CTRL_UP) and not Controls.check(oldpad, SCE_CTRL_UP) then
	seeking=0	
		Video.jumpToTime(Video.getTime() + 300000)
	end	
	
	if not Controls.check(pad, SCE_CTRL_TRIANGLE) and Controls.check(oldpad, SCE_CTRL_TRIANGLE) then
	timestamp = 0
	Video.jumpToTime(0)
	end
	
	if Controls.check(pad, SCE_CTRL_CIRCLE) and not Controls.check(oldpad, SCE_CTRL_CIRCLE) then
	if Video.isPlaying() then Video.pause() end
	Video.close()
	frame = 0
	System.launchEboot("app0:/eboot.bin")
	break
	end

	if not Controls.check(pad, SCE_CTRL_SELECT) and Controls.check(oldpad, SCE_CTRL_SELECT) then
	if marked~=nil then Video.jumpToTime(marked) end
	end

	if Controls.check(pad, SCE_CTRL_START) and not Controls.check(oldpad, SCE_CTRL_START) then
	disMode=disMode+1 if disMode==4 then disMode=1 end
	if disMode==1 then disModeMSG=("DEFAULT") outputx=960 outputy=544 outputpx=0 outputpy=0 end
	if disMode==2 then disModeMSG=("FIT TO SCREEN") outputx=960 outputy=420 outputpx=0 outputpy=60 end
	if disMode==3 then disModeMSG=("CROP") outputx=1260 outputy=544 outputpx=-150 outputpy=0 end
	disChange=0
	end

	if LAx >= 200 then outputx=outputx+5 end
	if LAx <= 100 then outputx=outputx-5 end
	if LAy >= 200 then outputy=outputy+5 end
	if LAy <= 100 then outputy=outputy-5 end
	if RAx >= 200 then outputpx=outputpx+5 end
	if RAx <= 100 then outputpx=outputpx-5 end
	if RAy >= 200 then outputpy=outputpy+5 end
	if RAy <= 100 then outputpy=outputpy-5 end

	if Controls.check(pad, SCE_CTRL_SQUARE) and not Controls.check(oldpad, SCE_CTRL_SQUARE) then
	bmpos=nil
	paused = Video.getTime()
		
		if vpkmode==1 then	
			if System.doesFileExist("ux0:/data/MyVideos/Bookmarks/"..Current_title_id.."-"..SelectedName.."-timestamp") then
			System.deleteFile("ux0:/data/MyVideos/Bookmarks/"..Current_title_id.."-"..SelectedName.."-timestamp") end
			position = io.open("ux0:/data/MyVideos/Bookmarks/"..Current_title_id.."-"..SelectedName.."-timestamp", "a+")
			position:write(""..paused.."")
			position:close()
			stampnote=1
		end
		
		if vpkmode==2 then
		
			if viewmode==1 then
			if System.doesFileExist("ux0:/data/MyVideos/Bookmarks/"..SelectedName.."-timestamp") then
			System.deleteFile("ux0:/data/MyVideos/Bookmarks/"..SelectedName.."-timestamp") end
			position = io.open("ux0:/data/MyVideos/Bookmarks/"..SelectedName.."-timestamp", "a+")
			position:write(""..paused.."")
			position:close()
			stampnote=1
			end
		
			if viewmode==2 then
			if System.doesFileExist("ux0:/data/MyVideos/Bookmarks/"..SelectedShow.."-"..SelectedName.."-"..EPSelected.."-timestamp") then
			System.deleteFile("ux0:/data/MyVideos/Bookmarks/"..SelectedShow.."-"..SelectedName.."-"..EPSelected.."-timestamp") end
			position = io.open("ux0:/data/MyVideos/Bookmarks/"..SelectedShow.."-"..SelectedName.."-"..EPSelected.."-timestamp", "a+")
			
			position:write(""..paused.."")
			position:close()
			stampnote=1
			end
		end		
	
	end
	
	oldpad = pad
end