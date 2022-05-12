
library(shiny)
library(shinyalert)
library(shinythemes)
library(rintrojs)
library(packrat)
library(rsconnect)
library(stringr)

shinyUI(
  fluidPage(theme = shinytheme("sandstone"),
            useShinyalert(),
    tabsetPanel(id = 'inTabset',
      tabPanel(
        title = "Strona glówna", icon = icon("home"),
        mainPanel(
                  fluidRow(h1("Witamy w bazie danych najlepszego zoo!!"), style="margin-top:0px;"),
                  fluidRow(h3("Wybierz swoje stanowisko"), style="margin-top:0px;"),
                  fluidRow(
                    actionButton('jump_to_man', label = "Manager", icon = icon('crown')),     
                    actionButton('jump_to_kasjer', label = "Kasjer", icon = icon('ticket-alt')),
                    actionButton('jump_to_wet', label = "Weterynarz", icon = icon('clinic-medical')),
                    actionButton('jump_to_op', label = "Opiekun", icon = icon('paw')),
                    actionButton('jump_to_clean', label = "Sprzatacz", icon = icon('broom'))
                      ),
                  fluidRow(h4("Dzisiejsza data: "), style="margin-top:0px;"),
                  fluidRow(verbatimTextOutput(outputId = "dzien2_id")
                    
                  )
                  
                  
        ) #main Panel bracket
      ),# tab panel bracket
      tabPanel( 'Kasjer', icon = icon('ticket-alt'),
                sidebarLayout(
                  sidebarPanel(selectInput(inputId = "kasjer_id", label = "Wybierz tabele",
                                           c("bilety", "sprzedane bilety")),
                               selectInput(inputId = "rodzaj_biletu_id", label = "Wybierz rodzaj biletu", c('normalny','uczniowski','studencki','dla_seniora','rodzinny','przewodnik','dzieci','grupowy_normalny','grupowy_uczniowski','grupowy_studencki')),
                               numericInput(inputId = "liczba_biletow_id", label = "Wpisz liczbe biletow", value = 1, min = 1, max = 999),
                               #selectInput(inputId = "data_sprzedaży_id", label = "Data sprzedazy", choices = dbGetQuery(con, "SELECT dzisiaj FROM dzisiejsza_data;")),
                               actionButton(inputId = "bilet_dodaj_id", label = "Sprzedaj bilet")),
                  
                  mainPanel(
                    DT::dataTableOutput(outputId = "kasjer_id")
                  ))),
      tabPanel('Opiekun',icon = icon('paw'),
               sidebarLayout(
                 sidebarPanel(
                   selectInput(inputId = "poka_karm_id", label = "Wybierz tabele", choices = c("Do nakarmienia","Historia karmienia")),
                   actionButton(inputId = "poka_jedzenie_id", label = "Pokaż stan zapasów"),
                   uiOutput('ui_assetClass'),
                   actionButton(inputId = "nakarm_id", label = "Nakarm!")

                   ),
                 mainPanel(
                   DT::dataTableOutput(outputId = "karmienie_id"),
                   DT::dataTableOutput(outputId = "jedzenie_id")
               ))),
      tabPanel('Weterynarz',icon = icon('clinic-medical'),
               sidebarLayout(
                 sidebarPanel(selectInput(inputId = "weterynarz_id", label = "Wybierz tabele",
                                          c("badane dawniej niz 30", "badania", "zabiegi")),
                              selectInput(inputId = "id_zwierzaka_id", label = "Wybierz id zwierzaka", choices = dbGetQuery(con, "SELECT id FROM zwierzeta;" )),
                              selectInput(inputId = "id_weterynarza_id", label = "Wybierz id weterynarza", choices = dbGetQuery(con, "SELECT id FROM pracownicy WHERE stanowisko = 'weterynarz';")),
                              selectInput(inputId = "rodzaj_zabiegu_id", label = "Wybierz rodzaj zabiegu", c('zlamanie_konczyny', 'zwichniecie_konczyny', 'usmierzenie_bolu', 'zabieg_dentystyczny', 'narkoza', 'rutynowe_badanie')),
                              numericInput(inputId = "ilosc_leku_id", label = "Wpisz ilosc leku", value = 1, min = 1, max = 99),
                              actionButton(inputId = "wykonaj_zabieg_id", label = "Wykonaj zabieg")),
                 mainPanel(
                   DT::dataTableOutput(outputId = "weterynarz_id")
                 ))),
      tabPanel('Sprzatacz',icon = icon('broom'),
               sidebarLayout(
                 sidebarPanel(selectInput(inputId = "sprzatacz_id", label = "Wybierz tabele",
                                          c("Wybiegi do posprzatania", "Wybiegi", "Historia sprzatania")),
                              selectInput(inputId = "id_sprzatacza_id", label = "Wybierz id sprzątającego", choices = dbGetQuery(con, "SELECT id FROM pracownicy WHERE stanowisko = 'sprzatacz';")),
                              uiOutput('ui_sprzatacz'),
                              actionButton(inputId = "posprzataj_id", label = "Posprzątaj")),
                 mainPanel(
                   DT::dataTableOutput(outputId = "sprzatacz_id")
                 )
               )),
      tabPanel('Manager',icon = icon('crown'),
               tabsetPanel(
                 tabPanel("Finanse",
                  sidebarLayout(
                    sidebarPanel(
                      selectInput(inputId = "tabele_finanse_id", label = "Wybierz tabele", 
                               choices = c(" ", "Stan zapasów", "Potrzeby na jutro", "Historia zamówien", "Suma pensji")),
                      dateRangeInput("daterange2", "Wybierz okres, w ciagu którego chcesz zobaczyć wydatki:",
                                     min    = "2010-01-01",
                                     max    = Sys.Date(),
                                     format = "mm/dd/yy",
                                     separator = " - "),
                      actionButton("show_wydatki_id", label = 'Pokaz wydatki'),
                      dateRangeInput("daterange3", "Wybierz okres, w ciagu którego chcesz zobaczyć dochody z biletów:",
                                     min    = "2010-01-01",
                                     max    = Sys.Date(),
                                     format = "mm/dd/yy",
                                     separator = " - "),
                      actionButton("show_dochody_id", label = 'Pokaz dochody'),
                      hr(),
                      actionButton("show_dzisiaj_id", label = 'Pokaz dochody z biletów z dzisiaj'),
                      
                      selectInput(inputId = "produkty_id", label = "Wybierz jaki produkt chcesz zamowic:", 
                                  choices =c(dbGetQuery(con, "SELECT produkt FROM zapasy;" ))),
                      numericInput(inputId = "ile_id", label = "Wpisz ilosc produktu:", value = 1, min = 1, max = 10000),
                      verbatimTextOutput('suma_zamowienia'),
                      selectInput(inputId = "menager_zam_id", label = "Wybierz swoje id:", 
                                  choices =c(dbGetQuery(con, "SELECT id FROM pracownicy WHERE stanowisko = 'menager';" ))),
                      
                      dateInput('data_zam_id', label = "Wybierz date zamowienia:", value = Sys.Date(), min = Sys.Date()-2, max= Sys.Date()+2),
                      dateInput('data_dost_id', label = "Wybierz date dostawy:", value = Sys.Date()+1, min = Sys.Date(), max= Sys.Date()+20),
                      actionButton("zamow_id", label = 'Zloz zamowienie')
                      
                 ),
                 mainPanel(
                   DT::dataTableOutput(outputId = "finanse_id"),
                   DT::dataTableOutput(outputId = "wydatki_zapasy_id"),
                   DT::dataTableOutput(outputId = "dochody_id"),
                   DT::dataTableOutput(outputId = "dochody_dzisiaj_id")
                   
                 )
                  )),
                tabPanel("Personel",
                         sidebarLayout(
                           sidebarPanel(
                             selectInput(inputId = "tabele_personel_id", label = "Wybierz tabele", 
                                         choices = c("  ","Pracownicy", "Stanowiska", "Ilosc personelu", "Ilosc podopiecznych")),
                             selectInput(inputId = "zwierzaki_opiekuna_id", label = "Wybierz opiekuna, którego podopiecznych chcesz zobaczyc", 
                                         choices = c(" ", dbGetQuery(con, "SELECT id FROM pracownicy WHERE stanowisko = 'opiekun';" ))),
                             
                            
                             selectInput(inputId = "zmien_opiekuna_id", label = "Wybierz zwierze, ktorego opiekuna chcesz zmienic:", 
                                         choices = c(" ", dbGetQuery(con, "SELECT id FROM zwierzeta ORDER BY id ASC;" ))),
                             selectInput(inputId = "nowy_opiekun_id", label = "Wybierz dla niego nowego opiekuna", 
                                         choices = c(" ", dbGetQuery(con, "SELECT id FROM pracownicy WHERE stanowisko = 'opiekun';" ))),
                             actionButton("zmien_op_id", label = 'Zmien opiekuna'),
                             
                             
                             selectInput(inputId = "vet_treat_id", label = "Wybierz weterynarza, którego zabiegi chcesz zobaczyc", 
                                         choices = c(" ", dbGetQuery(con, "SELECT id FROM pracownicy WHERE stanowisko = 'weterynarz';" ))),
                             dateRangeInput("daterange1", "Przedzial zabiegow:",
                                            min    = "2010-01-01",
                                            max    = "Sys.Date()",
                                            format = "mm/dd/yy",
                                            separator = " - "),
                             actionButton("show_treatment_id", label = 'Pokaz wykonane zabiegi!'),
                             
                             ##trzeba dorobic zeby ci ktorzy sa zwolnieni juz sie nie pokazywali
                             selectInput(inputId = "stanowiska_id", label = "Wybierz stanowisko, zeby wyswietlic pracownikow:", 
                                         choices = c(" ", dbGetQuery(con, "SELECT nazwa FROM stanowiska;"))),
                             selectInput(inputId = "zwolnij_id", label = "Wybierz pracownika, ktorego chcesz zwolnic:", 
                                         choices = c(" ", dbGetQuery(con, "SELECT id FROM pracownicy ORDER BY id ASC;"))),
                             actionButton("zwolnij1_id", label = 'Zwolnij'),
                             
                             
                             textInput(inputId = 'imie_id', label= "Wpisz imie nowego pracownika:", value = ""),
                             textInput(inputId = 'nazwisko_id', label= "Wpisz nazwisko nowego pracownika:", value = ""),
                             textInput(inputId = 'telefon_id', label= "Wpisz telefon nowego pracownika:", value = ""),
                             textInput(inputId = 'mail_id', label= "Wpisz mail nowego pracownika:", value = ""),
                             selectInput(inputId = "stanowiska1_id", label = "Wybierz stanowisko, na ktore chcesz zatrudnic:", 
                                         choices = c(" ", dbGetQuery(con, "SELECT nazwa FROM stanowiska;"))),
                             actionButton("zatrudnij_id", label = 'Zatrudnij')
                             ),
                           mainPanel(
                             DT::dataTableOutput(outputId = "personel_id"),
                             DT::dataTableOutput(outputId = "zwierzaki_op_id"),
                             DT::dataTableOutput(outputId = "vet_treat1_id"),
                             DT::dataTableOutput(outputId = "stanowiska_o_id")
                             )
                         )),
                tabPanel("Zwierzeta",
                         sidebarLayout(
                           sidebarPanel(
                             selectInput(inputId = "tabele_zwierzeta_id", label = "Wybierz tabele", 
                                         choices = c("Gatunki", "Zwierzeta", "Liczba okazów", 
                                                     "Wybiegi", "Ilosc wybiegów","Ilosc zwierzat na wybiegach")),
                             
                             textInput(inputId = 'nazwa_gatunku_id', label= "Wpisz nazwe nowego gatunku:", value = ""),
                             selectInput(inputId = 'strefa_klimatyczna_id', label= "Wybierz strefe klimatyczna:", 
                                         choices = c('okolobiegunowa', 'umiarkowana', 'miedzyzwrotnikowa', 'ocean')),
                             selectInput(inputId = 'pozywienie_id', label= "Wybierz rodzaj pozywienia:", 
                                         choices = c('mieso', 'siano', 'warzywa', 'owoce', 'ryby', 'owady', 'skorupiaki', 'karma_dla_ryb')),
                             selectInput(inputId = 'czy_drapieznik_id', label= "Czy drapieznik?:", 
                                         choices = c(T, F)),
                             selectInput(inputId = 'typ_wybiegu_id', label= "Wybierz typ wybiegu:", 
                                         choices = c('arktyczny', 'lesny', 'trawiasty', 'sawanna', 'dzungla', 'pustynny', 'gorski', 'akwarium', 'terrarium', 'ptaszarnia', 'afrykarium', 'mokradla')),
                             numericInput(inputId = "czestosc_jedz_id", label = "Wpisz czestotliwosc karmienia:", value = 7, min = 1, max = 39),
                             numericInput(inputId = "ilosc_pokarmu_id", label = "Wpisz ilosc pokarmu:", value = 1, min = 1, max = 19),
                             uiOutput('ui_wybieg'),
                             #selectInput(inputId = "wybierz_id_wybiegu", label = "Wybierz id wybiegu:", 
                                         #choices = c(" ", dbGetQuery(con, "SELECT id FROM wybiegi;"))),
                            
                             actionButton("dodaj_gatunek_id", label = 'Dodaj gatunek'),
                             
                             selectInput(inputId = 'wybierz_gatunek_id', label = "Wybierz gatunek", 
                                         choices = c(" ", dbGetQuery(con, "SELECT nazwa FROM gatunki;"))),
                             textInput(inputId = 'imie_zw_id', label= "Wpisz imie nowego zwierzaka:", value = ""),
                             selectInput(inputId = 'wybierz_opiekuna_id', label= "Wybierz opiekuna:", 
                                         choices = c(" ", dbGetQuery(con, "SELECT id FROM pracownicy WHERE stanowisko = 'opiekun';"))),
                             selectInput(inputId = 'wybierz_plec_id', label= "Wybierz plec:", 
                                         choices = c("M", "F")),
                             dateInput('data_urodzin_id', label = "Wybierz date urodzin zwierzaka:", value = Sys.Date(), min = Sys.Date()-4000, max= Sys.Date()),
                             numericInput(inputId = "dni_do_karmienia_id", label = "Wpisz dni do karmienia:", value = 7, min = 1, max = 39),
                             actionButton("dodaj_zwierzaka_id", label = 'Dodaj zwierzaka'),
                             
                             selectInput(inputId = "tabela_zwierzakow_id", label = "Wybierz gatunek, zeby wyswietlic zwierzeta:", 
                                         choices = c(" ", dbGetQuery(con, "SELECT nazwa FROM gatunki;"))),
                             selectInput(inputId = "usun_zw_id", label = "Wybierz id zwierzaka, ktorego chcesz usunac:", 
                                         choices = c(" ", dbGetQuery(con, "SELECT id FROM zwierzeta ORDER BY id ASC"))),
                             actionButton("usun_zwierze_id", label = 'Usun zwierze'),
                             
                             selectInput(inputId = "usun_gat_id", label = "Wybierz gatunek, ktory chcesz usunac:",
                                         choices = c(" ", dbGetQuery(con, "SELECT nazwa FROM gatunki;"))),
                             actionButton("usun_gatunek_id", label = 'Usun gatunek')
                             
                             
                             
                           ),
                           mainPanel(
                             DT::dataTableOutput(outputId = "zwierzeta_id"),
                             DT::dataTableOutput(outputId = "tabela_zwierzakow_id"),
                             verbatimTextOutput("dodanie_gatunku_id"),
                             verbatimTextOutput("dodanie_zwierzaka_id"),
                             verbatimTextOutput("usuniecie_zwierzaka_id")
                           )
                         )),
                tabPanel("Zakoncz dzien",
                         sidebarLayout(
                           sidebarPanel(
                             actionButton("otworz_dzien_id", label = 'Otworz dzien'),
                             hr(),
                             selectInput(inputId = "zakoncz_tabele_id", label = "Wybierz tabele",
                                                    c("Do nakarmienia", "Do posprzatania")),
                             actionButton("zakoncz_dzien_id", label = 'Zakoncz dzien'),
                             hr(),
                             verbatimTextOutput(outputId = "dzien_id")
                             
                           ),
                           mainPanel(
                             DT::dataTableOutput(outputId = "zakoncz_tabele_id"),
                             verbatimTextOutput("zakonczenie_id"),
                             verbatimTextOutput("rozpoczecie_id")
                           )
                         ))
                
               )
          )
      ))
    )
