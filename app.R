library(shiny)
library(shinydashboard)
library(plotly)
library(dplyr)
library(tidyr)
library(rlang)
library(htmlwidgets)
library(highcharter)
library(geojsonio)

data_tik <- read.csv("databar.csv",header = TRUE,stringsAsFactors = FALSE)
indo.json <- geojsonio::geojson_read("indonesia-prov.json", what = "list")
data_IPM <- read.csv("IPM_full.csv")
indo_IPM = read.csv("indoIPM.csv")
data_APS = read.csv("APSmasterData.csv")
data_APK = read.csv("APK.csv")
data_APM = read.csv("APM.csv")
data_jmlSekolah = read.csv("PertumbuhanSekolah.csv")
data_kelas <- read.csv("ruangkelas.csv", stringsAsFactors = FALSE)
data_internet = read.csv("internet.csv")
data_perpustakaan = read.csv("Perpustakaan.csv")
data_perpustakaan$jenjang = factor(data_perpustakaan$jenjang, levels = c("SMK","SMA","SMP","SD"))
data_murid <- read.csv("peserta_didik.csv")
data_murid$jenjang<-factor(data_murid$jenjang, levels = c("SMK","SMA","SMP","SD"))
data_guru <- read.csv("presentaseguru.csv", stringsAsFactors = FALSE)

header <- dashboardHeader(title = "Education Dashboard")

sidebar <- dashboardSidebar(
    sidebarMenu(
        menuItem("IPM", tabName = "ipm", icon = icon("map-marked-alt")
        ),
        menuItem("Partisipasi", tabName = "partisipasi", icon = icon("graduation-cap")
        ),
        menuItem("Sarana", tabName = "sarana", icon = icon("school")
        ),
        menuItem("Akses TIK", tabName = "tik", icon = icon("laptop")
        ),
        # menuItem("Hasil", tabName = "hasil", icon = icon("line-chart")
        # ),
        menuItem("About Us", tabName = "about", icon = icon("users"))
    )
)

