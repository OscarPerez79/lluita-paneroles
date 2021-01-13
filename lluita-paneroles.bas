REM Lluita de paneroles
fn.def dibuixa_taulell(a)
  bundle.create taulell
  bundle.put taulell, "caselles", crea_caselles(a)
  rem bundle.put taulell, "palillos", palillos
  bundle.put taulell, "panell_info", crea_panell(a)
  gr.render
  fn.rtn taulell
fn.end

fn.def crea_panell(a)
  bundle.create panell
  gr.text.size 50
  gr.text.draw label_torn, 1400,60,"Torn: Jugador 1"
  gr.text.draw label_unitats_moviment, 1400,130, "Moviments: 6"
  gr.text.draw label_vides, 1400,200, "Energia: 3"
  bundle.put panell, "torn", label_torn
  bundle.put panell, "moviments", label_unitats_moviment
  bundle.put panell, "vides", label_vides
  fn.rtn panell
fn.end

fn.def actualitza_panell(jugador, torn, panell)
  bundle.get panell, "torn", label_torn
  bundle.get panell, "moviments", label_unitats_moviment
  bundle.get panell, "vides", label_vides
  moviments=quants_moviments_te(jugador)
  vides = quantes_vides_te(jugador)
  gr.modify label_torn, "text", "Torn: Jugador "+str$(torn)
  gr.modify label_unitats_moviment, "text", "Moviments: "+str$(moviments)
  gr.modify label_vides, "text", "Energia: "+str$(vides)
fn.end

fn.def debug_palillos(palillos[])
  for i=1 to 2
    for j=1 to 3
      print "palillo["+str$(i)+","+str$(j)+"]=" + str$(palillos[i,j])
    next j
  next i      
  fn.rtn 1
fn.end

fn.def crea_palillos(palillos[])
  amplada=180
  alcada=20
  gr.color 255, 150,150,240,1
  for i=1 to 2
    for j=1 to 3
      if (round(rnd()*2)>1) then
        width=amplada
        height=alcada
      else
        width=alcada
        height=amplada
      endif
      left=20+(j)*200*2-200-width/2
      top=20+(i)*200*2-200 -height/2
      gr.rect palillos[i,j], left,top,left+width,top+height
    next j
  next i
  print "dins de crea_palillos"
  call debug_palillos(palillos[])
  fn.rtn palillos
fn.end


fn.def crea_caselles(a)
  dim caselles[4,6]
  width=200
  height=200
  left=20
  top=20

  gr.color 255,40,40,40,0
  for i=1 to 4 
    left=20
    for j=1 to 6
      gr.rect caselles[i,j], left,top,left+width,top+height
      left=left+width
    next j
    top=top+height
  next i
  fn.rtn caselles
fn.end

fn.def crea_explosio()
  gr.bitmap.create explosio, 80,80
  nom_arxiu$="../../git-projects/lluita-paneroles/resources/atac.jpg"
  gr.bitmap.load explosio, nom_arxiu$
  gr.bitmap.draw imatge,explosio, 600, 600
  fn.rtn imatge
fn.end

fn.def crea_jugador(quin)
  casella_x = 1
  casella_y = 1
  if (quin = 2)
    casella_x = 6
    casella_y = 4
  else
    if (quin = 3)
      casella_x = 1
      casella_y = 4
    else
      if (quin = 4)
        casella_x=6
        casella_y=1
      endif
    endif
  endif
  x= 20+200/2-120/2+((casella_x-1)*200)
  y= 20+200/2-120/2+((casella_y-1)*200)
  gr.bitmap.create imatge, 80,80
  nom_arxiu$="../../git-projects/lluita-paneroles/resources/jugador-"+replace$(str$(quin),".0","")+".jpg"
  gr.bitmap.load dibuix, nom_arxiu$
  gr.bitmap.scale dibuix_escalat, dibuix,120,120
  gr.bitmap.draw imatge,dibuix_escalat, x, y
  gr.color 128,55,250,69
  gr.rect quadre_vida_1, 10,10,40,40
  gr.rect quadre_vida_2, 10,10,40,40
  gr.rect quadre_vida_3, 10,10,40,40
  REM poso els numeros de jugadors
  gr.text.size 24
  gr.color 255,100,100,100
  gr.text.draw numero_jugador,10,10, "Jug. "+replace$(str$(quin),".0","")

  REM ara posem els objectes del jugador al bundle
  bundle.create jugador
  bundle.put jugador, "objecte", imatge
  bundle.put jugador, "casella_x", casella_x
  bundle.put jugador, "casella_y", casella_y
  bundle.put jugador, "moviments", 6
  bundle.put jugador, "vides", 3
  bundle.put jugador, "vida1", quadre_vida_1
  bundle.put jugador, "vida2", quadre_vida_2
  bundle.put jugador, "vida3", quadre_vida_3
  bundle.put jugador, "quadre_numero", numero_jugador
  posiciona_vides_jugador(jugador)
  print "Creo el jugador "+str$(quin)+"  x:"+str$(casella_x)+" y:"+str$(casella_y)+"  coordenades: ["+str$(x)+","+str$(y)+"]"
  gr.render
  fn.rtn jugador
