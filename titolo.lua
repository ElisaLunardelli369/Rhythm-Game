

-- progetto "rhythm game" sviluppato da:
-- Elisa Lunardelli 128764
-- Virginia Cailotto 127997 
-- Giorgia Deon 128315



-- TITOLO ---------------------------------
local composer = require("composer") 
local widget =  require("widget") -- richiamo la libreria widget per la creazione dei bottoni exit e menu
local scene = composer.newScene() -- creo una nuova scena che corrisponderà al titolo del gioco


local bgT = display.newGroup()    -- gruppo contenitore per gli elementi di sfondo
local fgT = display.newGroup()    -- gruppo contenitore per gli elementi in primo piano

------ dichiaro le variabili che verranno utilizzate in questa scena

local titolo
local sottotitolo
local sfondoTitolo
local sfondoTitolo_next
local tastoExit
local tastoMenu

local musica
local musica_play  


------------------------------------------------------------------------ 
-- CREATE -------------------------------------------------------------- 
------------------------------------------------------------------------

function scene:create( event )  
local sceneGroup = self.view

-- carico i file relativi alla grafica nelle variabili corrispondenti
sfondoTitolo = display.newImageRect (bgT,"img/sfondoCopertina.png",480,320)
sfondoTitolo_next = display.newImageRect (bgT,"img/sfondoCopertina_next.png",480,320)
titolo = display.newImageRect(fgT,"img/titolo.png",450,250)
sottotitolo = display.newImageRect(fgT,"img/sottotitolo.png",180,42)
tastoExit = display.newImageRect(fgT,"img/exit.png",90,43)
tastoMenu = display.newImageRect(fgT,"img/menu.png",90,32)

-- carico il file audio della musica per le scene di titolo e menu
musica = audio.loadSound("m/intro.wav",{channel=1})                  

-- inseriamo gli elementi caricati nella scena
sceneGroup:insert(bgT)
sceneGroup:insert(fgT)

end


-- FUNZIONE CHE MI PERMETTE DI ACCEDERE AL MENU
local function tornaMenu()

	composer.removeScene("menu")     -- nel caso la scena alla quale si vuole accedere sia già stata creata, per sicurezza viene rimossa. 
	composer.removeScene("titolo")   -- Vengono rimosse anche tutte le altre scene per evitare che, nel caso siano già state create,
	composer.removeScene("livello1") -- queste non vengano sovrapposte a quella che si deve raggiungere con questo comando.
	composer.removeScene("livello2")
	composer.gotoScene("menu")       -- indico scena da raggiungere
	
end


-- FUNZIONE PER LO SCROLLING DELLO SFONDO
local function scroller(self, event)                 -- questa funzione prende come argomento le due immagini di sfondo e l'evento enterFrame.
	local speed = 1                                  -- Una viene posizionata all'interno dello schermo, mentre l'altra viene
	if self.x < -(display.contentWidth-speed*2) then -- affiancata a questa, e in base alla velocità fissata le fa scorrere 
		self.x = display.contentWidth                -- creando l'effetto di scrolling 
	else 
		self.x = self.x - speed
	end
end



-- FUNZIONE PER CHIUDERE L'APPLICAZIONE

 local function esci()               -- permette di chiudere l'applicazione direttamente dalla scena titolo
 
    native.requestExit()
	return true 
	
 end
 
-------------------------------------------------------------------
-------- SHOW -----------------------------------------------------
-------------------------------------------------------------------

