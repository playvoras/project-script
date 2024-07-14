

function Main()
local t = gg.multiChoice({
'❥Player Menu', 
'❥Weapon Menu', 
'❥Exit'},
nil,'Kontra Script By Luckyday999😈🔥')
if t == nil then gg.sleep(1)
else
if t[1] then F1() end
if t[2] then F2() end
if t[3] then Exit() end
end
XGCK=-1
end

function F1()
local t = gg.multiChoice({
'❥Crouch Fly ON', 
'❥Crouch Fly OFF', 
'❥Fly Hack ON', 
'❥Fly Hack OFF', 
'❥Underground ON', 
'❥Underground OFF', 
'❥Teleport Walk ON', 
'❥Teleport Walk OFF', 
'❥Back'},
nil,'Player Menu')
if t == nil then gg.sleep(1)
else
if t[1] then B1() end
if t[2] then B2() end
if t[3] then B3() end
if t[4] then B4() end
if t[5] then B5() end
if t[6] then B6() end
if t[7] then B7() end
if t[8] then B8() end
if t[9] then Main() end
end
XGCK=-1
end


function B1()
gg.setRanges(gg.REGION_ANONYMOUS)
gg.searchNumber("1.5", gg.TYPE_FLOAT)
gg.getResults(3000)
gg.editAll("13", gg.TYPE_FLOAT)
gg.clearResults()
gg.toast("Crouch Fly Active")
end

function B2()
gg.setRanges(gg.REGION_ANONYMOUS)
gg.searchNumber("13", gg.TYPE_FLOAT)
gg.getResults(3000)
gg.editAll("1.5", gg.TYPE_FLOAT)
gg.clearResults()
gg.toast("Crouch Fly Disabled")
end

function B3()
gg.setRanges(gg.REGION_ANONYMOUS)
gg.searchNumber("2.0", gg.TYPE_FLOAT)
gg.getResults(3000)
gg.editAll("13", gg.TYPE_FLOAT)
gg.clearResults()
gg.toast("Fly Hack Active")
end

function B4()
gg.setRanges(gg.REGION_ANONYMOUS)
gg.searchNumber("13", gg.TYPE_FLOAT)
gg.getResults(3000)
gg.editAll("2.0", gg.TYPE_FLOAT)
gg.clearResults()
gg.toast("Fly Hack Disabled")
end

function B5()
gg.setRanges(gg.REGION_CODE_APP)
gg.searchNumber("0.1", gg.TYPE_FLOAT)
gg.getResults(1000)
gg.editAll("2.5", gg.TYPE_FLOAT)
gg.clearResults()
gg.toast("Underground Active")
end

function B6()
gg.setRanges(gg.REGION_CODE_APP)
gg.searchNumber("2.5", gg.TYPE_FLOAT)
gg.getResults(1000)
gg.editAll("0.1", gg.TYPE_FLOAT)
gg.clearResults()
gg.toast("Underground Disabled")
end

function B7()
gg.setRanges(gg.REGION_CODE_APP)
gg.searchNumber("0.9", gg.TYPE_FLOAT)
gg.getResults(1000)
gg.editAll("3", gg.TYPE_FLOAT)
gg.clearResults()
gg.toast("Teleport Walk Active")
end

function B8()
gg.setRanges(gg.REGION_CODE_APP)
gg.searchNumber("3", gg.TYPE_FLOAT)
gg.getResults(1000)
gg.editAll("0.9", gg.TYPE_FLOAT)
gg.clearResults()
gg.toast("Teleport Walk Disabled")
end

function F2()
local t = gg.multiChoice({
'❥Glock/Usp No Recoil', 
'❥Glock/Usp High Damage' , 
'❥Glock/Usp No Spread', 
'❥Glock/Usp High Armor Penetration', 
'❥Glock/Usp Instant Reload', 
'❥Back'},
nil,'Weapon Menu')
if t == nil then gg.sleep(1)
else
if t[1] then A1() end
if t[2] then A2() end
if t[3] then A3() end
if t[4] then A4() end
if t[5] then A5() end
if t[6] then Main() end
end
XGCK=-1
end


function A1()
gg.setRanges(gg.REGION_ANONYMOUS)
gg.searchNumber("0.6", gg.TYPE_FLOAT)
gg.getResults(1000)
gg.editAll("-1", gg.TYPE_FLOAT)
gg.clearResults()
gg.toast("Glock/Usp No Recoil Active")
end

function A2()
gg.setRanges(gg.REGION_ANONYMOUS)
gg.searchNumber("33", gg.TYPE_FLOAT)
gg.getResults(1000)
gg.editAll("1000", gg.TYPE_FLOAT)
gg.clearResults()
gg.sleep(100)
gg.setRanges(gg.REGION_ANONYMOUS)
gg.searchNumber("24", gg.TYPE_FLOAT)
gg.getResults(1000)
gg.editAll("1000", gg.TYPE_FLOAT)
gg.clearResults()
gg.toast("Glock/Usp High Damage")
end

function A3()
gg.setRanges(gg.REGION_ANONYMOUS)
gg.searchNumber("0.2", gg.TYPE_FLOAT)
gg.getResults(1000)
gg.editAll("-1", gg.TYPE_FLOAT)
gg.clearResults()
gg.sleep(100)
gg.setRanges(gg.REGION_ANONYMOUS)
gg.searchNumber("0.25", gg.TYPE_FLOAT)
gg.getResults(1000)
gg.editAll("-1", gg.TYPE_FLOAT)
gg.clearResults()
gg.toast("Glock/Usp No Spread")
end

function A4()
gg.setRanges(gg.REGION_ANONYMOUS)
gg.searchNumber("0.5", gg.TYPE_FLOAT)
gg.getResults(1000)
gg.editAll("1000", gg.TYPE_FLOAT)
gg.clearResults()
gg.sleep(100)
gg.setRanges(gg.REGION_ANONYMOUS)
gg.searchNumber("0.52", gg.TYPE_FLOAT)
gg.getResults(1000)
gg.editAll("1000", gg.TYPE_FLOAT)
gg.clearResults()
gg.toast("Glock/Usp High Armor Penetration")
end

function A5()
gg.setRanges(gg.REGION_ANONYMOUS)
gg.searchNumber("2.7", gg.TYPE_FLOAT)
gg.getResults(1000)
gg.editAll("0.1", gg.TYPE_FLOAT)
gg.clearResults()
gg.sleep(100)
gg.setRanges(gg.REGION_ANONYMOUS)
gg.searchNumber("2.2", gg.TYPE_FLOAT)
gg.getResults(1000)
gg.editAll("0.1", gg.TYPE_FLOAT)
gg.clearResults()
gg.toast("Glock/Usp Instant Reload")
end

function Exit()
print("Subscribe Luckyday999")
os.exit()
end

-------------END OF FUNCTIONS LIST OF MAIN MENU--------------------

cs = 'Oof'
while(true)do
if gg.isVisible(true) then
XGCK=1
gg.setVisible(false)
end
gg.clearResults()
if XGCK==1 then
Main()
end
end