fn.end

fn.def get_vides_te(jugador)
  bundle.get jugador, "vides", vides
  fn.rtn vides
fn.end

fn.def posiciona_vides_tots_jugadors(jugadors[])
  for i=1 to 4
    posiciona_vides_jugador(jugadors[i])
  next i
fn.end 

fn.def posiciona_vides_jugador(jugador)
  amplada = 30
  bundle.get jugador, "objecte", dibuix_jugador
  bundle.get jugador, "vida1", quadre_vida_1
  bundle.get jugador, "vida2", quadre_vida_2
  bundle.get jugador, "vida3", quadre_vida_3
  bundle.get jugador, "quadre_numero", quadre_numero_jugador
  vides = quantes_vides_te(jugador)
  gr.get.value dibuix_jugador, "x", left_jugador
  gr.get.value dibuix_jugador, "y", top_jugador
  bottom_jugador = top_jugador+120
  right_jugador = left_jugador+120

  REM calculem la posició dels quadres de vida
  left_quadre_1 =-50
  left_quadre_2 =-50
  left_quadre_3 = -50
  top_quadre_1 = bottom_jugador - amplada - 10
  if (vides>0) then
    left_quadre_1 = (right_jugador+left_jugador)/2-amplada*3/2
    if (vides >1) then
      left_quadre_2 = left_quadre_1+amplada
      if (vides > 2) then
        left_quadre_3 = left_quadre_1+amplada*2
      endif
    endif
  endif
  REM ara posem els quadres
  posiciona_quadre_vida(quadre_vida_1, left_quadre_1, top_quadre_1)
  posiciona_quadre_vida(quadre_vida_2, left_quadre_2, top_quadre_1)
  posiciona_quadre_vida(quadre_vida_3, left_quadre_3, top_quadre_1)
  posiciona_quadre_text(quadre_numero_jugador, left_quadre_1, top_jugador)
  fn.rtn 1
fn.end

fn.def posiciona_quadre_text(quadre_text, left, top)
  gr.modify quadre_text, "x", left
  gr.modify quadre_text, "y", top
  fn.rtn 1
fn.end  

fn.def posiciona_quadre_vida(quadre_vida, left, top)
  amplada=30
  gr.modify quadre_vida, "left", left
  gr.modify quadre_vida, "right", left+amplada
  gr.modify quadre_vida, "top", top
  gr.modify quadre_vida, "bottom", top+amplada
  fn.rtn 1
fn.end  



fn.def quantes_vides_te(jugador)
  bundle.get jugador, "vides", vides
  fn.rtn vides
fn.end

fn.def set_vides_te(jugador,vides)
  bundle.put jugador,"vides",vides
  fn.rtn vides
fn.end


fn.def quants_moviments_te(jugador)
  bundle.get jugador,"moviments", moviments
  fn.rtn moviments
fn.end

fn.def set_moviments_te(jugador,quants)
  bundle.put jugador,"moviments",quants
  fn.rtn quants
fn.end

fn.def selecciona_torn(torn, jugadors)
   
  fn.rtn 0
fn.end


