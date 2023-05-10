
-- MENU ---------------------------------

local composer = require( "composer" )
local widget =  require("widget")
local scene = composer.newScene() 

local bg = display.newGroup()  -- gruppo contenitore per gli elementi di sfondo
local fg = display.newGroup()  -- gruppo contenitore per gli elementi in primo piano

-- dichiaro le variabili che verranno utilizzate in questa scena
local sfondoMenu
local sfondoMenu_next 
local bottoneLivello1
local bottoneLivello2

local tastoExit
local options         

local web
local cinema

local istruzioni 
local istruzioni2
local istruzioni3 


------------------------------------------------------------------------ 
-- CREATE -------------------------------------------------------------- 
------------------------------------------------------------------------

function scene:create( event )  
local sceneGroup = self.view    

sfondoMenu = display.newImageRect (bg,"img/sfondoCopertina.png",480,320)
sfondoMenu_next = display.newImageRect (bg,"img/sfondoCopertina_next.png",480,320)
bottoneLivello1 = display.newImageRect(fg,"img/cinema.png",90,90)       -- bottone per accedere al livello 1 del gioco
bottoneLivello2 = display.newImageRect(fg,"img/informatica.png",90,90)  -- bottone per accedere al livello 2 del gioco 
 

cinema = display.newImageRect (fg,"img/testo.cinema.png",90,26)         -- titolo livello 1
web = display.newImageRect (fg,"img/testo.web.png",63,26)               -- titolo livello 2

options = {effect = "zoomInOutFade",time = 1000,}                       -- opzioni da utilizzare nelle transizioni da una scena all'altra 
tastoExit = display.newImageRect(fg,"img/exit.png",90,43)               -- tasto exit che permette di tornare alla scena "titolo"

-- viene inserito il testo con le istruzioni del gioco

istruzioni = display.newText ({text=" Frequentare l'università è una questione di ritmo!Allenati con noi.", font= "Calibri", fontSize= "11"})
istruzioni2 =display.newText ({text=" Quando un cerchio entra nell'altro premili e guadagna punti per diventare sempre più bravo", font= "Calibri", fontSize= "11"})
istruzioni3 = display.newText ({text=" Se riesci a premere più volte un cerchio farai più punti!", font= "Calibri", fontSize= "11"})

-- vengono aggiunti gli elementi appena creati all'interno della scena
sceneGroup:insert(bg)
sceneGroup:insert(fg)
sceneGroup:insert(istruzioni)
sceneGroup:insert(istruzioni2)
sceneGroup:insert(istruzioni3)



end



-- FUNZIONE PER LO SCROLLING DELLO SFONDO
local function scroller(self, event)                          
	local speed = 1
	if self.x < -(display.contentWidth-speed*2) then
		self.x = display.contentWidth
	else 
		self.x = self.x - speed
	end
end


-- FUNZIONI CHE MI PERMETTONO DI ANDARE AL LIVELLO SELEZZIONATO

-- LIVELLO1
local function giocaLivello1()
    
	composer.removeScene("livello1")	   -- nel caso la scena alla quale vogliamo accedere sia già creata, per sicurezza la rimuoviamo.  
	composer.removeScene("livello2")       -- Ripeto questa operazione per tutte le scene che potrebbero essere state create.      
	composer.removeScene("titolo")
	composer.removeScene("menu")
	
	composer.gotoScene("livello1",options) -- indico di raggiungere la scena utilizzando le opzioni stabilite 
end

-- LIVELLO2
local function giocaLivello2()
    
	composer.removeScene("livello1")	     
	composer.removeScene("livello2")  
	composer.removeScene("titolo")
	composer.removeScene("menu") 
   
	composer.gotoScene("livello2",options) 
end