function scene:show( event )
 
    local sceneGroup = self.view
    local phase = event.phase
 
  if ( phase == "will" ) then
	
	-- if fase "will" definisco la posizione degli elementi grafici prima caricati.
	
	sfondoTitolo.anchorX = 0                     -- sfondo
    sfondoTitolo.anchorY = 0
    sfondoTitolo.x = display.contentWidth
    sfondoTitolo.y = display.contentHeight- sfondoTitolo.height 

	sfondoTitolo_next.anchorX = 0                -- sfondo_next              
    sfondoTitolo_next.anchorY = 0
    sfondoTitolo_next.x = 0
    sfondoTitolo_next.y = display.contentHeight-sfondoTitolo_next.height
	
	titolo.x = display.contentCenterX            -- titolo
	titolo.y = display.contentCenterY - 20
	
	sottotitolo.x = display.contentCenterX       -- sottotitolo
	sottotitolo.y = display.contentCenterY - 43
		
	tastoExit = widget.newButton{                -- creiamo un bottone widget per uscire dall'applicazione
	defaultFile = "img/exit.png",                -- definiamo la prima immagine visualizzata
	overFile = "img/exit_mouse.png",             -- definiamo l'immagine da visualizzare al click
    width = 90, height = 43,                     -- dimensioni delle due immagini
	onRelease = esci                             -- al rilascio del bottone esegue funzione "esci"
	}
	tastoExit.x = display.contentCenterX - 100   -- posizione tasto exit
	tastoExit.y = display.contentCenterY + 100
	
	tastoMenu = widget.newButton{                -- creiamo un bottone widget per accedere al menu 
	defaultFile = "img/menu.png",                -- definiamo la prima immagine visualizzata
	overFile = "img/menu_mouse.png",             -- definiamo l'immagine da visualizzare al click
    width = 90, height = 32,                     -- dimensioni delle due immagini
	onRelease = tornaMenu                        -- al rilascio del bottone esegue funzione "tornaMenu"
	}
	
	tastoMenu.x = display.contentCenterX + 100   -- posizione tasto per accedere al menu
	tastoMenu.y = display.contentCenterY + 100
	
	
  elseif ( phase == "did" ) then
 
  -- in fase "did" attiviamo gli ascoltatori presenti nella scena      
		tastoMenu:addEventListener("tap",tornaMenu)	-- attivo l'ascoltatore del tasto che permette di raggiungere il menu
        tastoExit:addEventListener("tap",esci)	    -- attivo l'ascoltatore associato al tasto exit 
		
	    sfondoTitolo.enterFrame = scroller          -- attivo lo scrolling e i suoi ascoltatori
		sfondoTitolo_next.enterFrame = scroller
	    Runtime:addEventListener("enterFrame", sfondoTitolo)      
		Runtime:addEventListener("enterFrame", sfondoTitolo_next)
		
     local canale_attivo_menu = audio.isChannelPlaying(1) -- creo una variabile booleana visibile solo all'interno di questa funzione che
     if canale_attivo_menu then                           -- rileva se la musica caricata sul canale 1 (quella del menu) sta suonando o meno.
                                                          -- Se la musica è già in funzione quando entro nella scena non effettua azioni
     else
	    musica_play = audio.play(musica,{loops=-1})       -- Se la musica non è in funzione la faccio partire e il codice la riproducerà 
	 end	                                              -- infinite volte.
	
  end
end

--------------------------------------------------------
-------- HIDE ------------------------------------------ 
--------------------------------------------------------

function scene:hide(event)

   local sceneGroup = self.view
   local phase = event.phase 
   
     if (phase == "will") then  
     
      -- rimuoviamo tutti gli ascoltatori presenti nella scena
      Runtime:removeEventListener("enterFrame", sfondoTitolo)
	  Runtime:removeEventListener("enterFrame", sfondoTitolo_next)
	 
     elseif(phase == "did") then
     end
end	


---------------------------------------------------------
-------- DESTROY ----------------------------------------
---------------------------------------------------------

-- FUNZIONE PER LA DISTRUZIONE DEL PULSANTE EXIT E MENU
-- con la funzione hide il pulsante widget non viene eliminato, per questo è necessario inserire anche
-- una fase destroy per la sua eliminazione. Senza questa operazione il pulsante rimarrebbe sempre a video e 
-- anche il suo ascoltatore rimarrebbe attivo.

function scene:destroy( event )
 
  local sceneGroup = self.view
  
  if tastoMenu then             
     tastoMenu:removeSelf()   -- rimuovo tasto e ascoltatore
	 tastoMenu = nill         -- rimuovo variabile collegata al tasto 
  end
  
  if tastoExit then 
     tastoExit:removeSelf()
     tastoExit = nill
  end
 
end
	
------------------------------------------------------------- 
-- AGGIUNTA DEGLI ASCOLTATORI DELLA SCENA -------------------
-------------------------------------------------------------
	
-- ASCOLTATORI DELLA SCENA
scene:addEventListener( "create", scene )  
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy",scene )


return scene








 