fn.def get_casella_x_jugador(jugador)
  bundle.get jugador,"casella_x",x
  fn.rtn x
fn.end

fn.def get_casella_y_jugador(jugador)
  bundle.get jugador,"casella_y",y
  fn.rtn y
fn.end


fn.def descompta_moviments_jugador(jugador, quants)
  moviments = quants_moviments_te(jugador)
  queden=moviments-quants
  print "El jugador tenia "+str$(moviments)+ " moviments. En fa "+str$(quants)+" i en queden "+str$(queden)
  bundle.put jugador,"moviments", queden
  fn.rtn queden
fn.end



fn.def calcula_distancia_entre_caselles(x1, y1, x2, y2)
  distancia=abs(x2-x1)+abs(y2-y1)
  print "Distància entre ["+str$(x1)+","+str$(y1)+"] i ["+str$(x2)+","+str$(y2)+"] = "+str$(distancia)
  fn.rtn distancia
fn.end

fn.def min(a,b)
  if (b<a)
    minim = b
  else
    minim = a
  endif
  fn.rtn minim
fn.end

fn.def max(a,b)
  if (b<a)
    maxim = a
  else
    maxim = b
  endif
  fn.rtn maxim
fn.end


fn.def get_palillo_per_cami_lliure_entre_caselles_horitzontal(min_x, min_y, palillos[])
  if (min_y = 1) | (min_y = 2)
    i = 1
  else
    i = 2
  endif
  if (min_x = 1)
    j=1
  else
    if (min_x= 3)
      j=2
    else
      j=3
    endif
  endif
  fn.rtn palillos[i,j]
fn.end


fn.def get_palillo_per_cami_lliure_entre_caselles_vertical(min_x, min_y, palillos[])
  if (min_y = 1)
    i = 1
  else
    i = 2
  endif
  if (min_x = 1) | (min_x=2)
    j=1
  else
    if (min_x= 3) | (min_x = 4)
      j=2
    else
      j=3
    endif
  endif
  fn.rtn palillos[i,j]
fn.end


REM mira si entre (x1,y1) i (x2,y2) hi ha algun obstacle
REM la distància entre les dues coordenades només pot ser 1
fn.def cami_lliure_entre_caselles(x1, y1, x2, y2, palillos[])
  lliure=1
  if (calcula_distancia_entre_caselles(x1,y1,x2,y2) > 1)
    dialog.message "cami_lliure_entre_caselles només pot calcular en desplaçaments a 1 casella de distància",,boto
    lliure= 0
  else
    min_x= min(x1,x2)
    max_x = max(x1,x2)
    min_y = min(y1,y2)
    max_y = max(y1,y2)
    if (min_x = max_x) 
      REM és un moviment el vertical
      if (min_y=1 | min_y=3) 
        REM és entre dues files separades per un palillo
        palillo = get_palillo_per_cami_lliure_entre_caselles_vertical(min_x, min_y, palillos[])
        if (palillo_esta_horitzontal(palillo)=1)
          REM si està en horitzontal no permetrà el moviment
          lliure = 0
        endif 
      endif
    else
      REM és un moviment en horitzontal
      if (min_x = 1) | (min_x = 3) | (min_x = 5)
        REM és entre dues columnes separades per palillo
        palillo = get_palillo_per_cami_lliure_entre_caselles_horitzontal(min_x, min_y, palillos[])
        if (palillo_esta_vertical(palillo)=1)
          REM si està en vertical no permetrà el moviment
          lliure = 0
        endif
      endif
    endif
  endif
  fn.rtn lliure
fn.end



