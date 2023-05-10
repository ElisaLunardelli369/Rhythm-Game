
-- LIVELLO2
-- Il secondo livello ricalca il primo, ma ha degli elementi aggiuntivi per renderlo più difficile:
-- il numero di cerchi generati è maggiore 
-- un punteggio minimo è più alto.

local composer = require( "composer" )  
local widget =  require("widget")       
local scene = composer.newScene()       


local bg1 = display.newGroup()          
local fg1 = display.newGroup()          
local gruppoCC = {}                     


local sfondo 
local start

local tastoMenu
local cerchio1
local cerchio2
local cerchio3  -- cerchio obiettivo aggiuntivo

local options 

local timerCerchi

local c1
local c2
local c3

local score 
local punteggio2
local punteggioMinimo2
local vittoria
local sconfitta

local musica        
local musica_play

local musicaLivello2
local musicaLivello2_play
local musicaLivello1




----------------------------------------  
-- CREATE ------------------------------ 
---------------------------------------- 

function scene:create( event )  
  local sceneGroup = self.view    

  score = 0
  punteggio2 = display.newText ({text="PUNTEGGIO = "..score , font= "Calibri", fontSize= "15"})
  punteggioMinimo2 = display.newText ({text="Punteggio minimo 40" , font= "Calibri", fontSize= "12"})-- scritta che indica il punteggio minimo da raggiungere
  sfondo = display.newImageRect(bg1,"img/bgInformatica.png",480,320)      -- sfondo 
  start = display.newImageRect(fg1,"img/start.png",100,100)               -- bottone start
  tastoMenu = display.newImageRect (fg1,"img/menu.png",90,32)             -- bottone per ritornare alla scena menu
  cerchio1 = display.newImageRect(fg1,"img/cerchioBianco.png",54,54)      -- cerchio obiettivo 1
  cerchio2 = display.newImageRect(fg1,"img/cerchioBianco.png",54,54)      -- cerchio obiettivo 2 
  cerchio3 = display.newImageRect(fg1,"img/cerchioBianco.png",54,54)      -- cerchio obiettivo 3 
  
  vittoria = display.newText ({text=" Hai vinto! " , font= "Calibri", fontSize= "70"})
  sconfitta = display.newText ({text=" Hai perso! " , font= "Calibri", fontSize= "70"})
  options = {effect = "zoomInOutFade",time = 1600,}  

  -- aggiungo gli elementi creati al gruppo della scena chiamato sceneGroup
  sceneGroup:insert(bg1) 
  sceneGroup:insert(fg1)
  sceneGroup:insert(punteggio2)
  sceneGroup:insert(punteggioMinimo2)
  sceneGroup:insert(vittoria)
  sceneGroup:insert(sconfitta)
  
   

  musicaLivello2 = audio.loadSound ("m/musicaLivello2.mp3")   -- carico la musica del livello 2 
  
end


