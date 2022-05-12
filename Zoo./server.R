source('db_con.R')
library(shiny)
library(DT)
library(shinyalert)

shinyServer(function(input, output, session) {
  observeEvent(input$jump_to_man, {
    updateTabsetPanel(session, "inTabset",selected = "Manager")
  })
  observeEvent(input$jump_to_clean, {
    updateTabsetPanel(session, "inTabset",selected = "Sprzatacz")
  })
  observeEvent(input$jump_to_kasjer, {
    updateTabsetPanel(session, "inTabset",selected = "Kasjer")
  })
  observeEvent(input$jump_to_wet, {
    updateTabsetPanel(session, "inTabset",selected = "Weterynarz")
  })
  observeEvent(input$jump_to_op, {
    updateTabsetPanel(session, "inTabset",selected = "Opiekun")
  })
  ##kasjer
  output$kasjer_id <- DT::renderDataTable({
    if (input$kasjer_id == "bilety"){
      return(dbGetQuery(con, "SELECT * FROM bilety;"))
    }
    if (input$kasjer_id == "sprzedane bilety"){
      return(dbGetQuery(con, "SELECT * FROM sprzedane_bilety ORDER BY id DESC;"))
    }
  })
  
  
  observeEvent(input$bilet_dodaj_id, {
    if(input$liczba_biletow_id <= 999 && input$liczba_biletow_id >= 1){
      if(!((input$rodzaj_biletu_id == "grupowy_normalny" || input$rodzaj_biletu_id == "grupowy_uczniowski" || input$rodzaj_biletu_id == "grupowy_studencki") && input$liczba_biletow_id < 10)){
        rodzaj <- input$rodzaj_biletu_id
        
        ilosc <- input$liczba_biletow_id
        
        #data <- input$data_sprzedaży_id
        
        sql <- paste0("INSERT INTO sprzedane_bilety(rodzaj, ilosc) VALUES('", rodzaj, "', ", ilosc,");")
        dbSendQuery(con, sql)
      }
      else(print("niepoprawna liczba biletow dla grupy"))
    }
    else(print("niepoprawna liczba biletow"))
  })
  
  ##opiekun
  output$ui_assetClass <- renderUI({
    do_karmienia <- dbGetQuery(con, "SELECT id_zwierzaka FROM do_nakarmienia;")
    if (length(do_karmienia) >= 1){
    selectInput('karm_id',
                label ='Wybierz zwierzaka do nakarmienia',
                choices=do_karmienia)}})
 
  
  output$karmienie_id <- DT::renderDataTable({
    if (input$poka_karm_id == "Do nakarmienia"){
      return(dbGetQuery(con, "SELECT * FROM do_nakarmienia;"))
    }
    if (input$poka_karm_id == "Historia karmienia"){
      return(dbGetQuery(con, "SELECT * FROM karmienie ORDER BY dzien_karmienia DESC, godzina_karmienia DESC;"))
    }
    })
  
  observeEvent(input$poka_jedzenie_id, {
    output$jedzenie_id <- DT::renderDataTable({
      return(dbGetQuery(con, "SELECT * FROM zapasy WHERE rodzaj = 'jedzenie';"))
    })
  })
 
 
  observeEvent(input$nakarm_id, {
    id <- input$karm_id
    if (is.null(id)){
      id <- dbGetQuery(con, "SELECT id_zwierzaka FROM do_nakarmienia;")
    }
    print(id)
    if(!(id == "")){
      produkt <- dbGetQuery(con, paste0("SELECT pozywienie FROM do_nakarmienia WHERE id_zwierzaka = ", id, ";"))
      zapas <- dbGetQuery(con, paste0("SELECT ilosc FROM zapasy WHERE produkt = '", produkt, "';"))
      ilosc <- dbGetQuery(con, paste0("SELECT ile_pozywienia FROM do_nakarmienia WHERE id_zwierzaka = ", id, ";"))
      if (zapas >= ilosc){
        sql <- paste0("INSERT INTO karmienie(id_zwierzaka) VALUES(", id, ");")
        dbSendQuery(con, sql)
        print("nakarmiono zwierzaka")
      } else { print("nie ma wystarczajco pozywienia")}
    }
  })
  
  ##manager
  output$finanse_id <- DT::renderDataTable({
    if (input$tabele_finanse_id == "Stan zapasów"){
      return(dbGetQuery(con, "SELECT * FROM zapasy;"))
    }
    if (input$tabele_finanse_id == "Potrzeby na jutro"){
      return(dbGetQuery(con, "SELECT * FROM ile_jedzenia;"))
    }
    if (input$tabele_finanse_id == "Historia zamówien"){
      return(dbGetQuery(con, "SELECT * FROM zamowienia;"))
    }
    if (input$tabele_finanse_id == "Suma pensji"){
      return(dbGetQuery(con, "SELECT * FROM wydatki_na_pensje;"))
    }
  })
  
  observeEvent(input$show_wydatki_id, {
    output$wydatki_zapasy_id <- DT::renderDataTable({
        sql <- paste0("SELECT * FROM pokaz_wydatki('", input$daterange2[1], "','",input$daterange2[2], "');")
        return(dbGetQuery(con, sql))
    })
  })
  
  observeEvent(input$show_dochody_id, {
    output$dochody_id <- DT::renderDataTable({
      sql <- paste0("SELECT * FROM pokaz_dochody('", input$daterange3[1], "','",input$daterange3[2], "');")
      return(dbGetQuery(con, sql))
    })
  })
  
  observeEvent(input$show_dzisiaj_id, {
    output$dochody_dzisiaj_id <- DT::renderDataTable({
      sql <- paste0("SELECT * FROM suma_dzisiaj();")
      return(dbGetQuery(con, sql))
    })
  })
  
  output$suma_zamowienia <- renderPrint({
    produkt <- input$produkty_id
    ile <- input$ile_id
    cena <- dbGetQuery(con, paste0("SELECT cena_jednostkowa FROM zapasy WHERE produkt ='", produkt, "';"))
    
    return(paste("Koszt tego zamowienia: ", cena*ile))})
  
  observeEvent(input$zamow_id, {
    id_man <- as.integer(input$menager_zam_id)
    produkt <- input$produkty_id
    ile <- input$ile_id
    cena <- dbGetQuery(con, paste0("SELECT cena_jednostkowa FROM zapasy WHERE produkt ='", produkt, "';"))
    sql <- paste0("INSERT INTO zamowienia VALUES(", id_man, ",'", produkt, "',", ile, ",'", input$data_zam_id, "','", input$data_dost_id, "');" )
    dbGetQuery(con, sql)
    shinyalert("Zamowienie", text = paste0("Pomyslnie zlozono zamowienie na ", produkt, " w ilosci ", ile), type = "info")
    })
  
  output$personel_id <- DT::renderDataTable({
    if (input$tabele_personel_id == "Pracownicy"){
      return(dbGetQuery(con, "SELECT * FROM pracownicy;"))
    }
    if (input$tabele_personel_id == "Stanowiska"){
      return(dbGetQuery(con, "SELECT * FROM stanowiska;"))
    }
    if (input$tabele_personel_id == "Ilosc personelu"){
      return(dbGetQuery(con, "SELECT * FROM ile_pracownikow_na_stanowisku;"))
    }
    if (input$tabele_personel_id == "Ilosc podopiecznych"){
      return(dbGetQuery(con, "SELECT * FROM ile_zwierzat_ma_opiekun ORDER BY liczba_zwierzat DESC;"))
    }
    })
  
  output$zwierzaki_op_id <-  DT::renderDataTable({
     id <- input$zwierzaki_opiekuna_id
     if (id != " "){
     sql <- paste0("SELECT * FROM zwierzaki_opiekuna(", id, ");")
     return(dbGetQuery(con, sql))}
   })
  
  observeEvent(input$show_treatment_id, {
    output$vet_treat1_id <- DT::renderDataTable({
      if(input$vet_treat_id != " "){
      sql <- paste0("SELECT * FROM pokaz_zabiegi('", input$daterange1[1], "','",input$daterange1[2], "',", input$vet_treat_id, ");" )
      return(dbGetQuery(con, sql))}
    })
  })
  
  output$stanowiska_o_id <-  DT::renderDataTable({
    stan <- input$stanowiska_id
    if (stan != " "){
      sql <- paste0("SELECT * FROM pokaz_pracownikow('", stan, "');")
      return(dbGetQuery(con, sql))}
  })
  
  observeEvent(input$zmien_op_id, {
    if(input$zmien_opiekuna_id != " " && input$nowy_opiekun_id != " "){
    id_zwierz <- as.integer(input$zmien_opiekuna_id)
    id_new_op <- as.integer(input$nowy_opiekun_id)
    sql <- paste0("SELECT * FROM zmien_opiekuna(", id_zwierz, ",",id_new_op, ");" )
    dbGetQuery(con, sql)
    shinyalert("Zmieniono opiekuna", text = paste0('nowy opiekun zwierzaka ', id_zwierz, ' ma id ', id_new_op), type = "info")}
  })
  
  observeEvent(input$zwolnij1_id, {
    id_zwolnionego <- as.integer(input$zwolnij_id)
    if(id_zwolnionego != " "){
        sql <- paste0("SELECT * FROM zwolnij(", id_zwolnionego,");" )
        dbGetQuery(con, sql)
        shinyalert("Zwolniono pracownika", text = paste0('id zwolnionego:  ', id_zwolnionego), type = "info")
      }
  })
  
  ### zrobic zeby komunikaty znikaly
  observeEvent(input$zatrudnij_id, {
    imie <- str_trim(input$imie_id)
    nazwisko <- str_trim(input$nazwisko_id)
    telefon <- str_trim(input$telefon_id)
    mail <- str_trim(input$mail_id)
    stan <- input$stanowiska1_id
    if(imie != "" && nazwisko != "" && telefon != "" && mail != "" && stan != " "){
        sql <- paste0("SELECT * FROM zatrudnij('", stan, "','", imie, "','", nazwisko,"','", telefon, "','", mail, "');" )
        dbGetQuery(con, sql)
        shinyalert("Zatrudniono pracownika", text = paste0('nowy pracownik:  ', imie,' ', nazwisko, ' na stanowisku ',stan), type = "info")
  } else {
          return("Uzupelnij wszystkie dane nowego pracownika!")}
  })
  
  # ja zrobilem dla zakoncz dzien
  output$zakoncz_tabele_id <- DT::renderDataTable({
    if (input$zakoncz_tabele_id == "Do nakarmienia"){
      return(dbGetQuery(con, "SELECT * FROM do_nakarmienia;"))
    }
    if (input$zakoncz_tabele_id == "Do posprzatania"){
      return(dbGetQuery(con,  "SELECT * FROM do_sprzatania;"))
    }
  })
  
  output$dzien_id <- renderPrint({
    return(dbGetQuery(con, "SELECT * FROM dzisiejsza_data;"))
  })
  output$dzien2_id <- renderPrint({
    x <- dbGetQuery(con, "SELECT * FROM dzisiejsza_data;")
    return(print(x[1,1]))
  })
  
  observeEvent(input$zakoncz_dzien_id, {
    x <- dbGetQuery(con, "SELECT count(*) FROM do_sprzatania;")
    y <- dbGetQuery(con, "SELECT count(*) FROM do_nakarmienia;")
    output$zakonczenie_id <- renderPrint({
      if(x == 0 && y == 0){ return("Wszystkie zadania wykonane! Do jutra :) ")} 
      else {return("Zostaly zwierzeta do nakarmienia lub wybiegi do posprzatania!")}
      })
    })
  
  observeEvent(input$otworz_dzien_id, {
    x <- dbGetQuery(con, "SELECT count(*) FROM do_sprzatania;")
    y <- dbGetQuery(con, "SELECT count(*) FROM do_nakarmienia;")
    
    output$rozpoczecie_id <- renderPrint({
       x <- dbGetQuery(con, "SELECT * FROM zmien_date();")
      return(x[1,1])
      })
  })
  
  
  output$zwierzeta_id <- DT::renderDataTable({
    if (input$tabele_zwierzeta_id == "Gatunki"){
      return(dbGetQuery(con, "SELECT * FROM gatunki;"))
    }
    if (input$tabele_zwierzeta_id == "Zwierzeta"){
      return(dbGetQuery(con, "SELECT * FROM zwierzeta;"))
    }
    if (input$tabele_zwierzeta_id == "Liczba okazów"){
      return(dbGetQuery(con, "SELECT * FROM ile_zwierzat_w_gatunku ORDER BY liczba_okazow DESC;"))
    }
    if (input$tabele_zwierzeta_id == "Wybiegi"){
      return(dbGetQuery(con, "SELECT * FROM wybiegi;"))
    }
    if (input$tabele_zwierzeta_id == "Ilosc wybiegów"){
      return(dbGetQuery(con, "SELECT * FROM liczba_wybiegow;"))
    }
    if (input$tabele_zwierzeta_id == "Ilosc zwierzat na wybiegach"){
      return(dbGetQuery(con, "SELECT * FROM liczba_zwierzat_na_wybiegu;"))
    }
  })
  
  output$ui_wybieg <- renderUI({
    typ_wybiegu <- input$typ_wybiegu_id
    ktore_wybiegi <- dbGetQuery(con, paste0("SELECT id FROM wybiegi WHERE typ_wybiegu = '", typ_wybiegu, "';"))
    selectInput('wybierz_id_wybiegu',
                label ='Wybierz id wybiegu',
                choices=ktore_wybiegi)})
  
  observeEvent(input$dodaj_gatunek_id, {
    nazwa <- str_trim(input$nazwa_gatunku_id)
    strefa <- input$strefa_klimatyczna_id
    pozywienie <- input$pozywienie_id
    drapieznik <- input$czy_drapieznik_id
    typ_wybiegu <- input$typ_wybiegu_id
    czest_jedz <- input$czestosc_jedz_id
    ilosc_pokarmu <- input$ilosc_pokarmu_id
    id_wybiegu <- input$wybierz_id_wybiegu
    output$dodanie_gatunku_id <- renderPrint({
      if(nazwa != "" && strefa != " " && pozywienie != " " && drapieznik != " " && typ_wybiegu != " " && czest_jedz != " " && ilosc_pokarmu != " " && id_wybiegu != " "){
        sql <- paste0("SELECT * FROM dodaj_gatunek('", nazwa, "','", strefa, "','", pozywienie,"',", drapieznik, ",'", typ_wybiegu, "','", czest_jedz,"','",ilosc_pokarmu,"','", id_wybiegu, "');" )
        return(dbGetQuery(con, sql))} else {
          return("Uzupelnij wszystkie dane nowego gatunku!")}
    })
  })
  
  observeEvent(input$dodaj_zwierzaka_id, { # jest tu (chyba tu) jakis problem idk jaki: 'missing value where TRUE/FALSE needed'
    nazwa <- input$wybierz_gatunek_id
    imie <- str_trim(input$imie_zw_id)
    opiekun <- input$wybierz_opiekuna_id
    plec <- input$wybierz_plec_id
    urodziny <- str_trim(input$data_urodzin_id)
    karmienie <- input$dni_do_karmienia_id
    output$dodanie_zwierzaka_id <- renderPrint({
      if(nazwa != " " && imie != "" && opiekun != " " && plec != " " && urodziny != " " && karmienie != " "){ 
        sql <- paste0("SELECT * FROM dodaj_zwierze('", nazwa, "','", imie, "',", opiekun,",'", plec, "','", urodziny,"','",karmienie,"');" )
        return(dbGetQuery(con, sql))} else {
          return("Uzupelnij wszystkie dane nowego zwierzaka!")}
    })
  })
  
  observeEvent(input$usun_zwierze_id, {
    id_zwierzecia <- as.integer(input$usun_zw_id)
    if(id_zwierzecia != " "){
      sql <- paste0("SELECT * FROM usun_zwierze(", id_zwierzecia,");" )
      dbGetQuery(con, sql)
      shinyalert("Usunieto zwierzaka", text = paste0('id zwierzaka:  ', id_zwierzecia), type = "info")
    }
  })
  
  output$tabela_zwierzakow_id <-  DT::renderDataTable({
    gatunek <- input$tabela_zwierzakow_id
    if (gatunek != " "){
      sql <- paste0("SELECT * FROM pokaz_gatunek('", gatunek, "');")
      return(dbGetQuery(con, sql))}
  })
  
  observeEvent(input$usun_gatunek_id, {
    nazwa_gat <- input$usun_gat_id
    if(nazwa_gat != " "){
      sql <- paste0("SELECT * FROM usun_gatunek(", id_zwierzecia,");" )
      dbGetQuery(con, sql)
      shinyalert("Usunieto zwierzaka", text = paste0('id zwierzaka:  ', id_zwierzecia), type = "info")
    }
  })
  
  
  ##weterynarz
  output$weterynarz_id <- DT::renderDataTable({
    if (input$weterynarz_id == "badane dawniej niz 30"){
      return(dbGetQuery(con, "SELECT * FROM bad_dawniej_niz_30;"))
    }
    if (input$weterynarz_id == "badania"){
      return(dbGetQuery(con, "SELECT * FROM badania"))
    }
    if (input$weterynarz_id == "zabiegi"){
      return(dbGetQuery(con, "SELECT * FROM zabiegi"))
    }
  })
  
  observeEvent(input$wykonaj_zabieg_id, {
    if(input$ilosc_leku_id <= 99 && input$ilosc_leku_id >= 1){
      id_zwierzaka <- input$id_zwierzaka_id
      
      id_weterynarza <- input$id_weterynarza_id
      
      zabieg <- input$rodzaj_zabiegu_id
      
      ilosc_leku <- input$ilosc_leku_id
      
      lek <- dbGetQuery(con, paste0("SELECT rodzaj_leku FROM zabiegi WHERE rodzaj_zabiegu = '", zabieg, "';"))
      stan <- dbGetQuery(con, paste0("SELECT ilosc FROM zapasy WHERE produkt = '", lek, "';"))
      if (ilosc_leku <= stan){
      
      sql <- paste0("INSERT INTO badania(id_zwierzaka, id_weterynarza, zabieg, ilosc_leku) VALUES('", id_zwierzaka, "','", id_weterynarza,"','", zabieg,"', ",ilosc_leku, ");")
      dbSendQuery(con, sql)
      print("wykonano zabieg")
      }else(print("nie ma wystarczajaco leku"))
      }
    else(print("niepoprawna ilosc leku"))
  })
  
  ##sprzatacz
  output$ui_sprzatacz <- renderUI({
    do_sprzatania <-   dbGetQuery(con, "SELECT id_wybiegu FROM do_sprzatania;")                        
    selectInput(inputId = "id_wybiegu_id", 
                  label = "Wybierz wybieg do posprzątania", 
                  choices =do_sprzatania)})
  
  output$sprzatacz_id <- DT::renderDataTable({
    if (input$sprzatacz_id == "Wybiegi do posprzatania"){
      return(dbGetQuery(con, "SELECT * FROM do_sprzatania;"))
    }
    if (input$sprzatacz_id == "Wybiegi"){
      return(dbGetQuery(con, "SELECT * FROM wybiegi"))
    }
    if (input$sprzatacz_id == "Historia sprzatania"){
      return(dbGetQuery(con, "SELECT * FROM sprzatanie"))
    }
  })
  
  
  observeEvent(input$posprzataj_id, {
    id_sprzatajacego <- input$id_sprzatacza_id
    
    id_wybiegu <- input$id_wybiegu_id
    if (id_wybiegu!=""){
    sql <- paste0("INSERT INTO sprzatanie(id_sprzatajacego, id_wybiegu) VALUES('", id_sprzatajacego, "',", id_wybiegu,");")
    dbSendQuery(con, sql)
    
    sql <- paste0("UPDATE wybiegi SET dni_do_sprzatania = czestotliwosc_sprzatania WHERE id = ", id_wybiegu,";")
    dbSendQuery(con, sql)
    print('posprzatano')
    }
  })
  
  
  
  

  
})