REM Mira si el jugador al que li toca ara, pot anar a la casella
REM indicada. Serà així si té prous moviments per a la distància que
REM queda i no hi ha obstacles entremig
fn.def es_casella_on_pot_anar(jugador, casella_x, casella_y, palillos[])
  print "Miro si pot anar a la casella "+str$(casella_x)+","+str$(casella_y)
  pot_anar = 0
  if (casella_x > 0 ) & (casella_x <=6 ) & (casella_y > 0 ) & (casella_y <= 4) 
          moviments_queden = quants_moviments_te(jugador)
          print "Moviments que queden="+str$(moviments_queden)
          casella_origen_x = get_casella_x_jugador(jugador)
          casella_origen_y = get_casella_y_jugador(jugador)
          distancia = calcula_distancia_entre_caselles(casella_origen_x, casella_origen_y, casella_x, casella_y)
          print "Distància="+str$(distancia)
          if moviments_queden >= distancia & distancia <= 1
            print "Té prou moviments i la distància és 1"
            if (cami_lliure_entre_caselles(casella_origen_x, casella_origen_y, casella_x, casella_y, palillos[])=1)
              print "pot anar=true"
              pot_anar=1
            else
              print "pot anar=false"
            endif
          endif
  endif
  fn.rtn pot_anar
fn.end


fn.def jugador_que_hi_ha_a_casella(jugadors[], casella_x, casella_y)
  index_jugador = 0
  print "miro quin jugador hi ha a ["+str$(casella_x)+","+str$(casella_y)+"]"
  for i=1 to 4
    bundle.get jugadors[i], "casella_x", casella_x_jugador
    bundle.get jugadors[i], "casella_y", casella_y_jugador
    print "El jugador "+str$(i)+" està a ["+str$(casella_x_jugador)+","+str$(casella_y_jugador)+"]
    if (casella_x = casella_x_jugador) & (casella_y =casella_y_jugador)
      index_jugador = i
      print "a la casella ["+str$(casella_x)+","+str$(casella_y)+"] hi ha el jugador: "+str$(index_jugador)
    endif
  next i
  print "retorno index="+str$(index_jugador)
  fn.rtn index_jugador
fn.end


fn.def get_casella_a_coordenades(x, y, casella_x, casella_y)
  era_casella = 0
  if (x>=20) & (x <= 20+200*6)
    casella_x = floor((x-20) / 200)+1
    print "casella_x="+str$(casella_x)
    if (y >= 20) & (y <= 20+200*6)
        casella_y = floor((y-20) / 200)+1
        era_casella = 1
    endif
  endif
  fn.rtn era_casella
fn.end

REM indica si les coordenades corresponen a una cel·la a la que
REM es pot anar.
fn.def tocat_desti_possible(taulell, jugador,x,y, palillos[], jugadors[], torn)
  print "miro si tocat desti possible X="+str$(x)+"  Y="+str$(y)
  pot_anar=0
  era_casella = get_casella_a_coordenades(x,y,&casella_x, &casella_y)
  if (era_casella=1)
      print "casella_x="+str$(casella_x)
      print "casella_y="+str$(casella_y)
      if (es_casella_on_pot_anar(jugador, casella_x, casella_y, palillos[])=1)
        jugador_a_casella_desti = jugador_que_hi_ha_a_casella(jugadors[], casella_x, casella_y)
        if (jugador_a_casella_desti = 0)
          pot_anar=1
          print "POTANAR=TRUE"
        endif
      endif
  endif
  fn.rtn pot_anar
fn.end


fn.def mou_jugador(torn, taulell, jugador,p_x,p_y)
  print "MOU!"
  x=p_x-20
  y=p_y-20
  casella_x = floor((x) / 200)+1
  casella_y = floor((y) / 200)+1
  casella_origen_x =  get_casella_x_jugador(jugador)
  casella_origen_y =  get_casella_y_jugador(jugador)
  print "TAP a [x:"+str$(x)+", y:"+str$(y)+"]  casella:["+str$(casella_x)+","+str$(casella_y)+"]"
  distancia = calcula_distancia_entre_caselles(casella_origen_x, casella_origen_y, casella_x, casella_y)
  descompta_moviments_jugador(jugador, distancia)
  recolloca_jugador(jugador, casella_x, casella_y)
  fn.rtn true
fn.end

fn.def get_coordenades_casella(casella_x, casella_y, x, y)
  x = 20+(casella_x)*200-120/2-200/2
  y = 20+(casella_y)*200-120/2-200/2
  fn.rtn 1
fn.end

