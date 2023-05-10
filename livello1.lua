
--LIVELLO1

local composer = require( "composer" )  
local widget =  require("widget")       
local scene = composer.newScene()      


local bg1 = display.newGroup()          -- gruppo contenitore per gli elementi di sfondo
local fg1 = display.newGroup()          -- gruppo contenitore per gli elementi in primo piano
local gruppoCC = {}                     -- gruppo che raccoglie tutti i cerchi creati e che verranno cancellati una volta diventati inutili


-- dichiaro le variabili che verranno utilizzate in questa scena 
local sfondo 
local start

local tastoMenu
local cerchio1
local cerchio2

local options 

local timerCerchi

local c1
local c2

local score 
local punteggio
local punteggioMinimo
local vittoria
local sconfitta

local musica        
local musica_play

local musicaLivello1
local musicaLivello1_play

local musicaLivello2

----------------------------------------  
-- CREATE ------------------------------ 
---------------------------------------- 

function scene:create( event )  
  local sceneGroup = self.view

  score = 0                                                               -- inizializzo la variabile che conterrà il punteggio e le do valore 0
  punteggio = display.newText ({text="PUNTEGGIO = "..score , font= "Calibri", fontSize= "15"})      -- scritta a video del punteggio
  punteggioMinimo = display.newText ({text="Punteggio minimo 20" , font= "Calibri", fontSize= "12"})-- scritta che indica il punteggio minimo da raggiungere
  sfondo = display.newImageRect(bg1,"img/bgCinema.png",480,320)           -- sfondo 
  start = display.newImageRect(fg1,"img/start.png",100,100)               -- bottone start
  tastoMenu = display.newImageRect (fg1,"img/menu.png",90,32)             -- bottone per ritornare alla scena menu
  cerchio1 = display.newImageRect(fg1,"img/cerchioBianco.png",54,54)      -- cerchio obiettivo 1
  cerchio2 = display.newImageRect(fg1,"img/cerchioBianco.png",54,54)      -- cerchio obiettivo 2 

  options = {effect = "zoomInOutFade",time = 1600,}                       -- parametri da utilizzare nella transizione tra le scene
  
  vittoria = display.newText ({text=" Hai vinto! " , font= "Calibri", fontSize= "60"})  -- scritta da visualizzare in caso di vittoria
  sconfitta = display.newText ({text=" Hai perso! " , font= "Calibri", fontSize= "60"}) -- scritta da visualizzare in caso di sconfitta
  
  sceneGroup:insert(bg1) -- aggiungo gli elementi creati alla scena
  sceneGroup:insert(fg1)
  sceneGroup:insert(punteggio)
  sceneGroup:insert(punteggioMinimo)
  sceneGroup:insert(vittoria)
  sceneGroup:insert(sconfitta)
  
  musicaLivello1 = audio.loadSound ("m/musicaLivello1.mp3")  -- carico la musica del livello 1 


end


-- FUNZIONE CHE MI PERMETTE DI TORNARE AL MENU

-- questa funzione, oltre ad andare alla scena "menu" deve anche gestire l'audio del livello 1 del menu, alcune scritte e la cancellazione 
-- degli elementi grafici non più utili 