-- FUNZIONE CHE MI PERMETTE DI TORNARE AL MENU
local function tornaMenu(event)  
  sconfitta.isVisible = true
  vittoria.isVisible = true 

  musica_play = audio.fade({channel=1,time=2000,volume=1.0})   
  
  if vittoria.isVisible then
     display.remove(vittoria)
  else 
  
  end 
  
  if sconfitta.isVisible then
     display.remove(sconfitta)
  else
  
  end
  
  local canale_attivo = audio.isChannelPlaying(2)               
     if canale_attivo then
     audio.stop(2)
  end
  
  print(#gruppoCC)
for i = #gruppoCC,1,-1 do
    table.remove(gruppoCC,i)
end
  print(#gruppoCC)
  
  composer.removeScene("menu")         
  composer.removeScene("livello1")
  composer.removeScene("livello2")
  composer.removeScene("titolo")
 
  composer.gotoScene("menu",options) 
end

-- FUNZIONE PER GENERARE I CERCHI IN MANIERA AUTOMATICA 

local function creaCC(event)
 
if math.random(3) == 1 then 

  c1= display.newCircle(fg1,240,160,16)                                 
  c1:setFillColor(1,1,1)                                                 
  c1.alpha = 0
  
  
  local movimento_c1 = transition.to (c1,{ time = 2000,x = -100, y= 340, xScale = 2, yScale = 2, alpha = 1})-- spostamento verso cerchio 1
  
  
elseif math.random(3) == 2  then

  -- cerchio aggiuntivo
  c2= display.newCircle(fg1,240,100,16)                                 
  c2:setFillColor(1,1,1)                                                  
  c2.alpha = 0
  
  
  local movimento_c2 = transition.to (c2,{ time = 2000,x = 240 , y = 380, xScale = 2, yScale = 2,alpha = 1})-- spostamento verso cerchio 2
  
else
  
  c3= display.newCircle(fg1,240,160,16)                                 
  c3:setFillColor(1,1,1)                                                 
  c3.alpha = 0
  
  
  local movimento_c3 = transition.to (c3,{ time = 2000,x= 580 , y= 340, xScale = 2, yScale = 2, alpha = 1})-- spostamento verso cerchio 3
  
end
 table.insert(gruppoCC,c1)	
 table.insert(gruppoCC,c2)
 table.insert(gruppoCC,c3)
end
 


---- FUNZIONE PER IL CONTROLLO DELL'INTERAZIONE CON I CERCHI c1 
local function controlloTap1 (event)

if math.abs( event.x - c1.x) <= 20 then

  c1:setFillColor(0,0,0)
  score = score + 1
  punteggio2.text = "PUNTEGGIO = "..score
end
 return score
end

---- FUNZIONE PER IL CONTROLLO DELL'INTERAZIONE CON I CERCHI c2
local function controlloTap2 (event)

if math.abs( event.y - c2.y) <= 20 then  -- questa funzione differisce leggermente dalle altre del suo tipo: avendo il cerchio2 la stessa 
                                         -- coordinata x del c2, se avessimo utilizzato event.x e c2.x come parametri di controllo ogni interazione con il bottone 
  c2:setFillColor(0,0,0)                 -- sarebbe risultata true e si sarebbero aggiunti punti non meritati.
  score = score + 1
  punteggio2.text = "PUNTEGGIO = "..score
end
 return score
end

---- FUNZIONE PER IL CONTROLLO DELL'INTERAZIONE CON I CERCHI c3 
local function controlloTap3 (event)

if math.abs( event.x - c3.x) <= 20 then

  c3:setFillColor(0,0,0)
  score = score + 1
  punteggio2.text = "PUNTEGGIO = "..score
end
 return score
end



-- FUNZIONE DI FINE GIOCO 
local function fine ()
cerchio1:removeEventListener ("touch", controlloTap1 )
cerchio2:removeEventListener ("touch", controlloTap2 )
cerchio3:removeEventListener ("touch", controlloTap3 )
display.remove(cerchio1)
display.remove(cerchio2)
display.remove(cerchio3)
cerchio1=nil
cerchio2=nil
cerchio3=nil

if (score >= 40) then    -- il punteggio minimo di questo livello è maggiore rispetto al primo per aggiungere una difficoltà maggiore al livello
   
  vittoria.isVisible = true
  
else 
   
  sconfitta.isVisible = true

end
end

 



-- FUNZIONE CHE PERMETTE DI FAR COMINCIARE IL GIOCO
local function inizioGioco (event)   
  score = 0
  display.remove(start)                                          
  
  c1= display.newCircle(fg1,240,185,16)
  c1.alpha = 0
  c2= display.newCircle(fg1,240,185,16)
  c2.alpha = 0
  c3= display.newCircle(fg1,240,185,16)
  c3.alpha = 0
  
  timerCerchi = timer.performWithDelay (500, creaCC ,50)         
 
  musicaLivello2_play = audio.play(musicaLivello2, {onComplete = fine})
  
  cerchio1:addEventListener ("touch", controlloTap1 )
  cerchio2:addEventListener ("touch", controlloTap2 )
  cerchio3:addEventListener ("touch", controlloTap3 )           
end


---------------------------------------- 
-------- SHOW -------------------------- 
----------------------------------------

function scene:show( event )
 
  local sceneGroup = self.view
  local phase = event.phase
 
  if ( phase == "will" ) then        
  sfondo.x = display.contentCenterX   -- posiziono sfondo    
  sfondo.y = display.contentCenterY

  start.x = 240             -- posiziono tasto start
  start.y = 120

  tastoMenu = widget.newButton{                   
	defaultFile = "img/menu.png",                
	overFile = "img/menu_mouse.png",             
    width = 90, height = 32,                     
	onRelease = tornaMenu
	}
  tastoMenu.x = 330         -- posiziono immagine per il ritorno al menu  
  tastoMenu.y = 50

  cerchio1.x = 70           -- posiziono cerchio obiettivo 1
  cerchio1.y = 250
  cerchio1.type = "cerchio"                               

  cerchio2.x = 240          -- posiziono cerchio obiettivo 2   
  cerchio2.y = 230
  
  cerchio3.x = 410          -- posiziono cerchio obiettivo 3  
  cerchio3.y = 250
  
  punteggio2.x = 150        -- posizione del punteggio      
  punteggio2.y = 50
  
  punteggioMinimo2.x = 240  -- posizione punteggio minimo
  punteggioMinimo2.y = 280

  vittoria.x = 240          -- posiziono la scritta vittoria
  vittoria.y = 160
  vittoria.isVisible = false
  
  sconfitta.x = 240         -- posiziono la scritta sconfitta
  sconfitta.y = 160
  sconfitta.isVisible = false
  
 elseif ( phase == "did" ) then
 
  start:addEventListener("tap",inizioGioco) 	
  tastoMenu:addEventListener("tap",tornaMenu)
  musica_play = audio.fade({channel=1,time=2000,volume=0.0})  
  
  end
end

--------------------------------------------------------
-------- HIDE ------------------------------------------ 
--------------------------------------------------------
function scene:hide( event )
 
  local sceneGroup = self.view
  local phase = event.phase
 
  if ( phase == "will" ) then

 timerCerchi = timer.pause()
                               
  elseif ( phase == "did" ) then
      
   end
end

---------------------------------------------------------
-------- DESTROY ----------------------------------------
---------------------------------------------------------
function scene:destroy( event )
 
  local sceneGroup = self.view
  if tastoMenu then 
     tastoMenu:removeSelf()
	 tastoMenu = nill
  end
  
end
 
 
-- ----------------------------------------------------------- 
-- AGGIUNTA DEGLI ASCOLTATORI DELLA SCENA: -------------------
-- -----------------------------------------------------------

scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy",scene )

-- -----------------------------------------------------------
 
return scene