fn.def recolloca_jugador(jugador, casella_x, casella_y)
  get_coordenades_casella(casella_x, casella_y, &nova_x, &nova_y)
  print "Poso el jugador a les coordenades: x="+str$(nova_x)+"  y="+str$(nova_y)
  bundle.put jugador, "casella_x", casella_x
  bundle.put jugador, "casella_y", casella_y
  bundle.get jugador, "objecte", imatge
   gr.modify imatge, "x", nova_x
  gr.modify imatge, "y", nova_y
  fn.rtn true
fn.end


fn.def coordenades_a_palillo(palillo, x,y)
  dins=0
  gr.get.position palillo, x_palillo, y_palillo
  gr.get.value palillo,"right", right_palillo
  gr.get.value palillo,"bottom", bottom_palillo
  print "Coordenades palillo: ["+str$(x_palillo)+","+str$(y_palillo)+"], ["+str$(right_palillo)+","+str$(bottom_palillo)+"]"
  if (x >=x_palillo) & (x<=right_palillo) & (y >= y_palillo) & (y <= bottom_palillo)
    dins=1
  endif
  fn.rtn dins
fn.end



fn.def tocat_palillo(palillos[],x,y) 
  print "Miro si ha tocat palillo a coordenades: ["+str$(x)+","+str$(y)+"]"
  tocat = 0
  for i=1 to 2
    for j=1 to 3
      if (coordenades_a_palillo(palillos[i,j], x,y)=1)
        tocat=(i-1)*3 + j
      endif
    next j
  next i
  fn.rtn tocat
fn.end


REM mira si li queden prou moviments (2)
fn.def pot_moure_palillo(jugador)
  if (quants_moviments_te(jugador) >= 2)
    pot=1
  else
    pot = 0
  endif
  fn.rtn pot  
fn.end

fn.def ha_de_moure_palillo(palillos[],x,y,jugador)
  retorn=0
  print "ha_de_moure_palillo"
  call debug_palillos(palillos[])
  index_palillo_tocat = tocat_palillo(palillos[],x,y)
  if (index_palillo_tocat > 0)
    if (pot_moure_palillo(jugador)=1)
      retorn=1
    endif
  endif
  print "ha_de_moure_palillo="+str$(retorn)
  fn.rtn retorn
fn.end

REM rota el palillo que hi ha a les coordenades indicades
fn.def mou_palillo(palillos[],jugador,x,y)
  index_palillo_tocat = tocat_palillo(palillos[],x,y)
  i = floor((index_palillo_tocat-1)/3)+1
  j =mod(index_palillo_tocat-1,3)+1
  print "El palillo tocat és el idx="+str$(index_palillo_tocat)+" : ["+str$(i)+","+str$(j)+"]"
  if (palillo_esta_horitzontal(palillos[i,j]) = 1)
    posa_palillo_vertical(palillos[i,j])
  else
    posa_palillo_horitzontal(palillos[i,j])
  endif
  moviments=quants_moviments_te(jugador)
  set_moviments_te(jugador, moviments-1)
  fn.rtn 1
fn.end

REM posa el palillo indicat en vertical
fn.def posa_palillo_vertical(palillo)
  amplada=20
  alcada=180
  posa_palillo_en_posicio(palillo, amplada,alcada)
  fn.rtn 1
fn.end

fn.def posa_palillo_en_posicio(palillo, amplada,alcada) 
  gr.get.value palillo,"left", left
  gr.get.value palillo,"right", right
  gr.get.value palillo,"top", top
  gr.get.value palillo,"bottom", bottom
  centre_x = (right+left)/2
  centre_y = (top+bottom)/2
  left = centre_x - amplada/2
  right = centre_x + amplada/2
  top = centre_y - alcada/2
  bottom =centre_y +alcada/2
  posiciona_palillo(palillo,left,right,top,bottom)
fn.end



REM posa el palillo indicat en horitzontal
fn.def posa_palillo_horitzontal(palillo)
  amplada=180
  alcada=20
  posa_palillo_en_posicio(palillo, amplada,alcada)
  fn.rtn 1
fn.end


fn.def posiciona_palillo(palillo,left,right,top,bottom)
  gr.modify palillo, "left", left
  gr.modify palillo, "right", right
  gr.modify palillo, "top", top
  gr.modify palillo, "bottom", bottom
  fn.rtn  1
fn.end