body <- dashboardBody(
    tabItems(
        tabItem("ipm",
                fluidRow(
                    valueBoxOutput("ipmBox",width = 2),
                    valueBoxOutput("EYSBox",width = 3),
                    valueBoxOutput("MYSBox",width = 3),
                    valueBoxOutput("AHHBox",width = 2),
                    valueBoxOutput("EXPBox",width = 2),
                    box(status = "info", width = 2,
                        selectInput(inputId = "yearipm", label = "Pilih Tahun :", choices = c(as.character(2010:2017)), selected = "2017")
                    ),
                    box(title = "IPM berdasarkan Provinsi", status = "info", width = 10, solidHeader = TRUE, 
                        highchartOutput("mapIpm")
                    )
                )
        ),
        tabItem("partisipasi",
                fluidRow(
                    box(width = 10, status = "info",
                        highchartOutput("mapAps", height = "280px")
                        ),
                    box(width = 2, status = "info",
                        selectInput(inputId = "yearaps", label = "Pilih Tahun :", choices = c(as.character(2010:2018)), selected = "2018")
                    ),
                    box(title = "Jumlah Murid Tahun Ajaran 2017/2018", width = 6, status = "info", solidHeader = TRUE,
                        plotlyOutput("murid", height = 280)
                    ),
                    column(width = 6,
                           plotlyOutput("apk", height = "160px"),
                           br(),
                           plotlyOutput("apm", height = "160px")
                         )
                )
        ),
        tabItem("sarana",
                fluidRow(
                    box(title = "Pertumbuhan Jumlah Sekolah", status = "info", solidHeader = TRUE, width = 5,
                        plotlyOutput("jumlah_sekolah", height = 310)
                    ),
                    box(title = "Presentase Guru Layak Mengajar", width = 5, status = "info", solidHeader = TRUE,
                        column(width = 6,
                               plotlyOutput("guru_TK", height = 155),
                               plotlyOutput("guru_SMP", height = 155)
                               ),
                        column(width = 6, 
                               plotlyOutput("guru_SD", height = 155),
                               plotlyOutput("guru_SMA", height = 155)
                        )
                    ),
                    box(status = "info", width = 2,
                        selectInput(inputId = "year_partisipasi", label = "Pilih Tahun :", choices = as.character(2016:2018), selected = "2018")
                    ),
                    box(title = "Ruang Kelas Kondisi Baik", width = 5, status = "info", solidHeader = TRUE,
                        plotlyOutput("kelas", height = 210)
                    ),
                    box(title = "Persentase Perpustakaan Terhadap Sekolah", width = 5, status = "info", solidHeader = TRUE,
                        plotlyOutput("perpus", height = 210)
                    )
                )
            
        ),
        tabItem("tik",
                fluidRow(
                    box(title = "10 Provinsi dengan Proporsi Remaja (15-24) berketerampilan TIK Tertinggi", solidHeader = TRUE,status = "info", width = 12,
                        column(width = 6,
                               plotlyOutput("tik2015", height = 260)
                               ),
                        column(width = 6,
                               plotlyOutput("tik2016", height = 260)
                               )
                        ),
                    box(title = "Persentase Siswa Usia 5-24 Tahun yang Menggunakan Internet Menurut Provinsi Tahun 2018", status = "info", solidHeader = TRUE, width = 12,
                        plotlyOutput("internet", height = 260)
                        
                    )
                )
        ),
        tabItem("about",
                fluidRow(
                    tags$div(class = "col-md-4",
                             tags$div(class = "box box-widget widget-user",
                                      tags$div(class = "widget-user-header bg-aqua-active",
                                               tags$h3(class = "widget-user-username", "Ardian Satrio Utomo"),
                                               tags$h4(class = "widget-user-sosmed", "@ardian_satrio23")
                                      ),
                                      tags$div(class = "widget-user-image",
                                               tags$img(src="16.9021.jpg", width = 100, height = "auto", alt ="center")
                                      ),
                                      tags$div(class = "box-footer",
                                               tags$div(
                                                   class = "row",
                                                   tags$div(
                                                       class="col-sm-6 border-right",
                                                       tags$div(
                                                           class = "description-block",
                                                           tags$h5(class = "description-header", "2,3M"),
                                                           tags$h5(class = "description-text", "followers")
                                                       )
                                                   ),
                                                   tags$div(
                                                       class="col-sm-6 border-right",
                                                       tags$div(
                                                           class = "description-block",
                                                           tags$h5(class = "description-header", "99"),
                                                           tags$h5(class = "description-text", "following")
                                                       )
                                                   )
                                               ))
                             )
                    ),
                    tags$div(class = "col-md-4",
                             tags$div(class = "box box-widget widget-user",
                                      tags$div(class = "widget-user-header bg-aqua-active",
                                               tags$h3(class = "widget-user-username", "Epan Mareza"),
                                               tags$h4(class = "widget-user-sosmed", "@epan_mph")
                                      ),
                                      tags$div(class = "widget-user-image",
                                               tags$img(src="16.9104.jpg", width = 100, height = "auto", alt ="center")
                                      ),
                                      tags$div(class = "box-footer",
                                               tags$div(
                                                   class = "row",
                                                   tags$div(
                                                       class="col-sm-6 border-right",
                                                       tags$div(
                                                           class = "description-block",
                                                           tags$h5(class = "description-header", "10M"),
                                                           tags$h5(class = "description-text", "followers")
                                                       )
                                                   ),
                                                   tags$div(
                                                       class="col-sm-6 border-right",
                                                       tags$div(
                                                           class = "description-block",
                                                           tags$h5(class = "description-header", "2019"),
                                                           tags$h5(class = "description-text", "following")
                                                       )
                                                   )
                                               ))
                             )
                    ),tags$div(class = "col-md-4",
                               tags$div(class = "box box-widget widget-user",
                                        tags$div(class = "widget-user-header bg-aqua-active",
                                                 tags$h3(class = "widget-user-username", "Fadhlika Anggit"),
                                                 tags$h4(class = "widget-user-sosmed", "@fadhlikaanggit")
                                        ),
                                        tags$div(class = "widget-user-image",
                                                 tags$img(src="16.9111.jpg", width = 100, height = "auto", alt ="center")
                                        ),
                                        tags$div(class = "box-footer",
                                                 tags$div(
                                                     class = "row",
                                                     tags$div(
                                                         class="col-sm-6 border-right",
                                                         tags$div(
                                                             class = "description-block",
                                                             tags$h5(class = "description-header", "1"),
                                                             tags$h5(class = "description-text", "followers")
                                                         )
                                                     ),
                                                     tags$div(
                                                         class="col-sm-6 border-right",
                                                         tags$div(
                                                             class = "description-block",
                                                             tags$h5(class = "description-header", "169 k"),
                                                             tags$h5(class = "description-text", "following")
                                                         )
                                                     )
                                                 ))
                               )
                    ),
                    tags$div(class = "col-md-4",
                             tags$div(class = "box box-widget widget-user",
                                      tags$div(class = "widget-user-header bg-aqua-active",
                                               tags$h3(class = "widget-user-username", "Fenty Berliana Tifalny"),
                                               tags$h4(class = "widget-user-sosmed", "@fentybelin")
                                      ),
                                      tags$div(class = "widget-user-image",
                                               tags$img(src="16.9137.jpg", width = 100, height = "auto", alt ="center")
                                      ),
                                      tags$div(class = "box-footer",
                                               tags$div(
                                                   class = "row",
                                                   tags$div(
                                                       class="col-sm-6 border-right",
                                                       tags$div(
                                                           class = "description-block",
                                                           tags$h5(class = "description-header", "15M"),
                                                           tags$h5(class = "description-text", "followers")
                                                       )
                                                   ),
                                                   tags$div(
                                                       class="col-sm-6 border-right",
                                                       tags$div(
                                                           class = "description-block",
                                                           tags$h5(class = "description-header", "3019"),
                                                           tags$h5(class = "description-text", "following")
                                                       )
                                                   )
                                               ))
                             )
                    ),
                    tags$div(class = "col-md-4",
                             tags$div(class = "box box-widget widget-user",
                                      tags$div(class = "widget-user-header bg-aqua-active",
                                               tags$h3(class = "widget-user-username", "I Nyoman Setiawan"),
                                               tags$h4(class = "widget-user-sosmed", "@setiawan _nym")
                                      ),
                                      tags$div(class = "widget-user-image",
                                               tags$img(src="16.9186.jpg", width = 100, height = "auto", alt ="center")
                                      ),
                                      tags$div(class = "box-footer",
                                               tags$div(
                                                   class = "row",
                                                   tags$div(
                                                       class="col-sm-6 border-right",
                                                       tags$div(
                                                           class = "description-block",
                                                           tags$h5(class = "description-header", "4598"),
                                                           tags$h5(class = "description-text", "followers")
                                                       )
                                                   ),
                                                   tags$div(
                                                       class="col-sm-6 border-right",
                                                       tags$div(
                                                           class = "description-block",
                                                           tags$h5(class = "description-header", "4419"),
                                                           tags$h5(class = "description-text", "following")
                                                       )
                                                   )
                                               ))
                             )
                    ),
                    tags$div(class = "col-md-4",
                             tags$div(class = "box box-widget widget-user",
                                      tags$div(class = "widget-user-header bg-aqua-active",
                                               tags$h3(class = "widget-user-username", "Ilmi Aulia Akbar"),
                                               tags$h4(class = "widget-user-sosmed", "@ilmiauliaa")
                                      ),
                                      tags$div(class = "widget-user-image",
                                               tags$img(src="16.9193.jpg", width = 100, height = "auto", alt ="center")
                                      ),
                                      tags$div(class = "box-footer",
                                               tags$div(
                                                   class = "row",
                                                   tags$div(
                                                       class="col-sm-6 border-right",
                                                       tags$div(
                                                           class = "description-block",
                                                           tags$h5(class = "description-header", "170 k"),
                                                           tags$h5(class = "description-text", "followers")
                                                       )
                                                   ),
                                                   tags$div(
                                                       class="col-sm-6 border-right",
                                                       tags$div(
                                                           class = "description-block",
                                                           tags$h5(class = "description-header", "3 k"),
                                                           tags$h5(class = "description-text", "following")
                                                       )
                                                   )
                                               ))
                             )
                    )
                    
                    
                    
                )
            
        )
    )
)

    
ui <- dashboardPage(header, sidebar, body)



