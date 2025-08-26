if System.doesFileExist("ux0:/data/MyVideos/last") then System.deleteFile("ux0:/data/MyVideos/last") end
played = io.open("ux0:/data/MyVideos/last", "a+")
played:write("lastview = "..viewmode.."", "\n")
played:write("lastplayed = \""..videofile.."\"", "\n")
played:write("lastseason = \""..ep_dir.."\"", "\n")
lastname = videofile:sub(-23, #videofile - 14)
played:write("lastname = \""..lastname.."\"", "\n")
played:write("old_i = "..i.."")
played:close()

if viewmode==2 then if System.doesFileExist(""..SelectedVideo.."/movie.info") then
if System.doesFileExist("ux0:/data/MyVideos/last") then System.deleteFile("ux0:/data/MyVideos/last") end end end

Video.open(videofile, false)
Video.jumpToTime(0)
findtotal=0
spintotal=0
i=1
xhh=0
xmm=0
xss=0
ms=0
 
while findtotal<1000 do
Video.pause()

	Graphics.initBlend()
	Screen.clear()

--findtotalA = (""..xhh..""..xmm..""..xss.."")
if findtotal ~= 999 then 
findtotalA=(""..ms.."")

Video.jumpToTime(Video.getTime() + 3600000) -- 1h
Video.jumpToTime(Video.getTime() + 1800000)	-- 30m
Video.jumpToTime(Video.getTime() + 1200000)	-- 20m
Video.jumpToTime(Video.getTime() + 600000)	-- 10m
Video.jumpToTime(Video.getTime() + 300000)	-- 5m
Video.jumpToTime(Video.getTime() + 120000)	-- 2m
Video.jumpToTime(Video.getTime() + 60000)	-- 1m
Video.jumpToTime(Video.getTime() + 30000)	-- 30s
Video.jumpToTime(Video.getTime() + 15000)	-- 15s
Video.jumpToTime(Video.getTime() + 10000)	-- 10s
Video.jumpToTime(Video.getTime() + 5000)	-- 5s
Video.jumpToTime(Video.getTime() + 1000)	-- 1s

	ms = Video.getTime()
	xhh = ms / 1000
	xhh = xhh / 60
	xhh = xhh / 60
	xhh = math.floor(xhh)
	xmm = ms - (3600000*xhh)
	xmm = xmm / 1000
	xmm = xmm / 60
	xmm = math.floor(xmm)
	xss = ms - (3600000*xhh)
	xss = xss - (60000*xmm)
	xss = xss / 1000
	xss = math.floor(xss)

--findtotalB = (""..xhh..""..xmm..""..xss.."")
findtotalB=(""..ms.."")
end

	spin=spintotal/10
	Graphics.drawRotateImage(465, 272, loading, spin)
	Graphics.debugPrint(390,330,"Loading video . . .",white)
	Graphics.termBlend()
	Screen.waitVblankStart()
	Screen.flip()
	System.wait(30000)
spintotal=spintotal+1	
findtotalA = tonumber(findtotalA)
findtotalB = tonumber(findtotalB)
--findtotalB=findtotalB-100
if findtotal~=999 then if findtotalA>0 then if findtotalA>=findtotalB then findtotal=999 Video.jumpToTime(Video.getTime() - ms) end end else findtotal=1001 end

end
fullvideotime=ms
Video.jumpToTime(0)
dofile ("app0:/player2.lua")