fn.def palillo_esta_vertical(palillo)
  if (palillo_esta_horitzontal(palillo)=1)
    esta=0
  else
    esta = 1
  endif
  fn.rtn esta
fn.end

REM comprova si el palillo passat, segons la seva amplada
REM i alçada, està en horitzontal o no
fn.def palillo_esta_horitzontal(palillo)
  gr.get.value palillo,"left", left
  gr.get.value palillo,"right", right
  gr.get.value palillo,"top", top
  gr.get.value palillo,"bottom", bottom
  amplada = abs(right-left)
  alcada =abs(top-bottom)
  if (amplada > alcada)
    horitzontal=1
  else
    horitzontal=0
  endif
  fn.rtn horitzontal
fn.end

fn.def tocat_altre_jugador(torn,jugadors[],x,y)
  print "Miro si a les coordenades tocades hi ha un altre jugador: ("+str$(x)+", "+str$(y)+")"
  jugador_tocat = 0
  era_casella = get_casella_a_coordenades(x,y,&casella_x, &casella_y)
  if (era_casella = 1)
    print "La casella on ha tocat per a atacar era la: "+str$(casella_x)+","+str$(casella_y) 
    jugador_tocat = jugador_que_hi_ha_a_casella(jugadors[], casella_x, casella_y)
  endif
  fn.rtn jugador_tocat
fn.end


REM mira si li queden prou moviments 
fn.def pot_atacar(jugador)
  bundle.get jugador,"moviments", moviments
  if (moviments >= 3)
    pot = 1
  else
    pot = 0
  endif
  print "pot_atacar="+str$(pot)
  fn.rtn pot
fn.end


fn.def vol_atacar(torn,jugadors[],x,y)
  retorn=0
  print "miro si vol atacar"
  if (tocat_altre_jugador(torn,jugadors[],x,y)>0) then
    print "Ha tocat sobre un altre jugador => potser podem atacar"
    if (pot_atacar(jugadors[torn])=1) then
      print "SÍ que vol atacar. Miro si està prou a prop per a fer-ho"
      bundle.get jugadors[torn],"casella_x", casella_x_jugador
      bundle.get jugadors[torn],"casella_y", casella_y_jugador
      get_casella_a_coordenades(x,y,&casella_x_desti, &casella_y_desti)
      if (calcula_distancia_entre_caselles(casella_x_jugador, casella_y_jugador, casella_x_desti, casella_y_desti) = 1)
        retorn = 1
        print "La distancia es prou curta per a atacar"
      endif
    endif
  endif
  fn.rtn retorn
fn.end

fn.def jugador_ha_mort(jugador, index_jugador_mort,so_mort)
  audio.play so_mort
  dialog.message "Enhorabona! Has mort el jugador "+str$(index_jugador_mort),,boto
  do
    audio.isdone  done
    if done then d_u.break
    pause 10
  until 0
  audio.stop
  recolloca_jugador(jugador, -100, -100)
  fn.rtn 1
fn.end

REM fa un atac del jugador[torn] cap al que hi ha a les coordenades (x,y)
fn.def ataca(torn, jugadors[], x,y, so_mort)
  valor_retorn=1
  get_casella_a_coordenades(x,y,&casella_x, &casella_y)
  jugador_atacat = jugador_que_hi_ha_a_casella(jugadors[], casella_x, casella_y)
  print "El jugador "+str$(torn)+ " ataca al jugador "+str$(jugador_atacat)
  vides=quantes_vides_te(jugadors[jugador_atacat])
  vides =vides - 1
  print "Al jugador "+str$(jugador_atacat)+" ara li queden +str$(vides)
  set_vides_te(jugadors[jugador_atacat], vides)
  if (vides <= 0)
    REM el jugador està mort
    jugador_ha_mort(jugadors[jugador_atacat], torn, so_mort)
    valor_retorn=2
  endif
  moviments=quants_moviments_te(jugadors[torn])
  set_moviments_te(jugadors[torn], moviments-3)
  fn.rtn valor_retorn
fn.end

fn.def acabat_torn(jugador)
  moviments_queden = quants_moviments_te(jugador)
  if (moviments_queden <= 0)
    acabat=1
  else
    acabat=0
  endif
  print "Miro si acabat torn. moviments_queden="+str$(moviments_queden)+"  acabat="+str$(acabat)
  fn.rtn acabat