server <- function(input, output) {
    data_tik_2015 <- data_tik %>% select(Provinsi,X2015) %>% arrange(X2015) %>% top_n(10,X2015)
    bar2015 <- plot_ly(data_tik_2015, x=~X2015,y=~Provinsi, type = 'bar', orientation='h', marker = list(color='rgb(85 107 47)'))%>%
        layout(xaxis = list(title='Proporsi Remaja'), yaxis= list(title = " ",categoryorder = 'array',categoryarray ='x2015'), title='Tahun 2015')
    
    data_tik_2016 <- data_tik %>% select(Provinsi,X2016)%>% arrange(X2016) %>% top_n(10,X2016)
    bar2016 <- plot_ly(data_tik_2016, x=~X2016,y=~Provinsi, type = 'bar', orientation='h', marker = list(color='rgb(64 224 208'))%>%
        layout(xaxis = list(title='Proporsi Remaja'),yaxis= list(title= " ",categoryorder = 'array',categoryarray ='x2015'), title='Tahun 2016')
    
    filterIPM = reactive({
        ipm_filter = data_IPM %>% filter(tahun==input$yearipm)
        return(ipm_filter)
    })
    
    filteripmbox = reactive({
        indo = indo_IPM %>% filter(tahun==input$yearipm)
        value_ipm = as.character(indo$IPM)
        return(value_ipm)
    })
    
    filterEYSbox = reactive({
        indo = indo_IPM %>% filter(tahun==input$yearipm)
        value_EYS = as.character(indo$EYS)
        return(value_EYS)
    })
    filterMYSbox = reactive({
        indo = indo_IPM %>% filter(tahun==input$yearipm)
        value_MYS = as.character(indo$MYS)
        return(value_MYS)
    })
    filterEXPbox = reactive({
        indo = indo_IPM %>% filter(tahun==input$yearipm)
        value_Exp = as.character(round(indo$Pengeluaran,digits = 0))
        return(value_Exp)
    })
    filterAHHbox = reactive({
        indo = indo_IPM %>% filter(tahun==input$yearipm)
        value_AHH = as.character(indo$AHH)
        return(value_AHH)
    })
    
    filterPerpus = reactive({
        data_perpus = data_perpustakaan %>% filter(tahun==input$year_partisipasi)
        return(data_perpus)
    })
    
    filterMurid = reactive({
        data_muridNew = data_murid %>% filter(tahun==input$year_partisipasi)
        return(data_muridNew)
    })
    
    filterKelas = reactive({
        data_kelasNew = data_kelas %>% filter(tahun==input$year_partisipasi)
        return(data_kelasNew)
    })
    
    filterAPS = reactive({
        data_APSnew = data_APS %>% filter(tahun==input$yearaps)
        return(data_APSnew)
    })
    
    bar_ruangKelas <- function(data,xaxis1,xaxis2,yaxis) {
        a<- enquo(xaxis1)
        aa <- enquo(xaxis2)
        b<- enquo(yaxis)
        
        eval_tidy(
            quo_squash(
                quo({
                    plot_ly(data, x=~!!b,y=~!!a, type = 'bar',name ='Swasta', marker = list(color='#991140'))%>%
                        layout(yaxis = list(title = "Presentase (%)"),
                               xaxis = list(title = " ", categoryorder = 'array', categoryarray=~!!a)) %>%
                        add_trace(y = ~!!aa,name='Negeri' ,marker = list(color = '#A36B6B'))
                })
            )
        )
    }
    
    color_ipm <- list(c(0,'#00FF0044'),c(1/3,'#1ba602'),c(2/3,'#075800'))
    map_ipm <- function(json,data,col){
        highchart() %>%
            hc_title(text = "IPM Indonesia") %>%
            hc_subtitle(text = "Source: BPS-RI") %>%
            hc_add_series_map(json, data,
                              value = "IPM",
                              joinBy = c("ID", "id"),
                              borderColor = '#6CC4EE',
                              borderWidth = 0.5) %>%
            hc_mapNavigation(enabled = T)%>%
            hc_tooltip(formatter = JS("function(){
                            return ('<strong> Provinsi: </strong> ' + this.point.provinsi + ' <br> <strong>IPM: </strong> ' + this.point.IPM + ' <br> <strong>EYS:</strong> ' + this.point.EYS + ' <br> <strong>MYS:</strong> ' + this.point.MYS)
                                        }"))%>%
            hc_colorAxis(min = 50, max = 90, tickAmount = 5,type = "linier", stops = col)%>% 
            hc_chart(backgroundColor= '#cddee4',loading= c(hideDuration= 1000,showDuration= 1000))
    }
    
    
    map_aps <- function(json,data){
        class_data <- list(structure(list(0, data[34,c("APS")], "#FFFF00","Kurang dari Nasional"),
                                     .Names = c("from","to", "color", "name")),
                           structure(list(data[34,c("APS")], 100, "#0000FF","Lebih dari Nasional"),
                                     .Names = c("from", "to", "color","name")))
        highchart() %>%
            hc_title(text = "Angka Partisipasi Sekolah 7-18 Tahun Menurut Provinsi") %>%
            hc_add_series_map(json, data,
                              value = "APS",
                              joinBy = c("ID", "id"),
                              borderColor = '#000000',
                              borderWidth = 0.5) %>%
            hc_mapNavigation(enabled = T)%>%
            hc_tooltip(formatter = JS("function(){
                              return ('<strong> Provinsi: </strong> ' + this.point.provinsi + ' <br> <strong>APS: </strong> ' + this.point.APS)
                          }"))%>%
            hc_colorAxis(dataClasses = class_data)%>% 
            hc_chart(backgroundColor= '#cddee4')
    }
    
    line_jmlSekolah <- plot_ly(data_jmlSekolah, x = ~tahun, y = ~SD, name = 'SD', type = 'scatter', mode = 'line', fillcolor = 'blue') %>%
        add_trace(y = ~SMP, name = 'SMP', fillcolor = 'green') %>%
        add_trace(y = ~SMA, name = 'SMA', fillcolor = 'yellow') %>%
        add_trace(y = ~SMK, name = 'SMK', fillcolor = 'red') %>%
        layout(xaxis = list(title = " ", showgrid = FALSE),
               yaxis = list(title = "Pertumbuhan (%)",
                            showgrid = TRUE))
    
    blank_theme <- theme_minimal()+
        theme(
            axis.title.x = element_blank(),
            axis.title.y = element_blank(),
            panel.border = element_blank(),
            panel.grid=element_blank(),
            axis.ticks = element_blank()
        )
    bar_perpus = function(data){
        data %>% 
            ggplot(aes(x = jenjang, y = persen, fill = status), text=persen, position="fill") + 
            geom_bar(stat = "identity", 
                     position = position_stack(reverse = T), 
                     width = 0.7,
                     colour="white") + 
            coord_flip() + 
            xlab("Jenjang Pendidikan") +
            ylab("Persentase Perpustakaan") +
            geom_text(aes(label = paste(round(persen,2),"%")),
                      position = position_stack(reverse = T, vjust = 0.5),
                      size = 3.5) + blank_theme
    }
    
    bar_murid <- function(data){
        data %>% 
            ggplot(aes(x = jenjang, y = persen, fill = JenisKelamin), text=persen, position="fill") + 
            geom_bar(stat = "identity", 
                     position = position_stack(reverse = T), 
                     width = 0.7,
                     colour="white") + 
            coord_flip() + 
            xlab("Jenjang Pendidikan") +
            ylab("Jumlah Peserta Didik") +
            geom_text(aes(label = paste(round(persen,2),"%")),
                      position = position_stack(reverse = T, vjust = 0.5),
                      size = 3.5) + blank_theme
    } 
        
    line_APK <- plot_ly(data_APK, x = ~tahun, y = ~sma_perdesaan, name = 'Perdesaan', type = 'scatter', mode = 'density', fillcolor = 'blue') %>%
        add_trace(y = ~sma_perkotaan, name = 'Perkotaan', fillcolor = 'red') %>%
        layout(title = 'Angka Partisipasi Kasar (APK) SMA',
               xaxis = list(title = " ",
                            showgrid = TRUE),
               yaxis = list(title = "APK",
                            range = c(70,100),
                            showgrid = TRUE))
    
    line_APM <- plot_ly(data_APM, x = ~tahun, y = ~sma_perdesaan, name = 'Perdesaan', type = 'scatter', mode = 'density', fillcolor = 'blue') %>%
        add_trace(y = ~sma_perkotaan, name = 'Perkotaan', fillcolor = 'red') %>%
        layout(title = 'Angka Partisipasi Murni (APM) SMA',
               xaxis = list(title = " ",
                            showgrid = TRUE),
               yaxis = list(title = "APM",
                            range = c(50,80),
                            showgrid = TRUE))
    
    scatter_internet <- function(data){
        ind <- data[dim(data)[1],2]
        class1 = subset(data,data$Persentase < ind)
        class2 = subset(data,data$Persentase >ind)
        plot_ly()%>% 
            add_trace(data = class2, x = ~Provinsi, y = ~Persentase,
                      marker = list(size = 10,
                                    color = "blue"),
                      type ="scatter",mode = "markers",name = "Lebih dari Nasional") %>%
            add_trace(data = class1, x = ~Provinsi, y = ~Persentase,
                      marker = list(size = 10,
                                    color = "grey"),
                      type ="scatter",mode = "markers",name = "Kurang dari Nasional") %>%
            layout(yaxis = list(showgrid = FALSE),
                   xaxis = list(showticklabels = FALSE,showgrid = FALSE)) %>%
            add_trace(x= ~Provinsi,y = ind,type = "scatter" ,mode = "lines", showlegend = FALSE)
    }
    
    data_donut_TK = reactive({
        kolom = 
            case_when(input$year_partisipasi == "2012"~ 2,
                      input$year_partisipasi == "2013"~ 3,
                      input$year_partisipasi == "2014"~ 4,
                      input$year_partisipasi == "2015"~ 5,
                      input$year_partisipasi == "2016"~ 6,
                      input$year_partisipasi == "2017"~ 7,
                      input$year_partisipasi == "2018"~ 8)
        donut <- data_guru %>% filter(TingkatPendidikan == "TK") %>% select(1,kolom)
        donutt <- rbind(c("Tidak Layak",100-donut[,2]),donut)
        colnames(donutt)[2] = "prop" 
        return(donutt)
    })
    
    data_donut_SD = reactive({
        kolom = 
            case_when(input$year_partisipasi == "2012"~ 2,
                      input$year_partisipasi == "2013"~ 3,
                      input$year_partisipasi == "2014"~ 4,
                      input$year_partisipasi == "2015"~ 5,
                      input$year_partisipasi == "2016"~ 6,
                      input$year_partisipasi == "2017"~ 7,
                      input$year_partisipasi == "2018"~ 8)
        donut <- data_guru %>% filter(TingkatPendidikan == "SD") %>% select(1,kolom)
        donutt <- rbind(c("Tidak Layak",100-donut[,2]),donut)
        colnames(donutt)[2] = "prop" 
        return(donutt)
    })
    data_donut_SMP = reactive({
        kolom = 
            case_when(input$year_partisipasi == "2012"~ 2,
                      input$year_partisipasi == "2013"~ 3,
                      input$year_partisipasi == "2014"~ 4,
                      input$year_partisipasi == "2015"~ 5,
                      input$year_partisipasi == "2016"~ 6,
                      input$year_partisipasi == "2017"~ 7,
                      input$year_partisipasi == "2018"~ 8)
        donut <- data_guru %>% filter(TingkatPendidikan == "SMP") %>% select(1,kolom)
        donutt <- rbind(c("Tidak Layak",100-donut[,2]),donut)
        colnames(donutt)[2] = "prop" 
        return(donutt)
    })
    data_donut_SMA = reactive({
        kolom = 
            case_when(input$year_partisipasi == "2012"~ 2,
                      input$year_partisipasi == "2013"~ 3,
                      input$year_partisipasi == "2014"~ 4,
                      input$year_partisipasi == "2015"~ 5,
                      input$year_partisipasi == "2016"~ 6,
                      input$year_partisipasi == "2017"~ 7,
                      input$year_partisipasi == "2018"~ 8)
        donut <- data_guru %>% filter(TingkatPendidikan == "SMA/SMK") %>% select(1,kolom)
        donutt <- rbind(c("Tidak Layak",100-donut[,2]),donut)
        colnames(donutt)[2] = "prop" 
        return(donutt)
    })
    
    donut_plot = function(data,judul){
        text_donut <- list(structure(list(paste(data[2,2],"%"),FALSE), .Names =c("text","showarrow")))
        plot_ly(data,labels = ~TingkatPendidikan, values=~prop ,textinfo = 'none', marker = list(colors="white")) %>%
            add_pie(hole = 0.6) %>%
            layout(title = judul, showlegend = F, annotations = text_donut)
    }
    
    
    output$mapIpm = renderHighchart(map_ipm(indo.json,filterIPM(), color_ipm))
    output$mapAps = renderHighchart(map_aps(indo.json,filterAPS()))
    output$tik2015 = renderPlotly(bar2015)
    output$tik2016 = renderPlotly(bar2016)
    output$jumlah_sekolah = renderPlotly(line_jmlSekolah)
    output$perpus = renderPlotly(ggplotly(bar_perpus(filterPerpus())))
    output$murid = renderPlotly(ggplotly(bar_murid(filterMurid())))
    output$apk = renderPlotly(line_APK)
    output$apm = renderPlotly(line_APM)
    output$kelas = renderPlotly(bar_ruangKelas(filterKelas(),Swasta,Negeri,Jenjang))
    output$internet = renderPlotly(scatter_internet(data_internet))
    output$guru_TK = renderPlotly(donut_plot(data_donut_TK(),"TK"))
    output$guru_SD = renderPlotly(donut_plot(data_donut_SD(),"SD"))
    output$guru_SMP = renderPlotly(donut_plot(data_donut_SMP(),"SMP"))
    output$guru_SMA = renderPlotly(donut_plot(data_donut_SMA(),"SMA/SMK"))
    
    output$ipmBox <- renderValueBox({
        valueBox(filteripmbox(), "IPM", icon = icon("male"), color = "aqua", width = 2)
    })
    output$EYSBox <- renderValueBox({
        valueBox(filterEYSbox(), "Harapan Lama Sekolah", icon = icon("book"),color = "green", width = 3)
    })
    output$MYSBox <- renderValueBox({
    valueBox(filterMYSbox(), "Rata-rata Lama Sekolah", icon = icon("graduation-cap"),color = "orange", width = 3)
    })
    output$EXPBox <- renderValueBox({
        valueBox(filterEXPbox(), "Pengeluaran/kapita", icon = icon("money"),color = "teal", width = 2)
    })
    output$AHHBox <- renderValueBox({
        valueBox(filterAHHbox(), "Angka Harapan Hidup", icon = icon("medkit"),color = "red", width = 2)
    })
    
}


shinyApp(ui = ui, server = server)