local function tornaMenu(event)  
  sconfitta.isVisible = true  -- rendo queste due scritte obbligatoriamente visibili in questa fase, in modo da poterle eliminare con un if sia se la
  vittoria.isVisible = true   -- partita è terminata, sia che si torni al menu mentre ancora si sta giocando

  musica_play = audio.fade({channel=1,time=2000,volume=1.0})   -- rialzo il volume della canzone del menu
  
  if vittoria.isVisible then                                   -- elimino le scritte vittoria o sconfitta
     display.remove(vittoria)
  else 
  
  end 
  
  if sconfitta.isVisible then
     display.remove(sconfitta)
  else
  
  end
  
  local canale_attivo = audio.isChannelPlaying(2)      -- se la musica del livello sta suonando la interrompo 
     if canale_attivo then
     audio.stop(2)
  end
  
  print(#gruppoCC)                                     -- stampo in console il numero di cerchi creati (che rientrano nel "gruppoCC")
for i = #gruppoCC,1,-1 do                              -- cancello ogni elemento presente dentro la tabella 
    table.remove(gruppoCC,i)                              
end
  print(#gruppoCC)                                     -- stampo nuovamente il contenuto della tabella per avere conferma che sia stata svuotata
  
  composer.removeScene("menu")                         -- ora si può tornare alla scena menu
  composer.removeScene("livello1")
  composer.removeScene("livello2")
  composer.removeScene("titolo")
 
  composer.gotoScene("menu",options)                   -- indico di raggiungere la scena menu utilizzando le opzioni appena create
end




-- FUNZIONE PER GENERARE I CERCHI IN MANIERA AUTOMATICA 
local function creaCC(event)
 
if math.random(2) == 1 then 

  c1= display.newCircle(fg1,240,185,16)        -- creo un cerchio che dal centro del display raggiunge il suo corrispettivo                         
  c1:setFillColor(1,1,1)                       -- cerchio obiettivo grazie ad una transizione. In questa fase il cerchio passa                        
  c1.alpha = 0                                 -- da trasparente a opaco per creare un effetto migliore dal punto di vista estetico
 
  local movimento_c1 = transition.to (c1,{ time = 2000,x = -100, y= 185, xScale = 2, yScale = 2, alpha = 1}) -- spostamento verso cerchio 1
  
	
else 

  c2= display.newCircle(fg1,240,185,16)                                 
  c2:setFillColor(1,1,1)                                                  
  c2.alpha = 0
  
  local movimento_c2 = transition.to (c2,{ time = 2000,x = 580, y = 185, xScale = 2, yScale = 2,alpha = 1})   -- spostamento verso cerchio 2
end
 table.insert(gruppoCC,c1)	-- inserisco i cerchi creati nella tabella gruppoCC in modo da raccoglierli e poi eliminarli 
 table.insert(gruppoCC,c2)
end  


---- FUNZIONE PER IL CONTROLLO DELL'INTERAZIONE CON I CERCHI c1 
local function controlloTap1 (event)

if math.abs( event.x - c1.x) <= 40 then       -- se la distanza (in valore assoluto) tra il punto in cui si preme e il cerchio in arrivo è 

  c1:setFillColor(0,0,0)                      -- minore o uguale a 40 si colora quel cerchio di nero (per far capire al giocatore il successo 
  score = score + 1                           -- della sua azione), si aggiunge un punto allo score e si aggiorna il testo che indica il punteggio 
  punteggio.text = "PUNTEGGIO = "..score      -- ottenuto

end
 return score
end

---- FUNZIONE PER IL CONTROLLO DELL'INTERAZIONE CON I CERCHI c2
local function controlloTap2 (event)

if math.abs( event.x - c2.x) <= 40 then

  c2:setFillColor(0,0,0)
  score = score + 1
  punteggio.text = "PUNTEGGIO = "..score

end
 return score
end



-- FUNZIONE DI FINE GIOCO 
local function fine ()

-- questa funzione gestisce la fase finale del gioco
display.remove(cerchio1)    -- rimuove i cerchi fissi             
display.remove(cerchio2)
cerchio1=nil
cerchio2=nil

if (score >= 20) then       -- se il punteggio è uguale o superiore a 20 viene resa visibile la scritta di vittoria
   
   vittoria.isVisible =true
   
else 
   
   sconfitta.isVisible = true -- altrimenti viene resa visibile la scritta di sconfitta
   
end

end


-- FUNZIONE CHE PERMETTE DI FAR COMINCIARE IL GIOCO
local function inizioGioco (event)   
  score = 0                                   -- variabile punteggio inizializzata a 0
  display.remove(start)                       -- faccio sparire il tasto start
  
  c1= display.newCircle(fg1,240,185,16)       -- al via del gioco creiamo dei cerchi trasparenti. Questi cerchi hanno il solo scopo di evitare che, se
  c1.alpha = 0                                -- il giocatore preme un cerchio obiettivo prima che il cerchio generato dal centro compaia, non ci sia un errore
  c2= display.newCircle(fg1,240,185,16)       -- dovuto al fatto che la funzione "controllaTap" riceve un valore nullo.
  c2.alpha = 0
  
  timerCerchi = timer.performWithDelay (1000, creaCC ,32)   -- questo timer attiva la funzione che genera i cerchi. viene ripetuta 32 volte

  cerchio1:addEventListener ("tap",controlloTap1 )          -- associo ai cerchi fissi la funzione controllaTap 
  cerchio2:addEventListener ("tap",controlloTap2 )
  	
  musicaLivello1_play = audio.play(musicaLivello1, {onComplete = fine}) -- una volta che l'intera traccia musicale è stata riprodotta si attiva la 
                                                                        -- funzione fine
end

   
---------------------------------------- 
-------- SHOW -------------------------- 
----------------------------------------

function scene:show( event )
 
  local sceneGroup = self.view
  local phase = event.phase
 
  if ( phase == "will" ) then        
  sfondo.x = display.contentCenterX  -- posiziono sfondo       
  sfondo.y = display.contentCenterY

  start.x = 240  -- posiziono il bottone start       
  start.y = 185

  tastoMenu = widget.newButton{                  -- creiamo un bottone widget per tornare alla scena menu
	defaultFile = "img/menu.png",                -- definiamo la prima immagine visualizzata
	overFile = "img/menu_mouse.png",             -- definiamo l'immagine da visualizzare al click
    width = 90, height = 32,                     -- dimensioni delle due immagini
	onRelease = tornaMenu                        -- al rilascio del bottone esegue funzione "tornaMenu"
	}
  tastoMenu.x = 330         -- posiziono immagine per il ritorno al menu  
  tastoMenu.y = 65

  cerchio1.x = 70           -- posiziono cerchio obiettivo 1
  cerchio1.y = 185
  cerchio1.type = "cerchio"                               

  cerchio2.x = 410          -- posiziono cerchio obiettivo 2   
  cerchio2.y = 185
  
  punteggio.x = 150         -- posiziono il punteggio 
  punteggio.y = 65	
  
  punteggioMinimo.x = 240   -- posizione punteggio minimo
  punteggioMinimo.y = 280

  vittoria.x = 240          -- posiziono la scritta da usare in caso di vittoria. 
  vittoria.y = 160
  vittoria.isVisible = false
  
  sconfitta.x = 240         -- posiziono la scritta da usare in caso di sconfitta
  sconfitta.y = 160
  sconfitta.isVisible = false
 
 elseif ( phase == "did" ) then
 
  start:addEventListener("tap",inizioGioco) 	-- attivo tutti gli ascoltatori legati agli elementi grafici di questa scena
  tastoMenu:addEventListener("tap",tornaMenu) 
  musica_play = audio.fade({channel=1,time=2000,volume=0.0})  -- la musica che si sente nel menu si zittisce
  
  end
end

--------------------------------------------------------
-------- HIDE ------------------------------------------ 
--------------------------------------------------------
function scene:hide( event )
 
  local sceneGroup = self.view
  local phase = event.phase
 
  if ( phase == "will" ) then


 timerCerchi = timer.pause()   -- quando esco dal livello e vado in una nuova scena mi mette in pausa il timer e la tabella  gruppoCC
                               -- viene svuotata.
  elseif ( phase == "did" ) then
      
   end
end

---------------------------------------------------------
-------- DESTROY ----------------------------------------
---------------------------------------------------------
function scene:destroy( event )
 
  local sceneGroup = self.view   -- elimino il tasto del menu
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


 
return scene