fn.end


fn.def passa_torn(p_torn,jugador, quants, jugadors[])
  torn= p_torn
  do
    set_moviments_te(jugador,6)
    torn =torn+1
    if (torn > quants)
      torn = 1
    endif
    vides = get_vides_te(jugadors[torn])
    print "Ara és el torn del jugador: "+str$(torn)+"  vides:"+str$(vides)
  until vides > 0 
  fn.rtn torn
fn.end


fn.def play_so(so)
  audio.play so
  do
    audio.isdone  done
    if done then d_u.break
    pause 10
  until 0
  audio.stop
  fn.rtn 1
fn.end

REM fa el so de l'atac i en fa una representació gràfica
fn.def representa_atac(x,y,so_espasa, imatge_atac)
  audio.play so_espasa
  get_casella_a_coordenades(x,y,&casella_x, &casella_y)
  get_coordenades_casella(casella_x, casella_y, &nova_x, &nova_y)
  nova_x = nova_x-20
  nova_y = nova_y-20
  gr.modify imatge_atac,"x",nova_x
  gr.modify imatge_atac,"y",nova_y
  gr.render
  pause 110
  gr.modify imatge_atac,"x",-400
  gr.modify imatge_atac,"y",-400
  gr.render
  do
    audio.isdone  done
    if done then d_u.break
    pause 10
  until 0
  audio.stop
  fn.rtn 1
fn.end  
    

dim palillos[2,3]
audio.load so_palillo, "../../git-projects/lluita-paneroles/resources/lluita-mou-palillo.mp3"
audio.load so_moviment, "../../git-projects/lluita-paneroles/resources/lluita-mou-peca.mp3"
AUDIO.LOAD so_error, "../../git-projects/lluita-paneroles/resources/lluita-error.mp3"
AUDIO.LOAD so_mort, "../../git-projects/lluita-paneroles/resources/lluita-mort.mp3"
audio.load so_espasa, "../../git-projects/lluita-paneroles/resources/lluita-espasa.mp3"
quants=4
gr.open 255,200,200,200
taulell=dibuixa_taulell(0)
bundle.get taulell, "panell_info", panell
call crea_palillos(palillos[])
print "despres crear palillos"
call debug_palillos(palillos[])
REM crea jugadors
 dim jugadors[4]
  for i=1 to quants
    jugadors[i] = crea_jugador(i)
  next i
  REM fi de crea jugadors
dibuix_explosio = crea_explosio()
torn=1
selecciona_torn(torn,jugadors)
posiciona_vides_tots_jugadors(jugadors[])
gr.render
do
  do
    gr.touch touched,x,y
  until touched
  if (touched) 
    posiciona_vides_tots_jugadors(jugadors[])
    print "Abans de ha_de_moure_palillo"
    if (ha_de_moure_palillo(palillos[],x,y,jugadors[torn])=1)
      mou_palillo(palillos[],jugadors[torn],x,y)
      gr.render
      play_so(so_palillo)
    else
      if (vol_atacar(torn,jugadors[],x,y)=1)
        if (ataca(torn,jugadors[],x,y, so_mort)=1)
          representa_atac(x,y,so_espasa, dibuix_explosio)
        endif
      else  
        tocat_possible = tocat_desti_possible(taulell,jugadors[torn],x,y, palillos[], jugadors[], torn)
        print "tocat_possible="+str$(tocat_possible)
        if (tocat_possible=1)
          print "tocat_possible=true"
          mou_jugador(torn, taulell, jugadors[torn],x,y)
          posiciona_vides_tots_jugadors(jugadors[])
          gr.render
          play_so(so_moviment)
        else
          play_so(so_error)
        endif
      endif
    endif
    if (acabat_torn(jugadors[torn])=1) 
      torn=passa_torn(torn,jugadors[torn], quants, jugadors[])
    end if
  endif
  actualitza_panell(jugadors[torn], torn, panell)
  posiciona_vides_tots_jugadors(jugadors[])
  gr.render
  pause 500
until false