-- FUNZIONE CHE PERMETTE DI RITORNARE ALLA SCENA INIZIALE
local function tornaTitolo()

	composer.removeScene("livello1")	   
	composer.removeScene("livello2")
	composer.removeScene("titolo")
	composer.removeScene("menu")  
    
	composer.gotoScene("titolo") 
end

-------------------------------------------------------------------
-------- SHOW -----------------------------------------------------
-------------------------------------------------------------------
function scene:show( event )
 
    local sceneGroup = self.view
    local phase = event.phase
 
    if ( phase == "will" ) then
  sfondoMenu.anchorX = 0                     -- sfondo
  sfondoMenu.anchorY = 0
  sfondoMenu.x = display.contentWidth
  sfondoMenu.y = display.contentHeight- sfondoMenu.height 

  sfondoMenu_next.anchorX = 0                -- sfondo_next              
  sfondoMenu_next.anchorY = 0
  sfondoMenu_next.x = 0
  sfondoMenu_next.y = display.contentHeight-sfondoMenu_next.height  

  bottoneLivello1.x = 150 -- posizino bottone per selezionare il livello 1 
  bottoneLivello1.y = 120

  bottoneLivello2.x = 330 -- posizino bottone per selezionare il livello 2 
  bottoneLivello2.y = 120
  
  cinema.x = 150          -- posiziono titolo livello
  cinema.y = 160
  
  web.x = 330             -- posiziono titolo livello
  web.y = 160
  
  
  tastoExit = widget.newButton{       -- posiziono il tasto exit             
	defaultFile = "img/exit.png",                
	overFile = "img/exit_mouse.png",             
    width = 90, height = 43,                     
	onRelease = esci                             
	}
  tastoExit.x = display.contentCenterX + 150     
  tastoExit.y = display.contentCenterY + 100
  
  
  istruzioni.x = 235      -- posiziono il testo presente nella scena menu
  istruzioni.y = 190
  
  istruzioni2.x = 230
  istruzioni2.y = 210
  
  istruzioni3.x = 235
  istruzioni3.y = 240
  
  
  

 elseif ( phase == "did" ) then
 
        sfondoMenu.enterFrame = scroller         -- attivo gli ascoltatori dello scrolling
		sfondoMenu_next.enterFrame = scroller
		Runtime:addEventListener("enterFrame",sfondoMenu)
		Runtime:addEventListener("enterFrame",sfondoMenu_next)
		
		bottoneLivello1:addEventListener("tap",giocaLivello1)	-- attivo l'ascoltatore del tasto per selezionare il livello 1
        bottoneLivello2:addEventListener("tap",giocaLivello2)	-- attivo l'ascoltatore del tasto per selezionare il livello 2
		tastoExit:addEventListener("tap",tornaTitolo)           -- attivo l'ascoltatore del tasto per ritornare alla scena "titolo"
		
end		
 end



--------------------------------------------------------
-------- HIDE ------------------------------------------ 
--------------------------------------------------------

function scene:hide( event )
 
   local sceneGroup = self.view
   local phase = event.phase
 
   if ( phase == "will" ) then
        -- disattivo ascoltatori scena
        bottoneLivello1:removeEventListener("tap",giocaLivello1)	
        bottoneLivello2:removeEventListener("tap",giocaLivello2)		
		
		Runtime:removeEventListener("enterFrame", sfondoMenu)
	    Runtime:removeEventListener("enterFrame", sfondoMenu_next)
		
    elseif ( phase == "did" ) then
     
    end
end

---------------------------------------------------------
-------- DESTROY ----------------------------------------
---------------------------------------------------------
function scene:destroy( event )
 
  local sceneGroup = self.view
 
-- elimino tasto exit 
 if tastoExit then 
    tastoExit:removeSelf()
    tastoExit = nill
  end

end 
 
-- -----------------------------------------------------------------------------------
-- AGGIUNGO DEGLI ASCOLTATORI ALLE SCENA ---------------------------------------------
-- -----------------------------------------------------------------------------------
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )


 
return scene






